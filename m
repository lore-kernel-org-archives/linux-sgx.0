Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899D6C07E85
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 15:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9D120672
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 15:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="YnrB4isO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C9D120672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbeLKPla (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:41:30 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34460 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbeLKPla (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Dec 2018 10:41:30 -0500
Received: by mail-pl1-f194.google.com with SMTP id w4so7105086plz.1
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 07:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U9cQk/oU0NjVhkyahB/PaBaJmR2qTHCOw8kIX+qQC5E=;
        b=YnrB4isOJtN8m49WvsMv2NrOcPDBReeYRpwMX6Ehl/jYSnmjN85hZx2wuJ6lCX4Cc6
         9yVM4JUDc33P7JKuqL7gYJJvV1q4ypasrT20LTaLtIciY0JNi24UgDciyALWpRm1deeO
         x8GClN+J7yp2kLToiS6CV0aEywGNRGycQse6V9QtuCBSLI9lEDpo78GQFe8QbZABKZsx
         yM8TPp+JVuV9Pe4hJj3f0HyZTZ/KvvS/58aKLrPvuBa8KlEjrOd6S3WWi5/nHp+hyebT
         F5V1r+kKx3CZoF9nehRae2vA9TJenUYf9xG6AUTNWy7gW3u2//g6xUwoVIWZ7JGizP5t
         y6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U9cQk/oU0NjVhkyahB/PaBaJmR2qTHCOw8kIX+qQC5E=;
        b=VWJv5W4m/S7mGukZjtScW5tAOt87sEo0v4+Ocz5F4rjFMDL6vh28upjgnCVbmrW2u2
         ZPrFTu+yhP6lYcMJXBiQeuBSZ/tAk9o/3xTl+r8QkyHeWZVTeu0Gzc4kqXfCIpviL647
         cRFNcab8e+UGkaySrsdz8E55rDOpASMo/nTQa6BEONAJJLeytqnuEDvMCmtaVWqZhqLf
         rP1xAQSD0Lnd5e1kB2NryezzgpkorqPghQumWUXCYUPywbdU213HGvd8BNtZUDyu4k1u
         o/tesVPMbPpsWZJQklni0exVD7zM3r9bkOnL0r3DKd2qcexLlWoObzfoXc61dA62m6+9
         J7kA==
X-Gm-Message-State: AA+aEWY7PQBc4VmFuzhldDYCJFzpp3yon4PiZiJ+GqJJVce62HKYMiPw
        iX7ANNTUFtky2qtLm+sGLeeDPGCpicUHSg==
X-Google-Smtp-Source: AFSGD/Xi541w4Hn554IEJwsktZN9ZwZtLf0bcDlXADk7q3LdvPIkEXQ7/I6YcRLltqlivEKuHJwA8w==
X-Received: by 2002:a17:902:4a0c:: with SMTP id w12mr16679813pld.8.1544542889578;
        Tue, 11 Dec 2018 07:41:29 -0800 (PST)
Received: from ?IPv6:2601:646:c200:7429:cc12:b7da:e644:c670? ([2601:646:c200:7429:cc12:b7da:e644:c670])
        by smtp.gmail.com with ESMTPSA id u8sm20350831pfl.16.2018.12.11.07.41.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 07:41:28 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16B92)
In-Reply-To: <20181210232449.GA11843@localhost>
Date:   Tue, 11 Dec 2018 07:41:27 -0800
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EEE078E7-7F37-4F74-8874-46E16C1E0A77@amacapital.net>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com> <20181210232449.GA11843@localhost>
To:     Josh Triplett <josh@joshtriplett.org>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Dec 10, 2018, at 3:24 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>=20
>> On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
>> At that point I realized it's a hell of a lot easier to simply provide
>> an IOCTL via /dev/sgx that allows userspace to register a per-process
>> ENCLU exception handler.  At a high level, the basic idea is the same
>> as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
>> attempt to fixup select unhandled exceptions that occurred in user code.
>=20
> So, on the one hand, this is *absolutely* much cleaner than the VDSO
> approach. On the other hand, this is global process state and has some
> of the same problems as a signal handler as a result.

I liked the old version better for this reason and for another reason: while=
 this new one looks very very simple, it still has the hidden complexity tha=
t the magic values written to registers in the event of an exception are ver=
y much Linux specific.

OTOH, the old approach clobbered more regs than needed, but that=E2=80=99s a=
 easy fix.=
