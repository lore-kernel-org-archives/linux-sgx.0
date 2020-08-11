Return-Path: <SRS0=Le6A=BV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6941DC433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 00:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E0520734
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 00:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="jXfYK3Ob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgHKAwN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Aug 2020 20:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgHKAwM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 10 Aug 2020 20:52:12 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1540C061756
        for <linux-sgx@vger.kernel.org>; Mon, 10 Aug 2020 17:52:12 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p1so5992903pls.4
        for <linux-sgx@vger.kernel.org>; Mon, 10 Aug 2020 17:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=kHhE3KrqVSlK0oFrxg5v1Xt0D8wngSHyqdeNULILsHk=;
        b=jXfYK3ObsyUOF4jk+4aHI3bUqrwfSAsPwkkEo1V5liUVdrTCMjNvieOlq8Bpc7OKGJ
         hhNCTr+1YJAutODjagxDTxqwQ4DYSHaSy3crmF1RpydqxJFddvI4zFY8Dj8u5J+vHane
         G96bX15HcRFwp7IOdK4VVuUDrCAU923wDnlbZBm9jwA1fM7lnjw9m7P97T9ToXQqSH1U
         2FfQerKg0X3gF3su+FFfQjdPBm7tDXGIq0OmJAm6HDCCduQou3LCsfmfTA083Mko18hH
         gZUM85Ribs45yLd7GwUa+FLIEtiU/lrmz881fxedsyxp/3UvjVNwZRBXKJaEGSU7WiA/
         VPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=kHhE3KrqVSlK0oFrxg5v1Xt0D8wngSHyqdeNULILsHk=;
        b=K2zRI523/HUic7dVFGHroGjSM3n4V8JBRsk650KKfBxLZ87PdCEQGT4iCQmBLgDBLV
         H9fAYwY8smsE3O6usnxjovntcjzCmDlxHx78+X5fkAypIOZHj+0f/Oruhd82ly417iYS
         /5jjxfMfwFhZ/1R3nkKJ9tZq+utTwj4szsQM/7TdY4fMfxnb0rn8hmuUyUVZ60j/wbk/
         BalPbHdCitbWvpKME8vqVwV/NEbx1VAJ7lb+cs/yD+H+1FCSgPabgoicSFNcSPnoFOQG
         A4yIXg6UWWW2rwN2d1qE8dwJurKb259RPj5RE1GK0rI59p57R5v7gnSLDaxnnLaNw2fQ
         aYvQ==
X-Gm-Message-State: AOAM530vt1YrIaJ0B3DI7tfGF3bxqayL2vRkclEAKY8w48dux4//VZ+z
        2rcFB7FkbjMa3pfWbIQFbjZrAQ==
X-Google-Smtp-Source: ABdhPJxwJs3I5b3pGXSul2QL1pi5Yk6chwUGXOPyMrzXwEwUOvwrnP8hZHRLjI+SbL4tdb/gyJ4i9A==
X-Received: by 2002:a17:90a:eb18:: with SMTP id j24mr2000716pjz.76.1597107132033;
        Mon, 10 Aug 2020 17:52:12 -0700 (PDT)
Received: from ?IPv6:2600:1010:b06c:4273:ede1:e14c:cb3e:8ecb? ([2600:1010:b06c:4273:ede1:e14c:cb3e:8ecb])
        by smtp.gmail.com with ESMTPSA id np4sm679997pjb.4.2020.08.10.17.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 17:52:11 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX enclave call
Date:   Mon, 10 Aug 2020 17:52:09 -0700
Message-Id: <DD7996A6-CBA3-47CE-8DF2-9A6ADD3FE89E@amacapital.net>
References: <20200810234837.GH14724@linux.intel.com>
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
In-Reply-To: <20200810234837.GH14724@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17G68)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Aug 10, 2020, at 4:48 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
> =EF=BB=BFOn Mon, Aug 10, 2020 at 04:08:46PM -0700, Andy Lutomirski wrote:
>> What am I missing?  I still don't really understand why we are
>> supporting this mechanism at all.  Just the asm code to invoke the
>> callback seems to be about half of the entire function.
>=20
> Because the Intel SDK (and other SDKs?) wants to use the host stack to pas=
s
> parameters out of the enclave.

Ugh, right.  I forgot about that particular abomination.

I suppose that passing a context pointer would be reasonable.=
