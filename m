Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D17C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 23:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 110C82086C
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 23:35:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 110C82086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbeKGJC6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 04:02:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:48290 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730409AbeKGJC6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Nov 2018 04:02:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 15:35:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,473,1534834800"; 
   d="scan'208";a="84504054"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga008.fm.intel.com with ESMTP; 06 Nov 2018 15:35:15 -0800
Date:   Tue, 6 Nov 2018 15:35:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20181106233515.GB11101@linux.intel.com>
References: <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <b9c53669-cd27-e3bc-3d62-f47c77029c43@intel.com>
 <1C426267-492F-4AE7-8BE8-C7FE278531F9@amacapital.net>
 <209cf4a5-eda9-2495-539f-fed22252cf02@intel.com>
 <9B76E95B-5745-412E-8007-7FAA7F83D6FB@amacapital.net>
 <CALCETrV=iodOQhvXAyjs0TQNbCaFdkhrZqRHvWTnBfo2m0qXpA@mail.gmail.com>
 <1541541565.8854.13.camel@intel.com>
 <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7FF4802E-FBC5-4E6D-A8F6-8A65114F18C7@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106233515.9Ydoqwqkuyf4ZWei1k5GZQIlTqn6k76hqwwT_6gKYiA@z>

On Tue, Nov 06, 2018 at 03:00:56PM -0800, Andy Lutomirski wrote:
> 
> 
> >> On Nov 6, 2018, at 1:59 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >> 
> >>> On Tue, 2018-11-06 at 13:41 -0800, Andy Lutomirski wrote:
> >> Sean, how does the current SDK AEX handler decide whether to do
> >> EENTER, ERESUME, or just bail and consider the enclave dead?  It seems
> >> like the *CPU* could give a big hint, but I don't see where there is
> >> any architectural indication of why the AEX code got called or any
> >> obvious way for the user code to know whether the exit was fixed up by
> >> the kernel?
> > 
> > The SDK "unconditionally" does ERESUME at the AEP location, but that's
> > bit misleading because its signal handler may muck with the context's
> > RIP, e.g. to abort the enclave on a fatal fault.
> > 
> > On an event/exception from within an enclave, the event is immediately
> > delivered after loading synthetic state and changing RIP to the AEP.
> > In other words, jamming CPU state is essentially a bunch of vectoring
> > ucode preamble, but from software's perspective it's a normal event
> > that happens to point at the AEP instead of somewhere in the enclave.
> > And because the signals the SDK cares about are all synchronous, the
> > SDK can simply hardcode ERESUME at the AEP since all of the fault logic
> > resides in its signal handler.  IRQs and whatnot simply trampoline back
> > into the enclave.
> > 
> > Userspace can do something funky instead of ERESUME, but only *after*
> > IRET/RSM/VMRESUME has returned to the AEP location, and in Linux's
> > case, after the trap handler has run.
> > 
> > Jumping back a bit, how much do we care about preventing userspace
> > from doing stupid things? 
> 
> My general feeling is that userspace should be allowed to do apparently
> stupid things. For example, as far as the kernel is concerned, Wine and
> DOSEMU are just user programs that do stupid things. Linux generally tries
> to provide a reasonably complete view of architectural behavior. This is
> in contrast to, say, Windows, where IIUC doing an unapproved WRFSBASE May
> cause very odd behavior indeed. So magic fixups that do non-architectural
> things are not so great.

Sorry if I'm beating a dead horse, but what if we only did fixup on ENCLU
with a specific (ignored) prefix pattern?  I.e. effectively make the magic
fixup opt-in, falling back to signals.  Jamming RIP to skip ENCLU isn't
that far off the architecture, e.g. EENTER stuffs RCX with the next RIP so
that the enclave can EEXIT to immediately after the EENTER location.

> (How does the Windows case work?  If there’s an exception after the untrusted
> stack allocation and before EEXIT and SEH tries to handle it, how does the
> unwinder figure out where to start?)

No clue, I'll ask and report back.
