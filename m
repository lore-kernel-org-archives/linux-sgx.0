Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701EEC2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 15:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF292074A
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 15:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgI1PiQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 11:38:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:1891 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgI1PiP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 11:38:15 -0400
IronPort-SDR: Icsc9AYRPRjyaFlY5CJZc5evxzIEoZWZxhl5HeW9h0RzPB/S9zhEOs0ZILU/4vnRUhXcDeNvwW
 Qw7L6NIqlHYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="142023299"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="142023299"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:03:00 -0700
IronPort-SDR: ISC2ukrvmEDTuhcF//VIwv9nXDJWy02+pzO+JuVUYBA9Fm8WkrMeQjY7XLaVyfvpfKu0E1lZwf
 TD1fRczmzHPQ==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="488612961"
Received: from schuethe-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.34.214])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:02:52 -0700
Date:   Mon, 28 Sep 2020 18:02:53 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20200928150253.GD70098@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
 <20200925010031.GH119995@linux.intel.com>
 <20200925082807.GG16872@zn.tnic>
 <20200927233700.GA4450@linux.intel.com>
 <20200928083032.GB1685@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928083032.GB1685@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 10:30:32AM +0200, Borislav Petkov wrote:
> On Mon, Sep 28, 2020 at 02:37:00AM +0300, Jarkko Sakkinen wrote:
> > I did not get Sean's reply, and neither can find it from lore:
> > 
> > https://lore.kernel.org/linux-sgx/20200915112842.897265-1-jarkko.sakkinen@linux.intel.com/T/#t
> 
> Yah, your mail server upgrade broke a lot of stuff. And lore even says
> it is not there:
> 
> 2020-09-25 11:43           ` Jethro Beekman
>      [not found]     ` <20200925003808.GB20333@linux.intel.com>		<---
> 2020-09-25  1:04       ` Jarkko Sakkinen
> 
> Lemme bounce it to you.

Thank you. I think I have it correctly in my tree. And I actually
noticed that I had the original email stored in wrong archive folder on
my machine (sorry about that), so did I receive it after all, but it
does not exist in lore.

> > I'd make that a description and take away individual parameter
> > descriptions. Is that fine?
> 
> Sure.

/**
 * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
 *					__vdso_sgx_enter_enclave()
 * @run:	Pointer to the caller provided struct sgx_enclave_run
 *
 * The register parameters contain the snapshot of their values at enclave
 * exit
 *
 * Return:
 *  0 or negative to exit vDSO
 *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
 */
typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
					  long rsp, long r8, long r9,
					  struct sgx_enclave_run *run);

I think this looks reasonable now.

Another minor clean up I made is:

struct sgx_enclave_run {
	__u64 tcs;
	__u32 flags;
	__u32 exit_reason;
	__u64 user_handler;
	__u64 user_data;

I.e. got rid of the "user_handler union. Makes the struc less confusing
looking and is consistent with the other structs.

I've been thinking about this tail:

	union {
		struct sgx_enclave_exception exception;

		/* Pad the entire struct to 256 bytes. */
		__u8 pad[256 - 32];
	};
};

I'd just replace this with

	__u64 exception;
};

And do something like (just writing it to the email to show the idea,
have not even compiled this):

-       mov     %eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
-       mov     %di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
-       mov     %si,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ERROR_CODE)(%rbx)
-       mov     %rdx, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_ADDRESS)(%rbx)
+       mov     SGX_ENCLAVE_RUN_EXCEPTION(%rbx), %rbx
+
+       mov     %eax, (SGX_EX_LEAF)(%rbx)
+       mov     %di,  (SGX_EX_TRAPNR)(%rbx)
+       mov     %si,  (SGX_EX_ERROR_CODE)(%rbx)
+       mov     %rdx, (SGX_EX_ADDRESS)(%rbx)

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
