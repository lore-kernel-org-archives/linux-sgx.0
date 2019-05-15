Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA30C04E53
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 14:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05E72070D
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 14:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="Qxm23wvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfEOO1F (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 10:27:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36281 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfEOO1F (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 15 May 2019 10:27:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so1474911pgb.3
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 07:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Y11KbT6jnmDDPA7P14M9kZ4Az63Ux5gEX+rw5Zey9RE=;
        b=Qxm23wvMiWHRTvfv1zGQ1ToGTH8rjRs8d/EIcGj6oYqsXCJaqs5gh0iB/71zZgdePu
         Ansux+O15+LwDVh2yxvPMDNllmzcpvy1YPZsF9nI6PSVebt7dYU/1k4ebO1bHv0Ps9+0
         OTFdSfD5MxMc2Hl7VoFaVRe99Ia2d2n8mKzVB0WFGVkbT3qCVi7EpOLpBCAjgUeFl/I2
         esMOr2c2VXHwEEpq8xedNBrtmG8+yuGKIbNTNERP2aMDiJI8bOw8gHzGqhqlZmCmg6IS
         BtBjq1K2Bp5Bcu0Rwb432kGth7+h5ykDJpjoR9NpdmMiwXaSiVQ+Y6w5xbuzr+SyFly5
         vBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Y11KbT6jnmDDPA7P14M9kZ4Az63Ux5gEX+rw5Zey9RE=;
        b=UpXqmyq2wTGc3yNXnUJop8Bh1d8t2rtTVRJdGNDdILblWRHOe3A6LEBdozRnedLL8d
         ZOUpl2yAQ2+zOTMmILCYb0GcxCsg4r5qM9eznh6tWIhwqrqVx2uhOSoi2mb2mLEEaj00
         2paHtyMSxPC4bq/ZowCVi6XmqcOfnoCyO8XdZe0D9kne8VbDAdIhSrc8/YoKmWu0SqjH
         pKbWquH7LcaihUGPxX3jASgw1R7pZ1QcvYlU2MXGKUlo0V3xKPOWTxkzyMqYTiqwvBV3
         ZxncgMo8P5cuqmq8KODzMv7peG+wdU9W1ayxFwSLa00Xls5Tlel7ZQsrWDI6lfvUM/cb
         DlXQ==
X-Gm-Message-State: APjAAAUlbBkzAg13gAX+kzmEsV/yyC4AJoK+4EPpygkvVYuXQ3DfdUiG
        lndR/EDWLP/TA2L1KmdhjUvoOQ==
X-Google-Smtp-Source: APXvYqweW3Nx97D2pUDCHwmwd+JaNsxuI5iYDw/QBwn36eZKi/fI4XrnYFYxi0KY4R6E+tEM1EEMFA==
X-Received: by 2002:aa7:83d4:: with SMTP id j20mr26212093pfn.90.1557930424740;
        Wed, 15 May 2019 07:27:04 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:f597:45d4:7a8d:5d97? ([2601:646:c200:1ef2:f597:45d4:7a8d:5d97])
        by smtp.gmail.com with ESMTPSA id u134sm4211873pfc.61.2019.05.15.07.27.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 07:27:03 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190515110005.GA14718@linux.intel.com>
Date:   Wed, 15 May 2019 07:27:02 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1DF6DCD-C37D-4C87-AF32-F31785184482@amacapital.net>
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com> <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com> <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com> <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com> <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com> <20190514204527.GC1977@linux.intel.com> <20190515103531.GB10917@linux.intel.com> <20190515110005.GA14718@linux.intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On May 15, 2019, at 4:00 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.=
com> wrote:
>=20
>> On Wed, May 15, 2019 at 01:35:31PM +0300, Jarkko Sakkinen wrote:
>> This brings me to an open question in Andy's model: lets say that we
>> change the source for SIGSTRUCT from memory address to fd. How can the
>> policy prevent the use not creating a file containing a SIGSTRUCT and
>> passing fd of that to the EINIT ioctl?
>=20

The policy will presumably check the label on the file that the fd points to=
.

> Also wondering if a path would be better than plain fd for defining a
> reasonable policy i.e. have sigstruct_path as part of the ioctl
> parameters and not sigstruct_fd.
>=20

It would save two syscalls at the cost of a decent amount of complexity.=
