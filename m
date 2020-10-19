Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15420C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 20:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE917223EA
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 20:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731466AbgJSUVP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 16:21:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:1398 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731208AbgJSUVP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 16:21:15 -0400
IronPort-SDR: /KTKdCg0fH6SljUlNajwkbOel8aec3njGSVKDMk+CcH/5LhhS/GAnLjYbGIj0SRmWp7pFel7sm
 f5BjNqDKqpJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="146393725"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="146393725"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:21:11 -0700
IronPort-SDR: 1EXuQhFjza0k+Lt3XlMfKBwE0vXsm16ZZXv0P9NcdvClM7Vg8K2TXPNzPTnboTDNAle6V8ZGNr
 C2k39n58aBlQ==
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="522118229"
Received: from haixinlu-mobl1.amr.corp.intel.com (HELO [10.212.84.56]) ([10.212.84.56])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 13:21:10 -0700
Subject: Re: [PATCH v39 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-13-jarkko.sakkinen@linux.intel.com>
 <5f194bf0-ced1-66e1-b6a2-503741a3e7f1@intel.com>
 <20201018042633.GI68722@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <f6fe37ee-7b5c-15b6-6823-2500582e7921@intel.com>
Date:   Mon, 19 Oct 2020 13:21:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201018042633.GI68722@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/17/20 9:26 PM, Jarkko Sakkinen wrote:
...
>>> +static int sgx_validate_secs(const struct sgx_secs *secs)
>>> +{
>>
>> What's the overall point of this function?  Does it avoid a #GP from an
>> instruction later?
>>
>> Does all of the 'secs' content come from userspace?
> 
> Yes it does avoid #GP, and all the data comes from the user space.

Please comment the function to indicate this.

But, in general, why do we care to avoid a #GP?  Is it just because we
don't have infrastructure in-kernel to suppress the resulting panic()?

>>> +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
>>> +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
>>> +
>>> +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
>>> +		return -EINVAL;
>>> +
>>> +	if (secs->base & (secs->size - 1))
>>> +		return -EINVAL;
>>> +
>>> +	if (secs->miscselect & sgx_misc_reserved_mask ||
>>> +	    secs->attributes & sgx_attributes_reserved_mask ||
>>> +	    secs->xfrm & sgx_xfrm_reserved_mask)
>>> +		return -EINVAL;
>>> +
>>> +	if (secs->size > max_size)
>>> +		return -EINVAL;
>>> +
>>> +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
>>> +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
>>> +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) != ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
>>> +		return -EINVAL;
>>> +
>>> +	if (!secs->ssa_frame_size)
>>> +		return -EINVAL;
>>> +
>>> +	if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) > secs->ssa_frame_size)
>>> +		return -EINVAL;
>>> +
>>> +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
>>> +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
>>> +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
>>> +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
>>> +		return -EINVAL;
>>> +
>>> +	return 0;
>>> +}
>>
>> I think it would be nice to at least have one comment per condition to
>> explain what's going on there.
...


>>> +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>>> +{
>>> +	struct sgx_epc_page *secs_epc;
>>> +	struct sgx_pageinfo pginfo;
>>> +	struct sgx_secinfo secinfo;
>>> +	unsigned long encl_size;
>>> +	struct file *backing;
>>> +	long ret;
>>> +
>>> +	if (sgx_validate_secs(secs)) {
>>> +		pr_debug("invalid SECS\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	/* The extra page goes to SECS. */
>>> +	encl_size = secs->size + PAGE_SIZE;
>>> +
>>> +	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
>>> +				   VM_NORESERVE);
>>
>> What's the >>5 adjustment for?
> 
> The backing storage stores not only the swapped page but also
> Paging Crypto MetaData (PCMD) structure. It essentially contains
> a CPU encrypted MAC for a page.
> 
> The MAC is over page version and data. The version is stored in
> a EPC page called Version Array (VA) page.
> 
> Both of these are needed by ENCLS[ELDU].

	/*
	 * SGX backing storage needs to contain space for both the
	 * EPC data and some metadata called the Paging Crypto
	 * MetaData (PCMD).  The PCMD needs 128b of storage for each
	 * page.
 	 */

Also, the MAC is a fixed size, right?  Let's say that x86 got a larger
page size in the future.  Would this number be 128b or PAGE_SIZE/32?

If it's a fixed size, I'd write:

	size = encl_size;
	size += (encl_size / PAGE_SIZE) * SGX_PCPD_PER_PAGE;

If it really is 1/32nd, I'd write

	size += encl_size / SGX_PCPD_RATIO;

or something.

Either way, the >>5 is total magic and needs comments and fixing.

>>> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>>> +{
>>> +	struct sgx_encl *encl = filep->private_data;
>>> +	int ret, encl_flags;
>>> +
>>> +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
>>> +	if (encl_flags & SGX_ENCL_IOCTL)
>>> +		return -EBUSY;
>>
>> Is the SGX_ENCL_IOCTL bit essentially just a lock to single-thread
>> ioctl()s?  Should we name it as such?
> 
> Yes. It makes the concurrency overally easier if we can assume that
> only a single ioctl is in progress. There is no good reason to do
> them in parallel.
> 
> E.g. when you add pages you want to do that serially because the
> order changes the MRENCLAVE.

There are also hardware concurrency requirements, right?  A bunch of the
SGX functions seem not not even support being called in parallel.

> So should I rename it as SGX_ENCL_IOCTL_LOCKED?

I'd rather not see hand-rolled locking primitives frankly.
