Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FD9C54EAA
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Jan 2023 21:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjAZVYo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Jan 2023 16:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjAZVYn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Jan 2023 16:24:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9130CA
        for <linux-sgx@vger.kernel.org>; Thu, 26 Jan 2023 13:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699B861952
        for <linux-sgx@vger.kernel.org>; Thu, 26 Jan 2023 21:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B74DC433D2;
        Thu, 26 Jan 2023 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674768281;
        bh=m8K8/1x+lpb0G8moE90geB7+47uMGmFVf7Rwr44Y8qI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J9rkRuKI4vVJQhrNtTswB8439eKUUyCdt/se3pwDx6n0D2tCH7Q+iFIkNap9++qcc
         wQHSrhiPgmluUmhddXUE+dcrsXEwqK5dXttkj1GVy8UImUXBcChqTu5LQGknDGNI6d
         cBk3vM9jfrhCLiP3aZVD6WLGcRaigJn5QPdiGwXw2f1l5Qui/bAumEiBaqPF+vMBar
         ujZYMnuvSli/4uQ4Rxy/qe/kZ5S4D7GrgFjswx5q/GLrup75Kxo0xzUak8U6JAeAzd
         dmEDmfjvS0coWML/Q25sBRvQJgH5ZpwvAnVYjqDtrDPJupj6rQzl5/AnmBOUdvwc3j
         NrwS+0HADA37A==
Date:   Thu, 26 Jan 2023 21:24:39 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v3 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <Y9LvlzYO5B0MbH3E@kernel.org>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
 <Y3QMtZJd25lexKi8@kernel.org>
 <op.1zcd91mxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1zcd91mxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 25, 2023 at 01:40:39PM -0600, Haitao Huang wrote:
> On Tue, 15 Nov 2022 16:03:45 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> 
> > > +	if (!encl)
> > > +		return -EINVAL;
> > 
> > Why !encl check is needed?
> It was intended as sanity check. But I think encl should not be null at this
> point so will remove in next version.
> 
> > 
> > > +	if (!cpu_feature_enabled(X86_FEATURE_SGX2))
> > > +		return -EINVAL;
> > 
> > This should be done first before doing anything else in the function.
> 
> Will do
> 
> > 
> > > +
> > > +	if (offset + len < offset)
> > > +		return -EINVAL;
> > > +	if (encl->base + offset < encl->base)
> > > +		return -EINVAL;
> > > +	start  = offset + encl->base;
> > > +	end = start + len;
> > 
> > These could be just as well assigned in the declarations, which would
> > definitely be also less convoluted.
> > 
> Will do
> 
> ...
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > > b/arch/x86/kernel/cpu/sgx/encl.c
> > > index 1abc5e7f2660..c57e60d5a0aa 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > > @@ -305,11 +305,11 @@ struct sgx_encl_page
> > > *sgx_encl_load_page(struct sgx_encl *encl,
> > >   * on a SGX2 system then the EPC can be added dynamically via the SGX2
> > >   * ENCLS[EAUG] instruction.
> > >   *
> > > - * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was
> > > installed
> > > - * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
> > > + * Returns: 0 when PTE was installed successfully, -EBUSY for
> > > waiting on
> > > + * reclaimer to free EPC, -ENOMEM for out of RAM, -EFAULT as error
> > > otherwise.
> > >   */
> > > -vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
> > > -			      struct sgx_encl *encl, unsigned long addr)
> > > +int sgx_encl_eaug_page(struct vm_area_struct *vma,
> > > +		       struct sgx_encl *encl, unsigned long addr)
> > >  {
> > >  	vm_fault_t vmret = VM_FAULT_SIGBUS;
> > >  	struct sgx_pageinfo pginfo = {0};
> > > @@ -318,10 +318,10 @@ vm_fault_t sgx_encl_eaug_page(struct
> > > vm_area_struct *vma,
> > >  	struct sgx_va_page *va_page;
> > >  	unsigned long phys_addr;
> > >  	u64 secinfo_flags;
> > > -	int ret;
> > > +	int ret = -EFAULT;
> > 
> > Why?
> Original code uses ret only to temporarily store return values from the
> called functions.
> Now I also use it as return of this function and assign -EFAULT as default
> in all cases that ret is not assigned explicitly below, e.g., -EBUSY cases.
> Basically -EFAULT cases are the same as VM_FAULT_SIGBUS cases in original
> code.
> I'll clarify in comments above for the return values.
> 
> Thanks
> Haitao

OK, will look forward to it.

BR, Jarkko
