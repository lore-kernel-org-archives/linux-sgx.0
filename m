Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926D5C2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 21:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586782083B
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 21:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgI1Vgf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:36:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:62822 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgI1Vge (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 17:36:34 -0400
IronPort-SDR: qQqHZTuE+Mh8J5CZiLIolE1apfst99fEJvZYTHcRNoZ9Fg7OknZritWrmZ1r9pB4BsydVdCELQ
 69FWBiJTjEGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149726779"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="149726779"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:36:34 -0700
IronPort-SDR: QixY2KCI8RuTaNZ15Zir8oirwhfamYYRxgCHUV/j7rw7sixYiquZlnGAPyr/EaVxinU2Cw6/Aq
 eMx/bicyDm6w==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="457000991"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:36:27 -0700
Date:   Tue, 29 Sep 2020 00:36:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "H.J. Lu" <hjl.tools@gmail.com>
Cc:     "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        Borislav Petkov <bp@alien8.de>, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Andy Lutomirski <luto@kernel.org>, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928213625.GC2705@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <c1b0019d-d3cb-cc62-f47f-90c2550c22a4@intel.com>
 <CAMe9rOrVhQr9ad_4en2D5GTTqDsJGXqszBmscgenn_87mDxvUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMe9rOrVhQr9ad_4en2D5GTTqDsJGXqszBmscgenn_87mDxvUA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 08:54:01AM -0700, H.J. Lu wrote:
> On Mon, Sep 28, 2020 at 8:43 AM Yu, Yu-cheng <yu-cheng.yu@intel.com> wrote:
> >
> > On 9/25/2020 11:23 AM, Andrew Cooper wrote:
> > > On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> > >> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > >> new file mode 100644
> > >> index 000000000000..adbd59d41517
> > >> --- /dev/null
> > >> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > >> @@ -0,0 +1,157 @@
> > >> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > >> <snip>
> > >> +.Lretpoline:
> > >> +    call    2f
> > >> +1:  pause
> > >> +    lfence
> > >> +    jmp     1b
> > >> +2:  mov     %rax, (%rsp)
> > >> +    ret
> > >
> > > I hate to throw further spanners in the work, but this is not compatible
> > > with CET, and the user shadow stack work in progress.
> >
> > Hi Jarkko,
> >
> > These 1: and 2: targets are reached only from these few lines?  If they
> > are direct call/jmp targets, I think it is OK in terms of CET.  If they
> > are reached from an instruction like "jmp *%rax", then we need to put in
> > an "endbr64".
> >
> 
> This also isn't compatible with shadow stack.
> 
> -- 
> H.J.

I have the now full picture of the problem thanks to Andrew's response
[1]. And Dave Hansen just explained me in detail the context and
background with [2]. So I'd guess this will get sorted out soon.

If you don't mind I'll CC you to this commit when I send the next
version?

[1] https://lkml.org/lkml/2020/9/28/1153
[2] https://lkml.org/lkml/2020/9/25/1122

/Jarkko
