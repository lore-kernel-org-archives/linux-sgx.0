Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B98C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 19:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82AAC20850
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 19:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404970AbfHWTIP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 15:08:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:39243 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730788AbfHWTIP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 15:08:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 12:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="330810784"
Received: from budiraha-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.54.8])
  by orsmga004.jf.intel.com with ESMTP; 23 Aug 2019 12:08:10 -0700
Date:   Fri, 23 Aug 2019 22:08:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com, luto@kernel.org
Subject: sgx_reclaimer_write() refinement
Message-ID: <20190823190809.n3np4v7hvlj5isku@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi

I noticed that sgx_reclaimer_write() does not destory enclave albeit it
can fail. It should have a proper fallback mechanism.

I would take a long path to fix this by replacing sgx_reclaim_pages()
with

struct sgx_epc_page *sgx_reclaim_page(void)

It would greatly reduce the complexity of the flow. Would be much easier
to do fallback code paths. We have three trial EWB approach, which
should prevent already unnecesaary ETRACK's and IPI's.

The reclaimer thread would loop this until high watermark is reached.

The alloc function would change as:

struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
{
	struct sgx_epc_page *entry;

	entry = sgx_try_alloc_page(owner);
	if (entry)
		break;

	if (list_empty(&sgx_active_page_list)) {
		entry = ERR_PTR(-ENOMEM);
		goto out;
	}

	if (!reclaim) {
		entry = ERR_PTR(-EBUSY);
		goto out;
	}

	entry = sgx_reclaim_page();

out:
	if (sgx_calc_free_cnt() < SGX_NR_LOW_PAGES)
		wake_up(&ksgxswapd_waitq);

	return entry;
}

We get rid of the loop because the reclaimer function will return the
EPC page. The reclaimer thread will add the page to the active page
list.

/Jarkko
