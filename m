Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F36C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 20:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D0A2083B
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 20:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgI1UnI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:43:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:25730 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1UnH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 16:43:07 -0400
IronPort-SDR: lBRFckoc5tXzYSaaaYb3tsVvRqH41vQZIytqCOHYRsC+mNEWd280BRhgJL+UCbGWUGV0qCoMiP
 fJQh2PsqrsNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="246800758"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="246800758"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 13:43:07 -0700
IronPort-SDR: Sn2YZ2oNxMSD99dlfbKPM/ePJK6RmI0Ws9dcTkEPnnts1QdwTwgrU64fbSmOcjquRy6PK6US1f
 TSTwK74M+sUg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="456987367"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 13:43:00 -0700
Date:   Mon, 28 Sep 2020 23:42:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        "H.J. Lu" <hjl.tools@gmail.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928204258.GA2705@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 05:44:35PM +0100, Andrew Cooper wrote:
> On 28/09/2020 01:58, Jarkko Sakkinen wrote:
> > On Fri, Sep 25, 2020 at 07:23:59PM +0100, Andrew Cooper wrote:
> >> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> >>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>> new file mode 100644
> >>> index 000000000000..adbd59d41517
> >>> --- /dev/null
> >>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>> @@ -0,0 +1,157 @@
> >>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >>> <snip>
> >>> +.Lretpoline:
> >>> +	call	2f
> >>> +1:	pause
> >>> +	lfence
> >>> +	jmp	1b
> >>> +2:	mov	%rax, (%rsp)
> >>> +	ret
> >> I hate to throw further spanners in the work, but this is not compatible
> >> with CET, and the user shadow stack work in progress.
> > CET goes beyond my expertise. Can you describe, at least rudimentary,
> > how this code is not compatible?
> 
> CET Shadow Stacks detect attacks which modify the return address on the
> stack.
> 
> Retpoline *is* a ROP gadget.  It really does modify the return address
> on the stack, even if its purpose is defensive (vs Spectre v2) rather
> than malicious.

Aah. I get that, yes.

Kernel is full of retpoline but I presume that ring-0 does not use CET.

The situation with callback is follows: for a run-time the user_handler
by all practical means is always the same. There is ever only one user
handler that gets executed. I.e. the indirect callback will always lead
to the same thing. I wonder how much assets an adversary would get if
we just remove retpoline bits (not much thinking done yet on that).

/Jarkko
