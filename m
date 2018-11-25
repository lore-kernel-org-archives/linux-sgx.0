Return-Path: <SRS0=mkZ9=OE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F75C43441
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 16:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC8420850
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 16:22:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="DxNiQADu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FC8420850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbeKZDOC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 25 Nov 2018 22:14:02 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45955 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeKZDOC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 25 Nov 2018 22:14:02 -0500
Received: by mail-pf1-f195.google.com with SMTP id g62so5355369pfd.12
        for <linux-sgx@vger.kernel.org>; Sun, 25 Nov 2018 08:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m0PVqkjcw+12u0+KUpFGsrTYmf3DdzTqCQWVqScVdZ8=;
        b=DxNiQADuf2HNQWqalXSE0mcE9H0HM+fIkUChnNmyIDBS9oV75M2b5hsJ4yjhZvKxuV
         ihRRte0gMRWjvYtsTn3u86K1CM6ivHJhTdhMxR8lL0nt2HEnDT+e/3RSrqT0yygv9LlM
         s8CfmwRBj4m48/pWBWZ+7/madFdLU0GfajBmExXRL6C6dnd7v13bc59jsd4T7+MZOA5R
         HBHbMF/k0QewuoNy03Svo+MnAcPfi0YDnoCwiImsYYEOOYrzUkOy7/Xpcqt15m47jJWq
         +SAaZ2wfPXwoGDREm9LTWROEMmwAQp93Y2/IuWUhBIqx7nKd4wx8kHhb7w+lIy1wAjD6
         l+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m0PVqkjcw+12u0+KUpFGsrTYmf3DdzTqCQWVqScVdZ8=;
        b=PnYCEbmMdza/81f3ggoDf6gdA2OKDe3AUlgLj2pKMOroQdZnKQUFztie/NwCdOVtYC
         14h/bBQ5a27BUcvLFQBFTbi9jSM8vQ2b1SmLEdV6OvnAfdq2YnKB8i//IDsM6+EEyIt1
         3CuDrv4+LCuBkJuogwhMvwjv1xa+X/NMtdvXU/YqF5f2BJQJQOimsss9ZTzPR6qfJPQo
         CYy1GemP7wB9R180WVP6ky6vq8tS4g4a7AFPG8WP26BH5dfLYjXtXx2Xo2Bchu4nF0ks
         675TWAL4sVO4k9En2eQ3OKTGFW2zfcfj3ngqgY5rFU7l+sNaQz5VS5L+ynZ8mPPUim9E
         Tp5g==
X-Gm-Message-State: AA+aEWZbaumPKUtR/eqTgRtZ9fxZ2b5ohyvBQk2Mp8Do6chzsJmaz326
        eKs+t7z2wdD3IokIQdMlEIB0vw==
X-Google-Smtp-Source: AFSGD/WCYkcZcixKUId1uJd0uSrDIXxkJ+WE+KP2ENCvsIj9te9dAhpkGOjjzHVQL21y/OR+9SPlSg==
X-Received: by 2002:a65:610d:: with SMTP id z13mr21763674pgu.427.1543162957002;
        Sun, 25 Nov 2018 08:22:37 -0800 (PST)
Received: from ?IPv6:2601:646:c200:7429:8ca1:5464:4cf7:ce39? ([2601:646:c200:7429:8ca1:5464:4cf7:ce39])
        by smtp.gmail.com with ESMTPSA id w80-v6sm93123672pfk.11.2018.11.25.08.22.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Nov 2018 08:22:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16A404)
In-Reply-To: <20181125145329.GA5777@linux.intel.com>
Date:   Sun, 25 Nov 2018 08:22:35 -0800
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg Wettstein" <greg@enjellic.com>, X86 ML <x86@kernel.org>,
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
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


>> On Nov 25, 2018, at 6:53 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel=
.com> wrote:
>>=20
>> On Sat, Nov 24, 2018 at 09:21:14AM -0800, Jarkko Sakkinen wrote:
>> On Thu, Nov 22, 2018 at 07:21:08AM -0800, Andy Lutomirski wrote:
>>>> At a high level, addressing these issues is straight forward.  First,
>>>> the driver needs to support authorization equivalent to that which is
>>>> implemented in the current Intel Launch Enclave, ie. control over the
>>>> SGX_FLAGS_PROVISION_KEY attribute.
>>>=20
>>> I agree, hence my email :)
>>=20
>> Started to scratch my head that is it really an issue that any enclave
>> can provision in the end?
>>=20
>> Direct quote from your first response:
>>=20
>> "In particular, the ability to run enclaves with the provisioning bit set=

>> is somewhat sensitive, since it effectively allows access to a stable
>> fingerprint of the system."
>>=20
>> As can be seen from the key derivation table this does not exactly hold
>> so you should refine your original argument before we can consider any
>> type of change.
>>=20
>> I just don't see what it is so wrong for any enclave to be able to tell
>> that it really is an enclave.
>=20
> I mean I can understand why Greg wants LE although I don't understand
> what benefit does it bring to anyone to lock in for enclave to allow
> to identify itself.
>=20
> What you are proposing does not really bring any additional security if
> we consider a threat model where the kernel is an adversary but it makes
> the software stack more clanky to use.

Agreed. What I=E2=80=99m proposing adds additional security if the kernel is=
 *not* compromised.

There are other ways to accomplish it that might be better in some respects.=
  For example, there could be /dev/sgx and /dev/sgx_rights/provision.  The f=
ormer exposes the whole sgx API, except that it doesn=E2=80=99t allow provis=
ioning by default. The latter does nothing by itself. To run a provisioning e=
nclave, you open both nodes, then do something like:

ioctl(sgx, SGX_IOC_ADD_RIGHT, sgx_provisioning);

This requires extra syscalls, but it doesn=E2=80=99t have the combinatorial e=
xplosion problem.=
