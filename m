Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28D5C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Oct 2021 23:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA7860F46
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Oct 2021 23:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhJYXss (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 Oct 2021 19:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235103AbhJYXsq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 Oct 2021 19:48:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D2060ED4;
        Mon, 25 Oct 2021 23:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635205583;
        bh=ahCkc+jA79431ID76cNsskmw8zuDPNgoJc2YUCJq7+0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qZtEPPAwKgKMNyUUZWFJUZYMzozqwmvmwIcatqDcYwX66N7f55ZKLluhCwk8LIt1F
         RH5Ac7JhJbH2xCISrtM2Y9prVV2SEKnMHTKzND/mix6hDAoJHK+Zx4fYQRyC5HN2eH
         ys325r72bA/VvBNO5Ifo2X7mYr1Yq31pjsoJwLPfv9opD9lJuS7CB6lj+Xem+el0fh
         ZZienyCXeurS6dFybtv29oAdnY7NXvhUxublPxhv8cC0LH7J0/GZ04HAWMqoIKPTg4
         3oQOAxSnHDbg3tnUpBYC2hR1tQbNk9rnK0DVUsb2YgaOxoZ+TRaNjJ6xWNIIrbjzM9
         gsAJm1qUtq4VQ==
Message-ID: <4c3e7a41c545d10ed4aabcfa08118b1e2f80e3fd.camel@kernel.org>
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
Date:   Tue, 26 Oct 2021 02:46:20 +0300
In-Reply-To: <YXY9gsIn+VhmPhHU@kroah.com>
References: <20211018135744.45527-1-jarkko@kernel.org>
         <20211018135744.45527-2-jarkko@kernel.org> <YW2GLE89WxAeMZH4@kroah.com>
         <4050b7723f6f205c9afc3bdfa3888a6e8befa12a.camel@kernel.org>
         <YXOsx8SvFJV5R7lU@kroah.com>
         <2b30027eb017216986e88008fdc925d0e6c61ce0.camel@kernel.org>
         <YXY9gsIn+VhmPhHU@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-10-25 at 07:15 +0200, Greg Kroah-Hartman wrote:
> On Sun, Oct 24, 2021 at 05:24:43PM +0300, Jarkko Sakkinen wrote:
> > On Sat, 2021-10-23 at 08:33 +0200, Greg Kroah-Hartman wrote:
> > > On Sat, Oct 23, 2021 at 04:02:48AM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, 2021-10-18 at 16:35 +0200, Greg Kroah-Hartman wrote:
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D sysfs_create_group(&dev->kobj, &sgx_n=
ode_attr_group);
> > > > >=20
> > > > > A huge hint, if a driver has to call a sysfs_* call, something is=
 wrong.
> > > > >=20
> > > > > Something is wrong here.
> > > > >=20
> > > > > Why are you messing around with a kobject?=C2=A0 This is a device=
, that you
> > > > > control, you can just set the default attribute group for it and =
then
> > > > > the driver core will add and remove the sysfs group at the proper=
 time,
> > > > > in the proper way.=C2=A0 Right now you are racing userspace and l=
oosing.
> > > > >=20
> > > > > Use the default group list, that is what it is there for.
> > > >=20
> > > > I used sysfs_create_group() because node_devices is not owned by SG=
X
> > > > code. It is managed in drivers/base/node.c, and also initialized be=
fore
> > > > SGX.
> > >=20
> > > Then that is broken, please do not use that device as your code does =
not
> > > "own" it.=C2=A0 Or fix the logic to be initialized earlier.
> >=20
> > To get a synchronous initialization, I'd need to add the attributes as
> > part of this declaration:
> >=20
> > static struct attribute *node_dev_attrs[] =3D {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&dev_attr_cpumap.attr,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&dev_attr_cpulist.attr,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&dev_attr_meminfo.attr,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&dev_attr_numastat.attr=
,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&dev_attr_distance.attr=
,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&dev_attr_vmstat.attr,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0NULL
> > };
> > ATTRIBUTE_GROUPS(node_dev);
> >=20
> > That guarantees that the attribute exists at the time when the
> > node is created, e.g. in that sense this will fix the race with
> > uevent code.
> >=20
> > However, up until sgx_init() has been completed, the attribute
> > will emit '0'.
>=20
> Is that a problem?=C2=A0 Who would be wanting to use sgx until that happe=
ns?
> You have this issue today anyway, right?

Yeah, I guess I can just document this (as part of sysfs abi documentation)=
.

Thank you for the feedback.

/Jarkko
