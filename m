Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67317C433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 17:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BCDE61039
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 17:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhJaRv4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Oct 2021 13:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhJaRvz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Oct 2021 13:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C87061038;
        Sun, 31 Oct 2021 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635702563;
        bh=htwSkWwAOpFCewQzw9hsMXOQEy+PI2XqN6QXehj0IMM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EjLpzUFBEuC+6oU0i1VJK3Rbj9IwX1Ce723YKkRu+NM6dM/WZ+zRHWbhDDitfydzV
         /RvRE2ST70CaxKplocSh14IznPkLojbLLJlBEj1Q94MpBDdZdVNitFB3OQgELqu0SS
         n2bpg3FSOdAF3ztfO0PumXzCH9Tw7tke+dAmmk1K9yPNtz6RuerBSItWvrN6cLig3p
         aBLi51BvvgVg59Yaxj350mX0FUWwl4psDS9mJk4Ox8p/BcCAdcaPTSHLIAL80q2fpb
         LvYLFdToB9GnRcuP80bnlfvuWOQgwTMgLtsseLBhPY+CSBT/CWSsv0x/TE3ibUlAec
         u/rgv9PQGPAmg==
Message-ID: <4e5cdd5825018778ad15abed33242703b8066e76.camel@kernel.org>
Subject: Re: [PATCH v9 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Sun, 31 Oct 2021 19:49:21 +0200
In-Reply-To: <3ffafe28-e770-a285-98d0-1379271ba36d@intel.com>
References: <20211029121857.477885-1-jarkko@kernel.org>
         <20211029121857.477885-2-jarkko@kernel.org>
         <3ffafe28-e770-a285-98d0-1379271ba36d@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-10-29 at 10:00 -0700, Dave Hansen wrote:
> On 10/29/21 5:18 AM, Jarkko Sakkinen wrote:
> > +What:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/=
devices/system/node/nodeX/sgx/size
> > +Date:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Octob=
er 2021
> > +Contact:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Jarkko Sakkinen <jar=
kko@kernel.org>
>=20
> I don't think we should do something *entirely* SGX-specific here.=C2=A0 =
The
> only question to me is whether any non-SGX users want something like
> this and who they are.
>=20
> Here are some ideas I like more than an "sgx/" directory:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/devices/system/node/=
nodeX/arch/sgx_size
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/devices/system/node/=
nodeX/x86/sgx_size
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/devices/system/node/=
nodeX/coco/sgx_size

Sure, I can rename the attribute group as "x86".

> There's somebody else *today* who is trying to do something in the same
> general area: per-node platform-specific memory encryption capabilities:
>=20
> > https://lore.kernel.org/all/20211027195511.207552-6-martin.fernandez@ec=
lypsium.com/

Martin's is adding a new attribute as part of pre-existing attribute group =
for
node device, where as my patch is adding a completely new named attribute
group.

> Also, could we please think through how this will look if we add more
> attributes?=C2=A0 I can imagine wanting both:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* total SGX memory availa=
ble
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* total SGX memory presen=
t
>=20
> But those would be quite hard to differentiate if we have just an
> "sgx_size".
>=20
> Wouldn't it be much nicer to name them things like:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_present_bytes
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_available_bytes
>=20
> ?
>=20
> In other words, can we please try to think just a bit into the future on
> this one?=C2=A0 What other SGX things will we want to export like this?
> Outside of SGX, who else wants stuff _like_ this?

I don't mind renaming the attribute but maybe it should sgx_total_bytes, ju=
st
because in some other sysfs attributes that keyword is used to refer all of=
 the
bytes?

/Jarkko

