Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7201FC433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 01:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C702078D
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 01:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389070AbgFYBZR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:25:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:52359 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388928AbgFYBZR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Jun 2020 21:25:17 -0400
IronPort-SDR: BVnQ631daeQ3xZ7uZU0MOw6VuaoKCfxKBXblbGodSYpvH7gy4hBuHaEBwndBBqNfntTg1W47n+
 yCYA92RsY4vw==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="132143138"
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="132143138"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 18:25:16 -0700
IronPort-SDR: lHG9pRk5VM34/0o+zgZoBgZgr+FGKS/ovMZTi3xdPANRvKhwRkhGBYsanWNzUR682mClBXbuhL
 h7UqOmyreLVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="479314625"
Received: from hluxenbu-mobl.ger.corp.intel.com (HELO localhost) ([10.252.36.218])
  by fmsmga006.fm.intel.com with ESMTP; 24 Jun 2020 18:25:05 -0700
Date:   Thu, 25 Jun 2020 04:25:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 01/21] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
Message-ID: <20200625012503.GD21758@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-2-jarkko.sakkinen@linux.intel.com>
 <20200622173711.GJ32200@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200622173711.GJ32200@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 22, 2020 at 07:37:11PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:23AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add X86_FEATURE_SGX from CPUID.(EAX=7, ECX=1), which informs whether the
> > CPU has SGX.
> > 
> > Add X86_FEATURE_SGX1 and X86_FEATURE_SGX2 from CPUID.(EAX=12H, ECX=0),
> > which describe the level of SGX support available [1].
> > 
> > Add IA32_FEATURE_CONTROL_SGX_ENABLE. BIOS can use this bit to opt-in SGX
> 
> I'm guessing that wants to be
> 
> IA32_FEATURE_CONTROL.SGX_ENABLE
> 
> judging by the diff and the SDM chapter.

Underscore must be just a typo.

> 
> > before locking the feature control MSR [2].
> > 
> > [1] Intel SDM: 36.7.2 Intel® SGX Resource Enumeration Leaves
> > [2] Intel SDM: 36.7.1 Intel® SGX Opt-In Configuration
> > 
> > Cc: Borislav Petkov <bp@alien8.de>
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/asm/cpufeature.h        |  5 +++--
> >  arch/x86/include/asm/cpufeatures.h       |  7 ++++++-
> >  arch/x86/include/asm/disabled-features.h | 18 +++++++++++++++---
> >  arch/x86/include/asm/msr-index.h         |  1 +
> >  arch/x86/include/asm/required-features.h |  2 +-
> >  arch/x86/kernel/cpu/common.c             |  4 ++++
> >  tools/arch/x86/include/asm/cpufeatures.h |  7 ++++++-
> 
> Also, please drop this change to tools/, see
> 
> https://lkml.kernel.org/r/20200622141737.GA30611@kernel.org
> 
> from today.

OK I reverted it [*].

> With those addressed:
> 
> Reviewed-by: Borislav Petkov <bp@suse.de>

Thank you, I'll update this to the commit.

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

[*] By "git diff -R HEAD~1 -- tools/arch/x86/include/asm/cpufeatures.h | patch -p1".

/Jarkko
