Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D736EC4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 21:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352137AbiD1VPt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352187AbiD1VPr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 17:15:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A08A82D3D
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 14:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651180338; x=1682716338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f8KpB1Aeur3TvcZWB5MlenD7ueFvevYNepuqPuDd8VU=;
  b=btNoQcSTKTxvvzh1vuElW64h+vqmWPzQT7iUFN3FwVfUgL4XtF4D1G9X
   W24CHnli4Fjj0zCbENcnsm0xyB5GJUufAnOzkg1yB8TPFTsCdb1c9E4/8
   P7zYCYL5hHpK15vCyW/S5XRB6PmliF/Mb/x+aiUsBDIt3OV5BwKLkR51h
   7+JsjYP7gcdTiBn2q/nCdCwwIq1PBxH/ouwZY5IIvDvmUgS21J8Au2xZ6
   N39UeHqZyn7kicCdzXkCS2R04K0A8pl/Le7ZLKiliK1kUtdplNUuP2w0r
   43VnIDFPlggykgMX7oouDBmf2FV8HZ/rh5OiIyFmZNg3u8gE/JGowY+sY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246339833"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246339833"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:12:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581645328"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:12:17 -0700
Message-ID: <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
Date:   Thu, 28 Apr 2022 14:12:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/28/22 13:11, Reinette Chatre wrote:
> ELDU returned 1073741837 (0x4000000d)
> WARNING: CPU: 72 PID: 24407 at arch/x86/kernel/cpu/sgx/encl.c:81 sgx_encl_eldu+0x3cf/0x400
> ...
> Call Trace:
> <TASK>
> ? xa_load+0x6e/0xa0
> __sgx_encl_load_page+0x3d/0x80
> sgx_encl_load_page_in_vma+0x4a/0x60
> sgx_vma_fault+0x7f/0x3b0

First of all, thanks for all the work to narrow this down.

It sounds like there are probably at least two failure modes at play here:

	1. shmem_read_mapping_page_gfp() is called to retrieve an
	   existing page, but an empty one is allocated instead.  ELDU
	   fails on the empty page.  This one should be fixed by patch 	
	   4/4.
	2. shmem_read_mapping_page_gfp() actually finds a page, but it
	   still fails ELDU.

Is that right?

If so, I'd probably delve deeper into what the page and the PCMD look
like.  I usually go after these kinds of things with tracing.  I'd
probably dump some representation of the PCMD and page contents with
trace_printk().  Dump them when the at __sgx_encl_ewb() time, then also
dump them where the warning is being hit.  Pair the warning with a
tracing_off().

// A crude checksum:
u64 sum_page(u64 *page)
{
	u64 ret = 0
	int i;

	for (i = 0; i < PAGE_SIZE/sizeof(u64)); i++)
		ret += page[i];

	return ret;
}

Then, logically something like this:

	trace_printk("bad ELDU on shm page: %x sum: pcmd: %x %x...\n",
		page_to_pfn(shm_page), sum_page(page_kmap),
		&pcmd, ...);

Both at EWB time and ELDU time.  Let's see if the pages that are coming
out of shmem are the same as the ones that were put in.

When you hit the warning, tracing should turn itself off.  Then, you can
just grep through the trace for that same pfn.
