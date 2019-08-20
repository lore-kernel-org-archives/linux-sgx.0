Return-Path: <SRS0=WUWl=WQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188A0C3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Aug 2019 01:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEA90233FE
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Aug 2019 01:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566264864;
	bh=t2kfzl1Im6UkgjLX7Fx6EjFHl9UHAnZYRidAq5Pt5wY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Qp4ZeZRs78izS77WhxiYVsP/wWoH8DhC+Zlw31Bv6waYQm/7LydmjTG3a10/PsNL4
	 x3QdPLcc0M7V+nbz5WKSZoP597gfYQjA2cXd0wuv7Ul4exaTRfUVFSfYY1tZ9kmN70
	 G/SlNRBlm1+Z2bNBcmuZS3uEUybEjprQUo+9KJvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfHTBeX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 21:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbfHTBeX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 21:34:23 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0649123428
        for <linux-sgx@vger.kernel.org>; Tue, 20 Aug 2019 01:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566264862;
        bh=t2kfzl1Im6UkgjLX7Fx6EjFHl9UHAnZYRidAq5Pt5wY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DCSYnGps/sQTNHtTU7NG9vQIqAUmnw1PuIaB5SzjSHQYTUhxU8XQDXYIBHrNGhfdx
         16C4JRzenLAKrHE3ezskVW7UV330X/xa3+esMEuOUKflR8A/w7sVf1/aoDvffuWGgV
         jSAxXYlVvPxNGMKnVlaaC3TrJTTH0qkGgGOIDkE0=
Received: by mail-wr1-f50.google.com with SMTP id c3so10590165wrd.7
        for <linux-sgx@vger.kernel.org>; Mon, 19 Aug 2019 18:34:21 -0700 (PDT)
X-Gm-Message-State: APjAAAVsCH6srHhAMWmxOJBQxaw8wHk8I09KmBD0QxootvhYWfxlcI2s
        x0pS64zlN1ESkHXHViDXWqExeGRkbIFdXElvBLXWvg==
X-Google-Smtp-Source: APXvYqyF+AHDoPN5/wILKp6e1GM8xbws53lsz35ngojNrpFM03bdoLJZliFWjrdNYI+BtT2V0MNJMWR9Fae7uVpz03E=
X-Received: by 2002:adf:82cd:: with SMTP id 71mr26128200wrc.265.1566264860344;
 Mon, 19 Aug 2019 18:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
 <20190727055214.9282-9-sean.j.christopherson@intel.com> <CALCETrU_51Ae=F9HzUwsUuSkJ1or63p_eG+f3uKkBqFx=bheUA@mail.gmail.com>
 <20190730024940.GL21120@linux.intel.com> <25BBDA64-1253-4429-95AF-5D578684F6CC@amacapital.net>
 <20190819220150.GE1916@linux.intel.com>
In-Reply-To: <20190819220150.GE1916@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 19 Aug 2019 18:34:07 -0700
X-Gmail-Original-Message-ID: <CALCETrX6bmhFm62GyCF8Z2DGtb10Ua7xi6h3PoCUiP_es74M8A@mail.gmail.com>
Message-ID: <CALCETrX6bmhFm62GyCF8Z2DGtb10Ua7xi6h3PoCUiP_es74M8A@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 3:01 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Aug 15, 2019 at 05:47:12PM -0700, Andy Lutomirski wrote:
> >
> >
> > >> On Jul 29, 2019, at 7:49 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > >>
> > >> On Sat, Jul 27, 2019 at 10:38:03AM -0700, Andy Lutomirski wrote:
> > >> On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
> > >> <sean.j.christopherson@intel.com> wrote:
> > >>>
> > >>> Similar to the existing AMD #NPF case where emulation of the current
> > >>> instruction is not possible due to lack of information, virtualization
> > >>> of Intel SGX will introduce a scenario where emulation is not possible
> > >>> due to the VMExit occurring in an SGX enclave.  And again similar to
> > >>> the AMD case, emulation can be initiated by kvm_mmu_page_fault(), i.e.
> > >>> outside of the control of the vendor-specific code.
> > >>>
> > >>> While the cause and architecturally visible behavior of the two cases
> > >>> is different,  e.g. Intel SGX will inject a #UD whereas AMD #NPF is a
> > >>> clean resume or complete shutdown, the impact on the common emulation
> > >>> code is identical: KVM must stop emulation immediately and resume the
> > >>> guest.
> > >>>
> > >>> Replace the exisiting need_emulation_on_page_fault() with a more generic
> > >>> is_emulatable() kvm_x86_ops callback, which is called unconditionally
> > >>> by x86_emulate_instruction().
> > >>
> > >> Having recently noticed that emulate_ud() is broken when the guest's
> > >> TF is set, I suppose I should ask: does your new code function
> > >> sensibly when TF is set?
> > >
> > > Barring a VMX fault injection interaction I'm not thinking of, yes.  The
> > > SGX reaction to the #UD VM-Exit is to inject a #UD and resume the guest,
> > > pending breakpoints shouldn't be affected in any way (unless some other
> > > part of KVM mucks with them, e.g. when guest single-stepping is enabled).
> >
> > What I mean is: does the code actually do what you think it does if TF is
> > set?  Right now, as I understand it, the KVM emulation code has a bug in
> > which some emulated faults also inject #DB despite the fact that the
> > instruction faulted, and the #DB seems to take precedence over the original
> > fault.  This confuses the guest.
>
> Yes.  The proposed change is to inject the #UD instead of calling into the
> emulator, and by inspection I've verified that all code that injects a #DB
> is either contained within the emulator or is mutually exclusive with an
> intercepted #UD.  It's a qualified yes because I don't have an actual
> testcase to verify my literacy.  I'll look into adding a test, either to
> the selftest/x86/sgx or to kvm-unit-tests.

I wrote one, and it fails:

# ./tools/testing/selftests/x86/syscall_arg_fault_32
[RUN]    SYSENTER with invalid state
[OK]    Seems okay
[RUN]    SYSCALL with invalid state
[SKIP]    Illegal instruction
[RUN]    SYSENTER with TF and invalid state
[OK]    Seems okay
[RUN]    SYSCALL with TF and invalid state
[WARN]    Got stuck single-stepping -- you probably have a KVM bug

emulate_ud() is buggy.
