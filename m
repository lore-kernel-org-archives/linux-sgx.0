Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A363FC433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  4 May 2022 23:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349764AbiEDXaF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 May 2022 19:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384622AbiEDXIH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 May 2022 19:08:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B32A27B2C
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 16:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651705236; x=1683241236;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UtxMGWs23EON6MxNUmbunGDh0C1iaFZddyqEpih0M30=;
  b=dA/xNULtaLy8Ux8S9U36A9riudvtkVz0W7np9oLkeVvJyrMDIPZ+T79d
   EkcNrCdnx7uWNwjiamK7orQaq9KSVwXnVWGwDz6mD2p9qRBP+1RMRmgh0
   DeIsdkwfXefni8zmmlWlmK8+z/XYgHzwUfPEHAY3npszCFrtptv+TCtcV
   762CSyLx6YtdsO/T4/0Z/vkR92kzkUmYYhzJ9EiZagbBJycWOcZPsIzSY
   dnoHe0lQkYFBaf4LdwNbTvBMitPTn3Lk/mVMW6il572fj4bjHcN49iVhN
   UeZYt4SekMeR01KZEQiMfQdsLohT5GN4EtBR4uSssO+Tfm/+QjQV8SbIo
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="268076516"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="268076516"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:58:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="562949343"
Received: from jrhamric-mobl.amr.corp.intel.com (HELO [10.212.121.177]) ([10.212.121.177])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:58:16 -0700
Message-ID: <705c7c6a-3618-2d74-115c-68347b8aa8e6@intel.com>
Date:   Wed, 4 May 2022 15:58:36 -0700
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
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/4/22 15:13, Reinette Chatre wrote:
> +		/*
> +		 * VA page slot ID uses same bit as the flag so it is important
> +		 * to ensure that the page is not already in backing store.
> +		 */
> +		if (entry->epc_page &&
> +		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
> +			pr_debug("%s:%d encl %px addr 0x%lx desc 0x%lx (index %lu) being reclaimed\n",
> +				 __func__, __LINE__, encl, addr, entry->desc,
> +				 PFN_DOWN(entry->desc - entry->encl->base));
> +			reclaimed = 1;
> +			break;
> +		}

I don't think this works as-is.  As it stands,
SGX_ENCL_PAGE_BEING_RECLAIMED is cleared *BEFORE* the EWB.  It's
possible for that check above to race with SGX_ENCL_PAGE_BEING_RECLAIMED
being cleared.  That would erroneously lead pcmd_page_in_use() to return
false *just* before data is written to the PCMD page.

static void sgx_encl_ewb()
{
        encl_page->desc &= ~SGX_ENCL_PAGE_BEING_RECLAIMED;
	...
	__sgx_encl_ewb()
}

You might be able to move the ~SGX_ENCL_PAGE_BEING_RECLAIMED until after
the __sgx_encl_ewb().  But, at that point, the pcmd_page_empty is a bit
useless because it's stale.  I guess it might act as a performance
optimization because it allows avoiding the expensive pcmd_page_in_use()
check.

Also, one nit:

> +	/*
> +	 * Address of enclave page using the first entry within the
> +	 * PCMD page.
> +	 */
> +	pcmd_first_page = PFN_PHYS(page_index & ~0x1FUL) + encl->base;

That ~0x1FUL is pretty magic.  I assume that's 5 bits because there are
32 PCMDs per page.  This could probably be something resembling this
instead:

#define PCMDS_PER_PAGE (PAGE_SIZE/sizeof(struct sgx_pcmd))
#define PCMD_FIRST_MASK GENMASK(PCMDS_PER_PAGE, 0)

