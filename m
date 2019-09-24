Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA53C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 20:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C17A21655
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 20:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfIXUWM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 16:22:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:65190 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfIXUWM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 16:22:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 13:22:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,545,1559545200"; 
   d="scan'208";a="213812412"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 24 Sep 2019 13:22:10 -0700
Date:   Tue, 24 Sep 2019 13:22:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190924202210.GC16218@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924155232.GG19317@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 24, 2019 at 05:52:32PM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2019 at 05:26:33PM +0300, Jarkko Sakkinen wrote:
> > From: Kai Huang <kai.huang@linux.intel.com>
> > 
> > Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> > Launch Control.
> > 
> > Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> > SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> > called enclaves, are always signed. All enclaves signed with the public key
> > are unconditionally allowed to initialize. [1]
> > 
> > Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs
> > whether the formentioned MSRs are writable or not. If the bit is off, the
> > public key MSRs are read-only for the OS.
> > 
> > If the MSRs are read-only, the platform must provide a launch enclave (LE).
> > LE can create cryptographic tokens for other enclaves that they can pass
> > together with their signature to the ENCLS(EINIT) opcode, which is used
> > to initialize enclaves.
> > 
> > Linux is unlikely to support the locked configuration because it takes away
> > the control of the launch decisions from the kernel.
> 
> Right, who has control over FEATURE_CONTROL_SGX_LE_WR? Can the
> kernel set it and put another hash in there or there will be locked
> configurations where setting that bit will trap?

Short answer, BIOS controls SGX_LE_WR.

The approach we chose (patch 04, which we were discussing) is to disable
SGX if SGX_LE_WR is not set, i.e. disallow SGX unless the hash MSRs exist
and are fully writable.

WRMSR will #GP if FEATURE_CONTROL is locked (bit 0), e.g. attempting to
set SGX_LE_WR will trap if FEATURE_CONTROL was locked by BIOS.  And
conversely, the various enable bits in FEATURE_CONTROL don't take effect
until FEATURE_CONTROL is locked, e.g. the LE hash MSRs aren't writable if
FEATURE_CONTROL is unlocked, regardless of whether SGX_LE_WR is set.

> I don't want to leave anything in the hands of the BIOS controlling
> whether the platform can set its own key because BIOS is known to f*ck
> it up almost every time. And so I'd like for us to be able to fix up
> things without depending on the mood of some OEM vendor's BIOS fixing
> desire.

Sadly, because FEATURE_CONTROL must be locked to fully enable SGX, the
reality is that any BIOS that supports SGX will lock FEATURE_CONTROL.

That's the status quo today as well since VMX (and SMX/TXT) is also
enabled via FEATURE_CONTROL.  KVM does have logic to enable VMX and lock
FEATURE_CONTROL if the MSR isn't locked, but AIUI that exists only to work
with old BIOSes.

If we want to support setting and locking FEATURE_CONTROL in the extremely
unlikely scenario that BIOS left it unlocked, the proper change would be
to move the existing KVM FEATURE_CONTROL logic into the early-ish boot
flow and try to set all known bits before locking FEATURE_CONTROL.  I
don't have a strong preference either way.  We opted not to try and set
FEATURE_CONTROL as we felt that doing so was more likely to cause breakage
than it was to actually "fix" a broken BIOS.

> > [1] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration

One note on Launch Control that isn't covered in the SDM: the LE hash
MSRs can also be written before SGX is activated.  SGX activation must
occur before FEATURE_CONTROL is locked, meaning BIOS can set the LE
hash MSRs to a non-intel and then lock FEATURE_CONTROL with SGX_LE_WR=0.

There's a blurb on SGX activation in the kernel docs (patch 23).

> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index c5582e766121..ca82226e25ec 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -355,6 +355,7 @@
> >  #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
> >  #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
> >  #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
> > +#define X86_FEATURE_SGX_LC		(16*32+30) /* Software Guard Extensions Launch Control */
> 
> Amazing. SGX feature bits are spread around at least three CPUID leafs:
> 
> 7_EBX, 7_ECX, 12_EAX. Maybe there's a 4th somewhere because hey... :-\

Heh, why stop at 4?  12_EBX, 12_1_ECX and 12_1_EDX are effectively feature
leafs as well, although the kernel can ignore them for the most part.
