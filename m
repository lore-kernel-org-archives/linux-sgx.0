Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4539CC67839
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 20:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CCDB214AC
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544558673;
	bh=iceCIJ+MOdnemZmdzZgpg+G/tOQaPMTxkFD74NoBchM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ewx0QcZp1PMtX0V8hSVg9vYksoVr1CfbAIa34d0PclC8wGX7ToTMrht7ZO88es+12
	 minpazRPKBqTDt5T/fiUDZjECrlllqeYd0vwNM5u9QR7loR3fkM7f0ynA+hd96GP4s
	 rsY1PghSwYcVvvNr7pv7rNAHxKzkbT2AmLZ0yCn4=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CCDB214AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbeLKUEc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 15:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbeLKUEb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 15:04:31 -0500
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FB221486
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544558670;
        bh=iceCIJ+MOdnemZmdzZgpg+G/tOQaPMTxkFD74NoBchM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lVJVN7Yn138t2ZkHGtkzYmRtwHAPjhugGq8/SDYGjJP+Hcyvr3WyxGQZtAFI6Pise
         9dcfj+lUj96mfD6p4LlorR4LVhDbuq9xmTp8xxanOOx78SB7Kf4c539eRrh0F0OZg8
         6qQidZ/pBs1Noo3Sbqf3zEU6868nY7PKkkCQL0cU=
Received: by mail-wm1-f52.google.com with SMTP id f81so3576899wmd.4
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 12:04:30 -0800 (PST)
X-Gm-Message-State: AA+aEWbXGzGaqMPqYSmAgeHNhx+69yxplU+6CT/fHGZPgZhiGXCcNThg
        5sWv2bZ35BZjwrAfAQRGj/kAdJ6xc3tugkYs6eh0wQ==
X-Google-Smtp-Source: AFSGD/UQAbvOnZAq9uAz0UTPhT+24+VMhs2cZvY/GWHDpJF6CeQydOf4v7dEjxwhplk9wj6qKGqCncbepg+za7t4QwY=
X-Received: by 2002:a1c:b1d5:: with SMTP id a204mr3904123wmf.32.1544558668451;
 Tue, 11 Dec 2018 12:04:28 -0800 (PST)
MIME-Version: 1.0
References: <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
 <20181207165145.GB10404@linux.intel.com> <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
 <20181207190257.GC10404@linux.intel.com> <EFA99261-BE93-49DA-9A8F-E6FD28069AFC@amacapital.net>
 <20181207200935.GE10404@linux.intel.com> <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
 <20181207212649.GG10404@linux.intel.com> <CALCETrVBR+2HjTqX=W4r9GOq69Xg36v4gmCKqK0wUjzAqBJnrw@mail.gmail.com>
 <20181211193144.GG14731@linux.intel.com>
In-Reply-To: <20181211193144.GG14731@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Dec 2018 12:04:15 -0800
X-Gmail-Original-Message-ID: <CALCETrXbCFRQ_8Uu8Yh9EDeWJMEzZ+Dr386XrAprz1E6g+3X+Q@mail.gmail.com>
Message-ID: <CALCETrXbCFRQ_8Uu8Yh9EDeWJMEzZ+Dr386XrAprz1E6g+3X+Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 11, 2018 at 11:31 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Dec 07, 2018 at 03:33:57PM -0800, Andy Lutomirski wrote:
> > On Fri, Dec 7, 2018 at 1:26 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Running a checksum on the stack for every exit doesn't seem like it'd
> > > be worth the effort, especially since this type of bug should be quite
> > > rare, at least in production environments.
> > >
> > > If we want to pursue the checksum idea I think the easiest approach
> > > would be to combine it with an exit_handler and do a simple check on
> > > the handler.  It'd be minimal overhead in the fast path and would flag
> > > cases where invoking exit_handle() would explode, while deferring all
> > > other checks to the user.
> >
> > How about this variant?
> >
> > #define MAGIC 0xaaaabbbbccccddddul
> > #define RETADDR_HASH ((unsigned long)__builtin_return_address(0) ^ MAGIC)
> >
> > void foo(void)
> > {
> >     volatile unsigned long hash = RETADDR_HASH;
> >
> >     /* placeholder for your actual code */
> >     asm volatile ("nop");
> >
> >     if (hash != RETADDR_HASH)
> >         asm volatile ("ud2");
> > }
> >
> > But I have a real argument for dropping exit_handler: in this new age
> > of Spectre, the indirect call is a retpoline, and it's therefore quite
> > slow.
>
> Technically slower, but would the extra CALL+RET pair even be noticeable
> in the grand scheme of SGX?

But it's CALL, CALL, MOV to overwrite return address, intentionally
midpredicted RET, and RET because Spectre.  That whole sequence seems
to be several tens of cycles, so it's a lot worse than just CALL+RET.
Whether it's noticeable overall is a fair question, though.
