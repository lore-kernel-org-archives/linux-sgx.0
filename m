Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016E4C2BA17
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 16:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5F6E2256C
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 16:44:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="EiEeMF/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgDFQoX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 12:44:23 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38069 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729490AbgDFQoX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Apr 2020 12:44:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id w3so12336plz.5
        for <linux-sgx@vger.kernel.org>; Mon, 06 Apr 2020 09:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=roH6JsV1FsBoOxVCzFcZSZofE6TrYa+Py+2m2ee4VS8=;
        b=EiEeMF/NriPb/+2tlPk76pmYAn4BCNAe28KKVNoHSmAInKknbyly2nfvGxCsG/D7GG
         XB/8k9PrCtaEZ6uMfGuktGGMkQi7sWlRa7PrpLwz7YWiQNIHs+x9i9YUE9syuG+K92qY
         NDy6MMoHxhKB+b3XGm5OJCc4BXrjzvSM4Uo5tWbWJVURsB/TcwFS1qk57/dKB+tns9Bs
         AlnpNaNUlZZcqj204e7kuWQ9Kpkl52lnS9lNWKpNaVPRG+Ta5P3m1ikaSsX7Po5X3dp1
         lzqf51e97s0EGQ8Sgeg4aSxG02zVQ/SGmKeX/DgoZXPL3GzC1dKsLfYcVpBN6EWNdiGp
         YTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=roH6JsV1FsBoOxVCzFcZSZofE6TrYa+Py+2m2ee4VS8=;
        b=ZNtc+dELPaVC5hxzGy/TDMtl3DJm+589lw8JjGX8wIQaLZgz+8HaJq8rH7yo/4CSz9
         fN6ijt5kFxsvO6vXPIzs1mr+XYMfApy5EiHZbyoJprifxm41lULIqt6M8LfWQI3zzceW
         RhoVGhsKGs0CRHI385fkD0Agdjk8zs0L3WAQnuAMmZXN5nmZ5NDxq7GWmX8KXYCkUmDv
         6GPMTjF+TpbvXW8Db4VdRl4d5X6KU0wb8DDwIpC0+e41kR5QeoAl67lZm+OmXrqUIH7u
         v78PpBMtmvEwzG+08xYubpo8q4ymm0QHgwDv8p9kmDORSzN3KTxp+M8d5FmlmOugGgB3
         3znQ==
X-Gm-Message-State: AGi0Pub2MC6MKTS81OABUS5U7PS6s0xqkmpIxAlfc6Tj3/PTQjDy33SR
        pwh2UNE2FrjohU3J4OI4Hh/ZEg==
X-Google-Smtp-Source: APiQypK3L/f00d+iWEZTAI15hZczwoNLlDvkUGPDVxSYzS3/mc6ZwuZOFaLAzLrrF2P2Aktjm3qJUg==
X-Received: by 2002:a17:90a:f305:: with SMTP id ca5mr31914pjb.75.1586191462434;
        Mon, 06 Apr 2020 09:44:22 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:68c1:e473:382c:a72b? ([2601:646:c200:1ef2:68c1:e473:382c:a72b])
        by smtp.gmail.com with ESMTPSA id l18sm11196382pgc.26.2020.04.06.09.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 09:44:21 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Date:   Mon, 6 Apr 2020 09:44:19 -0700
Message-Id: <0F11A8CE-912C-4920-B281-F5AC8C0AFF36@amacapital.net>
References: <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
In-Reply-To: <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
To:     Topi Miettinen <toiwoton@gmail.com>
X-Mailer: iPhone Mail (17E255)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Apr 6, 2020, at 4:01 AM, Topi Miettinen <toiwoton@gmail.com> wrote:
>=20
> =EF=BB=BFOn 6.4.2020 9.42, Jethro Beekman wrote:
>> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make a s=
imilar exception as with v86d and grant exec to /dev.
>> I'm not sure this is a reasonable approach. Expect most devices with an I=
ntel processor will have the SGX device going forward. Then, no one is using=
 noexec, so why have this logic at all?
>=20
> Intel does not control the whole market yet, does AMD also offer SGX or si=
milar? Will SGX be also available for consumer devices? Are distros going to=
 enable SGX, will it benefit their users somehow?
>=20
> Perhaps the sgxfs approach or something else (system call?) would be bette=
r after all in order to not force exec just because of one device. /dev is u=
sually writable, so allowing exec means breaking the W^X principle for files=
ystems.
>=20
>=20

It=E2=80=99s *possible* to create a tmpfs, create the sgx nodes on it, bind-=
mount to /dev/sgx/..., and lazy-unmount the tmpfs.

I don=E2=80=99t know whether udev would be willing to support such a thing.=
