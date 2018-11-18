Return-Path: <SRS0=OFrI=N5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF1FC43441
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 13:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 782DB20869
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 13:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 782DB20869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbeKRXWa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Nov 2018 18:22:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:47204 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbeKRXWa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Nov 2018 18:22:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2018 05:02:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,248,1539673200"; 
   d="scan'208";a="107260292"
Received: from tmuluk-mobl4.ger.corp.intel.com (HELO localhost) ([10.249.254.142])
  by fmsmga004.fm.intel.com with ESMTP; 18 Nov 2018 05:02:05 -0800
Date:   Sun, 18 Nov 2018 15:02:03 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Message-ID: <20181118130203.GA18934@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181118071548.GA4795@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 18, 2018 at 09:15:48AM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 01, 2018 at 10:53:40AM -0700, Andy Lutomirski wrote:
> > Hi all-
> > 
> > The people working on SGX enablement are grappling with a somewhat
> > annoying issue: the x86 EENTER instruction is used from user code and
> > can, as part of its normal-ish operation, raise an exception.  It is
> > also highly likely to be used from a library, and signal handling in
> > libraries is unpleasant at best.
> > 
> > There's been some discussion of adding a vDSO entry point to wrap
> > EENTER and do something sensible with the exceptions, but I'm
> > wondering if a more general mechanism would be helpful.
> 
> I haven't really followed all of this discussion because I've been busy
> working on the patch set but for me all of these approaches look awfully
> complicated.
> 
> I'll throw my own suggestion and apologize if this has been already
> suggested and discarded: return-to-AEP.
> 
> My idea is to do just a small extension to SGX AEX handling. At the
> moment hardware will RAX, RBX and RCX with ERESUME parameters. We can
> fill extend this by filling other three spare registers with exception
> information.
> 
> AEP handler can then do whatever it wants to do with this information
> or just do ERESUME.

A correction here. In practice this will add a requirement to have a bit
more complicated AEP code (check the regs for exceptions) than before
and not just bytes for ENCLU.

e.g. AEP handler should be along the lines

1. #PF (or #UD or) happens. Kernel fills the registers when it cannot
   handle the exception and returns back to user space i.e. to the
   AEP handler.
2. Check the registers containing exception information. If they have
   been filled, take whatever actions user space wants to take.
3. Otherwise, just ERESUME.

From my point of view this is making the AEP parameter useful. Its
standard use is just weird (always point to a place just containing
ENCLU bytes, why the heck it even exists).

/Jarkko
