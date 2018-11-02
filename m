Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3EBC65C22
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08502081F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C08502081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbeKCClr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:41:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:38026 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbeKCClr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 22:41:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2018 10:33:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,456,1534834800"; 
   d="scan'208";a="104795413"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.193])
  by fmsmga001.fm.intel.com with ESMTP; 02 Nov 2018 10:33:50 -0700
Date:   Fri, 2 Nov 2018 10:33:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
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
Message-ID: <20181102173350.GF7393@linux.intel.com>
References: <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com>
 <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102173350.w9CyaVgxSj-3rhkJZw3hdgAj9Mkd_fx_-pV2xqyNqYI@z>

On Fri, Nov 02, 2018 at 10:13:23AM -0700, Dave Hansen wrote:
> On 11/2/18 10:06 AM, Sean Christopherson wrote:
> > On Fri, Nov 02, 2018 at 09:56:44AM -0700, Dave Hansen wrote:
> >> On 11/2/18 9:30 AM, Sean Christopherson wrote:
> >>> What if rather than having userspace register an address for fixup, the
> >>> kernel instead unconditionally does fixup on the ENCLU opcode?
> >>
> >> The problem is knowing what to do for the fixup.  If we have a simple
> >> action to take that's universal, like backing up %RIP, or setting some
> >> other register state, it's not bad.
> > 
> > Isn't the EENTER/RESUME behavior universal?  Or am I missing something?
> 
> Could someone write down all the ways we get in and out of the enclave?
> 
> I think we always get in from userspace calling EENTER or ERESUME.  We
> can't ever enter directly from the kernel, like via an IRET from what I
> understand.

Correct, the only way to get into the enclave is EENTER or ERESUME.
My understanding is that even SMIs bounce through the AEX target
before transitioning to SMM.
 
> We get *out* from exceptions, hardware interrupts, or enclave-explicit
> EEXITs.  Did I miss any?  Remind me where the hardware lands the control
> flow in each of those exit cases.

And VMExits.  There are basically two cases: EEXIT and everything else.
EEXIT is a glorified indirect jump, e.g. %RBX holds the target %RIP.
Everything else is an Asynchronous Enclave Exit (AEX).  On an AEX, %RIP
is set to a value specified by EENTER/ERESUME, %RBP and %RSP are
restored to pre-enclave values and all other registers are loaded with
synthetic state.  The actual interrupt/exception/VMExit then triggers,
e.g. the %RIP on the stack for an exception is always the AEX target,
not the %RIP inside the enclave that actually faulted.
