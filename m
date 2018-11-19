Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73397C43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 14:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472DB20851
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 14:59:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 472DB20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbeKTBXP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:23:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:25564 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbeKTBXO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 20:23:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2018 06:59:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,252,1539673200"; 
   d="scan'208";a="107519547"
Received: from tmuluk-mobl4.ger.corp.intel.com (HELO localhost) ([10.249.254.135])
  by fmsmga004.fm.intel.com with ESMTP; 19 Nov 2018 06:59:17 -0800
Date:   Mon, 19 Nov 2018 16:59:16 +0200
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
Message-ID: <20181119145916.GA11723@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
 <20181118130203.GA18934@linux.intel.com>
 <ce304dba-0b02-02e2-4de8-212cd3bd1876@fortanix.com>
 <20181119140543.GF8755@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119140543.GF8755@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 19, 2018 at 04:05:43PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 19, 2018 at 05:17:26AM +0000, Jethro Beekman wrote:
> > On 2018-11-18 18:32, Jarkko Sakkinen wrote:
> > > On Sun, Nov 18, 2018 at 09:15:48AM +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> > > > > Hi all-
> > > > > 
> > > > > The people working on SGX enablement are grappling with a somewhat
> > > > > annoying issue: the x86 EENTER instruction is used from user code and
> > > > > can, as part of its normal-ish operation, raise an exception.  It is
> > > > > also highly likely to be used from a library, and signal handling in
> > > > > libraries is unpleasant at best.
> > > > > 
> > > > > There's been some discussion of adding a vDSO entry point to wrap
> > > > > EENTER and do something sensible with the exceptions, but I'm
> > > > > wondering if a more general mechanism would be helpful.
> > > > 
> > > > I haven't really followed all of this discussion because I've been busy
> > > > working on the patch set but for me all of these approaches look awfully
> > > > complicated.
> > > > 
> > > > I'll throw my own suggestion and apologize if this has been already
> > > > suggested and discarded: return-to-AEP.
> > > > 
> > > > My idea is to do just a small extension to SGX AEX handling. At the
> > > > moment hardware will RAX, RBX and RCX with ERESUME parameters. We can
> > > > fill extend this by filling other three spare registers with exception
> > > > information.
> > > > 
> > > > AEP handler can then do whatever it wants to do with this information
> > > > or just do ERESUME.
> > > 
> > > A correction here. In practice this will add a requirement to have a bit
> > > more complicated AEP code (check the regs for exceptions) than before
> > > and not just bytes for ENCLU.
> > > 
> > > e.g. AEP handler should be along the lines
> > > 
> > > 1. #PF (or #UD or) happens. Kernel fills the registers when it cannot
> > >     handle the exception and returns back to user space i.e. to the
> > >     AEP handler.
> > > 2. Check the registers containing exception information. If they have
> > >     been filled, take whatever actions user space wants to take.
> > > 3. Otherwise, just ERESUME.
> > > 
> > >  From my point of view this is making the AEP parameter useful. Its
> > > standard use is just weird (always point to a place just containing
> > > ENCLU bytes, why the heck it even exists).
> > 
> > I like this solution. Keeps things simple. One question: when an exception
> > occurs, how does the kernel know whether to set special registers or send a
> > signal?
> 
> Yes, and AFAIK people do in many cases people want to do something else
> than just direct ERESUME in AEP handler so would neither be a major
> bummer for user space. If I remember correctly you have such?
> 
> You can check the cases that we have for SIGSEGV (namely EPCM conflict)
> from Sean's patch 08/23.
> 
> I'm open for expanding the scope. It is the easy part after there is
> consensus for the handling mechanism :-)

Not sure if it a good idea or not but maybe even have new ioctl in
addition to the enclave construction ioctls that you use to specify per
enclave what you want to get. SIGSEGV could be the fallback behavior if
you do not "register" to any exceptions.

/Jarkko
