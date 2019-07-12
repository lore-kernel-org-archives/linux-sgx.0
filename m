Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA710C742A5
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C306E20644
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfGLDr4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:47:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:17342 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbfGLDr4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:47:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:47:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="177382568"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by orsmga002.jf.intel.com with ESMTP; 11 Jul 2019 20:47:53 -0700
Date:   Fri, 12 Jul 2019 06:47:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v21] docs: x86/sgx: Add a blurb on basic EPC
 management to 'kernel internals'
Message-ID: <20190712034752.2grjs2uyjssa2cd3@linux.intel.com>
References: <20190711214417.16565-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711214417.16565-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 02:44:17PM -0700, Sean Christopherson wrote:
> Add a section on how EPC is managed and why.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  Documentation/x86/sgx/2.Kernel-internals.rst | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/Documentation/x86/sgx/2.Kernel-internals.rst b/Documentation/x86/sgx/2.Kernel-internals.rst
> index de359bf605ca..5c90a65936f2 100644
> --- a/Documentation/x86/sgx/2.Kernel-internals.rst
> +++ b/Documentation/x86/sgx/2.Kernel-internals.rst
> @@ -15,6 +15,26 @@ attempt to play nice in the face of a misconfigured system.  With the exception
>  of Launch Control's hash MSRs, which can vary per CPU, Linux assumes that all
>  CPUs have a configuration that is identical to the boot CPU.
>  
> +EPC management
> +==============
> +
> +Because the kernel can't arbitrarily read EPC memory or share RO backing pages
> +between enclaves, traditional memory models such as CoW and fork() do not work
> +with enclaves.  In other words, the architectural rules of EPC forces it to be
> +treated as MAP_SHARED at all times.
> +
> +The inability to employ traditional memory models also means that EPC memory
> +must be isolated from normal memory pools, e.g. attempting to use EPC memory
> +for normal mappings would result in faults and/or perceived data corruption.
> +Furthermore, EPC is not enumerated by as normal memory, e.g. BIOS enumerates
> +EPC as reserved memory in the e820 tables, or not at all.  As a result, EPC
> +memory is directly managed by the SGX subsystem, e.g. SGX employs VM_PFNMAP to
> +manually insert/zap/swap page table entries, and exposes EPC to userspace via
> +a well known device, /dev/sgx/enclave.
> +
> +The net effect is that all enclave VMAs must be MAP_SHARED and are backed by
> +a single file, /dev/sgx/enclave.
> +
>  EPC oversubscription
>  ====================
>  
> -- 
> 2.22.0
> 


Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
