Return-Path: <SRS0=NXiG=NL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C60C0044C
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Oct 2018 22:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BECE2081B
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Oct 2018 22:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="XaiMl72f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BECE2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbeKAHxB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 03:53:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43078 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbeKAHxB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Nov 2018 03:53:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id n10-v6so8055019pgv.10
        for <linux-sgx@vger.kernel.org>; Wed, 31 Oct 2018 15:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=34oUEVmdExJTvIxAgkSp6dTCD1gbn7r2Kaeog/RXUYA=;
        b=XaiMl72fn5zHAN7O7DPzuTczWEiVBIY1cx2dFIMLlSh8nUUf+AUPToZKfYyLBD/LcG
         BSQNS47dk1LtYYnZvI7kdoZQQhMSharZ5nBx/gZ7GviA30uJgben1/qMNCYlpqP0l481
         d8YEeNiuGAH7ftF77EiNqZ5y9tulBZeA88h3yXoM+cCsInEYtb1duNKB5wPfy1jNYVBj
         KzNFYr/Vg071scXqfyjN/InBpQQ0fhuZL5JOVVWxgPDaijzwfpvYH0eoFBA4ktBpplZI
         uYBynq18/MHWFSdKkyLab/IU83o1cQfE+LgTfLjO9xlfRZVs/+1/qSr3APlQJoWTmYy3
         brog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=34oUEVmdExJTvIxAgkSp6dTCD1gbn7r2Kaeog/RXUYA=;
        b=ceCb1TKeHpRfvhDNe4I02VEJzdakz7z0q2NMS/RpfApJrtSQI+ABLvS0a0HYBxeLf4
         7vwkkV9Aj4SK216D0gho37bxnNCWv3C6KM/YtRrI51ytEfgmRb7VS1dyT5bd6O+q62Jv
         xqz7fbpp9nGxl4CkoDvwrd6AzvyRPKkeaMel6JowC67MP4idQMUf8jnNGVaFezEWJM9B
         SUiTJxIDIreQh6GtpfGFRtdAajPjJgtDfyOQSR1UvtPwByp+3/S0hRHDg0HQT3v2byWb
         +LdSmmgA6YmUc400HdDJ7Dz1RljGmZcmlurveGhB6kl+1hajznKTZpYoi3ldaCh+fJkg
         C7qw==
X-Gm-Message-State: AGRZ1gI/0bYWl+PDDhOJpW0cwHwBCwjuAdWxKXUhDK6vSHRIP5Strhw6
        s0wUMLQSSF73JOcni5QK081eZQ==
X-Google-Smtp-Source: AJdET5ewxXiz5cNB3vs1OEZ8Vxct1UP5fp/Ai1iWNpkBWgEhWwNDv64TMGT4qtGf4CNjY1VWWc8F/Q==
X-Received: by 2002:a63:8c0b:: with SMTP id m11-v6mr4941953pgd.422.1541026373535;
        Wed, 31 Oct 2018 15:52:53 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:7429:3d1b:ef7:2c4c:5b1? ([2601:646:c200:7429:3d1b:ef7:2c4c:5b1])
        by smtp.gmail.com with ESMTPSA id u12-v6sm22825083pfi.83.2018.10.31.15.52.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 15:52:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/ PF_SGX
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16A404)
In-Reply-To: <a6deac4e-ce8f-aa43-2d75-a04c05bac104@intel.com>
Date:   Wed, 31 Oct 2018 15:52:51 -0700
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2833FD27-42A0-435C-AEA5-2DC73315867A@amacapital.net>
References: <20180926173516.GA10920@linux.intel.com> <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net> <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com> <20180926204400.GA11446@linux.intel.com> <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com> <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com> <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com> <20180927135603.GF8242@linux.intel.com> <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com> <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com> <20181031213036.GA23089@linux.intel.com> <a9c23203-476d-875d-9fbb-263716833e17@intel.com> <dc0f8bc8-4d69-517e-68af-abda2d51423f@fortanix.com> <a6deac4e-ce8f-aa43-2d75-a04c05bac104@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181031225251.n9qMGbUnPvTSwsJycp_mRu-dyGNn8QFwQZfjA3K845A@z>


> On Oct 31, 2018, at 2:58 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
>> On 10/31/18 2:53 PM, Jethro Beekman wrote:
>>> On 2018-10-31 14:35, Dave Hansen wrote:
>>>> On 10/31/18 2:30 PM, Sean Christopherson wrote:
>>>> AFAIK there isn't a way to prevent userspace from manually invoking
>>>> EENTER, short of doing some really nasty text poking or PTE swizzling.
>>>> We could declare using EENTER as unsupported,
>>>=20
>>> Yep, userspace can call it all it wants, and we can also say that
>>> calling it outside the vdso is "undefined".
>>=20
>> Is there a precedent for this? Are there any other ring 3 x86
>> instructions that Linux is claiming to be "undefined" when executed by a
>> user process?
>=20
> We did it for MPX.  "Don't use MPX unless you first tell the kernel, or
> we'll eat your puppy."

I think EENTER in plain user code should have well defined semantics, and it=
 should get regular signals with the appropriate bits set in the error code f=
ield in the ucontext.  But we should probably simultaneously offer a nicer A=
PI, and the libraries will use it because it=E2=80=99s nicer.=
