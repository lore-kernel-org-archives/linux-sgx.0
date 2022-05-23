Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AD8C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 23 May 2022 19:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiEWTfV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 23 May 2022 15:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiEWTfA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 23 May 2022 15:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6CD72210
        for <linux-sgx@vger.kernel.org>; Mon, 23 May 2022 12:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88E361309
        for <linux-sgx@vger.kernel.org>; Mon, 23 May 2022 19:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A68C385AA;
        Mon, 23 May 2022 19:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653333696;
        bh=VDByln83gsysqnSJxc/OKcvr4RM63ItlgGR+QfBwo6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YwRdkwzZJY6rLulqo3CnP/Eebai2Edpk/++7CruSoGaThlOIFUCtifd05SI15O7NE
         4W9MDZRhe6akviSfJQlN1eWTiBKEIe58xGfWfEXIvZHWGNso6SE3771oqNih6zkA9u
         zcq1q3opmE+pCDTtQ0c0YY93zwL6NFvRq0HklcFKtn6YP33rCZqOuJnJY6gOTn75rq
         oHUDvh6pBAtdlLHoyu2Mebg4pjxUoGbkDU7ELA08S/JLcJ76kQyh0ywcXvY6XPAdD4
         XNUL44fBwxzHn/CxnImqAIv8jfjQtwWkYOWIEVvh6VJV8iZxsa3lizZ7N29mtSQbZz
         5EM+dRws6dAUg==
Date:   Mon, 23 May 2022 22:19:54 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: Re: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest page
 type
Message-ID: <YoveWpEsH6Hghc5Y@kernel.org>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
 <20220520103904.1216-4-cathy.zhang@intel.com>
 <Yofnzg76OyCiHZwk@iki.fi>
 <aef784a1162e40e4a2f395ab3c52a55c@intel.com>
 <eb95b32ecf3d44a695610cf7f2816785@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb95b32ecf3d44a695610cf7f2816785@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 23, 2022 at 06:09:55AM +0000, Zhang, Cathy wrote:
> Hi Jarkko,
> 
> > -----Original Message-----
> > From: Zhang, Cathy
> > Sent: Monday, May 23, 2022 8:07 AM
> > To: 'Jarkko Sakkinen' <jarkko@kernel.org>; Li, Zhiquan1
> > <zhiquan1.li@intel.com>
> > Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> > Ashok <ashok.raj@intel.com>; chao.p.peng@linux.intel.com; Zhong, Yang
> > <yang.zhong@intel.com>
> > Subject: RE: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest page
> > type
> > 
> > Hi Jarkko,
> > 
> > > -----Original Message-----
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > Sent: Saturday, May 21, 2022 3:11 AM
> > > To: Zhang, Cathy <cathy.zhang@intel.com>; Li, Zhiquan1
> > > <zhiquan1.li@intel.com>
> > > Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> > > <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>;
> > > Raj, Ashok <ashok.raj@intel.com>; chao.p.peng@linux.intel.com; Zhong,
> > > Yang <yang.zhong@intel.com>
> > > Subject: Re: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest
> > > page type
> > >
> > > On Fri, May 20, 2022 at 06:38:58PM +0800, Cathy Zhang wrote:
> > > > Regular enclave EPC pages have sgx_encl_page as their owner, but SGX
> > > > VA page and KVM guest EPC page are maintained by different owner
> > > > structures.
> > > >
> > > > SGX CPUSVN update requires to know the EPC page owner's status and
> > > > then decide how to handle the page.
> > > >
> > > > Keep a record of page type for SGX VA and KVM guest page while the
> > > > other EPC pages already have their type tracked, so that CPUSVN
> > > > update can get EPC page's owner by type and handle it then.
> > > >
> > > > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > > >
> > > > ---
> > > > Changes since v3:
> > > >  - Rename SGX_EPC_PAGE_GUEST as SGX_EPC_PAGE_KVM_GUEST.
> > > (Suggested by
> > > >    Jarkko, Sakkinen)
> > > > ---
> > > >  arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
> > > > arch/x86/kernel/cpu/sgx/encl.c | 2 ++
> > > > arch/x86/kernel/cpu/sgx/virt.c
> > > > | 2 ++
> > > >  3 files changed, 8 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
> > > > b/arch/x86/kernel/cpu/sgx/sgx.h index f8ed9deac18b..4ad0e5396eef
> > > > 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > > > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > > > @@ -28,6 +28,10 @@
> > > >
> > > >  /* Pages on free list */
> > > >  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> > > > +/* VA page */
> > > > +#define SGX_EPC_PAGE_VA			BIT(2)
> > > > +/* Pages allocated for KVM guest */
> > > > +#define SGX_EPC_PAGE_KVM_GUEST		BIT(3)
> > > >
> > > >  struct sgx_epc_page {
> > > >  	unsigned int section;
> > > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > > > b/arch/x86/kernel/cpu/sgx/encl.c index 08f39fa03a39..383abd538ac9
> > > > 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > > > @@ -912,6 +912,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct
> > > sgx_va_page *va_page)
> > > >  		return ERR_PTR(-EFAULT);
> > > >  	}
> > > >
> > > > +	epc_page->flags |= SGX_EPC_PAGE_VA;
> > > > +
> > > >  	return epc_page;
> > > >  }
> > > >
> > > > diff --git a/arch/x86/kernel/cpu/sgx/virt.c
> > > > b/arch/x86/kernel/cpu/sgx/virt.c index e953816d7c8b..104487b72fb8
> > > > 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > > > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > > > @@ -50,6 +50,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> > > >  	if (IS_ERR(epc_page))
> > > >  		return PTR_ERR(epc_page);
> > > >
> > > > +	epc_page->flags |= SGX_EPC_PAGE_KVM_GUEST;
> > >
> > > This would need to be synced up with SGX_EPC_IS_VEPC:
> > >
> > > https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-
> > > e52b4a61e1ec@intel.com/T/#t
> > >
> > > Otherwise, we have a chaos.
> > >
> > > Can you sync up with Zhiquan Li and find some common approach. IMHO,
> > > it might even sense to merge these patch sets into one. Then it would
> > > be easier to review them as a whole.
> > 
> > Thanks for showing the above related patches, Jarkko! I just take a quick look
> > at that series, AFAIK, __sgx_vepc_fault() will only be called during VM boot
> > up to allocate physical EPC pages.
> > Then, host does not know how VM works with those pages. VM SGX driver
> > will handle any errors itself.
> > So with the approach in that series, what it actually tracks is the vaddr in
> > QEMU address space for all EPC pages allocated to the VM. Does host need
> > to track such information? QEMU side should provide it easily I think. @Li,
> > Zhiquan1.
> > 
> 
> I've synced with Zhiquan Li and got the whole picture of his patch logic. I suggest
> to follow the way how we handle the same change between EDMM and Seamless,
> that is Zhiquan Li will apply patch 3 from Seamless and then add his left patches.
> Please let's know if you have other suggestion. Thanks!

Sounds reasonable!

BR, Jarkko
