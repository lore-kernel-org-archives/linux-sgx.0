Return-Path: <SRS0=Le6A=BV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2072AC433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 15:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD472083B
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 15:16:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="MeJLmJ95"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgHKPQ6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Aug 2020 11:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbgHKPQ6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Aug 2020 11:16:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC96C061787
        for <linux-sgx@vger.kernel.org>; Tue, 11 Aug 2020 08:16:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kr4so2029016pjb.2
        for <linux-sgx@vger.kernel.org>; Tue, 11 Aug 2020 08:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=4+b6jTuGlXmVlD8HlgYNXs6m+RU4qSmvnoJzysAL5Mk=;
        b=MeJLmJ951LLcL2CYfs/yQVJFJ9J1W90tNpCr6pOdQ/BpWwSx+Ygnz+mIp1sUtN2Qe7
         y7anoGfMzcKvyBClLaMa7oGZb6Lt7kfONYPZ/HcOnqS+aqPRV/lQwLN9JXbbkiMcMCLS
         NNDiEAQi9844hRMKiySWxHblNXaOyP4qMba8TKnBQK4APNTo4QH72lfU0ZcnCE6eve5Q
         FVKvC/X2QTFbdgkzIUAuZiSoIXXazREopnJ6sJAOonAftUBBHw2K7ljG6pRiD2a9qNc/
         h6YHn2mYxXnds0EWwdC/UfG2B0cy68DeWfvHicVk8SUPbbI2mMKCSqpSZJRpahdWvKl4
         Q8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=4+b6jTuGlXmVlD8HlgYNXs6m+RU4qSmvnoJzysAL5Mk=;
        b=KaPF6slbSgeyBQSCKBToZfQcHPtuL4DP/Olg847wk4kQ2NEhApIeRNdiwA6KM64wBA
         aabxXJbNI4ZB1fa4iupJ25yHIahqkooLUC5DHovG9oiCq9p0zC64cidGVCLgFWRtxaJE
         pNkXyClOLccSpQAXQrITExXW4HaxzWlCylKkUvMC+C6RhQ48JO+keb3g2WCE4kRzE2R/
         WqA8CRbikF8NFU4ThhaNze7pWSM9S/Us7ORqEywcQo1qyS/SmLNqJosoDsVQS2w2V6bZ
         h4/LQxbSLEGauqVQBT1pYCAxUTOPjeDXSAvfbt308g/GtEKI9rcCz6g2fKMauTHRq7sb
         uh0w==
X-Gm-Message-State: AOAM533mWKsH0ZE/4DZfR56pm1UWZy/5JkoLn5517GzRzP0QHxTZG1cn
        mI7Mxy8gqYYFxWfwrQe64j8CTg==
X-Google-Smtp-Source: ABdhPJxI7YT//WvgGe2pjVI/MU1BWMAXsyQSOzYWzW5dOa/e4g2aUCGwMCtOQGiROFBoWLKU2vVsiw==
X-Received: by 2002:a17:902:9a0b:: with SMTP id v11mr1398608plp.236.1597159017693;
        Tue, 11 Aug 2020 08:16:57 -0700 (PDT)
Received: from ?IPv6:2600:1010:b06c:4273:ede1:e14c:cb3e:8ecb? ([2600:1010:b06c:4273:ede1:e14c:cb3e:8ecb])
        by smtp.gmail.com with ESMTPSA id s22sm26039548pfh.16.2020.08.11.08.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 08:16:56 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX enclave call
Date:   Tue, 11 Aug 2020 08:16:54 -0700
Message-Id: <C107C4D3-1730-41BA-960C-C75B32DB43A0@amacapital.net>
References: <DD7996A6-CBA3-47CE-8DF2-9A6ADD3FE89E@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
In-Reply-To: <DD7996A6-CBA3-47CE-8DF2-9A6ADD3FE89E@amacapital.net>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17G68)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Aug 10, 2020, at 5:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>=20
> =EF=BB=BF
>>> On Aug 10, 2020, at 4:48 PM, Sean Christopherson <sean.j.christopherson@=
intel.com> wrote:
>>>=20
>>> =EF=BB=BFOn Mon, Aug 10, 2020 at 04:08:46PM -0700, Andy Lutomirski wrote=
:
>>> What am I missing?  I still don't really understand why we are
>>> supporting this mechanism at all.  Just the asm code to invoke the
>>> callback seems to be about half of the entire function.
>>=20
>> Because the Intel SDK (and other SDKs?) wants to use the host stack to pa=
ss
>> parameters out of the enclave.
>=20
> Ugh, right.  I forgot about that particular abomination.
>=20
> I suppose that passing a context pointer would be reasonable.

The alternative would be to pass in a parameter that gets put in RSP before e=
ntering the enclave. The idea is that the untrusted runtime would allocate a=
 couple pages with guard pages at either end, and enclaves using the regrett=
able arguments-on-the-stack scheme would end up using the alternative stack.=


At the end of the day, none of this really matters too much. Languages that c=
an do inline asm but can=E2=80=99t do container_of() can get fixed or use wo=
rkarounds.=
