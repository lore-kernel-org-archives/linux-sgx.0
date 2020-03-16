Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B118C18E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 21:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 577DD20674
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 21:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbgCPV1S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:27:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:38459 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbgCPV1R (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 17:27:17 -0400
IronPort-SDR: GCbRW5ZSbr0fXvbRDwgpKBzzAeQVsRCVI7L2S7XVWAKh7EF9/0nZKX8Y4LlfcFZqbwpMlD7iXp
 8d4N6XpQVbWg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 14:27:16 -0700
IronPort-SDR: V0gDeoSzXtjSM50a4ADhfacu4J63WckUNwtDfMRUIb4gEYcjG3buyIm5sIBguTnGxaOsguBs/3
 y8or1DOgmwFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,561,1574150400"; 
   d="scan'208";a="445269217"
Received: from oaizenbe-mobl.ger.corp.intel.com ([10.254.149.199])
  by fmsmga006.fm.intel.com with ESMTP; 16 Mar 2020 14:27:04 -0700
Message-ID: <20d3cc40d559a854a7984543acdacb61a2d51b8d.camel@linux.intel.com>
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
Date:   Mon, 16 Mar 2020 23:27:03 +0200
In-Reply-To: <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
         <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
         <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
         <20200315012523.GC208715@linux.intel.com>
         <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
         <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
         <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.35.92-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2020-03-16 at 09:57 -0400, Nathaniel McCallum wrote:
> For the vDSO, only marginally. I'm counting +4,-2 instructions in my
> suggestions. For the wrapper, things become significantly simpler.

Simpler is not a quality that has very high importance here except
when it comes to vDSO.

At least it is not enough to change to vDSO. What else?

Anyway, I think the documentation should fixed and streamlined 1st.

It is way too verbose prose in some places and in some it completely
lacks the information e.g.

"Debug Exceptions (#DB) and Breakpoints (#BP) are ever fixed up and are
always delivered via standard signals."

Never should state things like that without explaining the reasons.

On the other hand:

"Most exceptions reported on ENCLU, including those that occur within
the enclave, are fixed up and reported synchronously instead of being
delivered via a standard signal. Debug Exceptions (#DB) and Breakpoints
(#BP) are never fixed up and are always delivered via standard signals.
On synchrously reported exceptions, -EFAULT is returned and details
about the exception are recorded in @e, the optional
sgx_enclave_exception struct."

Duplicates information already elsewhere (e.g. return values) and is
just pain to read and comprehend in general.

/Jarkko

