Return-Path: <SRS0=iBWu=AN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F95AC433E0
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jul 2020 12:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B64A20772
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jul 2020 12:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="s+wavn4H";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1g++i5NN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgGBMw3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jul 2020 08:52:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49372 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgGBMw2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 2 Jul 2020 08:52:28 -0400
X-Greylist: delayed 3188 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 08:52:27 EDT
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1593694345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aqrdi9rxf7Tn9B3k1NE3iOQPIUnUUC4buFv5kHY3mUo=;
        b=s+wavn4HSYxSxIKkuL4eIm/PtK8lTqB36eaX2y2TcQ/I2sdoweM/Fgs7pq00wS68Gr4dKt
        vIObSw109eqvYfuRhM7+eC9orZVwFAXkk5GZlnhQHD5RwMA398CclKT3zd5m1miHCsxc6L
        qCJpErW3uIB6bPkzIkvwBOOut62fDufhmslWoqKUl2Sul918wrhPBF+xQNmTwdNxa3NkUR
        35jErUo1ta+UPNp3v/C+tIzuemUMP/0dILY//Xn7eRDwViPg7ThmMNhRoCCM9XRCTa7pxT
        dqq6uZ37+PoWnmmTvYNNsH7iI0m4E/18gUONRABZv9Pzmqh9G4mr27sjoD5bhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1593694345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aqrdi9rxf7Tn9B3k1NE3iOQPIUnUUC4buFv5kHY3mUo=;
        b=1g++i5NNy0K1Zec8OFkf4LBvyBFbhBa5uw9a9g7cIhIkrQojiaUhXljvXDUVxLoaUeN59+
        VcEMEq3zNtSAAPCQ==
To:     Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, "Xing\, Cedric" <cedric.xing@intel.com>,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang\, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang\, Kai" <kai.huang@intel.com>,
        "Svahn\, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>, npmccallum@redhat.com,
        puiterwijk@redhat.com, David Rientjes <rientjes@google.com>,
        yaozhangx@google.com
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in vDSO functions
In-Reply-To: <CALCETrWUHw2WSDaJrxrwVrXSGz-zR0N2R3cT06esKBCpqyoZaQ@mail.gmail.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com> <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com> <20200629171022.GC32176@zn.tnic> <20200630060055.GS12312@linux.intel.com> <20200630084128.GA1093@zn.tnic> <CALCETrWUHw2WSDaJrxrwVrXSGz-zR0N2R3cT06esKBCpqyoZaQ@mail.gmail.com>
Date:   Thu, 02 Jul 2020 14:52:25 +0200
Message-ID: <87mu4i9j06.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
> On Tue, Jun 30, 2020 at 1:41 AM Borislav Petkov <bp@alien8.de> wrote:
>>
>> On Mon, Jun 29, 2020 at 11:00:55PM -0700, Sean Christopherson wrote:
>> > E.g. the vDSO function should get the fixup even if userspace screws
>> > up mmap() and invokes __vdso_sgx_enter_enclave() without being tagged
>> > an SGX task.
>>
>> I sincerely hope you don't mean this seriously.
>>
>> Please add a member to task_struct which denotes that a task is an
>> sgx task, test that member where needed and forget real quickly about
>> running *any* *fixup* for unrelated tasks.
>
> I don't see the problem.  If you call this magic vDSO function and get
> a fault, it gets handled.  What's the failure mode?

Handled by some definition of handled. If a random user space tasks ends
up in that function then it will not die as it would otherwise, but I
don't see a real issue with that either.

Thanks,

        tglx
