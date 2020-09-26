Return-Path: <SRS0=fqiI=DD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FCDC47426
	for <linux-sgx@archiver.kernel.org>; Sat, 26 Sep 2020 04:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7D72080A
	for <linux-sgx@archiver.kernel.org>; Sat, 26 Sep 2020 04:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="BWnMfRXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgIZEPY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 26 Sep 2020 00:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730001AbgIZEPX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 26 Sep 2020 00:15:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059D5C0613CE
        for <linux-sgx@vger.kernel.org>; Fri, 25 Sep 2020 21:15:23 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b17so484777pji.1
        for <linux-sgx@vger.kernel.org>; Fri, 25 Sep 2020 21:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=KUTsQ4cRgo7tcvKxTzbTra/DQ+skBopOu8YgTTZQp+o=;
        b=BWnMfRXUFKWpwia+E3QCxxaGzaHx+nORFT5Orpdeojhqss9dXtuYypFi6XTnsJ3WjW
         WEkjoK65wFyrvC73Uj4kbseBI6mjY8eI00R1vA7WhobCZE/0rP0GNtVPhFli7UV8Dl/h
         byjFxzHO9ScP+K55Ql6Rk8wrBGTASEGmQ12Kb9PNQ7J90+N7zvbXrlNrBQFcJJV8S2rn
         xUTWlqa18psooaWuTDDBTjmNpwjnO0T8EU6JYdLZpmN++wFoU6QFG7eeYK1CWTGKq17K
         RP1E8gLbK+aIf5TJRRCKDWGWep7Saozz5gdF6pyCSCrIAFp0gSKBE91tdnp4Y5Np7IuE
         b1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=KUTsQ4cRgo7tcvKxTzbTra/DQ+skBopOu8YgTTZQp+o=;
        b=HfnPtFObugIlPGmZdhn9R3+JvpQmey6E3KcjKdqINXtDr63vLbDSKCjFiDdrfl2eGo
         G4/+6g6KvYZ2/vUwiu2cMHWaxSVdgfOuGF77HZ8UCXQSSIbbnVJQr0nkWylDvU4AbRvK
         a0TEcFNyvLU5YMhOPX8TVt7XnRMY5+mz3UO1dI1l4GC8BT0E26WHGp1s4ZOH/fmBh4uo
         PR0/6zkP2vpou/Gun/YHFoRXqBvCUZ2f49OptQ6O9EHYZqvRXQ65DTmTgjtqhi5DQSfZ
         4HDJOCCH4RiaipFRsTIXIkxRjja548jqaWyjhdhpDIhkwMGHNFJAiCqMg5p79WFi0nB1
         to4A==
X-Gm-Message-State: AOAM531GGFHeF0eR29yRzOsUn7551hdLtRzo2bftryfEafCFtqKzFZuQ
        PZ2S2HivTdOcD+emt5sKqWKBWA==
X-Google-Smtp-Source: ABdhPJzsb5zohq/TAtZ5fioaotDPmq8e15jJlMaKFeemNTlWPQEVFAiwftJs/1T1diVswdmRcQu08g==
X-Received: by 2002:a17:902:b18f:b029:d2:1ec0:4161 with SMTP id s15-20020a170902b18fb02900d21ec04161mr2444866plr.58.1601093722526;
        Fri, 25 Sep 2020 21:15:22 -0700 (PDT)
Received: from localhost.localdomain ([2601:646:c200:1ef2:65a8:3322:5d17:ae5b])
        by smtp.gmail.com with ESMTPSA id gg19sm505756pjb.49.2020.09.25.21.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 21:15:21 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Date:   Fri, 25 Sep 2020 21:15:19 -0700
Message-Id: <2321E653-F629-44D7-91C3-F42F42AF4EF6@amacapital.net>
References: <230ce6da-7820-976f-f036-a261841d626f@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
In-Reply-To: <230ce6da-7820-976f-f036-a261841d626f@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: iPhone Mail (18A373)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Sep 25, 2020, at 12:53 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> =EF=BB=BFOn 9/25/20 12:43 PM, Sean Christopherson wrote:
>>> That means that the intent argument (SGX_PROT_*) is currently unused.
>> No, the intent argument is used (eventually) by SGX's ->mprotect()
>> implementation, i.e. sgx_mprotect() enforces that the actual protections a=
re a
>> subset of the declared/intended protections.
>>=20
>> If ->mprotect() is not merged, then it yes, it will be unused.
>=20
> OK, I think I've got it.
>=20
> I think I'm OK with adding ->mprotect().  As long as folks buy into the
> argument that intent needs to be checked at mmap() time, they obviously
> need to be checked at mprotect() too.
>=20
> Jarkko, if you want to try and rewrite the changelog, capturing the
> discussion here and reply, I think I can ack the resulting patch.  I
> don't know if that will satisfy the request from Boris from an ack from
> a "mm person", but we can at least start there. :)

I think I agree. ->mprotect seems reasonable to me.

FWIW, I don=E2=80=99t think I should ack this particular thing =E2=80=94 it w=
as, to a decent extent, my suggestion in the first place, so I=E2=80=99m bia=
sed. I think it turned into something reasonable, and the ->mprotect mechani=
sm seems easily supportable and plausibly useful for other purposes down the=
 road.

>=20
> Please be judicious in what you include in the changelog.  There's been
> a lot of detritus in them.  Let's keep it as short, sweet, simple and on
> topic as we can.
