Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBE1C32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 22:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B18F2081F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 22:42:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B18F2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbeKCHvR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 03:51:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:50503 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbeKCHvR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Nov 2018 03:51:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2018 15:42:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,457,1534834800"; 
   d="scan'208";a="93317178"
Received: from btyborox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.138])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Nov 2018 15:42:06 -0700
Date:   Sat, 3 Nov 2018 00:42:04 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Carlos O'Donell <carlos@redhat.com>,
        "adhemerval.zanella@linaro.org" <adhemerval.zanella@linaro.org>
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181102224204.GC24373@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com>
 <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
 <20181102165204.GC7393@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181102165204.GC7393@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102224204.CBBXtGmcgMWdus9DGdVtH3_jJfBVArgsDTrrcNakVtI@z>

On Fri, Nov 02, 2018 at 09:52:04AM -0700, Sean Christopherson wrote:
> On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
> > On 2018-11-02 09:30, Sean Christopherson wrote:
> > >... The intended convention for EENTER is to have an ENCLU at the AEX target ...
> > >
> > >... to further enforce that the AEX target needs to be ENCLU.
> > 
> > Some SGX runtimes may want to use a different AEX target.
> 
> To what end?  Userspace gets no indication as to why the AEX occurred.
> And if exceptions are getting transfered to userspace the trampoline
> would effectively be handling only INTR, NMI, #MC and EPC #PF.

I've understood that in some cases run-time implementation requires to
run a handler implemented inside the enclave i.e the sequence would be

1. #AEX
2. EENTER(in-enclave handler)
3. EEXIT(%rcx)
4. ERESUME

/Jarkko
