Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BB5CA9EA0
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EDB21D7C
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633174AbfJRKEV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:04:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:33313 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389081AbfJRKEV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 06:04:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 03:04:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="396574747"
Received: from glas-mobl.ger.corp.intel.com (HELO localhost) ([10.252.17.198])
  by fmsmga005.fm.intel.com with ESMTP; 18 Oct 2019 03:04:19 -0700
Date:   Fri, 18 Oct 2019 13:04:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 04/12] x86/sgx: Drop mmap_sem before
 EEXTENDing an enclave page
Message-ID: <20191018100417.GB4835@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016183745.8226-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 11:37:37AM -0700, Sean Christopherson wrote:
> Drop mmap_sem, which needs to be held for read across EADD, prior to
> doing EEXTEND on the newly added page to avoid holding mmap_sem for an
> extended duration.  EEXTEND doesn't access user pages and holding
> encl->lock without mmap_sem is perfectly ok, while EEXTEND is a _slow_
> operation, to the point where it operates on 256-byte chunks
> instead of 4k pages to maintain a reasonable latency for a single
> instruction.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Locks should be always freed in the opposite order for any piece of
code.

/Jarkko
