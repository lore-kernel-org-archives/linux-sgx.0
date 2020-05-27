Return-Path: <SRS0=yCNl=7J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD24C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 03:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387E220899
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 03:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgE0D4P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 May 2020 23:56:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:8355 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgE0D4O (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 May 2020 23:56:14 -0400
IronPort-SDR: 0meLswPweA+fJ7t6AYDAi2CMYqOuDcup7O26jdFHwoy4rttKfYaT3vspwtfDB8A9DHuc0ojJjJ
 XEjLjfx+2fTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 20:56:14 -0700
IronPort-SDR: pIShAQU7CxUI9esdy7kkM0IsTpmGk3+oIe95TTbLQTR/KNGLHoaxN7spIMrr806ZJG7Lz5EbbT
 esAeXYf+04Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="270317451"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 26 May 2020 20:56:14 -0700
Date:   Tue, 26 May 2020 20:56:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 07/20] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200527035613.GH31696@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
 <20200525092304.GD25636@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525092304.GD25636@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 25, 2020 at 11:23:04AM +0200, Borislav Petkov wrote:
> On Fri, May 15, 2020 at 03:43:57AM +0300, Jarkko Sakkinen wrote:
> > +struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > +int sgx_nr_epc_sections;
> 
> We have become very averse against global stuff. What is going to use
> those, only sgx code I assume...?

Yes, only SGX code.  The reclaim/swap code needs access to the sections,
and that code is in a different file, reclaim.c.  I don't have a super
strong objection to sucking reclaim.c into main.c, but I'm somewhat
indifferent on code organization as a whole.  Jarkko likely has a stronger
opinion.

> > +static bool __init sgx_page_cache_init(void)
> > +{
> > +	u32 eax, ebx, ecx, edx, type;
> > +	u64 pa, size;
> > +	int i;
> > +
> > +	for (i = 0; i <= ARRAY_SIZE(sgx_epc_sections); i++) {
> > +		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
> > +			    &eax, &ebx, &ecx, &edx);
> > +
> > +		type = eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
> > +		if (type == SGX_CPUID_SUB_LEAF_INVALID)
> > +			break;
> > +
> > +		if (type != SGX_CPUID_SUB_LEAF_EPC_SECTION) {
> > +			pr_err_once("Unknown EPC section type: %u\n", type);
> > +			break;
> > +		}
> > +
> > +		if (i == ARRAY_SIZE(sgx_epc_sections)) {
> > +			pr_warn("No free slot for an EPC section\n");
> > +			break;
> > +		}
> 
> This is also the loop termination: do we really need this warn or can
> the loop simply do "i < ARRAY_SIZE" ?

The warn alerts the user that there will effectively be lost/unused memory,
so IMO it's worth keeping.
 
> If the warn is needed, it can be after the loop too.
> > +
> > +		pa = sgx_calc_section_metric(eax, ebx);
> > +		size = sgx_calc_section_metric(ecx, edx);
> > +
> > +		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
> 
> I'm assuming that's useful information to issue in dmesg?

Yes, it's effectively the equivalent of dumping the e820 tables.  It might
not be as useful now that the code is stable, but I suspect it will come in
handy for debug/triage down the road.
 
> > diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> > new file mode 100644
> > index 000000000000..215371588a25
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> > @@ -0,0 +1,82 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > +// Copyright(c) 2016-19 Intel Corporation.
> > +
> > +#include <linux/freezer.h>
> > +#include <linux/highmem.h>
> > +#include <linux/kthread.h>
> > +#include <linux/pagemap.h>
> > +#include <linux/ratelimit.h>
> > +#include <linux/slab.h>
> > +#include <linux/sched/mm.h>
> > +#include <linux/sched/signal.h>
> > +#include "encls.h"
> > +
> > +struct task_struct *ksgxswapd_tsk;
> 
> Same for this one: also shared only among sgx code?

Yes, that one can definitely be buried behind a helper.

> > +/**
> > + * enum sgx_epc_page_desc - bits and masks for an EPC page's descriptor
> > + * %SGX_EPC_SECTION_MASK:	SGX allows to have multiple EPC sections in the
> > + *				physical memory. The existing and near-future
> > + *				hardware defines at most eight sections, hence
> > + *				three bits to hold a section.
> > + */
> > +enum sgx_epc_page_desc {
> > +	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),
> 
> If that should be three bits, then it should be (2, 0). Because now you
> have 4 bits:

Apparently even pre-school math is hard these days.  I'm pretty sure that's
an ongoing brain fart, I don't think we ever conciously bumped it to 4 bits.

That being said, using 4 bits (or even 5+) isn't necessary a bad thing.  We
aren't tight on bits and the burned memory isn't awful, e.g. <100 bytes per
unused section.  Not having to update the kernel just to handle a system
with more EPC sections would be nice, though we (Intel) should check on our
end to see if nearish-future CPUs are still hard limited to eight sections.

One idea would be to provide a Kconfig a la NR_CPUS or NODES_SHIFT.  I.e.
carve out the bits in sgx_epc_page_desc to allow up to N sections, but let
the user limit the number of sections to recoup the unused memory.

> # arch/x86/kernel/cpu/sgx/sgx.h:56:     return &sgx_epc_sections[page->desc & SGX_EPC_SECTION_MASK];
>         andl    $15, %edx       #, _22
> 		^^^
> 
> > +	/* bits 12-63 are reserved for the physical page address of the page */
> > +};
