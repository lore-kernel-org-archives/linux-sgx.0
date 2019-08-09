Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D3CC31E40
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EB3F214C6
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfHIQVW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 12:21:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:6944 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437045AbfHIQVW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 12:21:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 09:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,364,1559545200"; 
   d="scan'208";a="259083198"
Received: from ishiri-mobl1.ger.corp.intel.com ([10.252.50.117])
  by orsmga001.jf.intel.com with ESMTP; 09 Aug 2019 09:21:19 -0700
Message-ID: <c2938cd31a0f062d8fd319b918a0830ad6e277ec.camel@linux.intel.com>
Subject: Re: [PATCH for_v22 0/6] x86/sgx: Remove EADD worker and page copy
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Date:   Fri, 09 Aug 2019 19:21:18 +0300
In-Reply-To: <20190808221340.29460-1-sean.j.christopherson@intel.com>
References: <20190808221340.29460-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-08 at 15:13 -0700, Sean Christopherson wrote:
> As suggested by Andy, remove the work queue in favor of handling the
> entire EADD flow in the context of the ioctl().  After the worker is
> gone, pass the source page/address directly to EADD instead of first
> copying the data into kernel memory.
> 
> This applies on top the bug fix series I sent yesterday,
> https://patchwork.kernel.org/cover/11082995/.
> 
> Sean Christopherson (6):
>   x86/sgx: Validate generic SECINFO immediately after copying from user
>   x86/sgx: Set SGX_ENCL_PAGE_TCS when allocating encl_page
>   x86/sgx: Move encl_page insertion into tree out of alloc flow
>   x86/sgx: Allocate encl_page prior to taking encl->lock
>   x86/sgx: Remove the EADD page worker
>   x86/sgx: Pass userspace source address directly to EADD
> 
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 402 +++++++------------------
>  arch/x86/kernel/cpu/sgx/driver/main.c  |   4 -
>  arch/x86/kernel/cpu/sgx/encl.h         |   2 -
>  3 files changed, 103 insertions(+), 305 deletions(-)

Can you resend a rebased one, once I've squashed the fixes?

/Jarkko

