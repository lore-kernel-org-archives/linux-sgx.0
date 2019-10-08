Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2A5C4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8340B21721
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfJHEEG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:04:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:31427 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfJHEEG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:04:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:04:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="199706191"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Oct 2019 21:04:05 -0700
Date:   Mon, 7 Oct 2019 21:04:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 07/24] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20191008040405.GA1724@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-8-jarkko.sakkinen@linux.intel.com>
 <20191004094513.GA3362@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004094513.GA3362@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 04, 2019 at 11:45:13AM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2019 at 05:26:38PM +0300, Jarkko Sakkinen wrote:
> > +/**
> > + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> > + *
> > + * ENCLS has its own (positive value) error codes and also generates
> > + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> > + * with system error codes as everything percolates back up the stack.
> > + * Unfortunately (for us), we need to precisely identify each unique
> > + * error code, e.g. the action taken if EWB fails varies based on the
> > + * type of fault and on the exact SGX error code, i.e. we can't simply
> > + * convert all faults to -EFAULT.
> > + *
> > + * To make all three error types coexist, we set bit 30 to identify an
> > + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> > + * between positive (faults and SGX error codes) and negative (system
> > + * error codes) values.
> > + */
> > +#define ENCLS_FAULT_FLAG 0x40000000
> 
> BIT(30)

This is intentionally open coded so that it can be stringified in asm.
Alternatively, the asm could use the raw value or a different define.  Is
there a third option?

#define __encls_ret_N(rax, inputs...)				\
	({							\
	int ret;						\
	asm volatile(						\
	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
	"2:\n"							\
	".section .fixup,\"ax\"\n"				\
	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\  <----
	"   jmp 2b\n"						\
	".previous\n"						\
	_ASM_EXTABLE_FAULT(1b, 3b)				\
	: "=a"(ret)						\
	: "a"(rax), inputs					\
	: "memory", "cc");					\
	ret;							\
	})
