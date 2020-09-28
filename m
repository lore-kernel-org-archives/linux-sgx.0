Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F2DC2D0A8
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 010D620825
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 23:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgI1X76 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:59:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:12718 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbgI1X76 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 19:59:58 -0400
IronPort-SDR: nyRcAbQY9U+v13UtthCqBK0eruFjXoMIUqtkCqxNe1aWwKJ5v39E7pN3QubbyQgvVEiX+eRLox
 PyQy8gGvTAiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="223660966"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="223660966"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:56:44 -0700
IronPort-SDR: 3TWj+h2LPhdtBpEZ+uEDq8JR3Pkv5DjbrTY5pg8oVvTeweUZJ6ev/zSPMtjbBShluKnNJVlCkM
 ItrbFVtNgLDQ==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="457008323"
Received: from jlasecki-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.49.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:56:37 -0700
Date:   Tue, 29 Sep 2020 00:56:35 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "H.J. Lu" <hjl.tools@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
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
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928215635.GF2705@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <721ca14e-21df-3df1-7bef-0b00d0ff90c3@citrix.com>
 <20200928005842.GC6704@linux.intel.com>
 <85bc15d5-93cd-e332-ae9a-1e1e66e1181d@citrix.com>
 <CAMe9rOpzXW0cSD=9E7drGEHH=pcm_NqvPiaR0pBJzYLeAt0_3g@mail.gmail.com>
 <CALCETrU4Rhc0fwzzKLSUgan2YmSovxVFYOZEmFnBHC4DbZ5RfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU4Rhc0fwzzKLSUgan2YmSovxVFYOZEmFnBHC4DbZ5RfQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 11:12:08AM -0700, Andy Lutomirski wrote:
> On Mon, Sep 28, 2020 at 11:08 AM H.J. Lu <hjl.tools@gmail.com> wrote:
> >
> > On Mon, Sep 28, 2020 at 9:44 AM Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> > >
> > > On 28/09/2020 01:58, Jarkko Sakkinen wrote:
> > > > On Fri, Sep 25, 2020 at 07:23:59PM +0100, Andrew Cooper wrote:
> > > >> On 15/09/2020 12:28, Jarkko Sakkinen wrote:
> > > >>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > >>> new file mode 100644
> > > >>> index 000000000000..adbd59d41517
> > > >>> --- /dev/null
> > > >>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> > > >>> @@ -0,0 +1,157 @@
> > > >>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> > > >>> <snip>
> > > >>> +.Lretpoline:
> > > >>> +   call    2f
> > > >>> +1: pause
> > > >>> +   lfence
> > > >>> +   jmp     1b
> > > >>> +2: mov     %rax, (%rsp)
> > > >>> +   ret
> > > >> I hate to throw further spanners in the work, but this is not compatible
> > > >> with CET, and the user shadow stack work in progress.
> > > > CET goes beyond my expertise. Can you describe, at least rudimentary,
> > > > how this code is not compatible?
> > >
> > > CET Shadow Stacks detect attacks which modify the return address on the
> > > stack.
> > >
> > > Retpoline *is* a ROP gadget.  It really does modify the return address
> > > on the stack, even if its purpose is defensive (vs Spectre v2) rather
> > > than malicious.
> > >
> > > >> Whichever of these two large series lands first is going to inflict
> > > >> fixing this problem on the other.
> > > >>
> > > >> As the vdso text is global (to a first approximation), it must not be a
> > > >> retpoline if any other process is liable to want to use CET-SS.
> > > > Why is that?
> > >
> > > Because when CET-SS is enabled, the ret will suffer a #CP exception
> > > (return address on the stack not matching the one recorded in the shadow
> > > stack), which I presume/hope is wired into SIGSEGV.
> > >
> >
> > Here is the CET compatible retpoline:
> >
> > endbr64
> > /* Check if shadow stack is in use.  NB: R11 is the only usable
> >    scratch register for function calls.  */
> > xorl %r11d, %r11d
> > rdsspq %r11
> > testq %r11, %r11
> > jnz 3f
> > call 2f
> > 1:
> > pause
> > lfence
> > jmp 1b
> > 2:
> > mov %rax, (%rsp)
> > ret
> > 3:
> > /* Shadow stack is in use.  Make the indirect call.  */
> > call *%rax
> > ret
> 
> What do we expect user programs to do on CET systems?  It would be
> nice if we could instead ALTERNATIVE this out if X86_FEATURE_SHSTK.
> 
> --Andy

I'm open to do either solution. My thinking was to initially do things
vsgx.S local (i.e. consider ALTERNATIVE post upstreaming) and use the
above solution but I'm also fine doing ALTERNATIVE. Dave kindly briefed
on details how that thing works and it should be perfectly usable for
our use case.

/Jarkko
