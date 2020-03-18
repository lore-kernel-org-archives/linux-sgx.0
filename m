Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CFBC4332D
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 22:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE7320754
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 22:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCRWjv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:39:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:41336 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgCRWju (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 18:39:50 -0400
IronPort-SDR: 16vwUxItd219oym/u9uvTyHEr+eEG2ECLFxyN89lVOd0dthG9sPvLDxLr0OQC2uUIuQSHIwH6y
 ndoE5swUfJPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 15:39:49 -0700
IronPort-SDR: OIZt4/Bulq5VM9kt6gz93SuZccv60eWXlc2inejhm2wUCfLxduTFCDDxrd8BuexZGUz7Mwo9Py
 fiNQdjwwpBsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="355843989"
Received: from mbeldzik-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.127])
  by fmsmga001.fm.intel.com with ESMTP; 18 Mar 2020 15:39:39 -0700
Date:   Thu, 19 Mar 2020 00:39:37 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
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
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200318223937.GC52244@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <94ce05323c4de721c4a6347223885f2ad9f541af.camel@linux.intel.com>
 <CAOASepM1pp1emPwSdFcaRkZfFm6sNmwPCJH+iFMiaJpFjU0VxQ@mail.gmail.com>
 <5dc2ec4bc9433f9beae824759f411c32b45d4b74.camel@linux.intel.com>
 <20200316225322.GJ24267@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316225322.GJ24267@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 16, 2020 at 03:53:22PM -0700, Sean Christopherson wrote:
> Yes and no.   If we wanted to minimize the amount of wrapping around the
> vDSO's ENCLU then we wouldn't have the exit handler shenanigans in the
> first place.  The whole process has been about balancing the wants of each
> use case against the overall quality of the API and code.

Minimizing is not something that happens in a void. Given the user base
for the SDK having the handler was a necessity. Otherwise, we would not
have that handler in the first place.

> Up until Nathaniel joined the party, the only stakeholder in terms of the
> exit handler was the Intel SDK.  There was a general consensus to pass
> registers as-is when there isn't a strong reason to do otherwise.  Note
> that Nathaniel has also expressed approval of that approach.

OK, great.

> The major benefits being that the vDSO would be callable from C and that
> the kernel could define a legitimate prototype instead of a frankenstein
> prototype that's half assembly and half C.  For me, those are significant

I was not aware that there was a plot to make it callable by C.

OK, so right now

A. @leaf =  %eax
B. @tcs = 8(%rsp)
C. @e = 0x10(%rsp)
D. @handler = 0x18(%rsp)

On x86-64 Linux C calling convention means DI/SI/DX/CX type of thing.

So what is the thing that we are referring to C calling convetion in
this email discussion?

> benefits and well worth the extra MOV, PUSH and POP.  For some use cases
> it would eliminate the need for an assembly wrapper.  For runtimes that
> need an assembly wrapper for whatever reason, it's probably still a win as
> a well designed runtime can avoid register shuffling in the wrapper.  And
> if there is a runtime that isn't covered by the above, it's at worst an
> extra MOV.

Is it cool if I rip of the documentation from vsgx_enter_enclave.S and
move it to Documentation/ ? It is nasty to keep and update it where it
is right now. How it is right now, it is destined to rotten.

/Jarkko
