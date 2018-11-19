Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A17EC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 17:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCF6721104
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 17:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="nRo9bT/Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCF6721104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404783AbeKTDXy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 22:23:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54337 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405130AbeKTDXx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 19 Nov 2018 22:23:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id r63-v6so6096748wma.4
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 08:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnO+KI2zslD6ss3tS/w0B8InB8HwqMSPdTgrBSwIvRw=;
        b=nRo9bT/YdQmkQZkECAaVZuEw0/7HpDP3kZDW3tmRomIqFozct9haS6Nm57xuB/9rnF
         qFNJ/+YZiK7tFEWJXODuaBXldeHItg2qeJbKYbcEMh8DleXsl/nnafWRAWvCKjpeN/s9
         hmiEEyF/k7y5yT4WRp3i1MqLR5HbhpciMWHHRT1nub7jlp1zOCHBGWQeApnE+8XhsOrG
         76Bg3hzoXTXewjNQgWSW9pgpyC8JpkomOtRMOYnx4HyLSz/xlbKzwzAQJHOXGrJPKrXD
         ZCNCPiY5bQol0EvRNPCsG8EQ9zF2O0Nk8Hm+j4stN+1xWXnSeCSv+HkBO1hBI089Kli/
         /aHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnO+KI2zslD6ss3tS/w0B8InB8HwqMSPdTgrBSwIvRw=;
        b=inBlXoI01Wlm0+F53aZxEBKDAXOBqFtdEP6sDoFEyLQDfX5J44JD5UIn/I4WMFiV8R
         /PHgVwFqJfAeZUG6B1sqDUtSF1t+++mE3VGdUiTxAWbA4ir7s2DxWl3HX7R5+B3O+0h3
         NgM2EERrkuNkf6RI3FImkj5Djaj4khdLnaCkEvyihU/oAR5ua2UYF6H2oq0heKByaQZV
         6FNzmeVnDHJ2Xrxp90PHHZ6TbHjcY5dkyiVmyBn2UpYFrN2s/MnDgxQs8hnoaKsXRNal
         8FHcVMzgNrpamWtoimlN4yCZJMP6CgmGVXjIGqSQ2tY+WP5bKOWO0tuGUYanyicxviRw
         iNUA==
X-Gm-Message-State: AA+aEWbkP/a+X5LQ07WoWL68oaPwFxF1FI0K9yakZNbsWtnxMx/AxWLn
        fRquRjlw6wGUMa6w06TRL7HT36pPsjuv7KK2IlDFnQ==
X-Google-Smtp-Source: AJdET5dadd0fqJg2TdztWRlj6ZXlGkLKoFS2ZPDp2Umbo9zkWkGZvHcbdZ5G4Km94PMDMqlYez0i7ANCAXsxBPjOLgs=
X-Received: by 2002:a1c:110b:: with SMTP id 11mr5052294wmr.83.1542646776903;
 Mon, 19 Nov 2018 08:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com>
In-Reply-To: <20181119161917.GF13298@linux.intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Mon, 19 Nov 2018 08:59:24 -0800
Message-ID: <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>, andy@infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 19, 2018 at 8:19 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Nov 19, 2018 at 07:29:25AM -0800, Andy Lutomirski wrote:
> > On Thu, Nov 15, 2018 at 5:08 PM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > > can be used by applications to set aside private regions of code and
> > > data. The code outside the enclave is disallowed to access the memory
> > > inside the enclave by the CPU access control.
> > >
> > > SGX driver provides a ioctl API for loading and initializing enclaves.
> > > Address range for enclaves is reserved with mmap() and they are
> > > destroyed with munmap(). Enclave construction, measurement and
> > > initialization is done with the provided the ioctl API.
> > >
> >
> > I brought this up a while back, and I think I should re-ask it now
> > that this driver is getting close to ready:
> >
> > As it stands, there's just one SGX character device, and I imagine
> > that it'll be available to unprivileged applications.  I'm concerned
> > that this isn't quite what we want.  I certainly think that everyone,
> > or at least almost everyone, ought to be able to run normal enclaves.
> > But I think that we should consider restricting who can run specially
> > privileged enclaves.  In particular, the ability to run enclaves with
> > the provisioning bit set is somewhat sensitive, since it effectively
> > allows access to a stable fingerprint of the system.  Before flexible
> > LC, this wasn't such a big deal, since only Intel's provisioning
> > enclave could see the key, and Intel's enclave has some degree of
> > control of what is done with the key.  With flex LC, this protection
> > is lost.
> >
> > But this is maybe more of a big deal than just access to a stable
> > fingerprint.  The ability to provision a remote attestation protocol
> > is a key part of running SGX malware, and SGX malware is surely going
> > to exist some day.  (Sure, Intel will try to block access to the
> > actual attestation service for malware, but I doubt that Intel will be
> > able to fully defend it.)
> >
> > So I propose that there be a few device nodes.  Maybe
> > /dev/sgx/unprivilegd and /dev/sgx/provisioning?  The default mode of
> > the latter could be 0600.  If you've opened the unprivileged node, you
> > can only run enclaves without any special permission bits set.
>
> What would the use case for unprivileged i.e. this configuration would
> mean depending on permissions?

Everything except the quoting/provisioning code would use the unprivileged node.

>
> There would be three types of users:
>
> 1. Ones that have access to neither of the devices.
> 2. Ones that have access to unprivileged. Who are these?

Either 0666 (world) or an sgx group.

> 3. Ones that have access to provisioning.

Root only.

The idea here is that, under normal circumstances, provisioning only
runs once, or at least only runs rarely.  So, rather than the SDK
running provisioning whenever it feels like doing so (which is the
current behavior, I imagine, although I haven't looked), there would
be a privileged program, perhaps a systemd unit that runs when needed,
that produces the key material needed for remote attestation, and
non-root users that need attestation would get the keying material
from the provisioning service.  And the provisioning service could
implement its own policy.  Ideally, the service wouldn't give the
sealed keys to users at all but would, instead, just provide the
entire attestation service over a UNIX socket, which would make
provisioning capabilities revocable.

Does this make sense?

--Andy
