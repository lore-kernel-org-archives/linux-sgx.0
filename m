Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7C7C433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 15:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199982054F
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 15:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHRPPe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:15:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:15056 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgHRPPc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 11:15:32 -0400
IronPort-SDR: L+KLM5mBO9MBXbeEhSZ8wMk/MGFojmdiLGNrMQE9cESn2ivslhys2JC0WpBn5KR733aNULPm9c
 IwmKiaL2s/Eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="142751550"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="142751550"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 08:15:31 -0700
IronPort-SDR: 7uBaeP3VopyWjRQpdT30PXi+A+KSFPgMgAA8KTz87yr9M3wOPDd4MbvkETy3M7Z4GJ8DOFhNBs
 ATIClkKbotfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="296879410"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by orsmga006.jf.intel.com with ESMTP; 18 Aug 2020 08:15:25 -0700
Date:   Tue, 18 Aug 2020 18:15:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200818151524.GE132200@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <CALCETrVch_XW-oc_-LR8Dbgat9DpSKtCYTV9YZaU7tfu61FHEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVch_XW-oc_-LR8Dbgat9DpSKtCYTV9YZaU7tfu61FHEw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 10, 2020 at 04:08:46PM -0700, Andy Lutomirski wrote:
> On Thu, Aug 6, 2020 at 7:55 AM Nathaniel McCallum <npmccallum@redhat.com> wrote:
> >
> > In a past revision of this patch, I had requested a void *misc
> > parameter that could be passed through vdso_sgx_enter_enclave_t into
> > sgx_enclave_exit_handler_t. This request encountered some push back
> > and I dropped the issue. However, I'd like to revisit it or something
> > similar.
> 
> Why do you need an exit handler at all?  IIRC way back when I
> suggested that we simply not support it at all.  If you want to
> call__vdso_sgx_enter_enclave() in a loop, call it in a loop.  If you
> want to wrap it intelligently in Rust, you don't want a callback
> anyway -- that forces you have an FFI (or non-Rust, anyway) frame on
> the stack, which interacts poorly with panic handling and prevents you
> from using await in your Rust callback handler.  If, on the other
> hand, you just call __vdso_sg_enter_enclave() in a loop, all these
> problems go away and, if you really want, you can pass in a callback
> in Rust and call the callback from Rust.

How would Intel SDK be able to do its stack manipulation?

> What am I missing?  I still don't really understand why we are
> supporting this mechanism at all.  Just the asm code to invoke the
> callback seems to be about half of the entire function.

I'm most worried maintaining all of this given all the innovative ways
that users can exploit an uapi.

/Jarkko
