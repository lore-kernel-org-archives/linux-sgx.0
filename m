Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48049C4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 18:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A5B220878
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 18:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgJASuJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 14:50:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:56900 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgJASuJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 14:50:09 -0400
IronPort-SDR: NFLs3TnL7jDTdE/go0I/J1uvuwqlEp26GhJIqcuoNSDzXnxTHH3kM2jj50yGMh5toa1ui4p9lD
 9yKcopWpVDRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="160222603"
X-IronPort-AV: E=Sophos;i="5.77,324,1596524400"; 
   d="scan'208";a="160222603"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 11:50:06 -0700
IronPort-SDR: tYnWAxqffu3NS3Z3wq3K+Ona77mGv7Ka3NTdtibynD1yUlo8VFi40YPCPah5MsARiPnd3ruMKB
 0zwTiL1hdg1A==
X-IronPort-AV: E=Sophos;i="5.77,324,1596524400"; 
   d="scan'208";a="504946958"
Received: from mcampone-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.51.88])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 11:49:58 -0700
Date:   Thu, 1 Oct 2020 21:49:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201001184956.GB15664@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-12-jarkko.sakkinen@linux.intel.com>
 <20201001173653.GG7474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001173653.GG7474@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 01, 2020 at 10:36:53AM -0700, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 02:28:29PM +0300, Jarkko Sakkinen wrote:
> > +int __init sgx_drv_init(void)
> > +{
> > +	unsigned int eax, ebx, ecx, edx;
> > +	u64 attr_mask, xfrm_mask;
> > +	int ret;
> > +	int i;
> > +
> > +	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
> > +		pr_info("The public key MSRs are not writable.\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
> > +	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
> > +	sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);
> > +	sgx_encl_size_max_32 = 1ULL << (edx & 0xFF);
> > +
> > +	cpuid_count(SGX_CPUID, 1, &eax, &ebx, &ecx, &edx);
> > +
> > +	attr_mask = (((u64)ebx) << 32) + (u64)eax;
> > +	sgx_attributes_reserved_mask = ~attr_mask | SGX_ATTR_RESERVED_MASK;
> > +
> > +	if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> > +		xfrm_mask = (((u64)edx) << 32) + (u64)ecx;
> > +
> > +		for (i = 2; i < 64; i++) {
> > +			cpuid_count(0x0D, i, &eax, &ebx, &ecx, &edx);
> > +			if ((1UL << i) & xfrm_mask)
> 
> Any reason not to use BIT()?  The max size computations are arguably not
> bit operation, but XFRM is a set of bits.

AFAIK, yes.

If you have bandwidth drop a patch for this and provision thing. I'm
busy with the documentation. If not, that's fine, I'll do it once I'm
able to.

Thanks.

/Jarkko
