Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9CAC432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 17:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112422146E
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 17:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440302AbfIYRSZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 13:18:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:11420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440280AbfIYRSZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 13:18:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 10:18:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="273030650"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 25 Sep 2019 10:18:24 -0700
Date:   Wed, 25 Sep 2019 10:18:24 -0700
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
Message-ID: <20190925171824.GF31852@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190924202210.GC16218@linux.intel.com>
 <20190925085156.GA3891@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925085156.GA3891@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 10:51:56AM +0200, Borislav Petkov wrote:
> On Tue, Sep 24, 2019 at 01:22:10PM -0700, Sean Christopherson wrote:
> > Sadly, because FEATURE_CONTROL must be locked to fully enable SGX, the
> > reality is that any BIOS that supports SGX will lock FEATURE_CONTROL.
> 
> That's fine. The question is, would OEMs leave the hash MSRs writable?

Realistically, there will likely be a non-trivial number of systems with
SGX_LE_WR=0 but SGX enabled.

> If, as you say above, we clear SGX feature bit - not only
> X86_FEATURE_SGX_LC - when the MSRs are not writable, then we're fine.
> Platforms sticking their own hash in there won't be supported but I
> guess their aim is not to be supported in Linux anyway.
> 
> > That's the status quo today as well since VMX (and SMX/TXT) is also
> > enabled via FEATURE_CONTROL.  KVM does have logic to enable VMX and lock
> > FEATURE_CONTROL if the MSR isn't locked, but AIUI that exists only to work
> > with old BIOSes.
> > 
> > If we want to support setting and locking FEATURE_CONTROL in the extremely
> > unlikely scenario that BIOS left it unlocked, the proper change would be
> 
> I wouldn't be too surprised if this happened. BIOS is very inventive.

Given the number of steps BIOS needs to take to enable SGX, that'd be one
"inventive" BIOS. :-)

Anyways, adding logic to opportunistically set FEATURE_CONTROL during boot
should be trivial.  I'll prep a patch and send it separately from the SGX
series, moving the existing KVM code would be a good change irrespective
of SGX.

> > One note on Launch Control that isn't covered in the SDM: the LE hash
> > MSRs can also be written before SGX is activated.  SGX activation must
> > occur before FEATURE_CONTROL is locked, meaning BIOS can set the LE
> > hash MSRs to a non-intel and then lock FEATURE_CONTROL with SGX_LE_WR=0.
> 
> This is exactly what I'm afraid of. The OEM vendors locking this down.

It's inevitable that some systems will lock down the LE hash MSRs, either
intentionally or due to lack of support for SGX_LE_WR.  The latter is
probably going to be more common than OEMs intentionally locking the MSRs,
because some Intel reference BIOSes simply don't support SGX_LE_WR, e.g. I
have a Coffee Lake SDP that has hardware support for SGX_LC, but the BIOS
doesn't provide any way to set SGX_LE_WR or leave FEATURE_CONTROL unlocked.
