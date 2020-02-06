Return-Path: <SRS0=E9YI=32=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB081C33CAC
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 15:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7C47222C2
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 15:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBFPeN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:34:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:61661 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBFPeN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Feb 2020 10:34:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 07:34:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="430535622"
Received: from dgbrowne-mobl.ger.corp.intel.com (HELO localhost) ([10.252.14.106])
  by fmsmga005.fm.intel.com with ESMTP; 06 Feb 2020 07:34:07 -0800
Date:   Thu, 6 Feb 2020 17:34:06 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v25 07/21] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200206153406.GA9694@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-8-jarkko.sakkinen@linux.intel.com>
 <20200205195700.GJ4877@linux.intel.com>
 <20200205231147.GD28111@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205231147.GD28111@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 06, 2020 at 01:11:47AM +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 05, 2020 at 11:57:00AM -0800, Sean Christopherson wrote:
> > > +		ret = __eremove(sgx_epc_addr(page));
> > > +		if (!WARN_ON_ONCE(ret)) {
> > 
> > Sadly, this WARN can fire after kexec() on systems with multiple EPC
> > sections if the SECS has child pages in another section.
> 
> What causes this?

Ah obviously this can happen given that the final loop is done per
section before other sections are processed.

Lets fix the code first rather than change the approach based on code
that has an underlying regression. Performance can be fine tuned even
after upstreaming. Especially if the performance increases complexity it
is better to work that after there is a mainline code base.

Given that the loop is done in separate thread anyway, I'm not sure how
bad performance issue there is anyway. Performance based changes should
be always done based on a workloads and statistics.

I think you'd fix this issue by first changing the functions as:

static void sgx_sanitize_section(struct sgx_epc_section *section)
{
	struct sgx_epc_page *page, *tmp;
	LIST_HEAD(secs_list);
	int ret;

	while (!list_empty(&section->unsanitized_page_list)) {
		if (kthread_should_stop())
			return;

		spin_lock(&section->lock);

		page = list_first_entry(&section->unsanitized_page_list,
					struct sgx_epc_page, list);

		ret = __eremove(sgx_epc_addr(page));
		if (!ret)
			list_move(&page->list, &section->page_list);
		else
			list_move_tail(&page->list, &secs_list);

		spin_unlock(&section->lock);

		cond_resched();
	}

	list_move_tail(&secs_list, &section->unsanitized_list);
}

Then in ksgxswapd() you'd

for (i = 0; i < sgx_nr_epc_sections; i++)
	sgx_sanitize_section(&sgx_epc_sections[i]);

/* 2nd round for SECS */
for (i = 0; i < sgx_nr_epc_sections; i++)
	sgx_sanitize_section(&sgx_epc_sections[i]);

Finally you'd:

for (i = 0; i < sgx_nr_epc_sections; i++)
	WARN_ONCE(!list_empty(&sgx_epc_sections[i]->unsanitized_list));

/Jarkko
