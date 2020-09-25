Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A3EC4363D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91EC620936
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgIYLRW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 07:17:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:34866 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgIYLRW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 07:17:22 -0400
IronPort-SDR: Xg3Pth2/UcI6oUbDX9YRlyfi/5QxX5wmDRc06nnLx3Qe3HTsjWRh8mT8UXuXukNs3NhE4QlNnv
 e+YhVTWYzUng==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="141524145"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="141524145"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:17:21 -0700
IronPort-SDR: 8Z+81PwrOv/+Jds0OOJUHL6ddEa765YW1gB8rB7i5U5GoJD/fmphAblM2K5nKvUPDZ1gESLShI
 1vJF35NRfFFQ==
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="487430760"
Received: from tjhenson-mobl.amr.corp.intel.com (HELO localhost) ([10.252.48.117])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:17:15 -0700
Date:   Fri, 25 Sep 2020 14:17:13 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200925111713.GD180915@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
 <20200925010031.GH119995@linux.intel.com>
 <bf65f1f7-f91b-721c-90c5-064df152f710@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf65f1f7-f91b-721c-90c5-064df152f710@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 10:39:58AM +0200, Jethro Beekman wrote:
> On 2020-09-25 03:00, Jarkko Sakkinen wrote:
> > End result:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/include/uapi/asm/sgx.h
> > 
> > I'm wondering this sentence:
> > 
> > "The calling convention is custom and does not follow System V x86-64 ABI."
> > 
> > AFAIK, now the vDSO is fully C-callable but waiting for feedback before
> > removing it.
> 
> It's C-callable *iff your enclave follows the System V x86-64 ABI*. In
> addition, all registers not clobbered by the SGX ISA are passed to the
> enclave, not just those specified as parameter passing registers in
> the ABI. This is intentional to make the vDSO function usable in
> applications that use the current flexibility of ENCLU.

Hold on, I really want to fix this bit of documentation before sending
any new version, so I'll explain how I understand it.

I think it is just SystemV ABI call with six parameters in the usual
GPRs (rdi, rsi, rdx, rcx, r8, r9).

I'm looking at vdso_sgx_enter_enclave.

What I'm not getting?

> --
> Jethro Beekman | Fortanix

/Jarkko
