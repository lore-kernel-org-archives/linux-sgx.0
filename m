Return-Path: <SRS0=iBWu=AN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E38C433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jul 2020 03:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1C6207CD
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jul 2020 03:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgGBD7D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 1 Jul 2020 23:59:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:26776 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgGBD7C (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 1 Jul 2020 23:59:02 -0400
IronPort-SDR: UeVKnAbzP9rV1gTs3a2u29CPmtIRCgtjMO1UdQtvlnfFX2evOWMfjqInDK8XFLHNaxyulKhd2e
 h0JTHWwqe8TQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126403730"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="126403730"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 20:59:02 -0700
IronPort-SDR: BVhIUUZ1L/xEqOBO26oXtglVzitgz3GWW+7g3i67tenBlNkARotauZWDCTJyDmhbtBaIFmo1cO
 c9Cf4XlxNByQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="281818263"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2020 20:59:02 -0700
Date:   Wed, 1 Jul 2020 20:59:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200702035902.GC1819@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> +static int sgx_validate_secs(const struct sgx_secs *secs,
> +			     unsigned long ssaframesize)
> +{
> +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> +		return -EINVAL;
> +
> +	if (secs->base & (secs->size - 1))
> +		return -EINVAL;
> +
> +	if (secs->miscselect & sgx_misc_reserved_mask ||
> +	    secs->attributes & sgx_attributes_reserved_mask ||
> +	    secs->xfrm & sgx_xfrm_reserved_mask)
> +		return -EINVAL;
> +
> +	if (secs->attributes & SGX_ATTR_MODE64BIT) {
> +		if (secs->size > sgx_encl_size_max_64)
> +			return -EINVAL;
> +	} else if (secs->size > sgx_encl_size_max_32)
> +		return -EINVAL;

These should be >=, not >, the SDM uses one of those fancy ≥ ligatures.

Internal versions use more obvious pseudocode, e.g.:

    if ((DS:TMP_SECS.ATTRIBUTES.MODE64BIT = 1) AND
        (DS:TMP_SECS.SIZE AND (~((1 << CPUID.18.0:EDX[15:8]) – 1)))
    {
        #GP(0);
    }

> +
> +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
> +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
> +	     ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
> +		return -EINVAL;
> +
> +	if (!secs->ssa_frame_size || ssaframesize > secs->ssa_frame_size)
> +		return -EINVAL;
> +
> +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
> +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
> +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
> +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
