Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD8BC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 14:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D629A2073E
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 14:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgF3Ozp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 10:55:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:40606 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbgF3Ozp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 30 Jun 2020 10:55:45 -0400
IronPort-SDR: Gr8vt0UrdPl9QD1QFhiVM4FsfugMOr8ctk86Z0plhUMxRVdtbPq/39LFmbY38WqB0kUk4C6zDY
 aO3R1V51znFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="145323530"
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="145323530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 07:55:44 -0700
IronPort-SDR: 0TRG9d159j5c9hBSSSCMIu6gXkycyMjX1F7tQzG4wyo0IKU//t6Rjy7rtmSJpE8wmgJBtGNMaW
 0dD1d0P6IOIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="266492435"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jun 2020 07:55:44 -0700
Date:   Tue, 30 Jun 2020 07:55:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200630145543.GB7733@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com>
 <20200629171022.GC32176@zn.tnic>
 <20200630060055.GS12312@linux.intel.com>
 <20200630084128.GA1093@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630084128.GA1093@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 30, 2020 at 10:41:28AM +0200, Borislav Petkov wrote:
> On Mon, Jun 29, 2020 at 11:00:55PM -0700, Sean Christopherson wrote:
> > E.g. the vDSO function should get the fixup even if userspace screws
> > up mmap() and invokes __vdso_sgx_enter_enclave() without being tagged
> > an SGX task.
> 
> I sincerely hope you don't mean this seriously.
> 
> Please add a member to task_struct which denotes that a task is an
> sgx task, test that member where needed and forget real quickly about
> running *any* *fixup* for unrelated tasks.

But IMO they're not unrelated if they end up in __vdso_sgx_enter_enclave().
Getting to the point where __vdso_sgx_enter_enclave() actually attempts
ENCLU (the single fixup entry) requires a very deliberate attempt to run an
enclave.  Not to mention the fixup doesn't squash the fault, it simply
morphs what would be a signal into a synchronous error.

And I don't see how to sanely track this in task_struct.  As stated before,
the only foolproof way to identify an SGX task is by tracking whether it
has a VMA backed by /dev/sgx/enclave, i.e. the flag would probably need to
reside in mm_struct.  Keying off opening /dev/sgx/enclave isn't viable as
enclaves can be handed off via SCM_RIGHTS or fork().

Putting a flag in mm_struct is doable, but it would need to be sticky to
keep things sane, e.g. clearing the flag on unmapping the enclave would
require refcounting VMAs and hooking vm_ops->close.  The refcounting is
painful (we had it for several years) and ->close prevents merging VMAs,
which IMO is far worse than unconditionally morphing fault-based signals
that originate in __vdso_sgx_enter_enclave().  And assuming we don't do the
whole ->close thing, we'd end up with MADV_DONTFORK -> fork() having
divergent behavior for mm_structs without /dev/sgx/enclave VMAs, i.e. the
child of MADV_DONTFORK -> fork() case would not be tagged SGX (unless we
intentionally do the "wrong" thing and propagate the flag), whereas the
munmap() case would result in a SGX-tagged mm_struct with no
/dev/sgx/enclave VMAs.
