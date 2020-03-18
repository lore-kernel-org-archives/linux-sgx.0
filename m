Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E8EC4332E
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 22:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B678E20754
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 22:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCRWB0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:01:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:19359 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRWB0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 18:01:26 -0400
IronPort-SDR: /qFH/8WYaDf8WdFopJwqO8iPeoOiObVOVwkjAM+xRk0JcETESwlaBLfx3GgU+pAA+4Hd7xNL9S
 zVSRtKUChNaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 15:01:25 -0700
IronPort-SDR: Klu9TMou3EoHttQci5ZkRO0GJktwXeHEn6BrhsoQgdQ1qZn/HGT5fyX1pRRbe5f+p84CBjTjn1
 GoGgtXe6EjpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="244961234"
Received: from mbeldzik-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.127])
  by orsmga003.jf.intel.com with ESMTP; 18 Mar 2020 15:01:15 -0700
Date:   Thu, 19 Mar 2020 00:01:14 +0200
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
Message-ID: <20200318220114.GB52244@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
 <20200316225534.GK24267@linux.intel.com>
 <7634c48d-a8e2-7366-6f04-06a27f8e5eaf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7634c48d-a8e2-7366-6f04-06a27f8e5eaf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 16, 2020 at 04:56:42PM -0700, Xing, Cedric wrote:
> On 3/16/2020 3:55 PM, Sean Christopherson wrote:
> > On Mon, Mar 16, 2020 at 02:31:36PM +0100, Jethro Beekman wrote:
> > > Can someone remind me why we're not passing TCS in RBX but on the stack?
> > 
> > I finally remembered why.  It's pulled off the stack and passed into the
> > exit handler.  I'm pretty sure the vDSO could take it in %rbx and manually
> > save it on the stack, but I'd rather keep the current behavior so that the
> > vDSO is callable from C (assuming @leaf is changed to be passed via %rcx).
> > 
> The idea is that the caller of this vDSO API is C callable, hence it cannot
> receive TCS in %rbx anyway. Then it has to either MOV to %rbx or PUSH to
> stack. Either way the complexity is the same. The vDSO API however has to
> always save it on stack for exit handler. So receiving it via stack ends up
> in simplest code.

It is never C callable anyway given that not following the ABI so
who cares about being C callable anyway?

/Jarkko
