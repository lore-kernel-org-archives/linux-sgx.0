Return-Path: <SRS0=NwvC=6R=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29857C3A5A9
	for <linux-sgx@archiver.kernel.org>; Sun,  3 May 2020 00:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2D3120757
	for <linux-sgx@archiver.kernel.org>; Sun,  3 May 2020 00:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="yuXQSYYk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgECAsk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 2 May 2020 20:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726501AbgECAsk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 2 May 2020 20:48:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203ADC061A0E
        for <linux-sgx@vger.kernel.org>; Sat,  2 May 2020 17:48:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so3646987pfx.7
        for <linux-sgx@vger.kernel.org>; Sat, 02 May 2020 17:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=6jwsuwljAsVBGE4xymx7dV14JFcZxi8+xgH7yHh9HA4=;
        b=yuXQSYYk+Hrn8HvXg0kY7DhFgO4C6LsR4blnvVruZi6vvN2YJIXop11ivEUK/NDJEc
         q7hZPIJrq96YeAuvTRaA9/TGKMOetoJOs9Et1M1nDbxJB9GAK7xhbyg3QlZaolBjdFYJ
         uZOH/yH+pIF2LTQLTKorxLS0dXnbuRcBk8HZMsxjNhgBy7sTR5R10vMXuj/tCuo5RK3i
         jubfaIgQP6OVxznaWK1MK8tHvrsCpHwwUOrN838KCiQ/gF9+adMxaGeX4xqZ9MREY/wG
         /cs6U5N3ZrzA94KC8V58cU6mr7YJRpBUYKOwsxtfVyiZ6uNOvwrV2gkjADma4RI8uoBA
         I0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=6jwsuwljAsVBGE4xymx7dV14JFcZxi8+xgH7yHh9HA4=;
        b=Gylh4SD1ZmNf+8HfkaIlvKVIh2HJsASqcbFsRHf5PjBW9L6DJKFe4QN3as+UI3G88C
         5KTNQQkgd8rICjkhIIZUA+o9wIhRrO60yF2zDH3M2seHgj6R/l0qOsHxpTcHAAC87y49
         LeYwDme8P2/6ouUujx0QC7egrPTE09SgZxxJjtiiK1+Nb+XC8WKRcQjLPrabQnBRpvJi
         M8PiIsYsGhuHkY4T5DYUfiUYndFSAkniMEcUmEUQlYeUe488NEHRBEGyFYFFVWCSqvYT
         u077V5l69xJMjlm4VhGq2wBMRDvJgJ60AFRmwycTdCBFGzUx1/vK7qYXN5cTrrqD9NY0
         de1g==
X-Gm-Message-State: AGi0Pubz4Ck6lkLv+1JydMkAckQ7+HU62+av2nkaikMkrztea6eM/VUX
        yvA9pY+DUYas5xwbaMViEVrhzA==
X-Google-Smtp-Source: APiQypKXR/iwp2/MyfrkDK08We+62r3joTkPf6Q29QQDhJtcOe3Pf2oLbafpnp6s/pzFK/Et88HBfw==
X-Received: by 2002:a65:4bc6:: with SMTP id p6mr10687602pgr.20.1588466919431;
        Sat, 02 May 2020 17:48:39 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:21b6:fdf6:a361:f24a? ([2601:646:c200:1ef2:21b6:fdf6:a361:f24a])
        by smtp.gmail.com with ESMTPSA id f76sm5291154pfa.167.2020.05.02.17.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 17:48:38 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Date:   Sat, 2 May 2020 17:48:30 -0700
Message-Id: <BD424C59-0B02-451D-8DF0-74F92292A87C@amacapital.net>
References: <20200502230510.GA28470@wind.enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
In-Reply-To: <20200502230510.GA28470@wind.enjellic.com>
To:     "Dr. Greg" <greg@enjellic.com>
X-Mailer: iPhone Mail (17E262)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On May 2, 2020, at 4:05 PM, Dr. Greg <greg@enjellic.com> wrote:
>=20
> =EF=BB=BFOn Thu, Apr 30, 2020 at 06:59:11AM +0300, Jarkko Sakkinen wrote:
>=20
> Good afternoon, I hope the weekend is going well for everyone.
>=20
>>> On Wed, Apr 29, 2020 at 08:14:59AM -0700, Sean Christopherson wrote:
>>> On Wed, Apr 29, 2020 at 08:23:29AM +0300, Jarkko Sakkinen wrote:
>>>> On Sun, Apr 26, 2020 at 11:57:53AM -0500, Dr. Greg wrote:
>>>>> On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
>>>>=20
>>>>>> The current implementation requires that the firmware sets
>>>>>> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately
>>>>>> the kernel can decide what enclaves it wants run. The
>>>>>> implementation does not create any bottlenecks to support
>>>>>> read-only MSRs later on.
>>>>=20
>>>>> It seems highly unlikely that a driver implementation with any type of=

>>>>> support for read-only launch control registers would ever get into the=

>>>>> kernel.  All one needs to do is review the conversations that Matthew
>>>>> Garrett's lockdown patches engender to get a sense of that, ie:
>>>>>=20
>>>>> https://lwn.net/Articles/818277/
>>>>=20
>>>> We do not require read-only MSRs.
>>>=20
>>> Greg is pointing out the opposite, that supporting read-only MSRs is hig=
hly
>>> unlikely to ever be supported in the mainline kernel.
>=20
>> In a nutshell, what is wrong in the current code changes and what
>> *exactly* should we change? This is way too high level at the moment
>> at least for my limited brain capacity.
>=20
> In a nutshell, the driver needs our patch that implements
> cryptographic policy management.
>=20
> A patch that:
>=20
> 1.) Does not change the default behavior of the driver.
>=20
> 2.) Implements capabilities that are consistent with what the hardware
> was designed to do, but only at the discretion of the platform owner.
>=20
> 3.) Has no impact on the driver architecture.
>=20
> The only consumer for this driver are SGX runtimes.  To our knowledge,
> there exist only two complete runtime implementations, Intel's and
> ours.  It us unclear why our approach to the use of the technology
> should be discriminated against when it doesn't impact the other user
> community.

Can you clarify how exactly this patch set discriminates against your stack?=


>=20
> The Linux kernel that I have worked on and supported since 1992 has
> always focused on technical rationale and meritocracy rather then
> politics.  We would be interested in why our proposal for the driver
> fails on the former grounds rather then the latter.
>=20
>> /Jarkko
>=20
> Best wishes for a productive week.
>=20
> Dr. Greg
>=20
> As always,
> Dr. Greg Wettstein, Ph.D, Worker      Artisans in autonomously
> Enjellic Systems Development, LLC     self-defensive IOT platforms
> 4206 N. 19th Ave.                     and edge devices.
> Fargo, ND  58102
> PH: 701-281-1686                      EMAIL: greg@enjellic.com
> --------------------------------------------------------------------------=
----
> "The best way to predict the future is to invent it."
>                                -- Alan Kay
