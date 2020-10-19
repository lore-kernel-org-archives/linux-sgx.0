Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1BBC433E7
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 17:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 540752224D
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 17:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgJSRyA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 13:54:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:50333 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbgJSRx7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 13:53:59 -0400
IronPort-SDR: AdpDxLiWmMbIT0117pxASELCrhd7bmTv0io3QgY/0y/GDgB1aNoikSOJEyZauL2pYceGomg0aC
 veQmLhZ04L5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="146370926"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="146370926"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 10:53:59 -0700
IronPort-SDR: c55hAkd9zA37QhJPYDN4P3xQaQzlrvXoT5HSYdl6vmkm8IoJjLb3VlUVePMr3JnXQ4UZQvlmlk
 TEnRRO58FK2g==
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="532724126"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 10:53:55 -0700
Date:   Mon, 19 Oct 2020 10:53:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 05/24] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20201019175353.GB22358@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-6-jarkko.sakkinen@linux.intel.com>
 <a1ec29d2-41ab-fbac-6a06-8755742328d9@intel.com>
 <20201019173840.GA22119@linux.intel.com>
 <b3224f09-c853-f99a-a0a1-8c983076d25b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3224f09-c853-f99a-a0a1-8c983076d25b@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 10:48:35AM -0700, Dave Hansen wrote:
> On 10/19/20 10:38 AM, Sean Christopherson wrote:
> >>> +static inline bool encls_failed(int ret)
> >>> +{
> >>> +	int epcm_trapnr;
> >>> +
> >>> +	if (boot_cpu_has(X86_FEATURE_SGX2))
> >>> +		epcm_trapnr = X86_TRAP_PF;
> >>> +	else
> >>> +		epcm_trapnr = X86_TRAP_GP;
> >> So, the SDM makes it sound like the only thing that changes from
> >> SGX1->SGX2 is the ENCLS leafs supported.  Since the kernel doesn't use
> >> any SGX2 leaf functions, this would imply there is some other
> >> architecture change which is visible.  *But* I don't see any evidence of
> >> this in the SDM, at least from a quick scan.
> >>
> >> Why is this here?
> > SGX1 CPUs take an erratum on the #PF behavior, e.g. "KBW90 Violation of Intel
> > SGX Access-Control Requirements Produce #GP Instead of #PF".
> > 
> > https://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e3-1200v6-spec-update.pdf
> 
> OK, but that's only for "Intel ® Xeon ® E3-1200 v6 Processor Family",
> specifically stepping B-0.  That's far from a broad erratum.  I *see* it
> in other errata lists, but I still think this is too broad.
> 
> Also, what if a hypervisor masks the SGX2 cpuid bit on SGX2-capable
> hardware?  Won't the hardware still exhibit the erratum?
> 
> I don't think we can control model-specific errata behavior with an
> architectural CPUID bit.

Hmm, true.  Checking for #PF _or_ #GP on SGX1 CPUs would be my first choice.
ENCLS #GPs for other reasons, most of which would indicate a kernel bug.  It'd
be nice to limit the "#GP is expected, sort of" behavior to CPUs that might be
affected by an erratum.
