Return-Path: <SRS0=WnqF=OD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633CCC43441
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 17:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355522086B
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 17:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 355522086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbeKYD4z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 24 Nov 2018 22:56:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:10810 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbeKYD4z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 24 Nov 2018 22:56:55 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2018 09:08:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,273,1539673200"; 
   d="scan'208";a="88351753"
Received: from moellerb-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.169])
  by fmsmga007.fm.intel.com with ESMTP; 24 Nov 2018 09:07:33 -0800
Date:   Sat, 24 Nov 2018 09:07:26 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Message-ID: <20181124170726.GA32210@linux.intel.com>
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
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> 
> That is all I have drafted together so far. I'll try to finish v18 this
> week with other stuff and refine further next week (unless someone gives
> obvious reason why this doesn't work, which might well be because I
> haven't went too deep with my analysis yet because of lack of time).

The obvious con in this approach is that if you single step the code,
the whole AEP handler would single stepped also everytime. Probably big
enough con that it is better to go with the vDSO approach anyhow...

/Jarkko
