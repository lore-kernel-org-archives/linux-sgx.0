Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AF6C432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 14:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CF721D7C
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 14:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfIYOJ1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 10:09:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:51020 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbfIYOJ1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 10:09:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 07:09:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,548,1559545200"; 
   d="scan'208";a="364333313"
Received: from kmakows-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.225])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2019 07:09:09 -0700
Date:   Wed, 25 Sep 2019 17:09:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190925140903.GA19638@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924155232.GG19317@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> 
> I don't want to leave anything in the hands of the BIOS controlling
> whether the platform can set its own key because BIOS is known to f*ck
> it up almost every time. And so I'd like for us to be able to fix up
> things without depending on the mood of some OEM vendor's BIOS fixing
> desire.

The BIOS has control over the feature control bit because, as we know,
the feature control register is usually locked down before handover to
the OS.

The driver will support only the case where the bit is set i.e. that
it can freely write to the MSRs MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}.
It will refuse to initialize otherwise.

> > [1] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Haim Cohen <haim.cohen@intel.com>
> > Signed-off-by: Haim Cohen <haim.cohen@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> This time checkpatch is right:
> 
> WARNING: Missing Signed-off-by: line by nominal patch author 'Kai Huang <kai.huang@linux.intel.com>'
> 
> And looking at the SOB chain, sounds like people need to make up their
> mind about authorship...

I'll make myself the sole author for this one as 98% of the effort in
this patch is really the commit message, which I rewrote for v22, and 2%
are the code changes (mechanical, peek at SDM).  This patch was squashed
from three patches, all like one line changes, and Kai was author of one
of them.

The next version will thus have only my SOB and author information will
be changed. I doubt anyone will complain if I do that.

/Jarkko
