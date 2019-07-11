Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB40C74A52
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 09:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF3E208E4
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 09:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfGKJgZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:36:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:62994 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfGKJgZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 05:36:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 02:36:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,478,1557212400"; 
   d="scan'208";a="167975960"
Received: from spoledic-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.84])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2019 02:36:20 -0700
Date:   Thu, 11 Jul 2019 12:36:21 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v2 0/3] An alternative __vdso_sgx_enter_enclave() to
 allow enclave/host parameter passing using untrusted stack
Message-ID: <20190711093621.4wstj7bc7w6wxxj2@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-1-cedric.xing@intel.com>
 <20190710111719.nnoedfo4wvbfghq7@linux.intel.com>
 <686e47d2-f45c-6828-39d1-48374925de6c@intel.com>
 <20190710224628.epjxwlpqqxdurmzo@linux.intel.com>
 <a2d2ba5c-c7b3-a76b-594f-df2e14234b1d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d2ba5c-c7b3-a76b-594f-df2e14234b1d@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 10, 2019 at 03:54:20PM -0700, Xing, Cedric wrote:
> On 7/10/2019 3:46 PM, Jarkko Sakkinen wrote:
> > On Wed, Jul 10, 2019 at 11:08:37AM -0700, Xing, Cedric wrote:
> > > > With these conclusions I think the current vDSO API is sufficient for
> > > > Linux.
> > > 
> > > The new vDSO API is to support data exchange on stack. It has nothing to do
> > > with debugging. BTW, the community has closed on this.
> > 
> > And how that is useful?
> 
> There is a lengthy discussion on its usefulness so I don't want to repeat.
> In short, it allows using untrusted stack as a convenient method to exchange
> data with the enclave. It is currently being used by Intel's SGX SDK for
> e/o-calls parameters.
> 
> > > The CFI directives are for stack unwinding. They don't affect what the code
> > > does so you can just treat them as NOPs if you don't understand what they
> > > do. However, they are useful to not only debuggers but also exception
> > > handling code. libunwind also has a setjmp()/longjmp() implementation based
> > > on CFI directives.
> > 
> > Of course I won't merge code of which usefulness I don't understand.
> 
> Sure.
> 
> Any other questions I can help with?

I dissected my concerns in other email. We can merge this feature after
v21 if it makes sense.

/Jarkko
