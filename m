Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A9BC0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 21:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D85206C0
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 21:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbgCPVaI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:30:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:6232 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbgCPVaI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 17:30:08 -0400
IronPort-SDR: +Dc5zwygM1wkp0rLJA0xqpbWtEwvAHI/d5SWbG8gpU/Xzja9MMCeXtPzYVLP/Uz3yeGewW9vxV
 NNBPjKjFbn6Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 14:30:07 -0700
IronPort-SDR: AIMDdKRJtMZydTFlW4tt9zT6zaAKwOMzVPMm2h5MaPSCZKm4+n+PU9YNAwbg2et54nQCTOpvaI
 4G2Q/NqGsB+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,561,1574150400"; 
   d="scan'208";a="244273851"
Received: from oaizenbe-mobl.ger.corp.intel.com ([10.254.149.199])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2020 14:29:52 -0700
Message-ID: <11e9de481f37a5160fe0d82dcbd7beb9d100748d.camel@linux.intel.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>
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
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Date:   Mon, 16 Mar 2020 23:29:51 +0200
In-Reply-To: <20d3cc40d559a854a7984543acdacb61a2d51b8d.camel@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
         <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
         <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
         <20200315012523.GC208715@linux.intel.com>
         <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
         <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
         <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
         <20d3cc40d559a854a7984543acdacb61a2d51b8d.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.35.92-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2020-03-16 at 23:27 +0200, Jarkko Sakkinen wrote:
> On Mon, 2020-03-16 at 09:57 -0400, Nathaniel McCallum wrote:
> > For the vDSO, only marginally. I'm counting +4,-2 instructions in my
> > suggestions. For the wrapper, things become significantly simpler.
> 
> Simpler is not a quality that has very high importance here except
> when it comes to vDSO.
> 
> At least it is not enough to change to vDSO. What else?
                                      ~~
                                      the

In any case, where I stand is that the vDSO implementation itself is
exactly how it should be. The process to get it to this form was
tedious. Now we have a form that the known userbase can live with.

The documentation sucks, agreed. I think by fixing that this would
be a wholelot better.

/Jarkko
                                         

