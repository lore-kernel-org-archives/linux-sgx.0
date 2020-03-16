Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC807C18E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F6C20663
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgCPN4r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:56:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:4449 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbgCPN4r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 09:56:47 -0400
IronPort-SDR: X3aBeBnVSKtzArek4ILMPFhHlM2wm6lzGJGa4wjiFnxxeu7nW5nnQrxmw9dHkiwjSA29eaPlAn
 GjnGvm4LRFCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 06:56:46 -0700
IronPort-SDR: /SUHAXr9ZbR3tCMwpyjXlQOI9q2Src6Jid+g9z5mmueuqmBQgyXAsG0Xkqdmizj0DuQTtuc0XH
 oahoNkjdbz7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,560,1574150400"; 
   d="scan'208";a="443347986"
Received: from zidelson-mobl1.ger.corp.intel.com ([10.251.163.156])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2020 06:56:32 -0700
Message-ID: <94ce05323c4de721c4a6347223885f2ad9f541af.camel@linux.intel.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Date:   Mon, 16 Mar 2020 15:56:30 +0200
In-Reply-To: <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
         <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
         <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
         <20200315012523.GC208715@linux.intel.com>
         <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.35.92-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 2020-03-15 at 13:53 -0400, Nathaniel McCallum wrote:
> On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
> > > Currently, the selftest has a wrapper around
> > > __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> > > registers (CSRs), though it uses none of them. Then it calls this
> > > function which uses %rbx but preserves none of the CSRs. Then it jumps
> > > into an enclave which zeroes all these registers before returning.
> > > Thus:
> > > 
> > >   1. wrapper saves all CSRs
> > >   2. wrapper repositions stack arguments
> > >   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
> > >   4. selftest zeros all CSRs
> > >   5. wrapper loads all CSRs
> > > 
> > > I'd like to propose instead that the enclave be responsible for saving
> > > and restoring CSRs. So instead of the above we have:
> > >   1. __vdso_sgx_enter_enclave() saves %rbx
> > >   2. enclave saves CSRs
> > >   3. enclave loads CSRs
> > >   4. __vdso_sgx_enter_enclave() loads %rbx
> > > 
> > > I know that lots of other stuff happens during enclave transitions,
> > > but at the very least we could reduce the number of instructions
> > > through this critical path.
> > 
> > What Jethro said and also that it is a good general principle to cut
> > down the semantics of any vdso as minimal as possible.
> > 
> > I.e. even if saving RBX would make somehow sense it *can* be left
> > out without loss in terms of what can be done with the vDSO.
> 
> Please read the rest of the thread. Sean and I have hammered out some
> sensible and effective changes.

Have skimmed through that discussion but it comes down how much you get
by obviously degrading some of the robustness. Complexity of the calling
pattern is not something that should be emphasized as that is something
that is anyway hidden inside the runtime.

/Jarkko

