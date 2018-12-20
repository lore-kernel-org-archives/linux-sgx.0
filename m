Return-Path: <SRS0=1Eyi=O5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436A9C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 12:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B7912176F
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 12:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbeLTMJE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:09:04 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39005 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbeLTMJE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 20 Dec 2018 07:09:04 -0500
Received: by mail-qt1-f193.google.com with SMTP id n21so1467061qtl.6;
        Thu, 20 Dec 2018 04:09:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DgVSw7Y7zmF2FOtEGXtk0vSfyEz9/JSJIOaKQXO8u5k=;
        b=g+2J6LmkrSnPRnf9Lk3GShjhPmldLbMnd9Q6GQc3VTxLFkMrORlLAn3qc2HcDxH5tA
         zTzoni0o0b6w/J2IYqkQIh86UKFV7mNMZnbJfJuTPHrcWiXRDdwKv2WrS12+8t4FkI5V
         o3pSabscSaZg/VIyPVrepISrJ0uGSBLa3hljgrNnkkFSiVg4XM3VmuG2ZIEvWMBRVxMy
         ztnFoTep55AqKqTkaWe+urjCvLt7Ws7LTAXcYxk4UyN8b21eC+J45kjIt9aYgXCzupmG
         SyyBnds6VK8Gx8u1MRZqjuaK7XEeiZUxN1/imohhZjCmnLLLjxsOoOkKDEF33R3jCB8/
         5ymQ==
X-Gm-Message-State: AA+aEWYRIBx8d2Yx0og00GhtLH2uZN+ffMA+qS+BOZDBf87iQ2syxLyW
        Qhd0oQUCJCn8ij420oG7zpJIFs63coVMj0JoUAU=
X-Google-Smtp-Source: AFSGD/WOWbUo6CL/uxnx203pDx++a/X6qr42zEm7scnvCjT1Lq4fV1c1OAmGvsPetSRPLT7qKtqjuWyRlPslJz6HdbM=
X-Received: by 2002:ac8:7451:: with SMTP id h17mr25245792qtr.319.1545307743542;
 Thu, 20 Dec 2018 04:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com> <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
In-Reply-To: <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 20 Dec 2018 13:08:46 +0100
Message-ID: <CAK8P3a3QatXPYgDzZkUpxwHh5HJw5-XWA6VoyxW6Y9UAnzS=tQ@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     jethro@fortanix.com
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        sean.j.christopherson@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        haitao.huang@linux.intel.com, greg@enjellic.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 19, 2018 at 10:26 AM Jethro Beekman <jethro@fortanix.com> wrote:
>
> On 2018-12-19 13:28, Jarkko Sakkinen wrote:
> > /**
> >  * struct sgx_enclave_add_page - parameter structure for the
> >  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> >  * @eclave_fd:        file handle to the enclave address space
> >  * @src:      address for the page data
> >  * @secinfo:  address for the SECINFO data
> >  * @mrmask:   bitmask for the measured 256 byte chunks
> >  */
> > struct sgx_enclave_add_page {
> >       __u64   enclave_fd;
> >       __u64   src;
> >       __u64   secinfo;
> >       __u16   mrmask;
> > } __attribute__((__packed__));
>
> Wouldn't you just pass enclave_fd as the ioctl fd parameter?
>
> How to specify the address of the page that is being added?

One more comment about the structure: I would generally recommend
against packing structures like this. Instead just extend the mrmask
member to 64 bits as well.

      Arnd
