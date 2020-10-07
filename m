Return-Path: <SRS0=a0UF=DO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFBDC4727E
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 08:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385AE2076C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Oct 2020 08:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgJGIE2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Oct 2020 04:04:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:62660 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGIE1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Oct 2020 04:04:27 -0400
IronPort-SDR: rRiuTHbTn7yIrLk46eSktQGNLzd2xX9beTdGQNda6DND3f4RnmsaeaxDre5fDbLBijqh6GWtkF
 3F5ewrPA8adg==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="226446204"
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400"; 
   d="scan'208";a="226446204"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 01:04:26 -0700
IronPort-SDR: qAZrGJWZW5CwC7nZO1xy6Lb7ans0/3wAfGuHuHMDS/PXpHbM55bjBoIK+xkQi2E/UgFwJWMOMS
 7fDO2489KDmQ==
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400"; 
   d="scan'208";a="527837821"
Received: from juliahar-mobl.ger.corp.intel.com (HELO localhost) ([10.249.32.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 01:04:13 -0700
Date:   Wed, 7 Oct 2020 11:04:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20201007080408.GA4610@linux.intel.com>
References: <20201006025703.GG15803@linux.intel.com>
 <453c2d9b-0fd0-0d63-2bb9-096f255a6ff4@fortanix.com>
 <20201006151532.GA17610@linux.intel.com>
 <20201006172819.GA114208@linux.intel.com>
 <20201006232129.GB28981@linux.intel.com>
 <20201007002236.GA139112@linux.intel.com>
 <20201007011738.GE28981@linux.intel.com>
 <20201007031402.GA143690@linux.intel.com>
 <20201007043418.GG28981@linux.intel.com>
 <20201007073923.GA3632@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007073923.GA3632@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 07, 2020 at 10:39:23AM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 06, 2020 at 09:34:19PM -0700, Sean Christopherson wrote:
> > Even more hypothetical would be if Andy gets one of his wishes, and EENTER2
> > comes along that doesn't allow the enclave to dictate the exit point,
> > "returns" an error code on enclave failure, and allows the kernel to
> > auto-restart the enclave on IRQs/NMIs.  That (very hypothetical) scenario
> > fits nicely into the exit_reason handling.
> > 
> > I'm not arguing that any of the above is even remotely likely.  I just don't
> > understand why we'd want an API that at best requires heuristics in userspace
> > to determine why the enclave stopped running, and at worst will saddle us with
> > an ugly mess in the future.  All to save 4 bytes that no one cares about (they
> > literally cost nothing), and a single MOV in a flow that is hundreds, if not
> > thousands, of cycles.
> 
> I don't care as much as saving bytes as defining API, which has zero
> ambiguous state variables.
> 
> And since the field 'leaf' is there, and was before too, no degrees of
> freedom are lost. Removing one variable does not make more of a mess.

I think the reserved space should be expanded though.

I'd go with that 256 bytes as it was before. It's still fast to validate
and the loop construct for that is already in place. I complement that
with addition to the changelog with the reasoning that I gave earlier.
That was lacking for that detail in earlier patch set versions.

/Jarkko
