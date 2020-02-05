Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2F6C35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 19:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A93FC2072B
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 19:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgBET5C (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 14:57:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:53285 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBET5C (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Feb 2020 14:57:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 11:57:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,406,1574150400"; 
   d="scan'208";a="225933582"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 05 Feb 2020 11:57:00 -0800
Date:   Wed, 5 Feb 2020 11:57:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v25 07/21] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200205195700.GJ4877@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-8-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204060545.31729-8-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 04, 2020 at 08:05:31AM +0200, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Enumerate Enclave Page Cache (EPC) sections via CPUID and add the data
> structures necessary to track EPC pages so that they can be allocated,
> freed and managed. As a system may have multiple EPC sections, invoke CPUID
> on SGX sub-leafs until an invalid leaf is encountered.
> 
> For simplicity, support a maximum of eight EPC sections. Existing client
> hardware supports only a single section, while upcoming server hardware
> will support at most eight sections. Bounding the number of sections also
> allows the section ID to be embedded along with a page's offset in a single
> unsigned long, enabling easy retrieval of both the VA and PA for a given
> page.

...

> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-19 Intel Corporation.
> +
> +#include <linux/freezer.h>
> +#include <linux/highmem.h>
> +#include <linux/kthread.h>
> +#include <linux/pagemap.h>
> +#include <linux/ratelimit.h>
> +#include <linux/slab.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched/signal.h>
> +#include "encls.h"
> +
> +struct task_struct *ksgxswapd_tsk;
> +
> +/*
> + * Reset all pages to uninitialized state. Pages could be in initialized on
> + * kmemexec.
> + */
> +static void sgx_sanitize_section(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page, *tmp;
> +	LIST_HEAD(secs_list);
> +	int ret;
> +
> +	while (!list_empty(&section->unsanitized_page_list)) {
> +		if (kthread_should_stop())
> +			return;
> +
> +		spin_lock(&section->lock);
> +
> +		page = list_first_entry(&section->unsanitized_page_list,
> +					struct sgx_epc_page, list);
> +
> +		ret = __eremove(sgx_epc_addr(page));
> +		if (!ret)
> +			list_move(&page->list, &section->page_list);
> +		else
> +			list_move_tail(&page->list, &secs_list);
> +
> +		spin_unlock(&section->lock);
> +
> +		cond_resched();
> +	}
> +
> +	list_for_each_entry_safe(page, tmp, &secs_list, list) {
> +		if (kthread_should_stop())
> +			return;
> +
> +		ret = __eremove(sgx_epc_addr(page));
> +		if (!WARN_ON_ONCE(ret)) {

Sadly, this WARN can fire after kexec() on systems with multiple EPC
sections if the SECS has child pages in another section.

Virtual EPC (KVM) has a similar issue, which I'm handling by collecting all
pages that fail a second EREMOVE in a global list, and then retrying every
page in the global list every time a virtual EPC is destroyed, i.e. might
have freed pages.

The same approach should work here, e.g. retry all SECS pages a third time
once all sections have been sanitized and WARN if EREMOVE fails a third
time on a page.

> +			spin_lock(&section->lock);
> +			list_move(&page->list, &section->page_list);
> +			spin_unlock(&section->lock);
> +		} else {
> +			list_del(&page->list);
> +			kfree(page);
> +		}
> +
> +		cond_resched();
> +	}
> +}
> +
> +static int ksgxswapd(void *p)
> +{
> +	int i;
> +
> +	set_freezable();
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++)
> +		sgx_sanitize_section(&sgx_epc_sections[i]);

I'm having second thoughts about proactively sanitizing the EPC sections.
I think it'd be better to do EREMOVE the first time a page is allocated,
e.g. add a SGX_EPC_PAGE_UNSANITIZED flag.

  1. Sanitizing EPC that's never used is a waste of cycles, especially on
     platforms with 64gb+ of EPC.

  2. Deferring to allocation time automatically scales with the number of
     tasks that are allocating EPC.  And, the CPU time will also be
     accounted to those tasks.

  3. Breaks on-demand paging when running in a VM, e.g. if the VMM chooses
     to allocate a physical EPC page when it's actually accessed by the
     VM.  I don't expect this to be a problem any time soon, as all VMMs
     will likely preallocate EPC pages until KVM (or any other hypervisor)
     gains EPC oversusbscription support, which may or may not ever happen.
     But, I'd prefer to simply not have the problem in the first place.

The logic will be a bit more complicated, but not terribly so.  

> +
> +	return 0;
> +}
