Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51E6C28E83
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 12:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF632098B
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 12:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgIDMCZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 08:02:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:7973 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730114AbgIDMBv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 08:01:51 -0400
IronPort-SDR: 1I8Rtwh4GWOdeWX7J7eIEpl+QU7QjKZ9Egp+qCty8QrPl9PLcuDF5Vunz+D2G0TgvPl1hv2yM1
 YSFOXsT3oDgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="219283543"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="219283543"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 05:01:34 -0700
IronPort-SDR: JBhmnVDQJvbdd61JWWR8kZUG+owj8Bw5jHT4ua8fCs3yJvwjj2wBZCZEB0ACc/MeYpvQb5GIuI
 Z1Fx+DDEHNdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="478460799"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by orsmga005.jf.intel.com with ESMTP; 04 Sep 2020 05:01:27 -0700
Date:   Fri, 4 Sep 2020 15:01:26 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200904120126.GB39023@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200702035902.GC1819@linux.intel.com>
 <20200704033025.GA144756@linux.intel.com>
 <op.0qaqw6rvwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.0qaqw6rvwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 01, 2020 at 10:06:32PM -0500, Haitao Huang wrote:
> On Fri, 03 Jul 2020 22:31:10 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > On Wed, Jul 01, 2020 at 08:59:02PM -0700, Sean Christopherson wrote:
> > > On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > > > +static int sgx_validate_secs(const struct sgx_secs *secs,
> > > > +			     unsigned long ssaframesize)
> > > > +{
> > > > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (secs->base & (secs->size - 1))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (secs->miscselect & sgx_misc_reserved_mask ||
> > > > +	    secs->attributes & sgx_attributes_reserved_mask ||
> > > > +	    secs->xfrm & sgx_xfrm_reserved_mask)
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (secs->attributes & SGX_ATTR_MODE64BIT) {
> > > > +		if (secs->size > sgx_encl_size_max_64)
> > > > +			return -EINVAL;
> > > > +	} else if (secs->size > sgx_encl_size_max_32)
> > > > +		return -EINVAL;
> > > 
> > > These should be >=, not >, the SDM uses one of those fancy ≥ ligatures.
> > > 
> > > Internal versions use more obvious pseudocode, e.g.:
> > > 
> > >     if ((DS:TMP_SECS.ATTRIBUTES.MODE64BIT = 1) AND
> > >         (DS:TMP_SECS.SIZE AND (~((1 << CPUID.18.0:EDX[15:8]) – 1)))
> > >     {
> > >         #GP(0);
> > 
> > Updated as:
> > 
> > static int sgx_validate_secs(const struct sgx_secs *secs)
> > {
> > 	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> > 		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> > 
> > 	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> > 		return -EINVAL;
> > 
> > 	if (secs->base & (secs->size - 1))
> > 		return -EINVAL;
> > 
> > 	if (secs->miscselect & sgx_misc_reserved_mask ||
> > 	    secs->attributes & sgx_attributes_reserved_mask ||
> > 	    secs->xfrm & sgx_xfrm_reserved_mask)
> > 		return -EINVAL;
> > 
> > 	if (secs->size >= max_size)
> > 		return -EINVAL;
> > 
> 
> This should be > not >=. Issue raised and fixed by Fábio Silva for ported
> patches for OOT SGX support:
> https://github.com/intel/SGXDataCenterAttestationPrimitives/pull/123
> 
> I tested and verified with Intel arch, the comparison indeed should be >.
> 
> Thanks
> Haitao

Thans a lot!

I added this changelog entry to the v37 log:

* Fixed off-by-one error in a size calculation:
  https://github.com/intel/SGXDataCenterAttestationPrimitives/commit/e44cc238becf584cc079aef40b557c6af9a03f38

Given the Boris' earlier feedback I xref every changelog
entry in v37 changelog. Then it is also less time consuming
to spot if something is missing.

/Jarkko
