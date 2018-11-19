Return-Path: <SRS0=RM7e=N6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C9CC43441
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 18:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCF920659
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Nov 2018 18:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="PUEOFdB1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFCF920659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbeKTEni (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:43:38 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:54874 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbeKTEni (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 19 Nov 2018 23:43:38 -0500
Received: by mail-it1-f196.google.com with SMTP id a205-v6so9723268itd.4
        for <linux-sgx@vger.kernel.org>; Mon, 19 Nov 2018 10:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TFFx8e1Q8W8lee2IXNbRZZz71PcnEWi5NplF9kzzK94=;
        b=PUEOFdB1mKfhnFl/BUTYZ2o6hJ0qZuulS/nKSIuubFniCqbYO6oBWWNO6e+qQciAlz
         5820J1VJUvt2ailwn0EI7pPkVRhG8IHpwkZdku9IhqtitmfJHxGjBXeQkHkYaNjXbm/A
         9Brv5cuNLq/X8l8CPvKMlOIVRVmYS2poQAN5ERRwt+5JJog2r/d+2NnpOcdXCKGl2jQP
         JuS4Gvhe9nVPahzSvBuP80SyoNkXX/bjz2232ETrz+ogGwHhD7EjvylnIZnEOWAUOJwX
         FZQdkXNt8ISxpAyFrfGxsLANmbOJF/Jjp3x8xp2hupaVbuV4BSBsS0TDM6lX1JL6wx4J
         4C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TFFx8e1Q8W8lee2IXNbRZZz71PcnEWi5NplF9kzzK94=;
        b=N7zzH9zeQRV0Tn+90ABC2Tmi3E+NZOFQqFzptjuprLyvLBnQMPKCNzThqk6gyMmnvc
         x69JQ5e/36vEsNR44NnrPKwrILEbOZBzZb2No/PJc3qRt63r4dY7mmXx0IAjrES6KfwN
         wTRuAqiIVIN4S9RnBlhrFX7YH0MYQjBs96Pl4he4mP9UglWFGCfmAVZQGlRWX9pdFtCw
         qhH9tw1sVqf1reW4vnHgWsRpliu33GwYdshoMF2vGI67CPQFX/6hbS16EPG/LtVHCc8a
         nQ+Pr2GMsSdAaEyxslIy2voM4Gre4Is5GVfQzUlm34haoeB42q2yMWSpUTN0mbQxsz2B
         kJMA==
X-Gm-Message-State: AGRZ1gIBbQEfbUqdjlyk8EOQrTehBWttRDkbPKTOhZdTHpG/hii01FoY
        DMGqckED3Yop1VQ23NSnH4PxhA==
X-Google-Smtp-Source: AFSGD/WMiRe9lzasP0X3iVlWZTMp+pUWU7MsYLxfDDdPi4zk8xrq66mc1xlBUiSkF6aJQ+o7Myd7Cw==
X-Received: by 2002:a24:1706:: with SMTP id 6-v6mr9836417ith.16.1542651537262;
        Mon, 19 Nov 2018 10:18:57 -0800 (PST)
Received: from ?IPv6:2600:100e:b01e:cdc6:49a8:b0fe:6838:b5dd? ([2600:100e:b01e:cdc6:49a8:b0fe:6838:b5dd])
        by smtp.gmail.com with ESMTPSA id n25-v6sm11929866iop.34.2018.11.19.10.18.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Nov 2018 10:18:56 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16A404)
In-Reply-To: <20181119171934.GA16252@linux.intel.com>
Date:   Mon, 19 Nov 2018 11:18:54 -0700
Cc:     Jethro Beekman <jethro@fortanix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2804DD93-E67B-4E06-800D-82A2EA21FCC9@amacapital.net>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <20181119150655.GA11843@linux.intel.com> <e8e640be-6f9f-0835-0578-48f140ac68f9@fortanix.com> <20181119171934.GA16252@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Nov 19, 2018, at 10:19 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel=
.com> wrote:
>=20
>> On Mon, Nov 19, 2018 at 04:22:54PM +0000, Jethro Beekman wrote:
>>> On 2018-11-19 20:36, Jarkko Sakkinen wrote:
>>> Question: should be dissolve the driver completely and move this code to=

>>> arch/x86/kernel/cpu/sgx/ (and rename intel_sgx.c as main.c)? Swapping
>>> patch removes the possibility to compile this as a module anyway.
>>=20
>> No. We should keep the capability to build this as a module for other use=
rs
>> of SGX. What is the swapping patch and why doesn't allow building as a
>> module?
>=20
> In some earlier version of the patch set the request was to remove the
> callback interface to the driver so now core does direct calls to the
> swapping operations.
>=20
>=20

Once static_call lands, this will be a great use for it.=
