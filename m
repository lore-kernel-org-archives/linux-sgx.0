Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56309C0650F
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 210DC217F4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfHHPwf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:52:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:2150 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbfHHPwe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 11:52:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:52:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="179876418"
Received: from sandersb-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.239])
  by orsmga006.jf.intel.com with ESMTP; 08 Aug 2019 08:52:31 -0700
Date:   Thu, 8 Aug 2019 18:52:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 10/11] x86/sgx: Call sgx_encl_grow() with the
 enclave's lock held
Message-ID: <20190808155217.r5seneo3px3kzjmd@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-11-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808001254.11926-11-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 05:12:53PM -0700, Sean Christopherson wrote:
> Move the taking of the enclave's lock outside of sgx_encl_grow() in
> preparation for adding sgx_encl_shrink(), which will decrement the
> number of enclave pages and free any allocated VA page.  When freeing
> a VA page, the enclave's lock needs to be held for the entire time
> between adding the VA page to the enclave's list and freeing the VA
> page so as to prevent it from being used by reclaim, e.g. to avoid a
> use-after-free scenario.
> 
> Because sgx_encl_grow() can temporarily drop encl->lock, calling it
> with encl->lock held adds a subtle dependency on the ordering of
> checks against encl->flags, e.g. checking for SGX_ENCL_CREATED prior
> to calling sgx_encl_grow() could lead to a TOCTOU on ECREATE.  Avoid
> this by passing in the disallowed flags to sgx_encl_grow() so that the
> the dependency is clear.
> 
> Retaking encl->lock in the failure paths is a bit ugly, but the
> alternative is to have sgx_encl_grow() drop encl->lock in all failure
> paths, which is arguably worse since the caller has to know which
> paths do/don't drop the lock.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Would be cleaner to check the flags just before the call. Otherwise,
no problems with this.

/Jarkko
