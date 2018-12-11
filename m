Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8C1C07E85
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 17:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 089E520855
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544551118;
	bh=IT+/Sn539b1Hv8g6PSWkXhUMKvsM5oSYYLuIqhpavcs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=iPFwcsngPU9v49CHyZrcbngq4i+zVdaI5X8g4JVTSI+a3x6x4kvigSyCS9GQzKboP
	 dQYLwSuie+x7aakQ+CJ200PrpRddJWFebl5HR3g+duwclvAXCnPGSYdbi9ikczV1mJ
	 aSBBmHGJnxn+60qIMbtH+ooC98CyLpH2lAjanwI0=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 089E520855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbeLKR6e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 12:58:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbeLKR6e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 12:58:34 -0500
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE17120855
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544551113;
        bh=IT+/Sn539b1Hv8g6PSWkXhUMKvsM5oSYYLuIqhpavcs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KzPMVCIasypCyr/lG9ew7dulA9cm+XNoq7h1/vatjcUMLSWnwovRqtB0FCoa9oEG+
         3sNT2Kd29o/3Mlbbll7HAaSHlJc+55hE+ERi8s9Rl20c2d3cpdVv3DC5oROgbT6dq+
         Yo241SoQrwAjqZQZULXXHnxfRs+NI30mhvrlsKD8=
Received: by mail-wm1-f52.google.com with SMTP id a62so3174278wmh.4
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 09:58:32 -0800 (PST)
X-Gm-Message-State: AA+aEWakAo8M8GPYXm+qlcP8rLN4KakUw8KF1bqim3s6/Rhvc8kQbUJE
        waTSpPnmz0SNTcURms8GIHXL0dp+SrT5mKhd9u7GgA==
X-Google-Smtp-Source: AFSGD/VZqjpsAKbB53VjIJvHUw8HgLmuFtHxraUUCrmVWwQsuDerPo/JeZR7SnVU9e2mbHYCy63hBJUbTsU5dCMewtk=
X-Received: by 2002:a1c:aa0f:: with SMTP id t15mr3219252wme.108.1544551111470;
 Tue, 11 Dec 2018 09:58:31 -0800 (PST)
MIME-Version: 1.0
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
 <20181210232449.GA11843@localhost> <EEE078E7-7F37-4F74-8874-46E16C1E0A77@amacapital.net>
 <20181211165253.GB14731@linux.intel.com>
In-Reply-To: <20181211165253.GB14731@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Dec 2018 09:58:19 -0800
X-Gmail-Original-Message-ID: <CALCETrXOXh8Gb_d7NYLakx4w+JVEe79t11wFPLpy+5MEq9kq=A@mail.gmail.com>
Message-ID: <CALCETrXOXh8Gb_d7NYLakx4w+JVEe79t11wFPLpy+5MEq9kq=A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Dec 11, 2018, at 8:52 AM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>
>> On Tue, Dec 11, 2018 at 07:41:27AM -0800, Andy Lutomirski wrote:
>>
>>
>>>> On Dec 10, 2018, at 3:24 PM, Josh Triplett <josh@joshtriplett.org> wro=
te:
>>>>
>>>> On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
>>>> At that point I realized it's a hell of a lot easier to simply provide
>>>> an IOCTL via /dev/sgx that allows userspace to register a per-process
>>>> ENCLU exception handler.  At a high level, the basic idea is the same
>>>> as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
>>>> attempt to fixup select unhandled exceptions that occurred in user cod=
e.
>>>
>>> So, on the one hand, this is *absolutely* much cleaner than the VDSO
>>> approach. On the other hand, this is global process state and has some
>>> of the same problems as a signal handler as a result.
>>
>> I liked the old version better for this reason
>
> This isn't fundamentally different than forcing all EENTER calls through
> the vDSO, which is also per-process.  Technically this is more flexible
> in that regard since userspace gets to choose where their one ENCLU gets
> to reside.  Userspace can have per-enclave entry flows so long as the
> actual ENLU[EENTER] is common, same as vDSO.

Right. The problem is that user libraries have a remarkably hard time
agreeing on where their one copy of anything lives.

>
>> and for another reason:
>> while this new one looks very very simple, it still has the hidden
>> complexity that the magic values written to registers in the event of an
>> exception are very much Linux specific.
>
> Definitely more magical, but not necessarily more difficult to document.
> It'd essentially be an extension of hardware's AEE/AEP behavior.
>
>> OTOH, the old approach clobbered more regs than needed, but that=E2=80=
=99s a easy fix.
