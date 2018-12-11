Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D158C6783B
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 22:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E14C20672
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 22:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E14C20672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbeLKWAN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 17:00:13 -0500
Received: from mga18.intel.com ([134.134.136.126]:34371 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbeLKWAM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 17:00:12 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2018 14:00:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,343,1539673200"; 
   d="scan'208";a="106688496"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga007.fm.intel.com with ESMTP; 11 Dec 2018 14:00:10 -0800
Date:   Tue, 11 Dec 2018 14:00:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181211220010.GH14731@linux.intel.com>
References: <20181207165145.GB10404@linux.intel.com>
 <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
 <20181207190257.GC10404@linux.intel.com>
 <EFA99261-BE93-49DA-9A8F-E6FD28069AFC@amacapital.net>
 <20181207200935.GE10404@linux.intel.com>
 <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
 <20181207212649.GG10404@linux.intel.com>
 <CALCETrVBR+2HjTqX=W4r9GOq69Xg36v4gmCKqK0wUjzAqBJnrw@mail.gmail.com>
 <20181211193144.GG14731@linux.intel.com>
 <CALCETrXbCFRQ_8Uu8Yh9EDeWJMEzZ+Dr386XrAprz1E6g+3X+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXbCFRQ_8Uu8Yh9EDeWJMEzZ+Dr386XrAprz1E6g+3X+Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 11, 2018 at 12:04:15PM -0800, Andy Lutomirski wrote:
> On Tue, Dec 11, 2018 at 11:31 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Dec 07, 2018 at 03:33:57PM -0800, Andy Lutomirski wrote:
> > > On Fri, Dec 7, 2018 at 1:26 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > Running a checksum on the stack for every exit doesn't seem like it'd
> > > > be worth the effort, especially since this type of bug should be quite
> > > > rare, at least in production environments.
> > > >
> > > > If we want to pursue the checksum idea I think the easiest approach
> > > > would be to combine it with an exit_handler and do a simple check on
> > > > the handler.  It'd be minimal overhead in the fast path and would flag
> > > > cases where invoking exit_handle() would explode, while deferring all
> > > > other checks to the user.
> > >
> > > How about this variant?
> > >
> > > #define MAGIC 0xaaaabbbbccccddddul
> > > #define RETADDR_HASH ((unsigned long)__builtin_return_address(0) ^ MAGIC)
> > >
> > > void foo(void)
> > > {
> > >     volatile unsigned long hash = RETADDR_HASH;
> > >
> > >     /* placeholder for your actual code */
> > >     asm volatile ("nop");
> > >
> > >     if (hash != RETADDR_HASH)
> > >         asm volatile ("ud2");
> > > }
> > >
> > > But I have a real argument for dropping exit_handler: in this new age
> > > of Spectre, the indirect call is a retpoline, and it's therefore quite
> > > slow.
> >
> > Technically slower, but would the extra CALL+RET pair even be noticeable
> > in the grand scheme of SGX?
> 
> But it's CALL, CALL, MOV to overwrite return address, intentionally
> midpredicted RET, and RET because Spectre.  That whole sequence seems
> to be several tens of cycles, so it's a lot worse than just CALL+RET.
> Whether it's noticeable overall is a fair question, though.

I was thinking of the case where the handler re-entered the enclave vs.
leaving and re-calling the vDSO, which would be RET+CALL and some other
stuff.
