Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6931BC4360C
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 16:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4955821835
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 16:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfJJQIt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 12:08:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:27997 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfJJQIs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 12:08:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 09:08:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,280,1566889200"; 
   d="scan'208";a="197294625"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 10 Oct 2019 09:08:47 -0700
Date:   Thu, 10 Oct 2019 09:08:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 00/16] x86/vdso: sgx: Major vDSO cleanup
Message-ID: <20191010160847.GA23798@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191010081019.GA20654@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010081019.GA20654@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 11:10:19AM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 07, 2019 at 09:45:57PM -0700, Sean Christopherson wrote:
> > The main purpose of this series is to implement feedback from the original
> > RFC to expand the vDSO[*] that went unaddressed before the expanded
> > function was rushed into v21.
> > 
> > The other half of the series is to overhaul the selftest to actually test
> > the exit handler variation of the vDSO, with a bunch of prework to add an
> > assertion framework to standardize the various assertions in the test and
> > improve the readability of the code.
> > 
> > The basic ideas for the exit handler subtests are from Cedric's original
> > RFC, but rewritten from scratch to take advantage of the new assertion
> > framework.  I haven't yet implemented single-step subtest, ideally that
> > too will get done before v23.
> > 
> > [*] https://lkml.kernel.org/r/20190426210017.GA24467@linux.intel.com
> > 
> > Sean Christopherson (16):
> >   x86/vdso: sgx: Drop the pseudocode "documentation"
> >   x86/vdso: sgx: Do not use exception info to pass success/failure
> >   x86/vdso: sgx: Rename the enclave exit handler typedef
> >   x86/vdso: sgx: Move enclave exit handler declaration to UAPI header
> >   x86/vdso: sgx: Add comment regarding kernel-doc shenanigans
> >   x86/vdso: sgx: Rewrite __vdso_sgx_enter_enclave() function comment
> >   selftests/x86: Fix linker warning in SGX selftest
> >   selftests/x86/sgx: Use getauxval() to retrieve the vDSO base address
> >   selftests/x86/sgx: Add helper function and macros to assert results
> >   selftests/x86/sgx: Handle setup failures via test assertions
> >   selftests/x86/sgx: Sanitize the types for sgx_call()'s input params
> >   selftests/x86/sgx: Move existing sub-test to a separate helper
> >   selftests/x86/sgx: Add a test of the vDSO exception reporting
> >     mechanism
> >   selftests/x86/sgx: Add test of vDSO with basic exit handler
> >   selftests/x86/sgx: Add sub-test for exception behavior with exit
> >     handler
> >   x86/vdso: sgx: Rework __vdso_sgx_enter_enclave() to prefer "no
> >     callback"
> > 
> >  arch/x86/entry/vdso/vsgx_enter_enclave.S  | 228 +++++++------
> >  arch/x86/include/uapi/asm/sgx.h           |  18 +
> >  tools/testing/selftests/x86/sgx/Makefile  |   2 +-
> >  tools/testing/selftests/x86/sgx/defines.h |   6 +
> >  tools/testing/selftests/x86/sgx/main.c    | 384 ++++++++++++++--------
> >  5 files changed, 387 insertions(+), 251 deletions(-)
> > 
> > -- 
> > 2.22.0
> > 
> 
> vDSO changes look legit. I might do some minor edits (like coding
> style tweaks only). Thanks.

Let me send v2 to fix the stack alignment issue Cedric pointed out, along
with a selftest enhancement to verify the alignment.
