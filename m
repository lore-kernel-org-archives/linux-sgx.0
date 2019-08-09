Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FA3C31E40
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B29020C01
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 16:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407405AbfHIQWy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 12:22:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:33732 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406775AbfHIQWy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 12:22:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 09:22:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,364,1559545200"; 
   d="scan'208";a="259083416"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 09 Aug 2019 09:22:53 -0700
Date:   Fri, 9 Aug 2019 09:22:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 0/6] x86/sgx: Remove EADD worker and page copy
Message-ID: <20190809162253.GC10541@linux.intel.com>
References: <20190808221340.29460-1-sean.j.christopherson@intel.com>
 <c2938cd31a0f062d8fd319b918a0830ad6e277ec.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2938cd31a0f062d8fd319b918a0830ad6e277ec.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 09, 2019 at 07:21:18PM +0300, Jarkko Sakkinen wrote:
> On Thu, 2019-08-08 at 15:13 -0700, Sean Christopherson wrote:
> > As suggested by Andy, remove the work queue in favor of handling the
> > entire EADD flow in the context of the ioctl().  After the worker is
> > gone, pass the source page/address directly to EADD instead of first
> > copying the data into kernel memory.
> > 
> > This applies on top the bug fix series I sent yesterday,
> > https://patchwork.kernel.org/cover/11082995/.
> > 
> > Sean Christopherson (6):
> >   x86/sgx: Validate generic SECINFO immediately after copying from user
> >   x86/sgx: Set SGX_ENCL_PAGE_TCS when allocating encl_page
> >   x86/sgx: Move encl_page insertion into tree out of alloc flow
> >   x86/sgx: Allocate encl_page prior to taking encl->lock
> >   x86/sgx: Remove the EADD page worker
> >   x86/sgx: Pass userspace source address directly to EADD
> > 
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 402 +++++++------------------
> >  arch/x86/kernel/cpu/sgx/driver/main.c  |   4 -
> >  arch/x86/kernel/cpu/sgx/encl.h         |   2 -
> >  3 files changed, 103 insertions(+), 305 deletions(-)
> 
> Can you resend a rebased one, once I've squashed the fixes?

Yep, not a problem.
