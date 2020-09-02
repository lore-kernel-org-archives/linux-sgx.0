Return-Path: <SRS0=bSI5=CL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BED7C433E7
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Sep 2020 18:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FD820C56
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Sep 2020 18:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgIBSkz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Sep 2020 14:40:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:17072 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgIBSky (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Sep 2020 14:40:54 -0400
IronPort-SDR: tKAYgg1zYv4AUuuI/LWak6KL/a4DCSATuhu1aXx/v2EX2FyzYWFPPoS2BQfzB/7AFmitdb0V5a
 dEiz4fCJvdMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="221674238"
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="221674238"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 11:40:52 -0700
IronPort-SDR: P4YeBPN8mp1qKmIrafAtjmZm4807Q/A2J7qZUuipcGX0UCptRPoHbegSotuQlM/6nSqA5dL+kN
 EMMI3WIakq6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,383,1592895600"; 
   d="scan'208";a="502231194"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.255.38.180])
  by fmsmga006.fm.intel.com with ESMTP; 02 Sep 2020 11:40:48 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     "Sean Christopherson" <sean.j.christopherson@intel.com>
Cc:     "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Chunyang Hui" <sanqian.hcy@antfin.com>,
        "Jordan Hand" <jorhand@linux.microsoft.com>,
        "Nathaniel McCallum" <npmccallum@redhat.com>,
        "Seth Moore" <sethmo@google.com>,
        "Suresh Siddha" <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200702035902.GC1819@linux.intel.com>
 <20200704033025.GA144756@linux.intel.com>
 <op.0qaqw6rvwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
 <20200902161012.GD11695@sjchrist-ice>
Date:   Wed, 02 Sep 2020 13:40:47 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0qbx59v2wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200902161012.GD11695@sjchrist-ice>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 02 Sep 2020 11:10:12 -0500, Sean Christopherson  
<sean.j.christopherson@intel.com> wrote:

> On Tue, Sep 01, 2020 at 10:06:32PM -0500, Haitao Huang wrote:
>> On Fri, 03 Jul 2020 22:31:10 -0500, Jarkko Sakkinen
>> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> > On Wed, Jul 01, 2020 at 08:59:02PM -0700, Sean Christopherson wrote:
>> > > On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
>> > > > +static int sgx_validate_secs(const struct sgx_secs *secs,
>> > > > +			     unsigned long ssaframesize)
>> > > > +{
>> > > > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
>> > > > +		return -EINVAL;
>> > > > +
>> > > > +	if (secs->base & (secs->size - 1))
>> > > > +		return -EINVAL;
>> > > > +
>> > > > +	if (secs->miscselect & sgx_misc_reserved_mask ||
>> > > > +	    secs->attributes & sgx_attributes_reserved_mask ||
>> > > > +	    secs->xfrm & sgx_xfrm_reserved_mask)
>> > > > +		return -EINVAL;
>> > > > +
>> > > > +	if (secs->attributes & SGX_ATTR_MODE64BIT) {
>> > > > +		if (secs->size > sgx_encl_size_max_64)
>> > > > +			return -EINVAL;
>> > > > +	} else if (secs->size > sgx_encl_size_max_32)
>> > > > +		return -EINVAL;
>> > >
>> > > These should be >=, not >, the SDM uses one of those fancy ≥  
>> ligatures.
>> > >
>> > > Internal versions use more obvious pseudocode, e.g.:
>> > >
>> > >     if ((DS:TMP_SECS.ATTRIBUTES.MODE64BIT = 1) AND
>> > >         (DS:TMP_SECS.SIZE AND (~((1 << CPUID.18.0:EDX[15:8]) – 1)))
>> > >     {
>> > >         #GP(0);
>> >
>> > Updated as:
>> >
>> > static int sgx_validate_secs(const struct sgx_secs *secs)
>> > {
>> > 	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
>> > 		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
>> >
>> > 	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
>> > 		return -EINVAL;
>> >
>> > 	if (secs->base & (secs->size - 1))
>> > 		return -EINVAL;
>> >
>> > 	if (secs->miscselect & sgx_misc_reserved_mask ||
>> > 	    secs->attributes & sgx_attributes_reserved_mask ||
>> > 	    secs->xfrm & sgx_xfrm_reserved_mask)
>> > 		return -EINVAL;
>> >
>> > 	if (secs->size >= max_size)
>> > 		return -EINVAL;
>> >
>>
>> This should be > not >=. Issue raised and fixed by Fábio Silva for  
>> ported
>> patches for OOT SGX support:
>> https://github.com/intel/SGXDataCenterAttestationPrimitives/pull/123
>>
>> I tested and verified with Intel arch, the comparison indeed should be  
>> >.
>
> And this is a confirmed SDM bug, correct?

yes, the pseudo code for ECREATE is inaccurate and inconsistent with the  
CPUID spec. The latter is correct.
Haitao
