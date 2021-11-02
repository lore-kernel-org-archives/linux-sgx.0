Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF79C433FE
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B212560D42
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhKBUPP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231898AbhKBUOu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Nov 2021 16:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89BDD61053;
        Tue,  2 Nov 2021 20:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635883935;
        bh=PbeKWGBDAChMLC+Nu9bVzhinu6LEbxlXwqNnu7DoCz4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qnOJxHBMHOyaSST/GpmLdrZ4+t5G4dZjMTmPCIcBCjcVlkUnPZN9vQ4zK3oBPx6fY
         RJtoVvH7KBNZ3tDEX4Ld6xYs3ps0y1+GZXvkHcWPQAXWwXnAcQMt+6pYl1slPJNoiY
         sITiR6F6mEeFuqO4KPuKfkPRQpwJNRiMsOC2yhbVmdlbJ82guZTZNOMfL/zFKMHS0S
         5H/cpp1WDITvX1VxBRbM6YW2Qbq89U6eGAtQSTDzk8ybAGyES8SK7c1PwLILE4uP1U
         w6dqWV8vDCgxD5wZjeSuXoM3jZxANswq9aEtJajP4p/zr5RFrMYsDKM5FrRbl8y7cJ
         9F43jON2KKJwQ==
Message-ID: <c70af622b09439d2c168654e4bfab081eedaa489.camel@kernel.org>
Subject: Re: [PATCH v10 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, reinette.chatre@intel.com,
        tony.luck@intel.com, nathaniel@profian.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Tue, 02 Nov 2021 22:12:12 +0200
In-Reply-To: <YYFvdy0cH6HXeuX+@kroah.com>
References: <20211102164820.593385-1-jarkko@kernel.org>
         <20211102164820.593385-2-jarkko@kernel.org> <YYFvdy0cH6HXeuX+@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-11-02 at 18:03 +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 02, 2021 at 06:48:19PM +0200, Jarkko Sakkinen wrote:
> > * Change the attribute name as sgx_total_bytes, and attribute group
> > =C2=A0 name as "x86" (Dave).
>=20
> <snip>
>=20
> > --- a/Documentation/ABI/stable/sysfs-devices-node
> > +++ b/Documentation/ABI/stable/sysfs-devices-node
> > @@ -176,3 +176,10 @@ Contact:=C2=A0=C2=A0=C2=A0Keith Busch <keith.busch=
@intel.com>
> > =C2=A0Description:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0The cache write policy: 0 for write-back, 1 for =
write-through,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0other or unknown.
> > +
> > +What:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/sys/=
devices/system/node/nodeX/sgx/size
>=20
> Looks like the attribute group name is still "sgx" :(

Ugh, also commit message needs an update. Thanks, I'll do
fix this, apologies.

/Jarkko
