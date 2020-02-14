Return-Path: <SRS0=Pssp=4C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4246BC3B1A6
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Feb 2020 17:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D8824654
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Feb 2020 17:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391775AbgBNRLt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:11:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:10329 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394490AbgBNRLr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Feb 2020 12:11:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 09:11:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="234517959"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2020 09:11:46 -0800
Date:   Fri, 14 Feb 2020 09:11:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200214171146.GD20690@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <d17c50a7-6900-731b-43a2-d6e49b8eb44d@fortanix.com>
 <20200213180737.GC18610@linux.intel.com>
 <a4d9a58d-6984-5894-f6c8-73f2b2b466aa@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d9a58d-6984-5894-f6c8-73f2b2b466aa@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 14, 2020 at 10:24:10AM +0100, Jethro Beekman wrote:
> On 2020-02-13 19:07, Sean Christopherson wrote:
> > On Thu, Feb 13, 2020 at 02:59:52PM +0100, Jethro Beekman wrote:
> >> On 2020-02-09 22:25, Jarkko Sakkinen wrote:
> >>> +/**
> >>> + * struct sgx_enclave_add_pages - parameter structure for the
> >>> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> >>> + * @src:	start address for the page data
> >>> + * @offset:	starting page offset
> >>> + * @length:	length of the data (multiple of the page size)
> >>> + * @secinfo:	address for the SECINFO data
> >>> + * @flags:	page control flags
> >>> + * @count:	number of bytes added (multiple of the page size)
> >>> + */
> >>> +struct sgx_enclave_add_pages {
> >>> +	__u64	src;
> >>> +	__u64	offset;
> >>> +	__u64	length;
> >>> +	__u64	secinfo;
> >>> +	__u64	flags;
> >>> +	__u64	count;
> >>> +};
> >>
> >> Compared to the last time I looked at the patch set, this API removes the
> >> ability to measure individual pages chunks. That is not acceptable.
> > 
> > Why is it not acceptable?  E.g. what specific use case do you have that
> > _requires_ on measuring partial 4k pages of an enclave?
> 
> The use case is someone gives me an enclave and I want to load it. If I don't
> load it exactly as the enclave author specified, the enclave hash will be
> different, and it won't work.

And if our ABI says "thou shall measure in 4k chunks", then it's an invalid
enclave if its author generated MRENCLAVE using a different granularity.
