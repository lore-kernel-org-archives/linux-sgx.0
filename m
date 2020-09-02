Return-Path: <SRS0=bSI5=CL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB26DC433E6
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Sep 2020 03:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0AE206CD
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Sep 2020 03:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIBDHB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Sep 2020 23:07:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:62774 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBDHA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Sep 2020 23:07:00 -0400
IronPort-SDR: unM1avL+8Bv4KDKX5LdlKNNHpvgTp8c/uGlUQQAeULU62FTFHVjLXJQ0HJQijyEEGKvu0xFcMZ
 Nk+ChD4fgRIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="157314554"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="157314554"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 20:07:00 -0700
IronPort-SDR: dLeqMVa6k07q6GfWLy1bB+3vOfmMnoTP2rO/Z3OhbuYRKqvNNOSecXkZNbJOFaa/e5W5oPifUo
 wxSBJ2F+iiIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="502498257"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.255.35.33])
  by fmsmga005.fm.intel.com with ESMTP; 01 Sep 2020 20:06:36 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
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
Date:   Tue, 01 Sep 2020 22:06:32 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0qaqw6rvwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200704033025.GA144756@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 03 Jul 2020 22:31:10 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> On Wed, Jul 01, 2020 at 08:59:02PM -0700, Sean Christopherson wrote:
>> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
>> > +static int sgx_validate_secs(const struct sgx_secs *secs,
>> > +			     unsigned long ssaframesize)
>> > +{
>> > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
>> > +		return -EINVAL;
>> > +
>> > +	if (secs->base & (secs->size - 1))
>> > +		return -EINVAL;
>> > +
>> > +	if (secs->miscselect & sgx_misc_reserved_mask ||
>> > +	    secs->attributes & sgx_attributes_reserved_mask ||
>> > +	    secs->xfrm & sgx_xfrm_reserved_mask)
>> > +		return -EINVAL;
>> > +
>> > +	if (secs->attributes & SGX_ATTR_MODE64BIT) {
>> > +		if (secs->size > sgx_encl_size_max_64)
>> > +			return -EINVAL;
>> > +	} else if (secs->size > sgx_encl_size_max_32)
>> > +		return -EINVAL;
>>
>> These should be >=, not >, the SDM uses one of those fancy ≥ ligatures.
>>
>> Internal versions use more obvious pseudocode, e.g.:
>>
>>     if ((DS:TMP_SECS.ATTRIBUTES.MODE64BIT = 1) AND
>>         (DS:TMP_SECS.SIZE AND (~((1 << CPUID.18.0:EDX[15:8]) – 1)))
>>     {
>>         #GP(0);
>
> Updated as:
>
> static int sgx_validate_secs(const struct sgx_secs *secs)
> {
> 	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> 		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
>
> 	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> 		return -EINVAL;
>
> 	if (secs->base & (secs->size - 1))
> 		return -EINVAL;
>
> 	if (secs->miscselect & sgx_misc_reserved_mask ||
> 	    secs->attributes & sgx_attributes_reserved_mask ||
> 	    secs->xfrm & sgx_xfrm_reserved_mask)
> 		return -EINVAL;
>
> 	if (secs->size >= max_size)
> 		return -EINVAL;
>

This should be > not >=. Issue raised and fixed by Fábio Silva for ported  
patches for OOT SGX support:  
https://github.com/intel/SGXDataCenterAttestationPrimitives/pull/123

I tested and verified with Intel arch, the comparison indeed should be >.

Thanks
Haitao
