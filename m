Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E25C10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 13:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 569C720815
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 13:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfJHNfN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 09:35:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:32084 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730249AbfJHNfN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 09:35:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 06:35:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="223237554"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2019 06:35:11 -0700
Date:   Tue, 8 Oct 2019 06:35:11 -0700
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
Message-ID: <20191008133511.GB14020@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-8-jarkko.sakkinen@linux.intel.com>
 <20191004094513.GA3362@zn.tnic>
 <20191008040405.GA1724@linux.intel.com>
 <20191008071845.GA14765@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008071845.GA14765@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 08, 2019 at 09:18:45AM +0200, Borislav Petkov wrote:
> On Mon, Oct 07, 2019 at 09:04:05PM -0700, Sean Christopherson wrote:
> > > BIT(30)
> > 
> > This is intentionally open coded so that it can be stringified in asm.
> 
> It stringifies just fine with the BIT() macro too:
> 
> # 187 "arch/x86/kernel/cpu/sgx/encls.h" 1
>         1: .byte 0x0f, 0x01, 0xcf;
>         2:
> .section .fixup,"ax"
> 3: orl $((((1UL))) << (30)),%eax
>    jmp 2b
> .previous
> 
> and the resulting object:
> 
> Disassembly of section .fixup:
> 
> 0000000000000000 <.fixup>:
>    0:   0d 00 00 00 40          or     $0x40000000,%eax
>    5:   e9 00 00 00 00          jmpq   a <__addressable_sgx_free_page107+0x2>

Hmm, I get assembler errors using gcc 5.4.0

  linux/arch/x86/kernel/cpu/sgx/encls.h: Assembler messages:
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: junk `UL)))<<(30))' after expression
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: junk `UL)))<<(30))' after expression
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: missing ')'
  linux/arch/x86/kernel/cpu/sgx/encls.h:207: Error: junk `UL)))<<(30))' after expression
  linux/scripts/Makefile.build:265: recipe for target 'arch/x86/kernel/cpu/sgx/encls.o' failed
