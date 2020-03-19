Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3361FC4332B
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118CD2070A
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCSUtY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:49:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:41209 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSUtY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 16:49:24 -0400
IronPort-SDR: NiV78BeAcag28bijSNwRcR2yTGOwfrPXnN2Ywq48KQkZ92f/zcvGDQIgfdZnZXiqE4cXBSZ4Of
 Iv6OdJRwFeHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 13:49:24 -0700
IronPort-SDR: yESLMWpJFD3nCaclzV2N3JmPtj6sbY8pWvAizIvVUCYOfeeYHWd2GOdI8qbB3haz65Fmv/HFPF
 0/U8aDZrSvbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,573,1574150400"; 
   d="scan'208";a="391926817"
Received: from oamor-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.182.181])
  by orsmga004.jf.intel.com with ESMTP; 19 Mar 2020 13:49:21 -0700
Date:   Thu, 19 Mar 2020 22:49:20 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 1/8] x86/sgx: vdso: Remove an incorrect statement
 the enter enclave comment
Message-ID: <20200319204920.GE24804@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319011130.8556-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 06:11:23PM -0700, Sean Christopherson wrote:
> Remove the statement about the userspace exit handler being required to
> clean up the untrusted stack, the vDSO unconditionally restores %rsp to
> its value at the time of EEXIT.
> 
> Reported-by: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

[no resend]

/Jarkko
