Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904CEC432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A0F2168B
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406148AbfIXQLv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 12:11:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:51719 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388230AbfIXQLu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 12:11:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 09:11:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,544,1559545200"; 
   d="scan'208";a="364047230"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 24 Sep 2019 09:11:50 -0700
Date:   Tue, 24 Sep 2019 09:11:50 -0700
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
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [PATCH v22 01/24] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
Message-ID: <20190924161150.GA16218@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-2-jarkko.sakkinen@linux.intel.com>
 <20190924152848.GF19317@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924152848.GF19317@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 24, 2019 at 05:28:48PM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2019 at 05:26:32PM +0300, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 998c2cc08363..c5582e766121 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -222,12 +222,22 @@
> >  #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
> >  #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
> >  
> > -/* Virtualization flags: Linux defined, word 8 */
> > -#define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
> > -#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
> > -#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
> > -#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
> > -#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
> > +/*
> > + * Scattered Intel features: Linux defined, word 8.
> > + *
> > + * Note that the bit location of the SGX features is meaningful as KVM expects
> > + * the Linux defined bit to match the Intel defined bit, e.g. X86_FEATURE_SGX1
> > + * must remain at bit 0, SGX2 at bit 1, etc...
> 
> Eww, no.
> 
> > + */
> > +#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
> > +#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
> > +/* Bits [0:7] are reserved for SGX */
> 
> That leaf has "Bits 31 - 07: Reserved." So what happens if they start
> adding more bits there? We shoosh the other defines even further into
> the word?
> 
> Talk to your hw guys, if the plan is to leave those bits for other
> feature flags, then let's allocate a new capability word for F12_EAX.

We tried that, you shot it down[*], hence these shenanigans.  With respect
to more SGX feature flags, the original changelog even stated "with more
expected in the not-too-distant future".

I'm not arguing that this isn't ugly, just want to make it clear that
we're not wantonly throwing junk into the kernel.  I'm all for a dedicated
SGX word, it makes our lives easier.

[*] https://lkml.kernel.org/r/20180828102140.GA31102@nazgul.tnic
