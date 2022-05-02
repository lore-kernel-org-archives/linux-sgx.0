Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A65C433EF
	for <linux-sgx@archiver.kernel.org>; Mon,  2 May 2022 14:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiEBOjn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 2 May 2022 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385779AbiEBOjV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 2 May 2022 10:39:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82996411
        for <linux-sgx@vger.kernel.org>; Mon,  2 May 2022 07:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651502152; x=1683038152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SIiUE8sE8Xlp7uj/RPODES2rXNB8W7xpL7DGgCRL6s0=;
  b=A4+wGC2dE+Su3Nt9iMIq60voU9ARZlTZWWkyESd+l9tiBQvPq28HX6Re
   WyFZQuU+N8b9ZfnKTYcbiHJxKg4Xtu2DRtFxUDqXF5/n/0UL431bWjSaq
   Glx7CGTggkBPvl419l5zEpWum99UApDh70ssZ10OeeHNe67VetTAbwry2
   q7w8CizRLwXa/oYS+1q14f03J7STaFJ0VlyVjD4ZSt1eZwN9CzYsyhCby
   6EAMYMOfnh8hhjlmsXCP+8Frs0N0NixJ4hEs5vYauwMV16GBPC/P5p0fY
   jEOCYE+CmDDMyvjgNlfES3QvUUxc748734p/vSoElrtVvwj9Zns1y4kKM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="292405865"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="292405865"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 07:35:52 -0700
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="663547954"
Received: from gsteinke-mobl.amr.corp.intel.com (HELO [10.209.165.8]) ([10.209.165.8])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 07:35:52 -0700
Message-ID: <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
Date:   Mon, 2 May 2022 07:36:10 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/29/22 20:22, Reinette Chatre wrote:
> -	if (pcmd_page_empty) {
> +	if (pcmd_page_empty && && put_page_testzero(b.pcmd)) {
>  		ida_free(&encl->pcmd_in_backing, PFN_DOWN(page_pcmd_off));
>  		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
>  	}

Reinette, nice work on tracking this down!

One comment on the fix though:  Will this put_page_testzero() ever
actually trigger?  The page cache itself holds a reference, which is
released in this case via:

	shmem_truncate_range() ->
	truncate_inode_pages_range() ->
	truncate_inode_folio() ->
	filemap_remove_folio() ->
	filemap_free_folio() ->
	folio_put_refs()

So I think the lowest the page refcount can actually be at the point of
put_page_testzero() is 1.

I suspect the end result of that patch would actually just be that PCMD
pages are never freed at runtime, which would also work around the bug
you discovered.

No matter what we do here, we need to ensure that there is no race between:

        pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
and
	sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));

Holding the encl->lock over that section of code would work.  It also
would not be awful to add a special "truncation lock" which is taken
before putting data in a pcmd page and is taken over the
memchr()->truncate window as well.
