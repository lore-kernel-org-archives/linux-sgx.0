Return-Path: <SRS0=Z3oH=OF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251DDC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 14:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB5720817
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 14:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECB5720817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbeK0B3x (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Nov 2018 20:29:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:38238 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbeK0B3x (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Nov 2018 20:29:53 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2018 06:35:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,282,1539673200"; 
   d="scan'208";a="111623519"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga001.fm.intel.com with ESMTP; 26 Nov 2018 06:35:34 -0800
Date:   Mon, 26 Nov 2018 06:35:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181126143534.GA25719@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
 <20181120101133.GA7319@linux.intel.com>
 <CALCETrU2dy7Oh+AHDGZ2omq9p7pNbjFd8ruv5CkfJXCp5nTYBQ@mail.gmail.com>
 <20181120225518.GE8391@linux.intel.com>
 <0a78772e-4f42-254b-d91a-f0f80a24ff90@fortanix.com>
 <20181121151734.GA16564@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121151734.GA16564@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 21, 2018 at 05:17:34PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 21, 2018 at 05:17:32AM +0000, Jethro Beekman wrote:
> > Jarkko, can you please explain you solution in detail? The CPU receives an
> > exception. This will be handled by the kernel exception handler. What
> > information does the kernel exception handler use to determine whether to
> > deliver the exception as a regular signal to the process, or whether to set
> > the special registers values for userspace and just continue executing the
> > process manually?
> 
> Now we throw SIGSEGV when PF_SGX set, right? In my solution that would
> be turned just doing iret to AEP with the extra that three registers get
> exception data (type, reason, addr). No decoding or RIP adjusting
> involved.
> 
> That would mean that you would actually have to implement AEP handler
> than just have enclu there.
> 
> I've also proposed that perhaps for SGX also #UD should be propagated
> this way because for some instructions you need outside help to emulate
> "non-enclave" environment.

And how would you determine the #UD is related to SGX?  Hardware doesn't
provide any indication that a #UD (or any other fault) is related to SGX
or occurred in an enclave.  The only fault that is special-cased in a
non-virtualized environment is #PF signaled by the EPCM, which gets the
PF_SGX bit set in the error code.

> That is all I have drafted together so far. I'll try to finish v18 this
> week with other stuff and refine further next week (unless someone gives
> obvious reason why this doesn't work, which might well be because I
> haven't went too deep with my analysis yet because of lack of time).
> 
> /Jarkko
