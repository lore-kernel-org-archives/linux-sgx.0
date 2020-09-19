Return-Path: <SRS0=u4vM=C4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C45C43463
	for <linux-sgx@archiver.kernel.org>; Sat, 19 Sep 2020 00:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2959321D20
	for <linux-sgx@archiver.kernel.org>; Sat, 19 Sep 2020 00:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="pTu609JD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgISAPf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgISAPe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 18 Sep 2020 20:15:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F51C0613CE
        for <linux-sgx@vger.kernel.org>; Fri, 18 Sep 2020 17:15:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id bw23so1176050pjb.2
        for <linux-sgx@vger.kernel.org>; Fri, 18 Sep 2020 17:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=JjoTQD9k/YNjHDMyF9HkazPPcdhfN64N/oHVL1W2cNg=;
        b=pTu609JDpceDsCQlOeQUbpODmjkUkHE2LjL3lRajVYkKFo+X4VzhgldeoEJB/Deex0
         iPiwYL+AIk/T655F3Aur+njmUTo4THqYIU6uqPlbdG25ZLz1kx9qxVfr2gjoE84foBLv
         Juee/4vSKawywOKJTGP+MAQCuu31IAw843xlmEHxXlbYP5KBM0eclk/V48SVRUHv/fmL
         NhBrYzPE0/6yTWb4WaMu0I7GL0fmsjosndNfI6yC/O8htEiPFvkEyfVJXZ7WE3BOo2fq
         eUTEtIyyKuE+xeU9fw8fkgvDqWq2nNoU7yYWal1FP54ZvmlkvAQvLYFNIRsmEk0L2u5Q
         O5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=JjoTQD9k/YNjHDMyF9HkazPPcdhfN64N/oHVL1W2cNg=;
        b=GdCMvs4kD3Sp4O1gcNG+yd98MAAqsCCWMcR3r0fplRjd8N5aswnj4EBVVi+LGvH40a
         tFsjSHTMgWdtYs39Iun5VD2dLUJMLOCHN7ZYXEQGVU1G/nc61W1f8pNXM98LlDoWtRHa
         xFh26pgkaNVle2W0u43R2DtXHeDhtUSttnr/p1JpV3l/Xkp6J8ZPk2eoZcbEheLe1fOm
         TsIdEW5w+FDmgCTqZ9ZFyqtT8gmBqiOxF6Csl8RDp+UB9wEyo3Uq4qJecpGcFaV4tdFz
         IJuR0jJqeXGCpFSz8HPpBBiKHNcaurakWqBrXI6HHXSbhWcyTwVQTJ/NpkfTXy5IArIy
         sLZg==
X-Gm-Message-State: AOAM5321aHG2hWCvIXJpALw3eMvo9aAeTks8mh3PfzL202tPkYTJCNtV
        TLJqP7GJ07OJRKm9dCCaZSLWNW5WvHjw+A==
X-Google-Smtp-Source: ABdhPJzgaC77hTi4MmsduZHXcJkp4OVVRQSWL+E7Vd4DtZRT3kuy3vlwB6EmliXRcr7GIOm9JoACRQ==
X-Received: by 2002:a17:902:b7c4:b029:d2:173:34ba with SMTP id v4-20020a170902b7c4b02900d2017334bamr8356996plz.57.1600474534178;
        Fri, 18 Sep 2020 17:15:34 -0700 (PDT)
Received: from localhost.localdomain ([2601:646:c200:1ef2:f83f:aa5b:2153:6724])
        by smtp.gmail.com with ESMTPSA id g32sm4321339pgl.89.2020.09.18.17.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 17:15:33 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Date:   Fri, 18 Sep 2020 17:15:32 -0700
Message-Id: <1B23E216-0229-4BDD-8B09-807256A54AF5@amacapital.net>
References: <20200918235337.GA21189@sjchrist-ice>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
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
In-Reply-To: <20200918235337.GA21189@sjchrist-ice>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (18A373)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Sep 18, 2020, at 4:53 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
> =EF=BB=BFOn Fri, Sep 18, 2020 at 08:09:04AM -0700, Andy Lutomirski wrote:
>>> On Tue, Sep 15, 2020 at 4:28 AM Jarkko Sakkinen
>>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>=20
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>=20
>>> Add vm_ops()->mprotect() for additional constraints for a VMA.
>>>=20
>>> Intel Software Guard eXtensions (SGX) will use this callback to add two
>>> constraints:
>>>=20
>>> 1. Verify that the address range does not have holes: each page address
>>>   must be filled with an enclave page.
>>> 2. Verify that VMA permissions won't surpass the permissions of any encl=
ave
>>>   page within the address range. Enclave cryptographically sealed
>>>   permissions for each page address that set the upper limit for possibl=
e
>>>   VMA permissions. Not respecting this can cause #GP's to be emitted.
>=20
> Side note, #GP is wrong.  EPCM violations are #PFs.  Skylake CPUs #GP, but=

> that's technically an errata.  But this isn't the real motivation, e.g.
> userspace can already trigger #GP/#PF by reading/writing a bad address, SG=
X
> simply adds another flavor.
>=20
>> It's been awhile since I looked at this.  Can you remind us: is this
>> just preventing userspace from shooting itself in the foot or is this
>> something more important?
>=20
> Something more important, it's used to prevent userspace from circumventin=
g
> a noexec filesystem by loading code into an enclave, and to give the kerne=
l the
> option of adding enclave specific LSM policies in the future.
>=20
> The source file (if one exists) for the enclave is long gone when the encl=
ave
> is actually mmap()'d and mprotect()'d.  To enforce noexec, the requested
> permissions for a given page are snapshotted when the page is added to the=

> enclave, i.e. when the enclave is built.  Enclave pages that will be execu=
table
> must originate from an a MAYEXEC VMA, e.g. the source page can't come from=
 a
> noexec file system.
>=20
> The ->mprotect() hook allows SGX to reject mprotect() if userspace is decl=
aring
> permissions beyond what are allowed, e.g. trying to map an enclave page wi=
th
> EXEC permissions when the page was added to the enclave without EXEC.
>=20
> Future LSM policies have a similar need due to vm_file always pointing at
> /dev/sgx/enclave, e.g. policies couldn't be attached to a specific enclave=
.
> ->mprotect() again allows enforcing permissions at map time that were chec=
ked
> at enclave build time, e.g. via an LSM hook.
>=20
> Deferring ->mprotect() until LSM support is added (if it ever is) would be=

> problematic due to SGX2.  With SGX2, userspace can extend permissions of a=
n
> enclave page (for the CPU's EPC Map entry, not the kernel's page tables)
> without bouncing through the kernel.  Without ->mprotect () enforcement.
> userspace could do EADD(RW) -> mprotect(RWX) -> EMODPE(X) to gain W+X.  We=

> want to disallow such a flow now, i.e. force userspace to do EADD(RW,X), s=
o
> that the hypothetical LSM hook would have all information at EADD(), i.e.
> would be aware of the EXEC permission, without creating divergent behavior=

> based on whether or not an LSM is active.

That=E2=80=99s what I thought. Can we get this in the changelog?=
