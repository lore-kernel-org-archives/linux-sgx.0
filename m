Return-Path: <SRS0=o5ed=5U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E384C43331
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 03:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C111520731
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 03:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="k/6PnPQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDDDyo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 23:54:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43713 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgDDDyo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 3 Apr 2020 23:54:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id v23so3593628ply.10
        for <linux-sgx@vger.kernel.org>; Fri, 03 Apr 2020 20:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=asXMkTyrOvEE02xuiVAWaXD0gf6u/5dy4hT6/FIMAgg=;
        b=k/6PnPQ3gTjN4LN4T+gkqiUQO8zU2TAexHg7VLl70wAVwZ+pPCLqzORkO1KWV2+UKE
         kSh8H6gcLJDFteS4Q+oOsYhD72+OnZLFUrkEloPtnNsrmRQ/IBxo7h6Gu0YRYRUKqhQe
         hARyiIE7pko2N11Wk7tGeHb+aWa7XlmcAYDe6pMC+ozSUFrHeAY53qJacCYYkaqbcPcp
         GBvEdN6YQm2Pku5NQsoGacSmMVSmg1md7Ng7dmDzwwcx1yFM49g2czLEMk8/rGWUIg1n
         uD/SJTRzVg1rZBNEIvL+zx0j4H5WwrSgB7pM/N/0hoaoe82jfR009+8jALFmsUZyS3XX
         OwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=asXMkTyrOvEE02xuiVAWaXD0gf6u/5dy4hT6/FIMAgg=;
        b=bvhUgacOrajoVuujK3LrZrNFd1Mi/5B+PqXQo71WrGiNB+UpUlFAfYv+xUE8pmeOKI
         dJhFzZRrLRoow3UNdAR60CXib1LoZcWPLm5kVCuobcXy1bLEyGIUe6YnkRLimKIYBA76
         H1B/4hljeBNYXc3rPgyGHEcwdvujHhh2z7gR7S5ncgNfcvETKBi/QSrWjlhp4x+0KfGV
         k5z8WSDXdgjxrfLNcFOPxn31BjX3FPsEmDRh6bd87ktiU8vwIe6OIUI4xwLkWzntkUrl
         LHDS5hhF67S1Y02/ebJBqMn9Gv7XiR9BqJcdTtOPvq+aop2xoGyCaQ8MXcrjSDzmZ7q0
         xo/g==
X-Gm-Message-State: AGi0PubaqlZe1dJJUNZPjeY9OGG4VL9FtOAI0R2MeNw0RTGBBTL0D45t
        veLJ51ooBd/CX/iyVZ1MwLda9A==
X-Google-Smtp-Source: APiQypLFMw3hD/Z9bFupBC9CdoVSMyZZTxE1wsE5ijj6sAvYEnPnsSl8/g/uywUaDviNhbq+QjlDnA==
X-Received: by 2002:a17:90a:71c5:: with SMTP id m5mr13887469pjs.193.1585972483357;
        Fri, 03 Apr 2020 20:54:43 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:7003:efbc:3c22:ea6f? ([2601:646:c200:1ef2:7003:efbc:3c22:ea6f])
        by smtp.gmail.com with ESMTPSA id y4sm6859668pfo.39.2020.04.03.20.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 20:54:42 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Date:   Fri, 3 Apr 2020 20:54:40 -0700
Message-Id: <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
References: <20200403220848.GA7588@linux.intel.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
In-Reply-To: <20200403220848.GA7588@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-Mailer: iPhone Mail (17E255)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Apr 3, 2020, at 3:08 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.c=
om> wrote:
>=20
> =EF=BB=BFOn Fri, Apr 03, 2020 at 08:50:08AM -0700, Casey Schaufler wrote:
>>> How does smackfs interact with namespaces?
>>=20
>> Smack attributes are global. Aside from privilege issues, namespaces
>> ignore and are ignored by Smack.
>=20
> Okay.
>=20
> For SGX, I foresee things as:
>=20
> 1. Existing files are global.
> 2. If a policy of any kind is ever added it needs to be *per container*.
>   I'm not sure whether PID or user namespace is the right choice here,
>   but does not matter right now as the feature is not in the queue.
>=20
> To summarize:
>=20
> 1. We have a heterogeneous set of files (i.e. 'enclave' and 'provision'
>   are not "different sames").
> 2. The files probably will have heterogeneous visibility requirements.
>=20
> I think based on these premises own file system would be a more decent
> choice than populating /dev. Beside, SGX hasn't been a driver for a
> while.
>=20
> Andy, what do you think of this?

Probably okay.  There are two semantic questions you=E2=80=99ll have to addr=
ess, though:

- What happens if you mount sgxfs twice?  Do you get two copies that can div=
erge from each other, or do you get two views of the same thing?

- Can it be instantiated from outside the root initns?

It=E2=80=99s certainly conceptually simpler to stick with device nodes. Why e=
xactly is Ubuntu noexecing /dev?

>=20
> /Jarkko
