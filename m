Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC68FC433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 20:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiEJUMM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 May 2022 16:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbiEJUML (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 10 May 2022 16:12:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7AD1A051
        for <linux-sgx@vger.kernel.org>; Tue, 10 May 2022 13:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652213529; x=1683749529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=63XbzUvDjy+Pl9KkOOUzbWRpXChEQI/vzFxPLw53uMU=;
  b=M5JualB0gzML2lAS4QtIK8zdeM8rGsV25cN/yGsnGv1sfKWGe38625sA
   Ak+IpVzSt7HC0E0Wg47Kh9uF1k6uNZ9bm7Dke+MYymUU7uGPj71nNc/st
   An3mZT+Vy9qkuqEOz9lgc+ohXS+tLtiSUYgUSsveSt9U/SVyEzDuAFtyZ
   GfybAMvFthLvxRkKXEs9nfxAcLKV6iOXMiiOaWOpOk/5WX9kUKvIMhQW+
   +PyK8uq2w6PdBO7o13cXF6iSQcVJ+KBBKdfMCv5/98Xm5CH9wnUEtsLmT
   othahtrNLyd137pIDKukwwNTG3ezQYO58nhz9EU78L6npVsLdFLogazVY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="257029306"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="257029306"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 13:12:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="541964445"
Received: from mnazari-mobl.amr.corp.intel.com (HELO [10.209.1.152]) ([10.209.1.152])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 13:12:09 -0700
Message-ID: <8922e48f-6646-c7cc-6393-7c78dcf23d23@intel.com>
Date:   Tue, 10 May 2022 13:12:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH V2 1/5] x86/sgx: Disconnect backing page references from
 dirty status
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <4cda80a0049de6bc47480b4ad119091027c11d45.1652131695.git.reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <4cda80a0049de6bc47480b4ad119091027c11d45.1652131695.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/9/22 14:47, Reinette Chatre wrote:
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -190,6 +190,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
>  	pginfo.metadata = (unsigned long)kmap_atomic(backing->pcmd) +
>  			  backing->pcmd_offset;
>  
> +	set_page_dirty(backing->pcmd);
> +	set_page_dirty(backing->contents);
>  	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);

I think I may have led you astray on this.  It's typical to do:

	lock_page(page)
	set_page_dirty(backing->contents);
	// modify page
	unlock_page(page)

That's safe because laundering the page requires locking it.  But, the
page lock isn't held in this case.  So, it's possible to do:

	get_page(page) // page can be truncated, but not reclaimed
	set_page_dirty(page)
	// race: something launders page here
	__ewb(page)
	put_page(page)
	// page is reclaimed, __ewb() contents were thrown away

__shmem_rw() has a similar pattern to what __sgx_encl_ewb() uses.  It
doesn't hold a lock_page(), but does dirty the page *after* its memset()
writes to the page.

In other words, I think the page dirtying order in the previous (before
this patch) SGX code was correct.  The concept of this patch is correct,
but let's just change the dirtying order, please.

Could you also please add a cc: stable@ and a Link: to either this
message or the original message where I suggested this, like this
(temporary) commit has:

https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/commit/?h=testme&id=5ee32d5d3f3cdb943b01992d2ffc5093b139d023
