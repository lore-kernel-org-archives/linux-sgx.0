Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93806C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677AD20663
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbhAZXDo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394160AbhAZSKt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 26 Jan 2021 13:10:49 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EA0C0613ED
        for <linux-sgx@vger.kernel.org>; Tue, 26 Jan 2021 10:10:09 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o16so2331816pgg.5
        for <linux-sgx@vger.kernel.org>; Tue, 26 Jan 2021 10:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=9qXjNZouu+T2bptO4V2q/fEYj1NRhCbZOJSzY37VnAM=;
        b=kxAv0xKVGG7BwnWPjOQDwlrxfGCTuOtEvgV365hIsKf5iiADFSVyEhvSGIvKkoMLm5
         GDybLvjtHpDbuPduKHzEf+JyVancUCfRvTXgfF9QES6GhG6l+VXi75cfwnWQB4zZUqoL
         jwMAuAqRnbhLXuH1CzwE+uFP0hl9ikaC5h10PPCWzziLnmQ2i71NlILSUb+3v1EYoE29
         fVwnfLMS8launbZjAvVagJoeHiYpatzCKOsb7ahueSeiWX0VtdZdQ7/3A3cuiF6Xx/F5
         yRLgUCL7LOlOkdIj0cMBKDyl0wdkNsrlS5C3zzZ6v+MNZxBw6Q1LnPImv67phZGG3nWS
         lPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=9qXjNZouu+T2bptO4V2q/fEYj1NRhCbZOJSzY37VnAM=;
        b=GLahLcT/FhFFILoaZNEta+GWOVYIDYyXkiDJ0wbJ7rip4T/PU6FVv9iZ75UEhWoxvf
         v1JFI4u8yHxFigzONy6UqvkWeOiEvF7muRVl+lp5nvn1d3q0S7PPqwIpqjXcP44jrPWQ
         i9C0/bYsLOAZtnUurBlmP0mzNj0xbChco2Ns7HY/jS+MXYNnQN5H19y2CHWJaQncGsZP
         nEzFonmOH4Y8z96CbJEPLC5cMH2oUnXlKpzYBKJv/pTWN66lbqmRR+0+3DJQqXaPYx2p
         xVQcMxiHRNjCOyfVXQGUrmOt9bli4dBisGA2mDjAehPMRSLb1hv6q4o9NCtu/1rOOv2Y
         pXOg==
X-Gm-Message-State: AOAM531nTUg38H/ps6PptgjsCUbLisM2FdDfeGgCPpZ+sFo8yruBhgi/
        XOJ1x+eJd9qdPXDBtQU0Y94ueQ==
X-Google-Smtp-Source: ABdhPJw+Pyn/Lj1faj/rBJ50SuyQjLi9aPa/q0qBCO5rOApwmQkuP5S9N1Di3OSJZYoyx3kR9F+YDA==
X-Received: by 2002:a63:d42:: with SMTP id 2mr7048995pgn.236.1611684608859;
        Tue, 26 Jan 2021 10:10:08 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:4034:b7d6:a311:ffcc? ([2601:646:c200:1ef2:4034:b7d6:a311:ffcc])
        by smtp.gmail.com with ESMTPSA id p64sm19433188pfb.201.2021.01.26.10.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 10:10:07 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Tue, 26 Jan 2021 10:10:06 -0800
Message-Id: <7379D257-B504-4142-9FA3-F83DE5ABAEB4@amacapital.net>
References: <24778167-cbd4-1dc5-5b81-e8a49266d1f8@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        jarkko@kernel.org, luto@kernel.org, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
In-Reply-To: <24778167-cbd4-1dc5-5b81-e8a49266d1f8@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Jan 26, 2021, at 9:03 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> =EF=BB=BFOn 1/26/21 1:31 AM, Kai Huang wrote:
>> Modify sgx_init() to always try to initialize the virtual EPC driver,
>> even if the bare-metal SGX driver is disabled.  The bare-metal driver
>> might be disabled if SGX Launch Control is in locked mode, or not
>> supported in the hardware at all.  This allows (non-Linux) guests that
>> support non-LC configurations to use SGX.
>=20
> One thing worth calling out *somewhere* (which is entirely my fault):
> "bare-metal" in the context of this patch set refers to true bare-metal,
> but *ALSO* covers the plain SGX driver running inside a guest.
>=20
> So, perhaps "bare-metal" isn't the best term to use.  Again, my bad.
> Better nomenclature suggestions are welcome.


How about just SGX?  We can have an SGX driver and a virtual EPC driver.=
