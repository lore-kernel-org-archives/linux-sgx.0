Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9701DC433F5
	for <linux-sgx@archiver.kernel.org>; Sun,  6 Mar 2022 00:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiCFA07 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 5 Mar 2022 19:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFA07 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 5 Mar 2022 19:26:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E8639824;
        Sat,  5 Mar 2022 16:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68FC260FE9;
        Sun,  6 Mar 2022 00:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCF8C004E1;
        Sun,  6 Mar 2022 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646526367;
        bh=xEfvaElW6brT90ErHCFG2daGak2dq67oiihSTZPNMkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QQMLyi4Iq92WuG4nl8AcAZMEANYy2oX8XJn3CpW0xRUw18GAibSmgFWQlEpVChPKv
         QLm0TNftrF2FQK6ESdYrMgTlx+mDD/V4abIQefFFzwMgkAV6RnIMPoc5D5pa0pMrTL
         EcI+dGcMdZl9Bq3UU8GYSTB5hXGIE5fFsEa110NJFk1RWwVGZOZktKe118Pzkvu73R
         +m4nypXl1tagygNwX/FT7C+dVpwS08TMdRm1lYgx2SP7V/5fkFd7VnT0AbULkIjGYM
         uEsrz6/UE0bFK7QhHliT4b1JnBNJj+grtz+Wzc9Deh4XWqZ7kwXKGWxE4fSy1INNEO
         1x8U8njFBiF2Q==
Date:   Sun, 6 Mar 2022 02:25:25 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Shanahan, Mark" <mark.shanahan@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 16/32] x86/sgx: Support restricting of enclave page
 permissions
Message-ID: <YiP/db0KUsCx6M+y@iki.fi>
References: <Yh4fGORDaJyVrJQW@iki.fi>
 <Yh4i4hVcnfZ8QDAl@iki.fi>
 <2d2d3471-78ce-9faa-daf6-138078f5ffaa@intel.com>
 <Yh7Q5fbOtr+6YWaS@iki.fi>
 <6f65287a-f69c-971e-be2c-929e327e7ff9@intel.com>
 <op.1igppyk9wjvjmi@hhuan26-mobl1.mshome.net>
 <19155cab-ecff-a8a6-f724-98c4535642ef@intel.com>
 <ce9bd1a9-491a-09e9-1cdc-a55669f8cf28@intel.com>
 <YiLWvNxI/v43h+VQ@iki.fi>
 <YiP9IWzE3NfmzhB3@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiP9IWzE3NfmzhB3@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 06, 2022 at 02:15:32AM +0200, Jarkko Sakkinen wrote:
> On Sat, Mar 05, 2022 at 05:19:24AM +0200, Jarkko Sakkinen wrote:
> > Sorry, I missed this.
> > 
> > On Thu, Mar 03, 2022 at 01:44:14PM -0800, Dave Hansen wrote:
> > > On 3/3/22 13:23, Reinette Chatre wrote:
> > > > Unfortunately MAP_POPULATE is not supported by SGX VMAs because of their
> > > > VM_IO and VM_PFNMAP flags. When VMAs with such flags obtain this capability
> > > > then I believe that SGX would benefit.
> > > 
> > > Some Intel folks asked for this quite a while ago.  I think it's
> > > entirely doable: add a new vm_ops->populate() function that will allow
> > > ignoring VM_IO|VM_PFNMAP if present.
> > 
> > I'm sorry what I don't understand what you mean by ignoring here,
> > i.e. cannot fully comprehend the last sentece.
> > 
> > And would the vm_ops->populate() be called right after the existing ones
> > involved with the VMA creation process?
> > 
> > > Or, if nobody wants to waste all of the vm_ops space, just add an
> > > arch_vma_populate() or something which can call over into SGX.
> > > 
> > > I'll happily review the patches if anyone can put such a beast together.
> > 
> > I'll start with vm_ops->populate() and check the feedback first for
> > that.
> 
> I would instead extend populate() in file_operations into:
> 
> int (*populate)(struct file *, struct vm_area_struct *, bool populate);
> 
> This does not add to memory consumption.

Ugh, mixing my words, sorry :-) I meant:

int (*mmap)(struct file *, struct vm_area_struct *, bool populate);

BR, Jarkko
