Return-Path: <SRS0=H9hn=YR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1225CA9EAF
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Oct 2019 18:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC66521906
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Oct 2019 18:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504083AbfJXSfg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Oct 2019 14:35:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:33357 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfJXSfg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Oct 2019 14:35:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 11:35:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="373307918"
Received: from nesterov-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.8.153])
  by orsmga005.jf.intel.com with ESMTP; 24 Oct 2019 11:35:33 -0700
Date:   Thu, 24 Oct 2019 21:35:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 0/3] x86/sgx: More cleanup for v23
Message-ID: <20191024183532.GA849@linux.intel.com>
References: <20191022224922.28144-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022224922.28144-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 22, 2019 at 03:49:19PM -0700, Sean Christopherson wrote:
> Two small enchancements, and a rework of the sgx_free_page() split that
> was sent in a previous series.
> 
> Sean Christopherson (3):
>   x86/sgx: Update the free page count in a single operation
>   x86/sgx: Do not add in-use EPC page to the free page list
>   x86/sgx: Move reclaim logic out of sgx_free_page()
> 
>  arch/x86/kernel/cpu/sgx/encl.c    |  3 ++-
>  arch/x86/kernel/cpu/sgx/main.c    | 36 +++++++++----------------------
>  arch/x86/kernel/cpu/sgx/reclaim.c | 32 +++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h     |  3 ++-
>  4 files changed, 46 insertions(+), 28 deletions(-)
> 
> -- 
> 2.22.0
> 

I think these should be now merged. Always have to do a lot of tweaking
to keep diff's straight with these three commits:

1. x86/sgx: Add functions to allocate and free EPC pages
2. x86/sgx: Linux Enclave Driver
3. x86/sgx: Add a page reclaimer

If something is different the only reason is most likely that the
difference is just side-product of the patch adjustment. I haven't
made my own mods on purpose.

/Jarkko
