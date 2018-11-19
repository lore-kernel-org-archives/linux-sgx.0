Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5EDC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 17:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A563121104
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 17:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wEVyny+f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A563121104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405347AbeKTDYj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 22:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405344AbeKTDYj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Nov 2018 22:24:39 -0500
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B532022502
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542646823;
        bh=4QGrRb/NX/u9ezQIPG+tiTfLwtuWQfaNCdAWB5BxLug=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wEVyny+f5k/dOwYn8NaIcPRLv6mfKxyDkENQ+RIozuxMzekBPus0FAWcYhmFcUR2s
         U7pY+sBnhHpwvIOiH5RXeqKiAY5BxeYig65eVaJ3kT1ERLNIf6kIiBMNUq4jmP4nK5
         JrdKCIb/pEfKNVmSHeZ4yJu3uSHl4Qeyy6i7ZBXI=
Received: by mail-wm1-f52.google.com with SMTP id t15-v6so6009403wmt.0
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 09:00:22 -0800 (PST)
X-Gm-Message-State: AGRZ1gJNEpdW0qpZ/uQqBoipn+KvqX+G2dhUe7BWJhVZG6VPzhalY3LQ
        DYK0UOv4VCZdo0xokGB+kbzUVYW8EpFSshtxjdkPpA==
X-Google-Smtp-Source: AFSGD/UNnjQIq+s7BTeD/ou1YCY6BdFaRW7hiM9MGLXVsBzfxeC3bRcw3kF1lCJnjYWn9qukh5EbG6ECPPnxb9dnuXU=
X-Received: by 2002:a1c:f112:: with SMTP id p18mr7384002wmh.83.1542646821041;
 Mon, 19 Nov 2018 09:00:21 -0800 (PST)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <20181118071548.GA4795@linux.intel.com> <CALCETrXSpn7QGzPgO1BjMRQ75r2i0kmACrbUM+8PyT+xi3f3Hw@mail.gmail.com>
 <20181119160204.GD13298@linux.intel.com>
In-Reply-To: <20181119160204.GD13298@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 19 Nov 2018 09:00:08 -0800
X-Gmail-Original-Message-ID: <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
Message-ID: <CALCETrWRVgPjnDd-CknskrXfNbke=rSnr_jezszNNWJUM_YJKQ@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 19, 2018 at 8:02 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Nov 19, 2018 at 07:29:36AM -0800, Andy Lutomirski wrote:
> > 1. The kernel needs some way to know *when* to apply this fixup.
> > Decoding the instruction stream and doing it to all exceptions that
> > hit an ENCLU instruction seems like a poor design.
>
> I'm not sure why you would ever need to do any type of fixup as the idea
> is to just return to AEP i.e. from chosen exceptions (EPCM, #UD) the AEP
> would work the same way as for exceptions that the kernel can deal with
> except filling the exception information to registers.

Sure, but how does the kernel know when to do that and when to send a
signal?  I don't really like decoding the instruction stream to figure
it out.
