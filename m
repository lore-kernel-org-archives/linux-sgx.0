Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF1EC742A1
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 21:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10DA0206B8
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 21:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfGKVQn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 17:16:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:48462 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbfGKVQn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 17:16:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 14:16:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="249904697"
Received: from mmoerth-mobl6.ger.corp.intel.com (HELO localhost) ([10.249.35.82])
  by orsmga001.jf.intel.com with ESMTP; 11 Jul 2019 14:16:39 -0700
Date:   Fri, 12 Jul 2019 00:16:38 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v21 2/2] x86/sgx: Use mmu_notifier.release() instead
 of per-vma refcounting
Message-ID: <20190711211638.3bxf4heuejl67646@linux.intel.com>
References: <20190711161625.15786-1-sean.j.christopherson@intel.com>
 <20190711161625.15786-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711161625.15786-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 09:16:25AM -0700, Sean Christopherson wrote:
> Using per-vma refcounting to track mm_structs associated with an enclave
> requires hooking .vm_close(), which in turn prevents the mm from merging
> vmas (precisely to allow refcounting).
> 
> Avoid refcounting encl_mm altogether by registering an mmu_notifier at
> .mmap(), removing the dying encl_mm at mmu_notifier.release() and
> protecting mm_list during reclaim via a per-enclave SRCU.
> 
> Removing refcounting/vm_close() allows merging of enclave vmas, at the
> cost of delaying removal of encl_mm structs from mm_list, i.e. an mm is
> disassociated from an enclave when the mm exits or the enclave dies, as
> opposed to when the last vma (in a given mm) is closed.
> 
> The impact of delying encl_mm removal is its memory footprint and
> whatever overhead is incurred during EPC reclaim (to walk an mm's vmas).
> Practically speaking, a stale encl_mm will exist for a meaningful amount
> of time if and only if the enclave is mapped in a long-lived process and
> then passed off to another long-lived process.  It is expected that the
> vast majority of use cases will not encounter this condition, e.g. even
> using a daemon to build enclaves should not result in a stale encl_mm as
> the builder should never need to mmap() the enclave.
> 
> Even if there are scenarios that lead to defunct encl_mms, the cost is
> likely far outweighed by the benefits of reducing the number of vmas
> across all enclaves.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I don't think the stalled encl_mm's are a blocking issue for anything.
Can be even upstreamed with that. Good enough.

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
