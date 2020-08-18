Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3011FC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 17:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E1820786
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 17:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHRRBL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 13:01:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:3019 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbgHRRBB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 13:01:01 -0400
IronPort-SDR: 4ntDRPTLDEPmYmjfPZ77/7DKGDMZd6abdT4AC65ndBmwvDSHcxuL74XLzRmcADr67POEbT9Bt0
 ZcNeOWUsoWqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="135020165"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="135020165"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 10:01:00 -0700
IronPort-SDR: EZSxzPI/3c4ou+1KWrdAFzpoPsjxFM0P/qEZUg3cUN5u/w/5fSQ7l3YbuEYmTuI41qkpEdjwSP
 WjXRiW9takEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="441290759"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by orsmga004.jf.intel.com with ESMTP; 18 Aug 2020 10:00:58 -0700
Date:   Tue, 18 Aug 2020 20:00:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
Message-ID: <20200818170057.GD138452@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818042405.12871-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 17, 2020 at 09:24:05PM -0700, Sean Christopherson wrote:
> Allow userspace to exit the vDSO on interrupts that are acknowledged
> while the enclave is active.  This allows the user's runtime to switch
> contexts at opportune times without additional overhead, e.g. when using
> an M:N threading model (where M user threads run N TCSs, with N > M).
> 
> Suggested-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 27 ++++++++++++++++++++----
>  arch/x86/include/uapi/asm/sgx.h          |  3 +++
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> index b09e87dbe9334..33428c0f94b0d 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -21,6 +21,9 @@
>  
>  #define SGX_SYNCHRONOUS_EXIT	0
>  #define SGX_EXCEPTION_EXIT	1
> +#define SGX_INTERRUPT_EXIT	2
> +
> +#define SGX_EXIT_ON_INTERRUPTS	1

This naming scheme does not look too great.

I have nothing principal about code changes, *if* this is the approach
where we want to move. I did not look every detail because I'm not sure
what is the consensus yet.

/Jarkko
