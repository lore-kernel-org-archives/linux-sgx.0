Return-Path: <SRS0=zuU4=NO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6342EC0044C
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D272082E
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 13:17:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oamehlBo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19D272082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbeKCW3G (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 18:29:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46350 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbeKCW3G (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 18:29:06 -0400
Received: by mail-qk1-f196.google.com with SMTP id q1so7466523qkf.13;
        Sat, 03 Nov 2018 06:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDmxNKwMic+2kVqQsqB83TKH0HDMXiz95Fgq48fOd2Y=;
        b=oamehlBogbsVdDrDRuay0XGUI3c/fkk6vfyvd9yS8h0C9L79f1pBBTIrHOGNYB+vZR
         a4M8NGy9soEkXH+sWWJT09bUVkW3XmvweE+mQjhg3cY97uPGY/Qdm/q1s2KHGqdHaaXB
         GlHFR3B+18F82rwdzCENMGQF5X7Yq45nSGbppQbjj49zIsq/jj5CX/uf4/HQV7R7boo1
         zuJVaUCEZQ4Odo/oqfP/bjEqn4IMLEKsM9ecBB6tol3iTp3d5RjodbLROF2soFoZ9KcC
         bXkBd4Mpka9xiZSCnPELNr4DPw13z5dtOJ0/GxvHh8V5QSo5zuKHrVRZPM6mckbMuXVw
         eP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDmxNKwMic+2kVqQsqB83TKH0HDMXiz95Fgq48fOd2Y=;
        b=dRHlGW7pLw3/LhEE88/9pt9eKOUyINEIQSLoA/QWX+qTIEaQ7kN2xAwYuFetDVLvD1
         8Yw/ywZAxK7JN1HtZr5tpmv0LVP/dDT2c+S03mmOIaug/xceRk0c+vNdEebzryjeFxMg
         RExKXaZawF1PJLOp4t3aVnaOjjSmuCPJ8zpXMrxDbeKfCc+HN8LCsJjXgDJD7aecpxZ4
         mo2u+6HY55iJgx5TtrXujyJL8zeGbw6TQi2Mxydf+b5Pmw3Qu3TwFPO3PmExbqihUFEm
         tKwiYwwTZNlEwUuTF788QjaaDUmpukUSRsjeYdrJUZ1kKJ1M5RYq/E+DgCYUVweFPcu7
         NaKA==
X-Gm-Message-State: AGRZ1gJd14oZ8ZBww6n45aYRpDEb/+qf+TARAUCpKPl1b3Jr09KfHRf/
        N3bKeEsdJ4V7i9I2jXrjoBU4zBBJTer5felXNOE=
X-Google-Smtp-Source: AJdET5ffnw8aG2hRuEy7WoX8Llq8aYJtSpuW68JDZH3mX6sNu9egsWv89ycxrRVLZVSFSZHQ5P+ARxKlEx9rEc6km9U=
X-Received: by 2002:a0c:e202:: with SMTP id q2mr14091297qvl.180.1541251066244;
 Sat, 03 Nov 2018 06:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com> <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Nov 2018 15:17:35 +0200
Message-ID:
 <CAHp75VdhSwy8zzf64PZnHhZVikJEzasu-=a+UOz4cLAxEJW-YA@mail.gmail.com>
Subject: Re: [PATCH v15 15/23] x86/sgx: Add wrappers for ENCLS leaf functions
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, suresh.b.siddha@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181103131735.77b5Z2MTkrNrvqZNPoYmNoGK2qGt4i-zMj7wqjaaR80@z>

On Sat, Nov 3, 2018 at 1:18 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
> The ENCLS function that is executed is specified in EAX, with each
> function potentially having more leaf-specific operands beyond EAX.
> ENCLS introduces its own (positive value) error codes that (some)
> leafs use to return failure information in EAX.  Leafs that return
> an error code also modify RFLAGS.  And finally, ENCLS generates
> ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
> encounter faults on ENCLS that must be handled gracefully.
>
> Because of the complexity involved in encoding ENCLS and handling its
> assortment of failure paths, executing any given leaf is not a simple
> matter of emitting ENCLS.
>
> To enable adding support for ENCLS leafs with minimal fuss, add a
> two-layer macro system along with an encoding scheme to allow wrappers
> to return trap numbers along ENCLS-specific error codes.  The bottom
> layer of the macro system splits between the leafs that return an
> error code and those that do not.  The second layer generates the
> correct input/output annotations based on the number of operands for
> each leaf function.

> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */

> +/**

I dunno if kernel-doc script still complains about this.

> + * Copyright(c) 2016-18 Intel Corporation.
> + */

-- 
With Best Regards,
Andy Shevchenko
