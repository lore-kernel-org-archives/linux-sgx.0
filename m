Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47035C10F11
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 120A6214AE
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555952169;
	bh=638RxHioDZ2o3J7dXA5zGeo3lvE6uyScoC/kdy1+qGA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=L1Wx5f0tIsk6U6zjagQeibNb5qFDB7rTF0SBxPhyDkNE+U4BEft8GZNvXHK1n5E69
	 hM6yDLMf7R7p4XXEMrNSsPC9Je+g/AGxSMgID7+JjawWJKFT9CA6njSGHJL5yv3ZQi
	 g5z+ZcQLBsm+wmMy7h+vHrxxqw18dHTcCQDXaqQ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfDVQ4I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:56:08 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36096 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfDVQ4I (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 22 Apr 2019 12:56:08 -0400
Received: by mail-lj1-f194.google.com with SMTP id l23so297901lja.3
        for <linux-sgx@vger.kernel.org>; Mon, 22 Apr 2019 09:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=siTNhYq3VJ/zr5tI3VaOoIVXtnyv+3krWNy4a/CqeG8=;
        b=PcyV/0qpxk4tfSz4Jn6dPiZGrURYW6OA7vSHVOOSnxEZ7XRGalVdadjyJl8NBV4fMT
         qqzjLDZe8q2vJL40jou9pDEh0NB88CuMAZZYMLqrxWA68zfz3vNqCvsUHRgx25T1X/r1
         uTfMJavADNW9DPJ/H/43ZUTYlizj3a/eLOshM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=siTNhYq3VJ/zr5tI3VaOoIVXtnyv+3krWNy4a/CqeG8=;
        b=O5+X7zQBMfNazjEaN96BfOgRbyO1uDDJlahvv/+IUIhtd2VjggGS5BJllsgWSCFyAM
         q3H8PHHzIQmFWuHDTYGvGTh9xatQrVPkfZ1DL36V6dVAmKggKq+Md7v0npqlloUloYjd
         wbIbopXbGMko5W0kj/1rb1I6ffkGkbAfPYL53BXtMr0xWAVWGq5ZmmnR5/KbbujZM7vL
         5b3OQxevOVg8v1Etl75FQSbrov+puyy5rHPq30jzOGsV3wUfR/bvgux5BePmAP9T7LLz
         WUHZ8XNk7aWzkio1obqj9GeoiVfS4YmSVUczegGd07C2u8D/ZJ/xStUVJlc/d2X8+zhM
         6ntA==
X-Gm-Message-State: APjAAAWVvkEuC9GzgsqkpV0or6MXWB1JSK0/HYV/9ujFlEXvLSQo55t5
        RO+fInFbKWJvJQPoQjeoV7AB2fL3ufo=
X-Google-Smtp-Source: APXvYqyianzJSYF2JEnYiAkcIziqKIkDMntpUSvtcS/MxbNX0qD2DAvKoy/ob8U8tPTY+uF1TJxeOg==
X-Received: by 2002:a2e:8703:: with SMTP id m3mr10341428lji.107.1555952165039;
        Mon, 22 Apr 2019 09:56:05 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id j76sm2807472ljb.78.2019.04.22.09.56.03
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 09:56:04 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id l7so10889524ljg.6
        for <linux-sgx@vger.kernel.org>; Mon, 22 Apr 2019 09:56:03 -0700 (PDT)
X-Received: by 2002:a2e:9213:: with SMTP id k19mr10243181ljg.118.1555952163377;
 Mon, 22 Apr 2019 09:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com> <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
 <20190420160247.GA17291@wind.enjellic.com> <20190422150119.GA1236@linux.intel.com>
 <20190422162411.GA27389@wind.enjellic.com> <20190422164827.GC1236@linux.intel.com>
In-Reply-To: <20190422164827.GC1236@linux.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 22 Apr 2019 09:55:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjmT=uC1=18ZYV1CMfP_FBUEjh9_rabH0g+a0z-L0cgHg@mail.gmail.com>
Message-ID: <CAHk-=wjmT=uC1=18ZYV1CMfP_FBUEjh9_rabH0g+a0z-L0cgHg@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 9:48 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Right, and loading a malicious enclave doesn't change those guarantees
> (for other enclaves).  Ergo, restricting which enclaves can execute is
> orthogonal to the security provided by SGX.

But it is absolutely worth noting that TSX made a lot of attacks both
easier to _do_, and also easier to _hide_.

All while being basically completely worthless technology to everybody
except for some silly SAP benchmark.

So it is definitely worth at least discussing the downsides of SGX. If
it ends up being another technology that makes it easier to create
malware, without actually having a lot of _good_ software use it, the
patches to enable it should make damn sure that the upsides actually
outweigh the downsides.

And if the current setup basically is "you have to disable reasonable
SElinux protections that lots of distros use today", I think it's
entirely reasonable saying "the downsides are bigger than the
upsides".

                        Linus
