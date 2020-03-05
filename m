Return-Path: <SRS0=iPl9=4W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD91C3F2D1
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 11:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB07F2073D
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 11:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCELdd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:33:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:23507 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgCELdc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Mar 2020 06:33:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 03:33:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234387456"
Received: from unknown (HELO jsakkine-mobl1) ([10.237.50.161])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 03:33:27 -0800
Message-ID: <04362c0cf66bf66e8f7c25a531830b9f294d2d09.camel@linux.intel.com>
Subject: Re: [PATCH v28 14/22] selftests/x86: Add a selftest for SGX
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
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        linux-kselftest@vger.kernel.org
Date:   Thu, 05 Mar 2020 13:33:28 +0200
In-Reply-To: <CAOASepN1JrD6OEzZycbqOr6_ZVACK=EctEOoQ8oSAEeigMr1Eg@mail.gmail.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
         <20200303233609.713348-15-jarkko.sakkinen@linux.intel.com>
         <CAOASepN1JrD6OEzZycbqOr6_ZVACK=EctEOoQ8oSAEeigMr1Eg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.35.92-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2020-03-04 at 14:27 -0500, Nathaniel McCallum wrote:
> > > +xsave_area:
> > +       .fill   1, 4, 0x037F            # FCW
> > +       .fill   5, 4, 0
> > +       .fill   1, 4, 0x1F80            # MXCSR
> > +       .fill   1, 4, 0xFFFF            # MXCSR_MASK
> > +       .fill   123, 4, 0
> > +       .fill   1, 4, 0x80000000        # XCOMP_BV[63] = 1, compaction mode
> > +       .fill   12, 4, 0
> 
> I find this much more readable:

And I always aim to get things more readable. Thank you.

> xsave_area:
>         # Legacy
>         .fill   1, 4, 0x037F            # FCW
>         .fill   5, 4, 0
>         .fill   1, 4, 0x1F80            # MXCSR
>         .fill   1, 4, 0xFFFF            # MXCSR_MASK
>         .fill   60, 8, 0
> 
>         # Header
>         .fill   1, 8, 0                 # XSTATE_BV
>         .fill   1, 8, 1 << 63           # XCOMP_BV (compaction mode)
>         .fill   6, 8, 0
> 
> Also, since people are likely to copy this code for their own
> enclaves, it would be helpful to document which flags are set in FCW
> and MXCSR.

It was meant as a test program but I'd guess what you say is true
because it also might be the only alternative user space to Intel's
:-) And a great starting point if you want to do things from scratch.

Because I meant it as a smoke test program for SGX, not everything is
too well documented but given the multipurpose use for that code I'll
make the improvements that you are suggesting.

/Jarkko

