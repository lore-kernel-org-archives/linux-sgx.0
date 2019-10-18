Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9776CA9EA0
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 12:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873FA21D7C
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 12:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389672AbfJRMRZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 08:17:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:17881 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbfJRMRZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 08:17:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 05:17:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="186810215"
Received: from jlenoir-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.252])
  by orsmga007.jf.intel.com with ESMTP; 18 Oct 2019 05:17:23 -0700
Date:   Fri, 18 Oct 2019 15:17:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 06/12] x86/sgx: Fix a memory leak in
 sgx_encl_destroy()
Message-ID: <20191018121722.GB4027@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016183745.8226-7-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 11:37:39AM -0700, Sean Christopherson wrote:
> Delete an enclave page's entry in the radix tree regardless of whether
> or not it has an associated EPC page, and free the page itself when it's
> deleted from the radix tree.
> 
> Don't free/delete anything if the page is held by the reclaimer, as the
> reclaimer needs the page itself and the driver needs the radix entry to
> re-process the entry during sgx_encl_release().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Applied.

/Jarkko
