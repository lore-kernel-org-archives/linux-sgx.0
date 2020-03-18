Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091F6C4332D
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 22:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D99802076C
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 22:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCRWSh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:18:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:18929 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCRWSh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 18:18:37 -0400
IronPort-SDR: sWn4wkDKl7ISxqUUYbHCA7dnt1/NAOR/CQyS/8h2y5NQpj++K6I/0hi0Sjb8wEN1w41cmJxE1/
 9IIn2SRr5Q3A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 15:18:36 -0700
IronPort-SDR: pzWgpjP8Erned37xWTCxCnBvKO5M/jn/spY20OjxwLyLrxTke/LPFw24o1OkQU4FSJdw7vbDWG
 KHuW0RTMtAZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="248330371"
Received: from mbeldzik-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.127])
  by orsmga006.jf.intel.com with ESMTP; 18 Mar 2020 15:18:25 -0700
Date:   Thu, 19 Mar 2020 00:18:24 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200318221824.GA55522@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
 <20200316225534.GK24267@linux.intel.com>
 <7634c48d-a8e2-7366-6f04-06a27f8e5eaf@intel.com>
 <20200318220114.GB52244@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318220114.GB52244@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 19, 2020 at 12:01:26AM +0200, Jarkko Sakkinen wrote:
> On Mon, Mar 16, 2020 at 04:56:42PM -0700, Xing, Cedric wrote:
> > On 3/16/2020 3:55 PM, Sean Christopherson wrote:
> > > On Mon, Mar 16, 2020 at 02:31:36PM +0100, Jethro Beekman wrote:
> > > > Can someone remind me why we're not passing TCS in RBX but on the stack?
> > > 
> > > I finally remembered why.  It's pulled off the stack and passed into the
> > > exit handler.  I'm pretty sure the vDSO could take it in %rbx and manually
> > > save it on the stack, but I'd rather keep the current behavior so that the
> > > vDSO is callable from C (assuming @leaf is changed to be passed via %rcx).
> > > 
> > The idea is that the caller of this vDSO API is C callable, hence it cannot
> > receive TCS in %rbx anyway. Then it has to either MOV to %rbx or PUSH to
> > stack. Either way the complexity is the same. The vDSO API however has to
> > always save it on stack for exit handler. So receiving it via stack ends up
> > in simplest code.
> 
> It is never C callable anyway given that not following the ABI so
> who cares about being C callable anyway?

A direct quote from the documentation:

"**Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with
the x86-64 ABI, i.e. cannot be called from standard C code."

/Jarkko
