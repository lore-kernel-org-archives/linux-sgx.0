Return-Path: <SRS0=SAws=OH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12DBC43441
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 21:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AADCD20832
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 21:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="Ba9dJd4Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AADCD20832
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbeK2IzT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Nov 2018 03:55:19 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56317 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeK2IzS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Nov 2018 03:55:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so192406wmc.5
        for <linux-sgx@vger.kernel.org>; Wed, 28 Nov 2018 13:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+A6kKVDT/lzse7xZ8rGbuT3M9IaS07gutU1qZJ0FKGs=;
        b=Ba9dJd4YCsnI+qe8Wnv/2jONoooWXrGAh+x0TELwQaOpSzPl2JSdtXT0OClCfZSAD5
         LCyHfk0Mu1V1B+aDy/kz482gHNQeMI2xk5YhIb3AKpgf12FRGRcW80oqe5tUBwl39BTB
         5fjN9GmunOq3dSkK1BoS/D7sJrE+Baqsqq+TLRY+Np068Vh72A8yjiyx7Yof6r6aiSas
         jWUI9TiwQwK2EqQJtdo/QYSisoW/xwfhdpa9UAav2YTVT4QMR9wr4OEGO8SdOrOOydCT
         LizZ6Jt4WBmGSX4d4Yd4e+AXoMlo9/jXaUj+Lwzw8o+ef8gi16XUtedy5Ar8cgbAjyLn
         uudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+A6kKVDT/lzse7xZ8rGbuT3M9IaS07gutU1qZJ0FKGs=;
        b=PHHGux8jB1fUUJdh/356WaQaL5g9T41eJ1fmNnhA7gCkJgY6WYvvMdKeh8nTtYoOd8
         DxKqKslSbyoKzhNX1EaSCcWa70j3RXq0bS/a5w94Q/SphuDNqRjCe5jZTpHbTdVwvhOP
         MAsF6Exe7Kwca8WPf8iUeAtqECDEVC2tsF4xw1ECInw4ZE7d8Cix41YnFO71SVautzwn
         ITYVuX4ua2UILNE4d7/+Eswdn+lOMxif5aKiAwRWjhbhXcuLxMIIm5mBv4MrkKq4wwmT
         3Af9vzwrX8+Ff1yJwujTRRyymCQRTQvr+uocJ+0B+GGV5nyiwZyao774egg9rShCPvCj
         bjtg==
X-Gm-Message-State: AA+aEWYcYXlILmSJK0k3kbcIvDz21w/C8U4AdjgbZ/UIup5p0NWZEcCd
        /6tkaLAkai/r+S9vi9KjMHO+G3dxPftcwJIXthUlrQ==
X-Google-Smtp-Source: AFSGD/WcBX8wZdAEeTz3PUAHR4hYaTuMcJcpc4OYW4xhCKQve6ov+lVJ8iSq82mPV7WPFpt/X2RgXXTg1V7ClWRYMKg=
X-Received: by 2002:a1c:b1d5:: with SMTP id a204mr4500608wmf.32.1543441934150;
 Wed, 28 Nov 2018 13:52:14 -0800 (PST)
MIME-Version: 1.0
References: <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com>
 <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181126215145.GC868@linux.intel.com>
 <20181126230436.GA6737@linux.intel.com> <20181127085533.GA12247@wind.enjellic.com>
In-Reply-To: <20181127085533.GA12247@wind.enjellic.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Wed, 28 Nov 2018 13:52:00 -0800
Message-ID: <CALCETrV4UA5bn6dkq5aVycApx1ubq-rho_z=sHhxABbOSGZWMw@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     "Dr. Greg Wettstein" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 27, 2018 at 12:55 AM Dr. Greg <greg@enjellic.com> wrote:
> Since the thread has become a bit divergent I wanted to note that we
> have offered a proposal for a general policy management framework
> based on MRSIGNER values.  This framework is consistent with the SGX
> security model, ie. cryptographic rather then DAC based policy
> controls.  This framework also allows a much more flexible policy
> implementation that doesn't result in combinatoric issues.

Can you give a concrete explanation of a problem that your proposal
would solve?  As far as I can tell, it gets rid of a case in which an
unprivileged attacker who can run enclaves but hasn't compromised the
kernel can learn the PPID and other SGX-related permanent platform
identifiers, but it does nothing to prevent the same attacker from
learning non-SGX-related permanent identifiers, nor does it prevent
the attacker from using the Intel quoting enclave (unless configured
in a surprising way) and thus attesting to a remote system.

So what problem does it solve?
