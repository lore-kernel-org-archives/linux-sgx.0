Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726CEC433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Mar 2022 03:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiCEDVC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Mar 2022 22:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCEDVB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Mar 2022 22:21:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B8AD4442;
        Fri,  4 Mar 2022 19:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 741E0B82B90;
        Sat,  5 Mar 2022 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DF4C004E1;
        Sat,  5 Mar 2022 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646450410;
        bh=0W9YlmVUZoVMvDTw8eSOwjxegMCKAQYdeKMejdSlL/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RoudqW+mhUKmKkQy0HTNH3Zt/M1XrlxocmmLmYdemDKBxiOPUliy9fBU8/80tivPN
         D14ajWhfhDxAtnFnOjb4yElg8iL02POd+HjsDxeM8sPwuO4UTDbffqvmzRc7Ai28+L
         /npeqEzYai4v/yrvJnDC929leUzgQJh1QAzHZtylcaC+s/cZK8UApBmeRMPyBjt74p
         kcZXEMCgsBDlcPp5b/Z9jnBOx822U4C1LC7OLPlzNiU7hzTPp6S/qc8ee+Gj2SE6Uo
         zjbpR06rpQ+bkLSSukaISVMGleNh70PSqKM79P2Sfbm2LisRfrks/TbKmBm+svYdEG
         LkRrIa//lM8jA==
Date:   Sat, 5 Mar 2022 05:19:24 +0200
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
Message-ID: <YiLWvNxI/v43h+VQ@iki.fi>
References: <Yhy/GvJegnTqYdq6@iki.fi>
 <f6a256a6-a7d7-a8e7-c9a8-e232203c63af@intel.com>
 <Yh4fGORDaJyVrJQW@iki.fi>
 <Yh4i4hVcnfZ8QDAl@iki.fi>
 <2d2d3471-78ce-9faa-daf6-138078f5ffaa@intel.com>
 <Yh7Q5fbOtr+6YWaS@iki.fi>
 <6f65287a-f69c-971e-be2c-929e327e7ff9@intel.com>
 <op.1igppyk9wjvjmi@hhuan26-mobl1.mshome.net>
 <19155cab-ecff-a8a6-f724-98c4535642ef@intel.com>
 <ce9bd1a9-491a-09e9-1cdc-a55669f8cf28@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce9bd1a9-491a-09e9-1cdc-a55669f8cf28@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Sorry, I missed this.

On Thu, Mar 03, 2022 at 01:44:14PM -0800, Dave Hansen wrote:
> On 3/3/22 13:23, Reinette Chatre wrote:
> > Unfortunately MAP_POPULATE is not supported by SGX VMAs because of their
> > VM_IO and VM_PFNMAP flags. When VMAs with such flags obtain this capability
> > then I believe that SGX would benefit.
> 
> Some Intel folks asked for this quite a while ago.  I think it's
> entirely doable: add a new vm_ops->populate() function that will allow
> ignoring VM_IO|VM_PFNMAP if present.

I'm sorry what I don't understand what you mean by ignoring here,
i.e. cannot fully comprehend the last sentece.

And would the vm_ops->populate() be called right after the existing ones
involved with the VMA creation process?

> Or, if nobody wants to waste all of the vm_ops space, just add an
> arch_vma_populate() or something which can call over into SGX.
> 
> I'll happily review the patches if anyone can put such a beast together.

I'll start with vm_ops->populate() and check the feedback first for
that.

BR, Jarkko
