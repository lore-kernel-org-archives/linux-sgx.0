Return-Path: <SRS0=NXiG=NL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B3BC0044C
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Oct 2018 21:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440CF2054F
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Oct 2018 21:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 440CF2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbeKAGa2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 02:30:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:41562 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbeKAGa1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Nov 2018 02:30:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2018 14:30:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,449,1534834800"; 
   d="scan'208";a="277316362"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.193])
  by fmsmga006.fm.intel.com with ESMTP; 31 Oct 2018 14:30:36 -0700
Date:   Wed, 31 Oct 2018 14:30:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs
 w/ PF_SGX
Message-ID: <20181031213036.GA23089@linux.intel.com>
References: <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
 <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com>
 <20180927135603.GF8242@linux.intel.com>
 <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com>
 <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181031213036.d2qJLCJpWiZZ0jJZznoup056qeIL6ky5Ghfx5M2jrW8@z>

On Mon, Oct 01, 2018 at 03:03:30PM -0700, Dave Hansen wrote:
> On 10/01/2018 02:42 PM, Jethro Beekman wrote:
> > 
> > 1) Even though the vDSO function exists, userspace may still call 
> > `ENCLU[EENTER]` manually, so the fault handling as described in the 
> > current patch should also be maintained.
> 
> Why?

Circling back to this question, what if we take the easy way out and
simply signal SIGSEGV without an SGX-specific code?  I.e. treat #PF
with X86_PF_SGX as an access error, no more no less.  That should be
sufficient for userspace to function, albeit with a little more effort,
but presumably no more than would be needed to run on SGX1 hardware.

AFAIK there isn't a way to prevent userspace from manually invoking
EENTER, short of doing some really nasty text poking or PTE swizzling.
We could declare using EENTER as unsupported, but that seems like
cutting off the nose to spite the face.  Supporting userspace EENTER
in a limited capacity would allow people to do whatever crazy tricks
they're wont to do without having to deal with absurd requests for
the vDSO interface.

If we go this route we could also add the vDSO stuff after basic SGX
support is in mainline, obviously with approval from the powers that
be.
