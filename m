Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D140C3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A03123405
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389916AbfHWCM7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 22:12:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:25821 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389311AbfHWCM7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 22:12:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 19:12:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="330582594"
Received: from nmordaws-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.129])
  by orsmga004.jf.intel.com with ESMTP; 22 Aug 2019 19:12:57 -0700
Date:   Fri, 23 Aug 2019 05:12:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3] x86/sgx: Determine SECS at compile time in
 sgx_encl_eldu()
Message-ID: <20190823021255.e6cypkjjl4kfe4uo@linux.intel.com>
References: <20190822155501.8276-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822155501.8276-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 06:55:01PM +0300, Jarkko Sakkinen wrote:
> Add @secs_page to sgx_encl_eldu() and @is_secs_child to sgx_encl_ewb()
> (replacing earlier @do_free) in order to state explicitly in the call
> site when we are using SECS. These replace the use of
> SGX_ENCL_PAGE_IS_SECS() macro.
> 
> In order to fully remove SGX_ENCL_PAGE_IS_SECS(), replace
> sgx_encl_get_index() with a macro SGX_ENCL_PAGE_INEX() as the
> conditional logic is no longer required.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> v3: Forgot to flip the conditions in __sgx_encl_eldu().
> v2: Use @secs_page in the ELDU flow. Rename @secs_child as
>     @is_secs_child in EWB flow.
>  arch/x86/kernel/cpu/sgx/encl.c    | 51 ++++++++++++++-----------------
>  arch/x86/kernel/cpu/sgx/encl.h    |  4 +--
>  arch/x86/kernel/cpu/sgx/reclaim.c | 34 +++++++++++++--------
>  3 files changed, 47 insertions(+), 42 deletions(-)

This has been squashed.

/Jarkko
