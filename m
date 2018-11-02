Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE5CC32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 22:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833352081F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 22:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 833352081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbeKCHrK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 03:47:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:61363 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbeKCHrK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Nov 2018 03:47:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2018 15:38:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,457,1534834800"; 
   d="scan'208";a="103006930"
Received: from btyborox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.138])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2018 15:37:59 -0700
Date:   Sat, 3 Nov 2018 00:37:57 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Message-ID: <20181102223757.GB24373@linux.intel.com>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102223757.Xb91yzkFmP21DnZ59h_kfP-b1oHWB7UiyJX3kVLYgwk@z>

On Thu, Nov 01, 2018 at 04:22:55PM -0700, Andy Lutomirski wrote:
> On Thu, Nov 1, 2018 at 2:24 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Thu, Nov 1, 2018 at 12:31 PM Rich Felker <dalias@libc.org> wrote:
> > >
> > > See my other emails in this thread. You would register the *address*
> > > (in TLS) of a function pointer object pointing to the handler, rather
> > > than the function address of the handler. Then switching handler is
> > > just a single store in userspace, no syscalls involved.
> >
> > Yes.
> >
> > And for just EENTER, maybe that's the right model.
> >
> > If we want to generalize it to other thread-synchronous faults, it
> > needs way more information and a list of handlers, but if we limit the
> > thing to _only_ EENTER getting an SGX fault, then a single "this is
> > the fault handler" address is probably the right thing to do.
> 
> It sounds like you're saying that the kernel should know, *before*
> running any user fixup code, whether the fault in question is one that
> wants a fixup.  Sounds reasonable.
> 
> I think it would be nice, but not absolutely necessary, if user code
> didn't need to poke some value into TLS each time it ran a function
> that had a fixup.  With the poke-into-TLS approach, it looks a lot
> like rseq, and rseq doesn't nest very nicely.  I think we really want
> this mechanism to Just Work.  So we could maybe have a syscall that
> associates a list of fixups with a given range of text addresses.  We
> might want the kernel to automatically zap the fixups when the text in
> question is unmapped.

If we would have a syscall to specify a list fixups that would do the
job. Now essentially the only reason we require a vDSO is to implement
a single fixup for EENTER.

If this fixup stuff makes sense for other parts of the kernel,
introducing a vDSO for EENTER means essentially adding ABI to the kernel
that might possibly become legacy fast.

/Jarkko
