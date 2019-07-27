Return-Path: <SRS0=PICp=VY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D8FC433FF
	for <linux-sgx@archiver.kernel.org>; Sat, 27 Jul 2019 17:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A63FA2085A
	for <linux-sgx@archiver.kernel.org>; Sat, 27 Jul 2019 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564249481;
	bh=7508Hqjsp5BrZEfHjlTHq2n5lWF3Ig6ljiPlvZAE1mM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lSA41BtE8v0l87Sm8eIaJVIEfKqjGZQLlVNjm0wIRsEtGbIb20iADGkv0336tb719
	 j9Wrn5i4FBewZ/kBazZWrIXBl3tU2+lOE52REFZi5kfzQStdj8P2lPB4yLUAOPQgL1
	 ky4a6ArOC0+eD+D1bcaWQn/mcC7ZKF2SZt1Cpq8E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387940AbfG0Roi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 27 Jul 2019 13:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387714AbfG0Roi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 27 Jul 2019 13:44:38 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC24D214AE
        for <linux-sgx@vger.kernel.org>; Sat, 27 Jul 2019 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564249476;
        bh=7508Hqjsp5BrZEfHjlTHq2n5lWF3Ig6ljiPlvZAE1mM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0qJWEiy0ID85IOhEb93xNtQpSEilcQaXycwDHMREppR6o76xs9ICA6qt8UOR9VLnO
         ECykGS4C/wgMcPq6R3kDkur/NvlDAp/aqO3HedLyj4VvqnglLf+KU6cs91oGXi/lOM
         4+HP1a/RBvMk14M5IydeA/S7Z4Q5SD4f7BDBt7XI=
Received: by mail-wm1-f53.google.com with SMTP id 207so50456353wma.1
        for <linux-sgx@vger.kernel.org>; Sat, 27 Jul 2019 10:44:36 -0700 (PDT)
X-Gm-Message-State: APjAAAVwL+thCYQMPWyCTj1+O7eelxgZ+hCnztSFPnd40HDL3qNX+tpP
        tEeyAOBA0ou1vlnuC+BCQ411EGh0YDcWa8IlcD1inw==
X-Google-Smtp-Source: APXvYqyL7o2Bip6WKE1D1IyKrCOYDk6eK1EMMmNi55lNH9ZADh4TGsDQfeBUitoT/dV/PYPcV8t9et42W6nmgGaaYek=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr30866653wme.173.1564249475144;
 Sat, 27 Jul 2019 10:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190727055214.9282-1-sean.j.christopherson@intel.com> <20190727055214.9282-5-sean.j.christopherson@intel.com>
In-Reply-To: <20190727055214.9282-5-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 27 Jul 2019 10:44:24 -0700
X-Gmail-Original-Message-ID: <CALCETrXLE6RpR9p9eGPNvU+Nt=yyCkqsQHv7hzmNaC61sFK7Jg@mail.gmail.com>
Message-ID: <CALCETrXLE6RpR9p9eGPNvU+Nt=yyCkqsQHv7hzmNaC61sFK7Jg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/21] x86/sgx: Add /dev/sgx/virt_epc device to
 allocate "raw" EPC for VMs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Jul 26, 2019 at 10:52 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add an SGX device to enable userspace to allocate EPC without an
> associated enclave.  The intended and only known use case for direct EPC
> allocation is to expose EPC to a KVM guest, hence the virt_epc moniker,
> virt.{c,h} files and INTEL_SGX_VIRTUALIZATION Kconfig.
>
> Although KVM is the end consumer of EPC, and will need hooks into the
> virtual EPC management if oversubscription of EPC for guest is ever
> supported (see below), implement direct access to EPC in the SGX
> subsystem instead of in KVM.  Doing so has two major advantages:
>
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.

This is general grumbling more than useful feedback, but I wish there
was a way for KVM's userspace to add a memory region that is *not*
backed by a memory mapping.  For SGX, this would avoid the slightly
awkward situation where useless EPC pages are mapped by QEMU.  For
SEV, it would solve the really fairly awful situation where the SEV
pages are mapped *incoherently* for QEMU.  And even in the absence of
fancy hardware features, it would allow the guest to have secrets in
memory that are not exposed to wild reads, speculation attacks, etc
coming from QEMU.

I realize the implementation would be extremely intrusive, but it just
might make it a lot easier to do things like making SEV pages property
movable.  Similarly, I could see EPC oversubscription being less nasty
in this model.  For one thing, it would make it more straightforward
to keep track of exactly which VMs have a given EPC page mapped,
whereas right now this driver only really knows which host userspace
mm has the EPC page mapped.
