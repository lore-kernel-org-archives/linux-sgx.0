Return-Path: <SRS0=WnBG=N7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3702C4161D
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Nov 2018 18:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83213208E3
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Nov 2018 18:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83213208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbeKUEkK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Nov 2018 23:40:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:39197 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbeKUEkK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 20 Nov 2018 23:40:10 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2018 10:09:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,257,1539673200"; 
   d="scan'208";a="101804174"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga003.jf.intel.com with ESMTP; 20 Nov 2018 10:09:44 -0800
Date:   Tue, 20 Nov 2018 10:09:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rich Felker <dalias@libc.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181120180944.GD31109@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
 <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
 <20181120101133.GA7319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120101133.GA7319@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 20, 2018 at 12:11:33PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 19, 2018 at 09:00:08AM -0800, Andy Lutomirski wrote:
> > On Mon, Nov 19, 2018 at 8:02 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Mon, Nov 19, 2018 at 07:29:36AM -0800, Andy Lutomirski wrote:
> > > > 1. The kernel needs some way to know *when* to apply this fixup.
> > > > Decoding the instruction stream and doing it to all exceptions that
> > > > hit an ENCLU instruction seems like a poor design.
> > >
> > > I'm not sure why you would ever need to do any type of fixup as the idea
> > > is to just return to AEP i.e. from chosen exceptions (EPCM, #UD) the AEP
> > > would work the same way as for exceptions that the kernel can deal with
> > > except filling the exception information to registers.
> > 
> > Sure, but how does the kernel know when to do that and when to send a
> > signal?  I don't really like decoding the instruction stream to figure
> > it out.
> 
> Hmm... why you have to decode instruction stream to find that out? Would
> just depend on exception type (#GP with EPCM, #UD).

#PF w/ PFEC_SGX is the only exception that indicates a fault is related
to SGX.  Theoretically we could avoid decoding by using a magic value
for the AEP itself and doing even more magic fixup, but that wouldn't
help for faults that occur on EENTER, which can be generic #GPs due to
loss of EPC on SGX1 systems. 

> Or are you saying
> that kernel should need to SIGSEGV if there is in fact ENCLU so that
> there is no infinite trap loop? Sorry, I'm a bit lost here that where
> does this decoding requirement comes from in the first place. I
> understand how it is used in Sean's proposal...
> 
> Anyway, this option can be probably discarded without further
> consideration because apparently single stepping can cause #DB SS fault
> if AEP handler is anything else than a single instruction.

Not that it matters, but we could satisfy the "one instruction"
requirement if the fixup changed RIP to point at an ENCLU for #DBs.

> For me it seems that by ruling out options, vDSO option is what is
> left. I don't like it but at least it works...
> 
> /Jarkko
