Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9995C43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 15:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D0B206BB
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 15:29:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="LBE+zA4h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1D0B206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbeKTBxe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:53:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45210 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729746AbeKTBxe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 19 Nov 2018 20:53:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id v6so10658872wrr.12
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 07:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+RQUN0fyDHo1THMW3ReTMiCYeU1lQCWvCiMAqsczkg=;
        b=LBE+zA4hNrUm5hZeMTnec7dMJ+6wQ+Oqz6OSVIXAH+0oWYdoPxpl7479BE03rXuQyY
         Yk6WFAI1D8+KXVYJQRn+ozllE2l0hb/6FuUvi5TlZV68T2lQSG0jxDk7zyKSMFpAtU4x
         oYc4R7ZklfvJzRjPMkNRHZJg/LI/l1Gpl8kgxFvoCYPqieROZ1Z9q8v5a6uEr/3AS6d5
         fVww9j3OSeGCw+HUC5fEnSJcvBkvvGsMe7shvGkvKk3rs/4mtg7IZVJQjU7xrcSn7eXp
         5SO19Tt8//SC+ZRxeLz8Zvlkyltac7TuJ1bBFjFqcizpt1I1q1nrZ6RfLwqZmGJnln3r
         X1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+RQUN0fyDHo1THMW3ReTMiCYeU1lQCWvCiMAqsczkg=;
        b=qYvn5RSuA9WOOY2gKZ0NJuYWJ3xKOtmek8vNqo3ngJto0HAaISoXbwECUPIBu8/Z5s
         v68LqqkQGnINcraBz3f1y0dMMpHIS5JiHwOlU2GBCg8L0lEKZH1jeg98F10RwHTz3/wM
         sOX52aIGSXdNMtwi9rTzIHlejnbTSWuFmkBsEWtd64gbPDLJRyiq2hW1ll0p7lItK1Bf
         EHenA/p84LsK6eV7QV+O+55nwa0YZ2EdfgvpFaYR4r5go03xRktMNgPnS3PwmMK1+aQk
         122oa/ttQgaJVsslxe5xDsBVCz0UAFu6YywGsjEe8kcy4/XcvmNTOzI8sQH8WeFrNMmE
         g81A==
X-Gm-Message-State: AA+aEWYi1JIi84drsGjPvs2Bs5gfUbqqDhB/VGsIDnjiRpFq2JaJiTHT
        UBiqiAhP3Ul1boVHMBAcr8qAMl7zsiF2fe+8Ns0gqw==
X-Google-Smtp-Source: AFSGD/WYRPBhTdJuIH+D8VWe1MyvIEGr5DXWDIWbSdmzZpR2H5kKcnBaf3CWfXnhEljDwhtQ7AldjY3pA1QPEcTFHT0=
X-Received: by 2002:adf:ea81:: with SMTP id s1mr205890wrm.309.1542641377018;
 Mon, 19 Nov 2018 07:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Mon, 19 Nov 2018 07:29:25 -0800
Message-ID: <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
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

On Thu, Nov 15, 2018 at 5:08 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
>
> SGX driver provides a ioctl API for loading and initializing enclaves.
> Address range for enclaves is reserved with mmap() and they are
> destroyed with munmap(). Enclave construction, measurement and
> initialization is done with the provided the ioctl API.
>

I brought this up a while back, and I think I should re-ask it now
that this driver is getting close to ready:

As it stands, there's just one SGX character device, and I imagine
that it'll be available to unprivileged applications.  I'm concerned
that this isn't quite what we want.  I certainly think that everyone,
or at least almost everyone, ought to be able to run normal enclaves.
But I think that we should consider restricting who can run specially
privileged enclaves.  In particular, the ability to run enclaves with
the provisioning bit set is somewhat sensitive, since it effectively
allows access to a stable fingerprint of the system.  Before flexible
LC, this wasn't such a big deal, since only Intel's provisioning
enclave could see the key, and Intel's enclave has some degree of
control of what is done with the key.  With flex LC, this protection
is lost.

But this is maybe more of a big deal than just access to a stable
fingerprint.  The ability to provision a remote attestation protocol
is a key part of running SGX malware, and SGX malware is surely going
to exist some day.  (Sure, Intel will try to block access to the
actual attestation service for malware, but I doubt that Intel will be
able to fully defend it.)

So I propose that there be a few device nodes.  Maybe
/dev/sgx/unprivilegd and /dev/sgx/provisioning?  The default mode of
the latter could be 0600.  If you've opened the unprivileged node, you
can only run enclaves without any special permission bits set.

We should also consider whether we allow the unprivileged node to run
launch enclaves, and, for that matter, whether we allow user code to
run launch enclaves at all, given that they're not useful with the
current architecture of the driver.

--Andy
