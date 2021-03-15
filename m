Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA62C433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776F664E83
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Mar 2021 19:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhCOTsJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:48:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:31609 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhCOTri (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Mar 2021 15:47:38 -0400
IronPort-SDR: ZQFecpGVbVVCb4XBmuhJ5S3ZOYFFPKzlsHPpxjb4X5h5a2gmXkLi0JG23yOVO9DAn0Y4lP0v5F
 yAuVcQjJz0SQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="186768415"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="186768415"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 12:47:31 -0700
IronPort-SDR: wpVcFtBb+Zbfp1TzY+fc+O4JY0vVlDOvnAMyn3xcSQWm+6NyN2EFtN6GmAhxsjyeEMNvRMlbNw
 LTvi8SLdsbHw==
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="601550909"
Received: from lguadamu-mobl1.amr.corp.intel.com (HELO [10.213.176.188]) ([10.213.176.188])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 12:47:30 -0700
Subject: Re: [PATCH v4 2/3] x86/sgx: Replace section local dirty page lists
 with a global list
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210313160119.1318533-1-jarkko@kernel.org>
 <20210313160119.1318533-3-jarkko@kernel.org>
 <b2a02fa6-8076-9fe4-59b7-91a91f44aaf7@intel.com>
 <YE+x+lhDYnKZ1933@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <c98549d4-22f3-d279-52b2-c2383829e688@intel.com>
Date:   Mon, 15 Mar 2021 12:47:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YE+x+lhDYnKZ1933@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/15/21 12:14 PM, Jarkko Sakkinen wrote:
> On Mon, Mar 15, 2021 at 09:03:21AM -0700, Dave Hansen wrote:
>> On 3/13/21 8:01 AM, Jarkko Sakkinen wrote:
>>> Reset initialized EPC pages in sgx_dirty_page_list to uninitialized state,
>>> and free them using sgx_free_epc_page(). Do two passes, as for SECS pages
>>> the first round can fail, if all child pages have not yet been removed.
>>> The driver puts all pages on startup first to sgx_dirty_page_list, as the
>>> initialization could be triggered by kexec(), meaning that pages have been
>>> reserved for active enclaves before the operation.
>>>
>>> The section local lists are redundant, as sgx_free_epc_page() figures
>>> out the correction by using epc_page->section.
>>
>> During normal runtime, the "ksgxd" daemon behaves like a  version of
>> kswapd just for SGX.  But, its first job is to initialize enclave
>> memory.  This is done in a a separate thread because this initialization
>> can be quite slow.
>>
>> Currently, the SGX boot code places each enclave page on a
>> sgx_section-local list (init_laundry_list).  Once it starts up, the
>> ksgxd code walks over that list and populates the actual SGX page allocator.
>>
>> However, the per-section structures are going away to make way for the
>> SGX NUMA allocator.  There's also little need to have a per-section
>> structure; the enclave pages are all treated identically, and they can
>> be placed on the correct allocator list from metadata stoered in the
>> enclave page itself.
>>
> Is this a suggestion how to rephrase the commit message? :-)

Yep.

>>>  static int ksgxd(void *p)
>>>  {
>>> -	int i;
>>> +	struct sgx_epc_page *page;
>>> +	LIST_HEAD(dirty);
>>> +	int i, ret;
>>>  
>>>  	set_freezable();
>>>  
>>>  	/*
>>> -	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
>>> -	 * required for SECS pages, whose child pages blocked EREMOVE.
>>> +	 * Reset initialized EPC pages in sgx_dirty_page_list to uninitialized state,
>>> +	 * and free them using sgx_free_epc_page(). 
>>
>> I'm not a fan of comments that tell us verbatim what the code does.
> 
> So, what are you suggesting? Remove the whole comment or parts of it? I'm
> presuming that you suggest removing the "top-level" part.

Just please make it more relevant and informative.  I can tell this is
processing 'sgx_dirty_page_list' and calling sgx_free_epc_page() from
the code.  I don't need a comment to tell me that.

A better comment would say:

	Take enclave pages from the init code, ensure they are clean,
	and free the back into the main SGX page allocator

That tells what *role* this code plays (connecting init code to the
allocator) in a way that just verbatim telling what code is called does not.
