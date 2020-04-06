Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E428BC2BA1A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 19:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2A0E20672
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 19:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="h3UWnNd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDFTxq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 15:53:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33567 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgDFTxq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Apr 2020 15:53:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so279962pfc.0
        for <linux-sgx@vger.kernel.org>; Mon, 06 Apr 2020 12:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Ro6XsiyTG/iev3Jfb8gl0hcCfk9sgiCFxet6XwMnFKM=;
        b=h3UWnNd8uBKUByLV+uCRcymodyafEZhntMiOLGjd62t3QI4pASzimdnRnz48zqFpWB
         xJN42uVhMRIgRLKEudLDQIQ2WYmbJHOTZL7e0wVsItcRj4k0k3MybLwSECNybvFgolR5
         c47TFjJpHHAqP3v/xc1+czga1j9vZyspF0Kfxgudi5scenwly2ZbnAGOcx8mxbPhgTbs
         HqoTprfZekPy/1kwd3TOZWEFYcVsqEkkNQEkGOpgVvmVks1mTRjZSbU7K/PWY5H3zk8U
         zCO3rbzMjU/O1R9/ThHMC5nGDpseKeGl+nuanpbzBRNLaU2vQiyrFtroHUNMy2o8ACjh
         htMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=Ro6XsiyTG/iev3Jfb8gl0hcCfk9sgiCFxet6XwMnFKM=;
        b=teSmn20YNC24vo2R65RO5Q4RUSYN6iVsU1deL5ablb44bWpmSek8GT75mKHxGgc6sl
         oS1iEW29/hEqKwDgVnCqV7vBcO4YmNYpcs8oPphU+JCOwloIPr6Puas8fQy0T0TrKCRe
         SnRvV0DjMV3Ry6KbGPy2FlkbksZYVl3R58OrCuiXyHh0bjWfk6jqhypZxB0MXV0c//hj
         Lo40omZb6dHPQsXoHmX2dYx/LFpztNuHaP7te8DC9CuGcgBg6AmAfW2J6KxcGYLnee5X
         zfSHvMmCOy3BJuTNs3WDRML/u1X0oPNDqDlj1oJ4XKuGEV7oZpi7xPhTji7OezQExbvG
         7FAw==
X-Gm-Message-State: AGi0PuZkSEwo15HbaWXMexmgRz085TS0yUsaRHmB3nJI4GLf5LpKij5y
        FzQQ+f6ag68dH7cBTDHbUwwauw==
X-Google-Smtp-Source: APiQypI856lBJaMfYqC1N4BNX9slwX3PbSYyaVYZsWOtZr8f39kplPiBvOptALyAnXpZrWW0Vpvj+A==
X-Received: by 2002:a63:4e0a:: with SMTP id c10mr791667pgb.236.1586202824998;
        Mon, 06 Apr 2020 12:53:44 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:54d3:a29c:f391:9a0d? ([2601:646:c200:1ef2:54d3:a29c:f391:9a0d])
        by smtp.gmail.com with ESMTPSA id q67sm373344pjq.29.2020.04.06.12.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 12:53:44 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Date:   Mon, 6 Apr 2020 12:53:41 -0700
Message-Id: <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
References: <20200406185530.GE20105@linux.intel.com>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
In-Reply-To: <20200406185530.GE20105@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-Mailer: iPhone Mail (17E255)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Apr 6, 2020, at 11:55 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.=
com> wrote:
>=20
> =EF=BB=BFOn Mon, Apr 06, 2020 at 09:44:19AM -0700, Andy Lutomirski wrote:
>>=20
>>>> On Apr 6, 2020, at 4:01 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
>>>=20
>>> =EF=BB=BFOn 6.4.2020 9.42, Jethro Beekman wrote:
>>>> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make a=
 similar exception as with v86d and grant exec to /dev.
>>>> I'm not sure this is a reasonable approach. Expect most devices with an=
 Intel processor will have the SGX device going forward. Then, no one is usi=
ng noexec, so why have this logic at all?
>>>=20
>>> Intel does not control the whole market yet, does AMD also offer SGX or s=
imilar? Will SGX be also available for consumer devices? Are distros going t=
o enable SGX, will it benefit their users somehow?
>>>=20
>>> Perhaps the sgxfs approach or something else (system call?) would be bet=
ter after all in order to not force exec just because of one device. /dev is=
 usually writable, so allowing exec means breaking the W^X principle for fil=
esystems.
>>>=20
>>>=20
>>=20
>> It=E2=80=99s *possible* to create a tmpfs, create the sgx nodes on it,
>> bind-mount to /dev/sgx/..., and lazy-unmount the tmpfs.
>>=20
>> I don=E2=80=99t know whether udev would be willing to support such a thin=
g.
>=20
> sgxfs is somewhat trivial to implement and has one stakeholder less to
> worry about. It is not really a huge stretch.
>=20
> Overally, I think it is something that we could live with. At least it
> is something that does not step on others toes.
>=20
> Haitao: If we go with sgxfs route, then you can for the moment do what
> Andy suggested: bind mount it to /dev/sgx.

That also needs userspace support.

I=E2=80=99ll start a thread on the udev list.

>=20
> /Jarkko
