Return-Path: <SRS0=I7Yp=4J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EF9C11D00
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 00:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53985206EF
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 00:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="L2xq9Vle"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgBUAc1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 19:32:27 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37042 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbgBUAc0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 20 Feb 2020 19:32:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so275126pfn.4
        for <linux-sgx@vger.kernel.org>; Thu, 20 Feb 2020 16:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=z2DSekIXnkX9eU39ZMxeSaJ+Ey4ada2j/LjI3viMpe8=;
        b=L2xq9Vle6jxp9WXJix/nJ1E6aNq25XGRDldBnE6uRfHPTKAZidzklN+ABPMmf6twdj
         9iF+ezVYOWPSBqEKGBFsP667oRit4McJEgy0SnPH61oD5WigzY6ow9ds+A4YVkKCg71+
         isZ9j8P++FFMlx1PqFw2gd5fAr2ryaDc1lybA8W/uuAZFCMG/J6CL3EM1K8nQ/sEMLMr
         R4yNGXen8b9ERC8Inh1eMrA9zbbvEY7KBfc0E7lwgRjD71sZku0KLC5Wub0HyEN+1azo
         A7y9Aq2fiHX8eP7WA9XiUVTh11d13PprbklWSMPwnVUjKJeB7br7pZScqcu/sxf5hmEZ
         ZLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=z2DSekIXnkX9eU39ZMxeSaJ+Ey4ada2j/LjI3viMpe8=;
        b=GypKCYL9g1nKvhhA8H8M2zRlC8Gaybb29bm6JGPJyl7BOfmoId544BSyoUjpxtR2hA
         gEVKSQSNQvvOUuI/u7Lrl1ILwJJfWZe6gg8FSJ74Gi5J5PgbnvK5KHc4gU4RWUDyaxYx
         44OW++fPqRu/69KCwE+o21Al1GY44lHxmfySAbZv2MeDctPultwtTOkKdAOjlkjIJPNR
         9/l6io0xXMfeNDI0PsNshsNUUeLTpuFKpOHj9hjEiF1NUOHAlcPmeSyf4M5tlXaxe+PV
         GSORCEvJcJ/E4+V/K8prgmoxLyGqXIglxX3AUYMNbzrKMX/tu8GM9yGBWyZrA7zAL05Y
         85gg==
X-Gm-Message-State: APjAAAX3eIO4DcG0DaNGY46G8PiOvlfjCoiz39ln/mNDQtIXYzxHZZbp
        dGyHVYrQKIHOLOB/biHgQ/J4+Q==
X-Google-Smtp-Source: APXvYqw+4sLKln1oYdQ5ZrfvbhT1EDHvVbA/mNOVE6O5bdOhE1oFR/NW3nQfak7gZ3wI/2EWOdZ/fg==
X-Received: by 2002:a63:9919:: with SMTP id d25mr35049553pge.22.1582245146084;
        Thu, 20 Feb 2020 16:32:26 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:511c:ebc0:d124:b4a0? ([2601:646:c200:1ef2:511c:ebc0:d124:b4a0])
        by smtp.gmail.com with ESMTPSA id f43sm540853pje.23.2020.02.20.16.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 16:32:25 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Date:   Thu, 20 Feb 2020 16:32:22 -0800
Message-Id: <6AE5891F-FC0D-4062-A6CA-01C78C2D5A1A@amacapital.net>
References: <20200220221607.GB26618@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
In-Reply-To: <20200220221607.GB26618@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
X-Mailer: iPhone Mail (17D50)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org




> On Feb 20, 2020, at 2:16 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.=
com> wrote:
>=20
> =EF=BB=BFOn Thu, Feb 20, 2020 at 10:48:42AM -0800, Sean Christopherson wro=
te:
>> My biggest concern for allowing PROT_EXEC if RIE is that it would result
>> in #PF(SGX) (#GP on Skylake) due to an EPCM violation if the enclave
>> actually tried to execute from such a page.  This isn't a problem for the=

>> kernel as the fault will be reported cleanly through the vDSO (or get
>> delivered as a SIGSEGV if the enclave isn't entered through the vDSO), bu=
t
>> it's a bit weird for userspace as userspace will see the #PF(SGX) and
>> likely assume the EPC was lost, e.g. silently restart the enclave instead=

>> of logging an error that the enclave is broken.
>=20
> I think right way to fix the current implementation is to -EACCES mmap()
> (and mprotect) when !!(current->personality & READ_IMPLIES_EXEC).
>=20
> This way supporting RIE can be reconsidered later on without any
> potential ABI bottlenecks.
>=20

Sounds good to me.  I see no credible reason why anyone would use RIE and SG=
X.

> /Jarkko
