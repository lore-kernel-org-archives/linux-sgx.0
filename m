Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF984C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 20:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8EC2080A
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 20:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgI1U4q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:56:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:36585 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgI1U4p (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 16:56:45 -0400
IronPort-SDR: AntBVXBu61xZ+p8c4MEP1zprWDBZqzIOybxcwwRFD7e7SzUrVBRrutN/sG34WL1oDKuzkaXqQk
 8CrBEOy7Gw4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162122524"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="162122524"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 13:56:45 -0700
IronPort-SDR: fGbW3MaymiMrYnM20A8FHMVnJsWXl3X37Tcn1A6N2GhCqj+Qdmdmv67N+UKMyRo/Fs6MiaxFMv
 8mhj4psmJzJA==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="488755489"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 13:56:38 -0700
Date:   Mon, 28 Sep 2020 23:56:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Yu, Yu-cheng" <yu-cheng.yu@intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
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
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928205636.GB2705@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <c1b0019d-d3cb-cc62-f47f-90c2550c22a4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b0019d-d3cb-cc62-f47f-90c2550c22a4@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 08:43:16AM -0700, Yu, Yu-cheng wrote:
> On 9/25/2020 11:23 AM, Andrew Cooper wrote:
> > On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> > > diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > new file mode 100644
> > > index 000000000000..adbd59d41517
> > > --- /dev/null
> > > +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > @@ -0,0 +1,157 @@
> > > +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > <snip>
> > > +.Lretpoline:
> > > +	call	2f
> > > +1:	pause
> > > +	lfence
> > > +	jmp	1b
> > > +2:	mov	%rax, (%rsp)
> > > +	ret
> > 
> > I hate to throw further spanners in the work, but this is not compatible
> > with CET, and the user shadow stack work in progress.
> 
> Hi Jarkko,
> 
> These 1: and 2: targets are reached only from these few lines?  If they are
> direct call/jmp targets, I think it is OK in terms of CET.  If they are
> reached from an instruction like "jmp *%rax", then we need to put in an
> "endbr64".
> 
> Yu-cheng

The invocation is over here:

	/* Load the callback pointer to %rax and invoke it via retpoline. */
	mov	SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
	call	.Lretpoline

/Jarkko
