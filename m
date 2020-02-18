Return-Path: <SRS0=GKs3=4G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C651C34026
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Feb 2020 15:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA9832176D
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Feb 2020 15:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="SnSt5feY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgBRPAj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Feb 2020 10:00:39 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40454 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgBRPAj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Feb 2020 10:00:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id z7so11065330pgk.7
        for <linux-sgx@vger.kernel.org>; Tue, 18 Feb 2020 07:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=htSLA1uUXNrZU4u/VJJyDRh0oTqRNIMHaf7XeTfqSUo=;
        b=SnSt5feYNFsm75epeNzaY7shtlo2w+tMobzKW57gqPSck8ZgdA27Xi14qfUpUWsyna
         KdqOIA3KvVZvE4rCr0135bc7QzdmQ46sjihHGud8+qwgPQ1KrtJGayIsE6Z3j7xu56Pf
         x0bCS3mkLfQJPGyRImft41Ey3gvV9QUjtAV+d4Qia/DM1ey3JeDUAIki/cf7bszuoFqt
         dCjpmZl22wHR08TnlCd0R/F9+L3t4+rKLc+qFcA4zAZdtEiDvJkFIMdOZf6GBpIOuZqV
         vPhR4JIUb9fAQ/48fnxekzGnDoPIjJUe0MXUUlnl3D/EdpwoeDnPmb10CwPY97RaFDjA
         02rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=htSLA1uUXNrZU4u/VJJyDRh0oTqRNIMHaf7XeTfqSUo=;
        b=GeyQvwyDS4UqxpnpxanvE+m9TISvNX7cEgWe+8b0gyeKRJ3SnTy+EtLHzaXFZvP+B4
         9AZWAz1QcvxaYFBaYRk5ZG+TGqb72xgzKUoq0ni12rPtdYyWqRPtDmEwW5R2ruayNyOu
         fKqU4r3+mluio2jX8iB2ongIZZZc/zRtOOuPCWmtqwo7WXI3LWA8jWO9J5GnbCtBPaAk
         bX9XFuygN6sha4FLllKnYFWTcUTOiPWq8MQpBpfGtpUsf3du8hCqMfstXubL845AMI+C
         +NsVTHz+6K1V810thqfXY7IPZ7L+sgC3ez01CQMaLDLv67sEnYeVyFxTC5BW8J/ATyoP
         wsYw==
X-Gm-Message-State: APjAAAWcRjMvVnxgq66WT1q1thpJlD30b9zWquToyQVd0SR+h5KYaDe1
        pj28gAcRacZke7ASR+L8EX/ZzQ==
X-Google-Smtp-Source: APXvYqwyqF6iT1by4m8YXCbAv2V7xkB6v8eMSwGjDbaa+py992pAUc3kuwLP+fSjVgaRw9OwGRd61g==
X-Received: by 2002:a63:4c66:: with SMTP id m38mr1059164pgl.313.1582038025701;
        Tue, 18 Feb 2020 07:00:25 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:80e7:9a67:9154:590f? ([2601:646:c200:1ef2:80e7:9a67:9154:590f])
        by smtp.gmail.com with ESMTPSA id x28sm4997868pgc.83.2020.02.18.07.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 07:00:25 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: x86/sgx: v23-rc2
Date:   Tue, 18 Feb 2020 07:00:23 -0800
Message-Id: <8269DEFA-960C-47D0-A1E5-14C427F3CD23@amacapital.net>
References: <20200218104243.GA13967@wind.enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
In-Reply-To: <20200218104243.GA13967@wind.enjellic.com>
To:     "Dr. Greg Wettstein" <gw@idfusion.org>
X-Mailer: iPhone Mail (17D50)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Feb 18, 2020, at 2:43 AM, Dr. Greg Wettstein <gw@idfusion.org> wrote:
>=20
> =EF=BB=BFOn Mon, Feb 17, 2020 at 08:55:26PM +0200, Jarkko Sakkinen wrote:
>=20
> Good morning, I hope the week is starting well for everyone.
>=20
>>> On Mon, Feb 17, 2020 at 09:52:25AM +0100, Jethro Beekman wrote:
>>> On 2020-02-15 08:24, Jarkko Sakkinen wrote:
>>>> On Thu, Feb 13, 2020 at 03:10:24PM +0100, Jethro Beekman wrote:
>>>>>>> There are other scenarios where it's not just the permissions on
>>>>>>> /dev/sgx/enclave that are the problem but using the filesystem in ge=
neral
>>>>>>> that is. Maybe you've used seccomp to disable file operations, etc.
>>>>>>=20
>>>>>> Andy and Jarkko, thoughts?
>>>>>=20
>>>>> Folks, any more thoughts on how to resolve the issue that you need to
>>>>> call open() for every enclave?
>>>>=20
>>>> Why is it an issue?
>>>=20
>>> Already discussed in https://www.spinics.net/lists/linux-sgx/msg02075.ht=
ml
>=20
> I believe an accurate summary of Dr. Beekman's concerns are as
> follows:
>=20
> 1.) He envisions a need for an enclave orchestrator that uses root
> privileges to open the SGX driver device and then drop privileges,
> presumably in a permanent fashion.  The orchestrator would then use
> the filehandle to load and initialize multiple enclaves on request.
>=20
> 2.) The enclave orchestrator may be run in an environment that has
> SECCOMP limitations on the ability to conduct filesystem operations.
>=20
>> Not everyone has to have access to open /dev/sgx/enclave in order to
>> use enclaves.
>=20
> That depends on the architecture of the runtime.
>=20
> The Intel PSW has a model where the AESM daemon orchestrates
> activities for applications that wish to use enclaves.
>=20
> Our Secure Runtime Development Environment (SRDE), on the other hand,
> uses a model where each application independently manages its use of
> enclaves.  In our model, the SGX driver needs to be accessible by
> whatever privilege level an application chooses to run at.
>=20
> As a result of this model, our SRDE has around an order of magnitude
> less complexity then the AESM model and virtually no external
> dependencies.  At last count the AESM depends on about 35 separate
> shared library systems.
>=20
> Our model allows us to build applications that are statically linked
> and completely self-contained.  A concept of reasonable utility for
> containerized environments and embedded systems.  We also avoid C++
> that allows us to build MUSL based security stacks.
>=20
>> It is as much a problem as for practically any driver that provides
>> devices for some use.
>=20
> The only customers of this driver are the runtime developers and that
> is currently an extremely limited spectrum of users.
>=20
> I will concede that I don't understand the SECCOMP issue.  Jethro may
> or may not be able to discuss an architecture that would not have
> basic filesystem operations available to it.

Jethro, is there a way you could use SCM_RIGHTS to solve your problem?  In p=
rinciple, the driver could allow an enclave fd that isn=E2=80=99t ECREATEd y=
et to be forked with an ioctl, but ISTM this is extra complexity and there s=
hould be a well understood use case before something like this is added.

>=20
> The fundamental issue, that there appears to be a reluctance to
> discuss, is that DAC/MAC controls are not relevant to SGX,
> particularly SGX2 based systems, which is what most of this stuff
> will be running on.
>=20

No, this isn=E2=80=99t the fundamental issue, because DAC/MAC is just as rel=
evant to systems with SGX and SGX2.  I=E2=80=99m sure that there will be sys=
tems that work with SGX and with everything running as root (or even SGX on a=
 kernel without access control at all), but these will be a minority. Even i=
f you have absolutely perfect protection of sensitive data, you sacrifice an=
y sort of defense in depth against an attacker DoSing you in any number of a=
mazing ways.  Or, for that matter, leaking keys derived from the provisionin=
g key.

(Don=E2=80=99t forget that, no matter how carefully your system might lock d=
own the SGXPUBKEYHASH MSRs and control the associated keys, that lockdown is=
 being done by non-enclave *software*, and a bad guy who gets root is quite l=
ikely to be able to unlock the registers by upgrading their root access to c=
ontrol the firmware.  Or get a launch token that can=E2=80=99t be revoked be=
cause SGX doesn=E2=80=99t have a token expiration mechanism.)

No one wants to discuss your DAC-less model because, as far as I can tell, n=
o one agrees with you.

>> /Jarkko
>=20
> Have a good day.
>=20
> Dr. Greg
>=20
> As always,
> Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
> IDfusion, LLC
> 4206 19th Ave N.            Specialists in SGX secured infrastructure.
> Fargo, ND  58102
> PH: 701-281-1686            CELL: 701-361-2319
> EMAIL: gw@idfusion.org
> --------------------------------------------------------------------------=
----
> "... remember that innovation is saying 'no' to 1000 things."
>                                -- Moxie Marlinspike
