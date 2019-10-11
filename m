Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B483ECE58D
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 18:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662E421835
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 18:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfJKSPv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Oct 2019 14:15:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:58405 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfJKSPu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Oct 2019 14:15:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 11:15:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,285,1566889200"; 
   d="scan'208";a="346101167"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2019 11:15:50 -0700
Date:   Fri, 11 Oct 2019 11:15:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20191011181550.GB30935@linux.intel.com>
References: <20191010113745.GA12842@linux.intel.com>
 <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 11, 2019 at 04:37:25PM +0000, Jethro Beekman wrote:
> UAPI:
> 
> This got a whole lot more complex for userspace compared to the out-of-tree
> driver.
> 
> 1. Manually needing to mmap a naturally-aligned memory region by allocating
> too much memory and then unmapping parts is quite annoying. Why was the
> auto-aligning removed? I think this will need to be handled the same for
> every consumer of SGX, so I don't see why this is not handled in the kernel.
> It never seems wrong to align if NULL is passed as the requested address.
> Alternatively, is there room in the flags for a MAP_ALIGNED bit?

I'm pretty sure everyone agrees it's annoying.  The short of it is that
the SGX driver is the wrong place to do the alignment.  The driver could
key off addr=0, but we don't want to take on that implicit behavior.

A MAP_ALIGNED flag to have the allocation be naturally aligned is the
ideal solution.  It's definitely something we should pursue, but that can
and probably should be done in parallel to the SGX series.

> 2. Having to re-open the device for every enclave is also annoying. This
> means you need a filesystem available throughout the process lifetime. I
> tried dup, but that doesn't work. Can we make dup work?

The semantics of dup() won't get you what want, as dup() just creates a
new descriptor pointing at the same file.

An alternative solution that was proposed was to have an ioctl() for
creating an enclave.  But that means using an anonymous inode, which runs
afoul of SELinux permissions, e.g. every _process_ that runs enclaves
would require EXECMEM.  Linus was quite clear that SGX wouldn't be merged
if using it required users to degrade existing security.

I'm open to other ideas.  I wasn't aware this was a pain point and file
stuff isn't exactly my area of expertise, so I haven't put much/any
thought into alternatives.

> 3. Needing to mprotect every page with the precise permissions needed after
> EINIT is really bad. This means I have to remember this data for every page
> between EADD and EINIT. I don't care about SELinux, I trust the ECPM will do
> its job for me. Can we make it so that I can protect the whole range at once,
> or protect the individual pages at EADD time?

You can mprotect() or mmap(..., MAP_FIXED) an enclave range once all
pages covered by the specified range have been added to the enclave, i.e.
at EADD.  I double checked this with the selftest.  Holler if you're
seeing different behavior.


> VDSO:
> 
> It is *difficult* to link to weakly link to a symbol in the VDSO. Anyway, I
> figured it out.
> 
> 1. What if I don't want to automatically ERESUME after kernel interrupt?

Do EENTER/ERESUME directly instead of going through the vDSO.

> 2. I normally do a sanity check after ENCLU[EENTER] that EAX = EEXIT. The
> current implementation just clears EAX instead without looking at it.

Hmm, the only reason I can think of for checking EAX would be to support
userspace mucking with EAX in a #DB/#BP signal handler.  At that point, I
would expect the signal handler to modify RIP as well.  Reaching the XOR
via any other non-EEXIT path would require a kernel bug.

Was there a specific scenario or use case you had in mind?  I'm not
against adding a check, I just don't see what value it would provide.
