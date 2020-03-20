Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA75C4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 18:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF64920775
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 18:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCTSKu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 14:10:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:6178 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgCTSKu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 14:10:50 -0400
IronPort-SDR: U0m2o4Ct217H6vuhtbOia7HE76zoxIyWlkkqMnMa9euJP8w7znMWY5W4Awwx9CTc8wfHj0oA+x
 raM7ITZPsW5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 11:10:49 -0700
IronPort-SDR: cqtZyPiH50pMn6jpy5CloDCGzqNhJ6iFhgKuHFOWkFruJBkYsBJqI2TnY3myNH3NUUopaCZOEc
 WkdaEAOpk99A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="392228911"
Received: from aklimker-mobl1.ger.corp.intel.com (HELO localhost) ([10.255.197.99])
  by orsmga004.jf.intel.com with ESMTP; 20 Mar 2020 11:10:47 -0700
Date:   Fri, 20 Mar 2020 20:10:45 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/2] selftests/x86/sgx: Move to selftests/sgx
Message-ID: <20200320181045.GB389717@linux.intel.com>
References: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
 <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
 <20200320175212.GA166291@linux.intel.com>
 <20200320180949.GA389717@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320180949.GA389717@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 20, 2020 at 08:09:55PM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 20, 2020 at 07:52:17PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Mar 20, 2020 at 07:47:16PM +0200, Jarkko Sakkinen wrote:
> > > Move selftest under the top level selftests directory so that we don't
> > > need to clutter x86/Makefile. The changes made for x86/Makefile caused
> > > also issues with packaging the selftests. Finally, SGX assets need their
> > > own tailored compilation environment.
> > > 
> > > With this change BuildRoot nicely packages both standard x86 selftests
> > > and our SGX test.
> > > 
> > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > Promise that this my last update to selftests. Just wanted to hammer
> > these quickly to cause minimum amount of distraction with the other
> > patch set. Otherwise, would be very hard to focus on reviewing those
> > chages. The changes I've done I think are no brainers. That's why I
> > don't hold for long before merging.
> 
> Merged:
> 
> # ./test_sgx
> SUCCESS
> 
> Also:
> 
> # ls sgx
> encl.bin  test_sgx
> # ls x86
> check_initial_reg_state_64  syscall_arg_fault_64
> fsgsbase_64                 syscall_nt_64
> ioperm_64                   syscall_numbering_64
> iopl_64                     sysret_rip_64
> mov_ss_trap_64              sysret_ss_attrs_64
> protection_keys_64          test_mremap_vdso_64
> sigreturn_64                test_vdso_64
> single_step_syscall_64      test_vsyscall_64

Nothing else in the queue for selftests.

/Jarkko
