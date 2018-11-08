Return-Path: <SRS0=tPzl=NT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CBEECDE47
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 15:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9255020825
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 15:12:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9255020825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbeKIAsG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:48:06 -0500
Received: from mga04.intel.com ([192.55.52.120]:13191 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbeKIAsG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Nov 2018 19:48:06 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2018 07:12:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="278183129"
Received: from ibanaga-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.75])
  by fmsmga005.fm.intel.com with ESMTP; 08 Nov 2018 07:11:58 -0800
Date:   Thu, 8 Nov 2018 17:11:56 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Rich Felker <dalias@libc.org>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Carlos O'Donell <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181108151156.GC14072@linux.intel.com>
References: <1541518670.7839.31.camel@intel.com>
 <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com>
 <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
 <20181106231730.GR5150@brightrain.aerifal.cx>
 <20181106232616.GA11101@linux.intel.com>
 <20181107212758.GU5150@brightrain.aerifal.cx>
 <20181107214058.GG27170@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107214058.GG27170@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181108151156.Yg8E60UcoRbO7QjnxpCq6NqeTZ415Ong7UU60yApcXU@z>

On Wed, Nov 07, 2018 at 01:40:59PM -0800, Sean Christopherson wrote:
> > In that case it seems like the only way to use SGX that's not a gaping
> > security hole is to run the SGX enclave in its own fully-seccomp (or
> > equivalent) process, with no host application in the same address
> > space. Since the host application can't see the contents of the
> > enclave to make any determination of whether it's safe to run, running
> > it in the same address space only makes sense if the cpu provides
> > protection against unwanted accesses to the host's memory from the
> > enclave -- and according to you, it doesn't.
> 
> The enclave's code (and any initial data) isn't encrypted until the
> pages are loaded into the Enclave Page Cache (EPC), which can only
> be done by the kernel (via ENCLS[EADD]).  In other words, both the
> kernel and userspace can vet the code/data before running an enclave.
> 
> Practically speaking, an enclave will be coupled with an untrusted
> userspace runtime, i.e. it's loader.  Enclaves are also measured
> as part of their build process, and so the enclave loader needs to
> know which pages to add to the measurement, and in what order.  I
> guess technically speaking an enclave could have zero pages added
> to its measurement, but that'd probably be a big red flag that said
> enclave is up to something fishy.

IMHO the whole idea adds too much policy into kernel even if it would
be doable. You can easily spawn untrusted run-time and enclave to its
own process.

Seccomp limits the syscall space and enclaves cannot do syscalls in the
first place. It is the URT that will do them behalf of the enclave.

/Jarkko
