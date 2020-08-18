Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B85C433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 14:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87EB12080C
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 14:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHROwn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:52:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:12236 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgHROwm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 10:52:42 -0400
IronPort-SDR: +jKtLePMzRQoO2k/6dt7ZuwZ179pMSLcm1NNYOm2jkTdZPaFNzPlsjA2ohgN4nZWdkiIvLHZo7
 ckVWUsnk7JsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="142742972"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="142742972"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 07:52:41 -0700
IronPort-SDR: d2buaeSk2jnkNjYsMBcotUV83mieA7rCG9w4EIOwKwdWB2GHnm5IFP348wPBzeCQJ6TG+wMbQU
 v+IBc1Q2f80A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="497394912"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by fmsmga005.fm.intel.com with ESMTP; 18 Aug 2020 07:52:35 -0700
Date:   Tue, 18 Aug 2020 17:52:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>, kai.huang@intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        ludloff@google.com, luto@kernel.org,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200818145234.GC132200@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810222317.GG14724@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 10, 2020 at 03:23:17PM -0700, Sean Christopherson wrote:
> > This can be done implicitly by wrapping the struct
> > sgx_enclave_exception in another structure and then using techniques
> > like container_of() to find another field. However, this is made more
> > difficult by the fact that the sgx_enclave_exit_handler_t is not
> > really using the x86_64 sysv calling convention. Therefore, the
> > sgx_enclave_exit_handler_t MUST be written in assembly.
> 
> What bits of the x86-64 ABI require writing the handler in assembly?  There
> are certainly restrictions on what the handler can do without needing an
> assembly trampoline, but I was under the impression that vanilla C code is
> compatible with the exit handler patch.  Is Rust more picky about calling
> convention?
> 
> Side topic, the documentation for vdso_sgx_enter_enclave_t is wrong, it
> states the EFLAGS.DF is not cleared before invoking the handler, but that's
> a lie.

If handler requires the use of setjmp/longjmp API for sudden exits, that
is considered bad even with C++, as it is not compatible with stack
unwinding. The handler has a lot of constraints for its environment, and
is somewhat unappealing to use.

That's why I started today thinking a possibility of using a bpf program
as a middle-man. BPF programs can be used to execute code by the kernel
in behalf of user in a domain defined sandbox. The execution context is
just a buffer passed in R1 to the BPF interpreter. It can be defined by
application.

/Jarkko
