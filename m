Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3E4C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 09:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB411207EA
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 09:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgIDJw1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:52:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:59191 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgIDJw0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 05:52:26 -0400
IronPort-SDR: uhPkgWeOenhZt43vVMvhdU3Oj5tS4UgDmPWRnlezcN2FZkCJV+lW9U8+UE2esnhL5IA2S0QlPC
 ZqnETaNJMBYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="137238795"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="137238795"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 02:52:26 -0700
IronPort-SDR: 2ybPULVKtlKqg8SipJXoa3G+4y085o7XPcRqzKUsYiBzQptlkR7jLLPEVaTz8lxuRdwwIBHNKT
 JqNzVdsdZGWA==
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="302549851"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 02:52:26 -0700
Date:   Fri, 4 Sep 2020 02:52:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200904095223.GA7844@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <2ddc5a5b-0929-b99f-41a0-06b3b53fcc8f@intel.com>
 <20200826201511.GB21459@sjchrist-ice>
 <a4ccd8e1-0c0f-8664-b0c2-d7a30bd5c31a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4ccd8e1-0c0f-8664-b0c2-d7a30bd5c31a@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 26, 2020 at 04:26:11PM -0700, Xing, Cedric wrote:
> After countless discussions along this upstream journey, I thought we had
> agreed that simplicity was the priority. And for simplicity we were even
> willing to give up compliance to x86_64 ABI. Then how do you justify
> treating rust better than other programming languages? This looks a hard
> sell to me.

If you view using a struct instead of a multiple params as a separate cost,
adding a pass-through param to throw a bone to Rust adds zero complexity.
The flags field has nothing to do with Rust whatsoever.

As for the struct itself, I suppose you could argue it's gratuitous, but
I don't buy that it adds complexity.  The impact on the vDSO is something
like four extra instructions, two of which are a CMP+Jcc to enforce the
flags, and the others are the additional moves need to chase pointers through
the struct.

Unless someone really dislikes structs, there is no added complexity to the
caller, it's just slightly different code, e.g. the selftest update for the
struct variant actually removed code.

> > > > Moving the params into a struct will also make it less painful to use
> > > > dedicated exit reasons, and to support exiting on interrupts in future
> > > > patches.
> > > > 
> > > My apology for not following discussion lately. What did you mean by
> > > "dedicated exit reasons" and why was it "painful"? According to another
> > > thread, I guess we wouldn't have "exiting on interrupts".
> > 
> > Currently the vDSO returns -EFAULT if the enclave encounters an exception,
> > which is kludgy for two reasons:
> > 
> >   1. EFAULT traditionally means "bad address", whereas an exception could be
> >      a #UD in the enclave.
> > 
> >   2. Returning -EFAULT provides weird semantics as it implies the vDSO call
> >      failed, which is not the case.  The vDSO itself was successful, i.e. it
> >      did the requested EENTER/ERESUME operation, and should really return '0'.
> > 
> EFAULT is descriptive enough for me. And more importantly detailed/specific
> info is always available in exinfo.
>
> IMO, the purpose of return code is for the caller/handler to branch on. If 2
> cases share the same execution path, then there's no need to distinguish
> them. In the case of SGX, most (if not all) exceptions are handled in the
> same way - nested EENTER, then what's point of distinguishing them? Please
> note that detailed info is always available in exinfo to cover corner cases.

The primary motiviation is to adhere to the general rules of the kernel,
specifically that -EFAULT isn't intended as a catchall for exceptions. 

> Moreover, even the vDSO API itself cannot tell between faults at
> EENTER/ERESUME (the vDSO itself failes) vs. faults inside the enclave (vDSO
> succeeded but the enclave fails). I don't think you can be accurate without
> complicating the code significantly.

And I didn't even try.  The proposed documentation explicitly states that
"success" is defined as attempting ENCLU.

> > The proposed solution for #1 is to define arbitrary return values to
> > differentiate between synchronous (EEXIT) exits and asynchronous exits due
> > to exceptions.  But that doesn't address #2, and gets especially awkward when
> > dealing with the call back return, which is also overloaded to use positive
> > return values for ENCLU leafs.
> > 
> > Passing a "run" struct makes it trivially easy to different the return value
> > of the vDSO function from the enclave exit reason, and to avoid collisions
> > with the return value from the userspace callback.
> > 
> When a callback is configured, the vDSO NEVER returns to caller directly -
> i.e. all return codes must be from the callback but NOT the vDSO. I don't
> see any collisions here.

Unless the user provides a bad leaf, in which case -EINVAL is returned.

But that wasn't what I was talking about.  If we want to use arbitrary values
instead of hijacking -EFAULT (and possibly -EINTR), then we run into problems
with choosing an arbitrary value that won't collide with the value returned
from the callback to the _vDSO_.  The callback essentially gets dibs on all
negative values and 0 is off limits.  That leaves positive values, but those
are interpreted as the new ENCLU leaf by the vDSO.  That means the vDSO can
"return" a value to the callback that the callback can't safely reflect back
to the vDSO.  Using an exit reason side steps that by virtue of it not being
the return value in either direction.
