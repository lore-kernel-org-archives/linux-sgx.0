Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C19C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1282064C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B1282064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=libc.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbeKBEht (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:37:49 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:57954 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbeKBEht (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Nov 2018 00:37:49 -0400
Received: from dalias by brightrain.aerifal.cx with local (Exim 3.15 #2)
        id 1gIIgN-00035m-00; Thu, 01 Nov 2018 19:31:07 +0000
Date:   Thu, 1 Nov 2018 15:31:07 -0400
From:   Rich Felker <dalias@libc.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jann Horn <jannh@google.com>, luto@kernel.org,
        dave.hansen@linux.intel.com, sean.j.christopherson@intel.com,
        jethro@fortanix.com, jarkko.sakkinen@linux.intel.com,
        fweimer@redhat.com, linux-api@vger.kernel.org, x86@kernel.org,
        linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, bp@alien8.de,
        carlos@redhat.com, adhemerval.zanella@linaro.org
Subject: Re: RFC: userspace exception fixups
Message-ID: <20181101193107.GE5150@brightrain.aerifal.cx>
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx>
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101193107.3Y3TmE8xErdsOlHI0TCL7J55IMJU8U_VqYwa8jPUaUA@z>

On Thu, Nov 01, 2018 at 12:10:35PM -0700, Linus Torvalds wrote:
> On Thu, Nov 1, 2018 at 11:52 AM Rich Felker <dalias@libc.org> wrote:
> >
> > There's no need to chain if the handler is specific to the context
> > where the fault happens. You just replace the handler with the one
> > relevant to the code you're about to run before you run it.
> 
> That's much too expensive to do as a system call.

See my other emails in this thread. You would register the *address*
(in TLS) of a function pointer object pointing to the handler, rather
than the function address of the handler. Then switching handler is
just a single store in userspace, no syscalls involved.

Rich
