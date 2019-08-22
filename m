Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE37C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 12:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA200233A2
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 12:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388086AbfHVM4r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 08:56:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:52009 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387779AbfHVM4r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 08:56:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 05:56:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="354274866"
Received: from greathea-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.39.37])
  by orsmga005.jf.intel.com with ESMTP; 22 Aug 2019 05:56:44 -0700
Date:   Thu, 22 Aug 2019 15:56:43 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 4/8] x86/sgx: Set SGX_ENCL_PAGE_TCS when
 allocating encl_page
Message-ID: <20190822125613.4a36bg3ujoexzj27@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813011252.4121-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 12, 2019 at 06:12:48PM -0700, Sean Christopherson wrote:
> Set SGX_ENCL_PAGE_TCS when encl_page->desc is initialized in
> sgx_encl_page_alloc() to improve readability, and so that the code
> isn't affected when the bulk of __sgx_encl_add_page() is rewritten
> to remove the EADD worker in a future patch.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I don't mean to be impolite but this change only decreases readability,
and in no possible way improves it. Clear semantics and such things
improve readability

The semantics are terrible if you have a parameter that can have
multiple values but only a single value would trigger something. We
don't want that kind of weirdness to the codebase. We want clean
up such glitches.

If you have a boolean behaviour, please use a boolean value then.

I changed it to always assign the page type and added spacing to make
the code more readable. SECINFO gets validated early in the ioctl so
there should not be problem.

/Jarkko
