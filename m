Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08962C4CECE
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBE942133F
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbfJNVDV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 17:03:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:25233 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfJNVDV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 17:03:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 14:03:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="396594719"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2019 14:03:18 -0700
Date:   Tue, 15 Oct 2019 00:03:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 0/4] x86/sgx: Fix add page bugs
Message-ID: <20191014210317.GU15552@linux.intel.com>
References: <20191010225530.26400-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010225530.26400-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 03:55:26PM -0700, Sean Christopherson wrote:
> Three bug fixes in the add page flow, along with a related enhancement.
> Note, patch 4/4 is effectively a revert.
> 
> Sean Christopherson (4):
>   x86/sgx: Pass EADD the kernel's virtual address for the source page
>   x86/sgx: Check the validity of the source page address for EADD
>   x86/sgx: Fix EEXTEND error handling
>   x86/sgx: Drop mmap_sem before EEXTENDing an enclave page
> 
>  arch/x86/kernel/cpu/sgx/ioctl.c | 46 ++++++++++++++++++---------------
>  1 file changed, 25 insertions(+), 21 deletions(-)

So, which one should be merged first. This or v2 of the other series.

Can you send a single "for-v23 fixes" series with everything needed just
so that there is no room guess work? You can call v3 of the series that
you first started.

You already know that I applied 1/9 and 2/9 so please don't include
them.

/Jarkko
