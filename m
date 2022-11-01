Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0333FA3746
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Nov 2022 00:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiKAAqJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 31 Oct 2022 20:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKAAqJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 31 Oct 2022 20:46:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BC412632
        for <linux-sgx@vger.kernel.org>; Mon, 31 Oct 2022 17:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B96A1B81B03
        for <linux-sgx@vger.kernel.org>; Tue,  1 Nov 2022 00:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD98C433C1;
        Tue,  1 Nov 2022 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667263565;
        bh=IUGayUNnPupAcTdzN4uTKRMro6hVUC1+09wCbKzDWqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WTmilsb8omrktCtnCgl94GSLuT60c2WHP0MW+mxezfo44acn+HQub/+NRkjHcc1Gb
         cf7gAfpVUTscxiLPtvVqHl04KrLFheTVhpc4kGw5eJUUSqCmrEMy45J8nrg/MfMTwQ
         zoNNjANe98d9uM47hLVgyie+tPIboqfOiP2ra7UB7beKkP0RyN1tdjY4EIzEn6Ho0p
         B0OHum57YtZAxMpW/qWnPEjYQXYVJ1LMmROFvBq/IqlLrit1kyuXT4zU93s6VFC+nn
         IhzH5hYM8b+vmfEgzraTuJKGZQge5DeVGS0a1E7kj+UdtPcZMKlCdAfj1WQqESj5hJ
         C158+D8Oqy3XQ==
Date:   Tue, 1 Nov 2022 02:46:00 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Message-ID: <Y2BsSCM1BWlsqPcK@kernel.org>
References: <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 24, 2022 at 09:32:13AM +0800, Zhiquan Li wrote:
> 
> 
> On 2022/10/24 04:39, jarkko@kernel.org wrote:
> >> As you can see if the EPC page has already been populated at a given index of
> >> one virtual EPC instance, the current fault handler just assumes the mapping is
> >> already there and returns success immediately.  This causes a bug when one
> >> virtual EPC instance is shared by multi processes via fork(): if the EPC page at
> >> one index is already populated by the parent process, when the child accesses
> >> the same page using different virtual address, the fault handler just returns
> >> success w/o actually setting up the mapping for the child, resulting in endless
> >> page fault.
> >>
> >> This needs to be fixed in no matter what way.
> > I think you mean that vm_insert_pfn() does not happen for child because
> > of early return? I did not understand the part about "different virtual
> > addresses", as it is the same mapping.
> > 
> 
> If userspace do something like this, the child will get "different
> virtual address":
> 
>   ... parent run enclave within VM ...
>   if (fork() == 0) {
>       int *caddr = mmap(NULL, 4096, PROT_READ, MAP_SHARED, vepc_fd, 0);
>       printf("child: %d\n", caddr[0]);
>   }
> 
> 
> - "vepc_fd" is inherited from parent which had opened /dev/sgx_vepc.
> - mmap() will create a VMA in child with "different virtual addresses".
> - "caddr[0]" will cause a page fault as it's a new mapping.
> 
> 1. Then kernel will run into the code snippet referenced by Kai.
> 2. The early return 0 will result in sgx_vepc_fault() return
>    "VM_FAULT_NOPAGE".
> 3. This return value will make the condition as true at
>    function do_user_addr_fault()
> 
>    if (likely(!(fault & VM_FAULT_ERROR)))
>        return;
> 
> 4. Since this page fault has not been handled and "$RIP" is still the
>    original value, it will result in the same page fault again.  Namely,
>    it's an endless page fault.
> 
> But the problem is neither the early return in __sgx_vepc_fault() nor
> the return of VM_FAULT_NOPAGE at sgx_vepc_fault().  The root cause has
> been highlighted by Kai, one virtual EPC instance
> can only be mmap()-ed by the process which opens /dev/sgx_vepc.
> 
> In fact, to share a virtual EPC instance in userspace doesn't make any
> sense.  Even though it can be shared by child, the virtual EPC page
> cannot be used by child correctly.

OK, makes sense, thanks for the explanation!

Why would we want to enforce for user space not to do this, even
if it does cause malfunctioning program?

BR, Jarkko
