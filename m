Return-Path: <SRS0=PICp=VY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77FDC433FF
	for <linux-sgx@archiver.kernel.org>; Sat, 27 Jul 2019 17:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21782085A
	for <linux-sgx@archiver.kernel.org>; Sat, 27 Jul 2019 17:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="ChjuOA3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387940AbfG0RkB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 27 Jul 2019 13:40:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39993 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387714AbfG0RkB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 27 Jul 2019 13:40:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so50132586wmj.5
        for <linux-sgx@vger.kernel.org>; Sat, 27 Jul 2019 10:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ep/bHJiwTJubKvCC+mCIkJn0WsJ1FO1eKm4QNltKuYQ=;
        b=ChjuOA3qi8hCRwOL9y99MT+7yo1t/bL0L6Ncsb3uWV71xRrRX6evagsWwnF98DFPzn
         ReISaGFh5kQyGICxbtfmuOI+gkr36ju6f2L+dBfv0rymGAWzj38ODeTccI4tatv/eqZn
         tdOPkjx1kA2nT3LVk/i54jbH4GmtHkszvZxc2kPpBwDfmtsA/g5tA1S5sWz5iIqF+neH
         hDfsbmVPkW8qxlfX819hqG4PGIiF4Us+/RLoov+UGKzyIwkhQv/+0HFbz3vWCFcdQtZK
         iC2FW1CYf/EJPns2g1kwR+89knj+P9DJ5Z36Hk2nEYfDWuasdkc+wHv5+VYihGBvR2E5
         x+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ep/bHJiwTJubKvCC+mCIkJn0WsJ1FO1eKm4QNltKuYQ=;
        b=NiVBpXs8l9/1tmcRZb4a6bB4LlcOG74vLgOPyoDvnLnH57T3QakoQkr/qjazA0MVIK
         PbLSaN/xaO+rZB+Y3DFkszikuyGEInJ4moUqvb+Ri8qt8ZmhW+ulT6rwKGeY0lWIM+jU
         uQqXWfzqZFwcjUThljyauRxrPdVaN5wXQTlBbERaBnz4t4zTvHfJl8ClzK7vjJ51uH4C
         BpHKk3voPjxQf3e/ua5S6w81bjp1Z4St2HkLS91kUT3V8ZE571LE1cUNOcPuH/s4X4tz
         kIMryI8bm5spStOXSdgHTrpOVdcMzkwnvgr6Wnhm33KhZfgy+jyYkK2mt9iRb2qWtflN
         pP+w==
X-Gm-Message-State: APjAAAUfB1FXJ1NOEOWyWJ7SHh1pa+KjrNSGWhG+MZn9StpOcc+4ijPc
        VdToZTb1GuSiaESBDlY0rGXDHWj4bpcGi1NLH0aTfw==
X-Google-Smtp-Source: APXvYqxTGhXxLIkZBjp9vHFr7vfJZLQQuLojzbsMN1L6Q+kxU1bNPfP5/4CeCgiTLR1EhS6r90+g+fM2xHYaqgFAdyE=
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr91410809wmk.79.1564248742263;
 Sat, 27 Jul 2019 10:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190727055214.9282-1-sean.j.christopherson@intel.com> <20190727055214.9282-22-sean.j.christopherson@intel.com>
In-Reply-To: <20190727055214.9282-22-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Sat, 27 Jul 2019 10:32:11 -0700
Message-ID: <CALCETrVJ1vMAA-7qtiZ8tg-3qyckSwbzNC2kbbHsojm+W46PWg@mail.gmail.com>
Subject: Re: [RFC PATCH 21/21] KVM: x86: Add capability to grant VM access to
 privileged SGX attribute
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
> The SGX subsystem restricts access to a subset of enclave attributes to
> provide additional security for an uncompromised kernel, e.g. to prevent
> malware from using the PROVISIONKEY to ensure its nodes are running
> inside a geniune SGX enclave and/or to obtain a stable fingerprint.
>
> To prevent userspace from circumventing such restrictions by running an
> enclave in a VM, KVM restricts guest access to privileged attributes by
> default.  Add a capability, KVM_CAP_SGX_ATTRIBUTE, that can be used by
> userspace to grant a VM access to a priveleged attribute, with args[0]
> holding a file handle to a valid SGX attribute file corresponding to
> an attribute that is restricted by KVM (currently only PROVISIONKEY).

Looks good to me.  Thanks!

> +can use KVM_CAP_SGX_ATTRIBUTE to grant a VM access to a priveleged attribute.

Spelling.
