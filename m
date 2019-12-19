Return-Path: <SRS0=bk6Q=2J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08396C43603
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 00:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D415C222C2
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 00:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLSAxe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:53:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:18689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbfLSAxe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Dec 2019 19:53:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 16:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="210280863"
Received: from jtreacy-mobl1.ger.corp.intel.com ([10.251.82.127])
  by orsmga008.jf.intel.com with ESMTP; 18 Dec 2019 16:53:25 -0800
Message-ID: <5ba9e16a81d920c3a60b2486b98154590a0e0650.camel@linux.intel.com>
Subject: Re: [PATCH v24 08/24] x86/sgx: Enumerate and track EPC sections
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
In-Reply-To: <20191218091856.GA24886@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
         <20191129231326.18076-9-jarkko.sakkinen@linux.intel.com>
         <20191218091856.GA24886@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Thu, 19 Dec 2019 02:53:08 +0200
User-Agent: Evolution 3.34.1-2 
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-12-18 at 10:18 +0100, Borislav Petkov wrote:
> On Sat, Nov 30, 2019 at 01:13:10AM +0200, Jarkko Sakkinen wrote:
> > +static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
> > +					 unsigned long index,
> > +					 struct sgx_epc_section *section)
> > +{
> > +	unsigned long nr_pages = size >> PAGE_SHIFT;
> 
> I'm assuming here that size which gets communicated through CPUID -
> which is an interesting way to communicate SGX settings in itself :-) - is
> in multiples of 4K? SDM doesn't say...

Yes.

> And last time I asked:
> 
> "This size comes from CPUID but it might be prudent to sanity-check it
> nevertheless, before doing the memremap()."
> 
> but it was left uncommented.

I'm sorry about that. Not intended. I just forgot to deal with it or
missed it.

> > +/**
> > + * A section metric is concatenated in a way that @low bits 12-31 define the
> > + * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
> > + * metric.
> > + */
> > +static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
> > +{
> > +	return (low & GENMASK_ULL(31, 12)) +
> > +	       ((high & GENMASK_ULL(19, 0)) << 32);
> > +}
> > +
> > +static bool __init sgx_page_cache_init(void)
> > +{
> > +	u32 eax, ebx, ecx, edx, type;
> > +	u64 pa, size;
> > +	int i;
> > +
> > +	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
> > +
> > +	for (i = 0; i < (SGX_MAX_EPC_SECTIONS + 1); i++) {
> 
> Those brackets are still here from the last time. You said:
> 
> "For nothing :-)
> 
> I'll change it as:
> 
>   for (i = 0; i <= SGX_MAX_EPC_SECTIONS; i++) {"
> 
> but probably forgot...
> 
> and looking at my review comments here:
> 
> https://lkml.kernel.org/r/20191005092627.GA25699@zn.tnic
> 
> and your reply:
> 
> https://lkml.kernel.org/r/20191007115850.GA20830@linux.intel.com
> 
> you clearly missed addressing some so I'm going to stop reviewing here.
> 
> Please have a look at those review comments again and check whether the
> apply - and then do them - or they don't and they pls explain why they
> don't.
> 
> And do that for the rest of the patchset, please, before you send it
> again.
> 
> Thx.

It is unintentional but I seriously do my best on keeping track of
things.  Sometimes when you multitask with maintaining other subsystems
and refactor huge patch set like this, it just happens, no matter how
well you try to organize your work.

I'll go through v23 comments with time before sending v25.

/Jarkko

