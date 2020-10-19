Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D777C433E7
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 17:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C051E2224D
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 17:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgJSRtb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 13:49:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:20524 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgJSRtb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 13:49:31 -0400
IronPort-SDR: aur93pqpt1dL6DKErzEXzL6wS/56NLg7E/7VstCVbZHzTSkMUn1K4ht/f2G5HrsWJI1lpsu2Y5
 tEzxnvie1PnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="164460521"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="164460521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 10:49:30 -0700
IronPort-SDR: ZO6wpV7jwCCbX2srP5jN3gUyHrfgKRdfIa+5aNSC66P7owyFI6lnRJZSx1K6zkWtg4aoO1aQSo
 NRANWuGW4KbA==
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="522075727"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 10:49:29 -0700
Date:   Mon, 19 Oct 2020 10:49:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 01/24] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
Message-ID: <20201019174928.GA22358@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-2-jarkko.sakkinen@linux.intel.com>
 <fb556734-6347-31ba-3595-67a25f4ebf0d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb556734-6347-31ba-3595-67a25f4ebf0d@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 07:10:58AM -0700, Dave Hansen wrote:
> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
> > 
> > Add X86_FEATURE_SGX1 and X86_FEATURE_SGX2 from CPUID.(EAX=12H, ECX=0),
> > which describe the level of SGX support available [1].
> 
> The SDM says there are 6 leaf functions added with SGX2 (SDM Vol 3D
> Table 36-2):
> 
> ENCLS[EAUG]
> ENCLS[EMODPR]
> ENCLS[EMODT]
> ENCLU[EACCEPT]
> ENCLU[EMODPE]
> ENCLU[EACCEPTCOPY]
> 
> But I don't see *ANY* of those in use in this patch set.  I know we
> added a bunch of infrastructure around mitigating if EMODPE got *used*,
> but does the kernel need to change its behavior if SGX1 vs. SGX2 is
> supported?
> 
> BTW, the SG2 bit is defined:
> 
> 	Bit 01: SGX2. If 1, Indicates Intel SGX supports the collection
> 	of SGX2 leaf functions.
> 
> which makes me think it's for leaf functions only.

As mentioned in the other thread, SGX1 hardware takes an erratum on the #PF
behavior of the EPCM, i.e. on SGX2+, EPCM violations generate #PF with
PFEC.SGX=1, whereas SGX1 hardware will #GP.
