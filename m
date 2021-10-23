Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEFFC433F5
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Oct 2021 01:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF4361038
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Oct 2021 01:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhJWBFJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Oct 2021 21:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhJWBFI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Oct 2021 21:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1937560F93;
        Sat, 23 Oct 2021 01:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634950970;
        bh=I439mF2WZtNAk4kuMgCqrhIAafiyO07udJLJk3VZaWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g1my/ogNFxuAsPODSY7LkbF3w64EcxcGFsO9EBkyK1PZn7Zzrwzd+pSrcmCrTr9Gb
         ScTgnxfICBLuiaLOiCsumr4WB8hFwTfZI3u5c1skFqjRFluIji9qvsYdb341XX33W9
         7Qr/ysCDNW+R9AsIct78MVGnlKf9HKb6nIIIk0qz7s9lG3gGKHsu8ATTbAV9VHGofs
         6JOiPGtxzPsByVkHVji6AN7Jsca1n0PTjT4548KQ1zaxiRJcvosLPcf1THo8/Lj5bX
         vtJ85K2nsy6JlGBrr2V/DXo/pheHurNUDEclSaGt920Pbr4dd57gBLHSbKlAyr3OtT
         114oAcfrwWzEA==
Message-ID: <4050b7723f6f205c9afc3bdfa3888a6e8befa12a.camel@kernel.org>
Subject: Re: [PATCH v8 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Date:   Sat, 23 Oct 2021 04:02:48 +0300
In-Reply-To: <YW2GLE89WxAeMZH4@kroah.com>
References: <20211018135744.45527-1-jarkko@kernel.org>
         <20211018135744.45527-2-jarkko@kernel.org> <YW2GLE89WxAeMZH4@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-10-18 at 16:35 +0200, Greg Kroah-Hartman wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0ret =3D sysfs_create_group(&dev->kobj, &sgx_node_attr_=
group);
>=20
> A huge hint, if a driver has to call a sysfs_* call, something is wrong.
>=20
> Something is wrong here.
>=20
> Why are you messing around with a kobject?=C2=A0 This is a device, that y=
ou
> control, you can just set the default attribute group for it and then
> the driver core will add and remove the sysfs group at the proper time,
> in the proper way.=C2=A0 Right now you are racing userspace and loosing.
>=20
> Use the default group list, that is what it is there for.

I used sysfs_create_group() because node_devices is not owned by SGX
code. It is managed in drivers/base/node.c, and also initialized before
SGX.

/Jarkko

