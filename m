Return-Path: <SRS0=tPzl=NT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22631ECDE47
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 21:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E542320818
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 21:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E542320818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbeKIGxU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Nov 2018 01:53:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:61568 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbeKIGxU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Nov 2018 01:53:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2018 13:16:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="102760809"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga002.fm.intel.com with ESMTP; 08 Nov 2018 13:16:00 -0800
Date:   Thu, 8 Nov 2018 13:16:00 -0800
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
Message-ID: <20181108211600.GA17167@linux.intel.com>
References: <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <20181108195420.GA14715@linux.intel.com>
 <CALCETrUCQbPMfBJVRRg=0apEU=2U2ps74UPTrN8bFqi1k0K4VA@mail.gmail.com>
 <7027c3dc-addb-1b96-027e-a57fccf1f812@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7027c3dc-addb-1b96-027e-a57fccf1f812@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181108211600.MH9dKZtGoKuzS9OMBQiGsHoLzb07YndIV99k-Nav3xY@z>

On Thu, Nov 08, 2018 at 12:10:30PM -0800, Dave Hansen wrote:
> On 11/8/18 12:05 PM, Andy Lutomirski wrote:
> > Hmm.  The idea being that the SDK preserves RBP but not RSP.  That's
> > not the most terrible thing in the world.  But could the SDK live with
> > something more like my suggestion where the vDSO supplies a normal
> > function that takes a struct containing registers that are visible to
> > the enclave?  This would make it extremely awkward for the enclave to
> > use the untrusted stack per se, but it would make it quite easy (I
> > think) for the untrusted part of the SDK to allocate some extra memory
> > and just tell the enclave that *that* memory is the stack.
> 
> I really think the enclave should keep its grubby mitts off the
> untrusted stack.  There are lots of ways to get memory, even with
> stack-like semantics, that don't involve mucking with the stack itself.
> 
> I have not heard a good, hard argument for why there is an absolute
> *need* to store things on the actual untrusted stack.

Convenience and performance are the only arguments I've heard, e.g. so
that allocating memory doesn't require an extra EEXIT->EENTER round trip.

> We could quite easily have the untrusted code just promise to allocate a
> stack-sized virtual area (even derived from the stack rlimit size) and
> pass that into the enclave for parameter use.

I agree more and more the further I dig.  AFAIK there is no need to for
the enclave to actually load %rsp.  The initial EENTER can pass in the
base/top of the pseudo-stack and from there the enclave can manage it
purely in software.
