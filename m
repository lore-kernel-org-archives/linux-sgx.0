Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44967C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 20:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FF22078A
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 20:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="dnx5NXi4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHZU4D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 16:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgHZU4C (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 26 Aug 2020 16:56:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CC9C061574
        for <linux-sgx@vger.kernel.org>; Wed, 26 Aug 2020 13:56:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id p11so1693116pfn.11
        for <linux-sgx@vger.kernel.org>; Wed, 26 Aug 2020 13:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=y5azs/YmL64kbtJ2uI/p4/UB7DUuLQrfTEFUiv2VACI=;
        b=dnx5NXi4QiobUejlHephFfBlrUf9G1jBPzI+iRTMACGxWBP/ktQrOnwGHg9Navyvlp
         f8KcKNd8V6wkRbQF37q+jHkh4hmiPSg0Q9c5lBXIomLHZ2Qa2J0py0klH26KTdz3o32a
         UfGOPoGCpPyMSNpPtgK4Rt9lbTWdfisc+Rn6w2T6UZw6n7N5FIL8IPng5DBKrG6uem7U
         5GJ+JAOjAQ9ykp4oWzqZRpz9uI7+BYcgu7H9IWb7n9Sy/61wdR26ybXQkBeIUSRFjPCW
         TVGgfKzJPM5K6NoG2CA92+O2OIUfi/aR3a4FIn3TFsWg/rjPvuhtlPju9FKssPd9b8vn
         XjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=y5azs/YmL64kbtJ2uI/p4/UB7DUuLQrfTEFUiv2VACI=;
        b=A1Pu/t6eKRizvv4PeT7UMOB4Mmj4Osddjw0i/UC7TJWOhf6N3SfkFvPYZLxsM880r3
         D/xaq/0vXjTc75FvRkg35+UKU0wSaHYm0tanmW4bTBBMTzRiAO0j1+LMXegGlxWxWbHX
         2XpbgvtkfC5NWxiQLSSxYdf7gd45BG0KKLRz+MkAYa2bMyvYN4+QPIt71Rk1fn3EDeWT
         dLus7qGHz6MovSjveD0z+XaDArcoKnpFQ6c/5xHVq5TNCw2thSGwRMK4BW3G8iSWDNKL
         wFfB1TErRgYf3r10QUr7FlFqj3IR4YkBkoVd0Z9z5fkUnysfhV+T6H1hbIWcUFmUMOFF
         auYQ==
X-Gm-Message-State: AOAM530TyjS1y+PtYolp24lzEJTRY3g/Axe1oNG+m8Yc9tIO39k0mict
        25RCsqKawXeymlPrusNM3LX8hg==
X-Google-Smtp-Source: ABdhPJyESd49N3s4iECkT/QTYhdOKNjPMBAba13cjOidYxQg7ahmPxIDXtut9PayL/NCJEO8aJqMZA==
X-Received: by 2002:a62:8387:: with SMTP id h129mr13615533pfe.142.1598475360479;
        Wed, 26 Aug 2020 13:56:00 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:d5cb:47c1:6fcb:aad4? ([2601:646:c200:1ef2:d5cb:47c1:6fcb:aad4])
        by smtp.gmail.com with ESMTPSA id t25sm2959752pgl.60.2020.08.26.13.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 13:55:59 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework __vdso_sgx_enter_enclave() API
Date:   Wed, 26 Aug 2020 13:55:55 -0700
Message-Id: <ED79461A-86DC-4D00-970B-481AE2E04C5D@amacapital.net>
References: <20200826202029.GD21459@sjchrist-ice>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>, linux-sgx@vger.kernel.org
In-Reply-To: <20200826202029.GD21459@sjchrist-ice>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17G80)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Aug 26, 2020, at 1:20 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
> =EF=BB=BFAndy,
>=20
> Any thoughts on using a struct versus a plethora of params?  If you don't
> have a strong opinion, I'd like to push for the struct option as it fixes
> the -EFAULT weirdness, satisfies Nathaniel's request, and gives some
> flexibility for the future.  The code impact, both to the vDSO and to the
> caller, is largely a lateral move, i.e. it's different but in the end
> doesn't require any more or less work.

I have no preference.

