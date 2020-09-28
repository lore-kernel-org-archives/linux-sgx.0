Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB68C4346E
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 00:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D812623A33
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 00:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgI1A6s (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Sep 2020 20:58:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:3753 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgI1A6s (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 27 Sep 2020 20:58:48 -0400
IronPort-SDR: Qrwq7sieAnXW2K3yAcbLs8Ds5D86rNKJPtpfgD/45dl3YHzhG/ppF6O6cBmbKDDyjc5TVJirC0
 DYe8wuiKOkkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="161980969"
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="161980969"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 17:58:48 -0700
IronPort-SDR: a893AbrkDh9NEqsvVgsFECYLvDp1TGe5NEn8Kf3iYsyO9hWGRj2HhNerB/5u+vChTtTHg6xArP
 464TFTaa3iFQ==
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="488354243"
Received: from memara-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.157])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 17:58:40 -0700
Date:   Mon, 28 Sep 2020 03:58:42 +0300
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
Message-ID: <20200928005842.GC6704@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 07:23:59PM +0100, Andrew Cooper wrote:
> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > new file mode 100644
> > index 000000000000..adbd59d41517
> > --- /dev/null
> > +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > @@ -0,0 +1,157 @@
> > +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > <snip>
> > +.Lretpoline:
> > +	call	2f
> > +1:	pause
> > +	lfence
> > +	jmp	1b
> > +2:	mov	%rax, (%rsp)
> > +	ret
> 
> I hate to throw further spanners in the work, but this is not compatible
> with CET, and the user shadow stack work in progress.

CET goes beyond my expertise. Can you describe, at least rudimentary,
how this code is not compatible?

I know CET only conceptual level (separate stack holding return
addresses as an measure against return oriented programming (ROP)).

> Whichever of these two large series lands first is going to inflict
> fixing this problem on the other.
> 
> As the vdso text is global (to a first approximation), it must not be a
> retpoline if any other process is liable to want to use CET-SS.

Why is that?

> If the retpoline really does need to stay, then the vdso probably needs
> to gain suitable __x86_indirect_thunk_%reg thunks which are patched at
> boot based on the system properties.
> 
> ~Andrew

aka without CET it is patched? With CET, not?

/Jarkko
