Return-Path: <SRS0=UA5/=DE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9D8C4346E
	for <linux-sgx@archiver.kernel.org>; Sun, 27 Sep 2020 23:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54E823A33
	for <linux-sgx@archiver.kernel.org>; Sun, 27 Sep 2020 23:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgI0XhF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Sep 2020 19:37:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:7293 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgI0XhF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 27 Sep 2020 19:37:05 -0400
IronPort-SDR: G8o5wPLxZD7V09inwxhr1DOBS5QLO7kseR+9jHxGhPX2dz5hwsZPc98R9U7FPlO5PixAbP8tAX
 wVqgbbJRFhfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="246658430"
X-IronPort-AV: E=Sophos;i="5.77,311,1596524400"; 
   d="scan'208";a="246658430"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 16:37:04 -0700
IronPort-SDR: g3DNNPNqPM8zIlRN2HlJVhyzyTKQy7usmCRG4fEf/zRgameEqlQd0mgWhptwPNG3dYAfNnyUnn
 8uDyLDnIb4tQ==
X-IronPort-AV: E=Sophos;i="5.77,311,1596524400"; 
   d="scan'208";a="488336523"
Received: from memara-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.157])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 16:36:58 -0700
Date:   Mon, 28 Sep 2020 02:37:00 +0300
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
Message-ID: <20200927233700.GA4450@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
 <20200925010031.GH119995@linux.intel.com>
 <20200925082807.GG16872@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925082807.GG16872@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 10:28:07AM +0200, Borislav Petkov wrote:
> > > I can see why you would write "TCS" though - there's a thread control
> > > structure thing too in that patch.
> > 
> > Renamed.
> 
> See Sean's reply.

I did not get Sean's reply, and neither can find it from lore:

https://lore.kernel.org/linux-sgx/20200915112842.897265-1-jarkko.sakkinen@linux.intel.com/T/#t

> >  * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
> >  *					__vdso_sgx_enter_enclave()
> >  * @rdi:	RDI snapshot
> >  * @rsi:	RSI snapshot
> >  * @rdx:	RDX snapshot
> >  * @rsp:	RSP snapshot (untrusted stack)
> >  * @r8:		R8 snapshot
> >  * @r9:		R9 snapshot
> 
> I'd say here:
> 
> "The registers' content is the snapshot made at enclave exit."

I'd make that a description and take away individual parameter
descriptions. Is that fine?

> > Also, I renamed 'r' as 'run' in some places.
> > 
> > End result:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/include/uapi/asm/sgx.h
> > 
> > I'm wondering this sentence:
> > 
> > "The calling convention is custom and does not follow System V x86-64 ABI."
> 
> Yeah, I was wondering what that meant too.

I'll refine that one based on my own and Jethro's feedback.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
