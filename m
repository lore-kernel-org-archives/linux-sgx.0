Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AAAC432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 18:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F03F207E0
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 18:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439846AbfIYSSP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 14:18:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:17205 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437692AbfIYSSP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 14:18:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 11:18:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="364406188"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2019 11:18:14 -0700
Date:   Wed, 25 Sep 2019 11:18:14 -0700
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
Message-ID: <20190925181814.GH31852@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190925140903.GA19638@linux.intel.com>
 <20190925151949.GE3891@zn.tnic>
 <20190925164932.GE31852@linux.intel.com>
 <20190925172815.GG3891@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925172815.GG3891@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 07:28:15PM +0200, Borislav Petkov wrote:
> On Wed, Sep 25, 2019 at 09:49:32AM -0700, Sean Christopherson wrote:
> > Correct, only X86_FEATURE_SGX_LC is cleared.  The idea is to have SGX_LC
> > reflect whether or not flexible launch control is fully enabled, no more
> > no less.
> 
> So we do not disable SGX when the MSRs are read-only - we disable only
> launch control.
> 
> > Functionally, this doesn't impact support for native enclaves as the
> > driver will refuse to load if SGX_LC=0.
> 
> So why aren't we clearing all feature bits then? What's the purpose for
> leaving them set if we're not going to support hardcoded OEM vendor hash
> in the MSRs anyway?

To allow KVM to expose SGX to guests even if the MSRs are locked down.

> > Looking forward, this *will* affect KVM.  As proposed, KVM would expose
> > SGX to a guest regardless of SGX_LC support.
> > 
> > https://lkml.kernel.org/r/20190727055214.9282-17-sean.j.christopherson@intel.com
> 
> ... which would do what exactly? Guests can execute SGX only
> when signed by the Intel key, when LC is disabled?

Guest can only run launch enclaves that are signed by whatever key matches
the LE hash MSRs.  That could be an Intel key, e.g. if BIOS neglected to
set FEATURE_CONTROL.SGX_LE_WR=1, or some third party key if BIOS
deliberately rewrote the hash MSRs and cleared SGX_LE_WR.

A mainline Linux kernel in the guest would not allow running enclaves due
to the MSRs being locked, i.e. doing an end-around on the host kernel to
run enclaves on a locked system would require a custom Linux kernel or a
different OS entirely.
