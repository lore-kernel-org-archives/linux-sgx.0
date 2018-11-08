Return-Path: <SRS0=tPzl=NT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E2EC43441
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 22:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D32A820883
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 22:25:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D32A820883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbeKIHlt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Nov 2018 02:41:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:46002 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbeKIHls (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Nov 2018 02:41:48 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2018 14:04:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="104641689"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga004.fm.intel.com with ESMTP; 08 Nov 2018 14:04:17 -0800
Date:   Thu, 8 Nov 2018 14:04:16 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Carlos O'Donell <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181108220416.GA18263@linux.intel.com>
References: <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <20181108195420.GA14715@linux.intel.com>
 <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
 <7027c3dc-addb-1b96-027e-a57fccf1f812@intel.com>
 <20181108211600.GA17167@linux.intel.com>
 <7d965299-0402-f730-6e1a-515a836a3956@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d965299-0402-f730-6e1a-515a836a3956@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181108220416.U-j2wY7M7fGW17had3GjVKaAhgnavC6-fcoXSJ1dwX4@z>

On Thu, Nov 08, 2018 at 01:50:31PM -0800, Dave Hansen wrote:
> On 11/8/18 1:16 PM, Sean Christopherson wrote:
> > On Thu, Nov 08, 2018 at 12:10:30PM -0800, Dave Hansen wrote:
> >> On 11/8/18 12:05 PM, Andy Lutomirski wrote:
> >>> Hmm.  The idea being that the SDK preserves RBP but not RSP.  That's
> >>> not the most terrible thing in the world.  But could the SDK live with
> >>> something more like my suggestion where the vDSO supplies a normal
> >>> function that takes a struct containing registers that are visible to
> >>> the enclave?  This would make it extremely awkward for the enclave to
> >>> use the untrusted stack per se, but it would make it quite easy (I
> >>> think) for the untrusted part of the SDK to allocate some extra memory
> >>> and just tell the enclave that *that* memory is the stack.
> >>
> >> I really think the enclave should keep its grubby mitts off the
> >> untrusted stack.  There are lots of ways to get memory, even with
> >> stack-like semantics, that don't involve mucking with the stack itself.
> >>
> >> I have not heard a good, hard argument for why there is an absolute
> >> *need* to store things on the actual untrusted stack.
> > 
> > Convenience and performance are the only arguments I've heard, e.g. so
> > that allocating memory doesn't require an extra EEXIT->EENTER round trip.
> 
> Well, for the first access, it's going to cost a bunch asynchronous
> exits to fault in all the stack pages.  Instead of that, if you had a
> single area, or an explicit out-call to allocate and populate the area,
> you could do it in a single EEXIT and zero asynchronous exits for demand
> page faults.
> 
> So, it might be convenient, but I'm rather suspicious of any performance
> arguments.

Ya, I meant versus doing an EEXIT on every allocation, i.e. a very
naive allocation scheme.
