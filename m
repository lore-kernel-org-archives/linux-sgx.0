Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E8DC4CECE
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 20:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7292217D9
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 20:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbfJNU6e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 16:58:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:23408 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730335AbfJNU6e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 16:58:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 13:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="194322879"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga008.fm.intel.com with ESMTP; 14 Oct 2019 13:58:31 -0700
Date:   Mon, 14 Oct 2019 23:58:30 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 2/9] x86/sgx: Do not EWB SECS if the enclave is
 dead
Message-ID: <20191014205830.GS15552@linux.intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
 <20191010214301.25669-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010214301.25669-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 02:42:54PM -0700, Sean Christopherson wrote:
> Don't EWB if the enclave is dead when opportunistically zapping the SECS
> during reclaim as VA pages are freed by sgx_encl_destroy(), i.e.
> sgx_encl_ewb() will consume a bad encl->va_pages if the enclave has been
> destroyed.
> 
> Add a comment in sgx_encl_destroy() to explicit call out that it's ok to
> free VA pages.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thank you.

Merged.

/Jarkko
