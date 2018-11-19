Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978FCC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 15:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 539FB20831
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 15:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 539FB20831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbeKTBay (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:30:54 -0500
Received: from mga04.intel.com ([192.55.52.120]:23022 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbeKTBay (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 20:30:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2018 07:07:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,252,1539673200"; 
   d="scan'208";a="97452161"
Received: from tmuluk-mobl4.ger.corp.intel.com (HELO localhost) ([10.249.254.135])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Nov 2018 07:06:56 -0800
Date:   Mon, 19 Nov 2018 17:06:55 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181119150655.GA11843@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:01:25AM +0200, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
> 
> SGX driver provides a ioctl API for loading and initializing enclaves.
> Address range for enclaves is reserved with mmap() and they are
> destroyed with munmap(). Enclave construction, measurement and
> initialization is done with the provided the ioctl API.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Question: should be dissolve the driver completely and move this code to
arch/x86/kernel/cpu/sgx/ (and rename intel_sgx.c as main.c)? Swapping
patch removes the possibility to compile this as a module anyway.

Would make also maintainer hierarchy more clear and clean albeit that
cannot be a guiding reason to do such change. Here's the current
MAINTAINERS entry in my master:

INTEL SGX
M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
M:	Sean Christopherson <sean.j.christopherson@intel.com>
L:	linux-sgx@vger.kernel.org
S:	Maintained
Q:	https://patchwork.kernel.org/project/intel-sgx/list/
T:	git https://github.com/jsakkine-intel/linux-sgx.git
F:	arch/x86/include/asm/sgx.h
F:	arch/x86/include/uapi/asm/sgx.h
F:	arch/x86/kernel/cpu/intel_sgx.c
F:	drivers/platform/x86/intel_sgx/*
K:	\bSGX_

If we do this, we would end up with this:

INTEL SGX
M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
M:	Sean Christopherson <sean.j.christopherson@intel.com>
L:	linux-sgx@vger.kernel.org
S:	Maintained
Q:	https://patchwork.kernel.org/project/intel-sgx/list/
T:	git https://github.com/jsakkine-intel/linux-sgx.git
F:	arch/x86/include/asm/sgx.h
F:	arch/x86/include/uapi/asm/sgx.h
F:	arch/x86/kernel/cpu/sgx/*
K:	\bSGX_

Then once the base code has been merged I would put my PRs to x86
maintainers for subsequent kernel releases.

/Jarkko
