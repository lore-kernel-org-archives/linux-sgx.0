Return-Path: <SRS0=yBo6=YT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4F1CA9EB9
	for <linux-sgx@archiver.kernel.org>; Sat, 26 Oct 2019 14:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5961321655
	for <linux-sgx@archiver.kernel.org>; Sat, 26 Oct 2019 14:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572098900;
	bh=e+SAGnu9u7XmSV/xrbeQ19kpD2DZ/fyIhh0l+6+LTBc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MnrBDVept2s7ztqTnapR+qEMXMPWnT58rX71nruWU2ENfF/CWx7MKIXIm97EqSJPT
	 y8EvVU3xEn0ErPBX4LQiO9ooFYLac9gVIcnuyCpaP5jKHWU7LPQ2v3Oz3b5kQiJl08
	 yh99QIukTYG1u5LIj6BqeWPOQKKNhiZaCKEPVy4E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZOIU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 26 Oct 2019 10:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZOIT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 26 Oct 2019 10:08:19 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FF72070B
        for <linux-sgx@vger.kernel.org>; Sat, 26 Oct 2019 14:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572098899;
        bh=e+SAGnu9u7XmSV/xrbeQ19kpD2DZ/fyIhh0l+6+LTBc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fsIUiEOPDIGV+Zc3Yg8hyflqvU7IFoke90tnW8obDVAOgDUmLD/0vXDU9cYx2DM6w
         IAjKFuwi3BB1wlFgkFDYWeiONkIdHowuNDOVeqkQHVQ1faBfUZhY5xDt4u8TX5BzPo
         lzr6v/Y99FKZ2/12b5wEzHO73YPjAUdr154QQuMc=
Received: by mail-wm1-f49.google.com with SMTP id q70so5025065wme.1
        for <linux-sgx@vger.kernel.org>; Sat, 26 Oct 2019 07:08:18 -0700 (PDT)
X-Gm-Message-State: APjAAAWQe7ad/6Xsudt8tVhJnQs8/mLdJnC8XogHO1n/gFGX3ccAFmRb
        KajM2tqSfndIl5Cb4WREs1hHxCGGuzdSEybssvIYmw==
X-Google-Smtp-Source: APXvYqzfiww46wwu566bdLUh8nW8Q//R1UdS+hDmvd7Pw1dpTO2ujGNhi3NhIkOMMvi2XSD7C6lMKI7tGuzq3C93jlM=
X-Received: by 2002:a1c:20d8:: with SMTP id g207mr7983705wmg.79.1572098897258;
 Sat, 26 Oct 2019 07:08:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
 <20191018101252.GD4835@linux.intel.com> <20191018102059.GA6314@linux.intel.com>
 <20191022224158.GB27239@linux.intel.com> <20191023123933.GE23733@linux.intel.com>
In-Reply-To: <20191023123933.GE23733@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 26 Oct 2019 07:08:06 -0700
X-Gmail-Original-Message-ID: <CALCETrV-rMMicN=647_3NYpMVwpFtMoBWsA37bJwpnyMk9W6eQ@mail.gmail.com>
Message-ID: <CALCETrV-rMMicN=647_3NYpMVwpFtMoBWsA37bJwpnyMk9W6eQ@mail.gmail.com>
Subject: Re: [PATCH for_v2? v2 00/14] selftests/x86/sgx: Improve tests
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 23, 2019 at 5:39 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Oct 22, 2019 at 03:41:58PM -0700, Sean Christopherson wrote:
> > On Fri, Oct 18, 2019 at 01:20:59PM +0300, Jarkko Sakkinen wrote:
> > > On Fri, Oct 18, 2019 at 01:12:52PM +0300, Jarkko Sakkinen wrote:
> > > > On Wed, Oct 16, 2019 at 08:03:26PM -0700, Sean Christopherson wrote:
> > > > > The bulk of this series is comprised of the selftest portion of the vDSO
> > > > > cleanup[*].  The big difference from the full vDSO series is to reuse as
> > > > > much of the existing selftest code as possible.  There is still a bit of
> > > > > homebrew code in defining the low level assertion macro, but much less so
> > > > > than in the previous from-scratch version.
> > > > >
> > > > > Cc'd Andy, who also happens to be a reviewer for the harness code, on the
> > > > > off chance he has bandwidth to weigh in.
> > > > >
> > > > > Tagged for_v2? to make it clear that this doesn't need to be rushed into
> > > > > v23.
> > > >
> > > > No need for harness right now. Open coded tests are better for initial
> > > > upstreaming.
> > >
> > > Macros make code more productive to write but harder to read and
> > > debug. With only maybe three tests the cost of using them does
> > > not pay.
> >
> > Harder to read is debatable, personally I find this
> >
> > static void test_sgx_basic(struct sgx_secs *secs)
> > {
> >       uint64_t result = 0;
> >
> >       sgx_call_eenter((void *)&MAGIC, &result, (void *)secs->base);
> >       EXPECT_EQ(result, MAGIC);
> > }
> >
> > to be more intuitive than
> >
> > static void test_sgx_basic(struct sgx_secs *secs)
> > {
> >       uint64_t result = 0;
> >
> >       printf("Input: 0x%lx\n", MAGIC);
> >
> >       sgx_call_eenter((void *)&MAGIC, &result, (void *)secs->base);
> >       if (result != MAGIC) {
> >               fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
> >               exit(1);
> >       }
> >
> >       printf("Output: 0x%lx\n", result);
> > }
> >
> > but to each his own.
> >
> > The debug argument I just don't buy.  How is this
> >
> >   $ ./test_sgx
> >   TAP version 13
> >   1..4
> >   not ok 1 Expected 'result (0) == MAGIC (1234605616436508552)' at main.c:325
> >   ok 2 test_sgx_vdso: Passed
> >   ok 3 test_sgx_vdso_exit_handler: Passed
> >   ok 4 test_sgx_vdso_exception_handler: Passed
> >   # Pass 3 Fail 1 Xfail 0 Xpass 0 Skip 0 Error 0
> >
> >
> > harder to debug than this?
> >
> >   $ ./test_sgx
> >   Input: 0x1122334455667788
> >   0x0 != 0x1122334455667788
> >
> > Except for the error status in the shell there's not even an explicit
> > indicator that something went wrong, let alone any information about
> > what test was being run, what exact check failed, etc...
>
> Lets consider this post upstreaming. For me it comes in the end
> not to add new twists to the patch set unless there is life and
> death reason to do so.
>

I tend to agree.

For what it's worth, the main reason that I don't use any test harness
in most of the x86 selftests is that I wrote them so early in the
history of kselftests that there wasn't any infrastructure.  I haven't
looked to see what the best practice is now.
