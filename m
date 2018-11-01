Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F76AC6786F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 21:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6307620820
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 21:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I8sNO71V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6307620820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbeKBG32 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 02:29:28 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43558 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbeKBG31 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Nov 2018 02:29:27 -0400
Received: by mail-lj1-f195.google.com with SMTP id g26-v6so18113844lja.10
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 14:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6l0oXKTWmF6192MGpX+vILDY+h+riejuNP24DHkSMWM=;
        b=I8sNO71VG7+Std248CcLp382Pq6vk7t03j5Y8qjTm5RhyHYruHMZNnaak081W3c180
         NqOO57k44MhEq1DIrVf/Db6Otw1p3LYTskn+xJCzc3fpKqsnoG9urVzDtDpCiftuXqfD
         7G/pPHstYrW9uUpSAG2ZvNZHa6/wH/SDVX0IE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6l0oXKTWmF6192MGpX+vILDY+h+riejuNP24DHkSMWM=;
        b=JrhqMBE1n4x3bieW1cYsnOIhDAzMVN2u8dCgtpYXhO3/MFDeH5SmK/5wkflMTFP1iy
         /VJnqzxCG66U0uyB5GDWIViO+ifq65LbWfSQibFQlN8XuvV0a+Wxfk2JGXrriICcaJAu
         E2y2FB2KFRGyXcIdW/p2RkkxhAPZTI0K91AxQ9DwgeMkB6ic7AulG5a407CMN+M1TVBC
         FmBSMKMcFvB7WiDYaF8n0ScAOmMAeP/ryeFCoIFgzGTmkWI/4UV1VrFwvf+Ffa3mA2pq
         7fneHLwz0BXfeFesLot22B6e/g5CR+bjpGgOfecO159uGVF4U2nSn9Fihaq8k4ba5Cf3
         LupA==
X-Gm-Message-State: AGRZ1gJ14ZwNCGY9g5G68/aCeF2Mr3tCfg1C0dawdgMLDlwUWzTRpIC3
        mFE7qzeoDFOnq/7NE2kS5QFgcxt4I1/uTQ==
X-Google-Smtp-Source: AJdET5f3ReGo8qaUwnedeYq+DyMJnX4NG1NlMeHWqqvUDj3SX4M0LJ1vALQzeaaugfBGx1P9n+9txw==
X-Received: by 2002:a2e:b1d0:: with SMTP id e16-v6mr1651284lja.16.1541107484405;
        Thu, 01 Nov 2018 14:24:44 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id a9sm2331794lfi.57.2018.11.01.14.24.43
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 14:24:43 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id a28-v6so16369121ljd.6
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 14:24:43 -0700 (PDT)
X-Received: by 2002:a2e:9584:: with SMTP id w4-v6mr6043318ljh.118.1541107482506;
 Thu, 01 Nov 2018 14:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx>
In-Reply-To: <20181101193107.GE5150@brightrain.aerifal.cx>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Nov 2018 14:24:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
Message-ID:
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     dalias@libc.org
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101212426.nhg_7A1se87zxY29KAxa1ZZF49Nu7vy4RWG5__-VAHY@z>

On Thu, Nov 1, 2018 at 12:31 PM Rich Felker <dalias@libc.org> wrote:
>
> See my other emails in this thread. You would register the *address*
> (in TLS) of a function pointer object pointing to the handler, rather
> than the function address of the handler. Then switching handler is
> just a single store in userspace, no syscalls involved.

Yes.

And for just EENTER, maybe that's the right model.

If we want to generalize it to other thread-synchronous faults, it
needs way more information and a list of handlers, but if we limit the
thing to _only_ EENTER getting an SGX fault, then a single "this is
the fault handler" address is probably the right thing to do.

                     Linus
