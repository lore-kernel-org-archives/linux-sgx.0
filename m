Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDAAC4CECE
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 263E5217F9
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbfJNVJn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 17:09:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:52971 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfJNVJn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 17:09:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 14:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="396596439"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2019 14:09:41 -0700
Date:   Tue, 15 Oct 2019 00:09:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 2/5] selftests/x86/sgx: Add check to verify exit
 handler stack alignment
Message-ID: <20191014210940.GW15552@linux.intel.com>
References: <20191011004059.28581-1-sean.j.christopherson@intel.com>
 <20191011004059.28581-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011004059.28581-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 05:40:56PM -0700, Sean Christopherson wrote:
> Add an assembly trampoline to the basic exit handler to snapshot the
> pre-CALL %rsp in order to verify that the stack is 16-byte aligned as
> required by the x86_64 ABI.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I'll rework the existing selftest commit in my tree to use the
"non-VDSO" (aka plain EENTER) call path. Please then provide me commits
for vDSO selftests. These commits will be their own commits in the patch
set. I'll move my selftest commit earlier in the patch set before the
vDSO commits.

Should be more than obvious why this makes sene, so I skip explaining
it but can provide rationale on demand basis.

I'll work this change out tomorrow.

/Jarkko
