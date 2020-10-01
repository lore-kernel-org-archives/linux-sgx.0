Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150D8C4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 17:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D707420897
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 17:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732642AbgJARg5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:36:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:63052 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732096AbgJARg5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 13:36:57 -0400
IronPort-SDR: fxp/O1jWVJY9DE/RrVEg0+VL1pBD8RPgk8n+ZJhdKOfI+RoAxfD+yuk/fUuNO7ESvp4L2IUEh8
 vPAqNZZ33rrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="247528213"
X-IronPort-AV: E=Sophos;i="5.77,324,1596524400"; 
   d="scan'208";a="247528213"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 10:36:55 -0700
IronPort-SDR: /tLPVE/O8p8boW2dIofsySD2WGZdOye2YFx6bfNPyidg/4aJloQeFUf7sqB1d7F/aGD8GRe8hs
 GjnBjhp4pu9A==
X-IronPort-AV: E=Sophos;i="5.77,324,1596524400"; 
   d="scan'208";a="339631820"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 10:36:54 -0700
Date:   Thu, 1 Oct 2020 10:36:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20201001173653.GG7474@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-12-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:29PM +0300, Jarkko Sakkinen wrote:
> +int __init sgx_drv_init(void)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +	u64 attr_mask, xfrm_mask;
> +	int ret;
> +	int i;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
> +		pr_info("The public key MSRs are not writable.\n");
> +		return -ENODEV;
> +	}
> +
> +	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
> +	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
> +	sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);
> +	sgx_encl_size_max_32 = 1ULL << (edx & 0xFF);
> +
> +	cpuid_count(SGX_CPUID, 1, &eax, &ebx, &ecx, &edx);
> +
> +	attr_mask = (((u64)ebx) << 32) + (u64)eax;
> +	sgx_attributes_reserved_mask = ~attr_mask | SGX_ATTR_RESERVED_MASK;
> +
> +	if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +		xfrm_mask = (((u64)edx) << 32) + (u64)ecx;
> +
> +		for (i = 2; i < 64; i++) {
> +			cpuid_count(0x0D, i, &eax, &ebx, &ecx, &edx);
> +			if ((1UL << i) & xfrm_mask)

Any reason not to use BIT()?  The max size computations are arguably not
bit operation, but XFRM is a set of bits.

> +				sgx_xsave_size_tbl[i] = eax + ebx;
> +		}
> +
> +		sgx_xfrm_reserved_mask = ~xfrm_mask;
> +	}
> +
> +	ret = misc_register(&sgx_dev_enclave);
> +	if (ret) {
> +		pr_err("Creating /dev/sgx/enclave failed with %d.\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
