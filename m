Return-Path: <SRS0=NOB7=AP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AF7C433E0
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 03:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C15420899
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 03:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGDDb2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Jul 2020 23:31:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:39715 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgGDDb1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Jul 2020 23:31:27 -0400
IronPort-SDR: IN3AXyWv1h7g810kGPi06xjmhEO6V8Jte2eAsIZ7uZHBCB61XSwCl2M89bLTS9OXvME8gk3Kl4
 I0/R+QhQdjJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="147239518"
X-IronPort-AV: E=Sophos;i="5.75,310,1589266800"; 
   d="scan'208";a="147239518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 20:31:26 -0700
IronPort-SDR: JlMMqkTiFk8Mk98DqTZ8i8/NJpMhQO7FUiSWpuFrinD4zff6ep+DUsAsP4tSpnVXoWfqKKGudK
 kweN9iMAlOQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,310,1589266800"; 
   d="scan'208";a="456075034"
Received: from winzenbu-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.221])
  by orsmga005.jf.intel.com with ESMTP; 03 Jul 2020 20:31:12 -0700
Date:   Sat, 4 Jul 2020 06:31:10 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20200704033025.GA144756@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200702035902.GC1819@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200702035902.GC1819@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 01, 2020 at 08:59:02PM -0700, Sean Christopherson wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > +static int sgx_validate_secs(const struct sgx_secs *secs,
> > +			     unsigned long ssaframesize)
> > +{
> > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> > +		return -EINVAL;
> > +
> > +	if (secs->base & (secs->size - 1))
> > +		return -EINVAL;
> > +
> > +	if (secs->miscselect & sgx_misc_reserved_mask ||
> > +	    secs->attributes & sgx_attributes_reserved_mask ||
> > +	    secs->xfrm & sgx_xfrm_reserved_mask)
> > +		return -EINVAL;
> > +
> > +	if (secs->attributes & SGX_ATTR_MODE64BIT) {
> > +		if (secs->size > sgx_encl_size_max_64)
> > +			return -EINVAL;
> > +	} else if (secs->size > sgx_encl_size_max_32)
> > +		return -EINVAL;
> 
> These should be >=, not >, the SDM uses one of those fancy ≥ ligatures.
> 
> Internal versions use more obvious pseudocode, e.g.:
> 
>     if ((DS:TMP_SECS.ATTRIBUTES.MODE64BIT = 1) AND
>         (DS:TMP_SECS.SIZE AND (~((1 << CPUID.18.0:EDX[15:8]) – 1)))
>     {
>         #GP(0);

Updated as:

static int sgx_validate_secs(const struct sgx_secs *secs)
{
	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
		       sgx_encl_size_max_64 : sgx_encl_size_max_32;

	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
		return -EINVAL;

	if (secs->base & (secs->size - 1))
		return -EINVAL;

	if (secs->miscselect & sgx_misc_reserved_mask ||
	    secs->attributes & sgx_attributes_reserved_mask ||
	    secs->xfrm & sgx_xfrm_reserved_mask)
		return -EINVAL;

	if (secs->size >= max_size)
		return -EINVAL;

/Jarkko
