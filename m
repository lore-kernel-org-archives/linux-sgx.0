Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA04C433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 24 Oct 2021 14:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AC260F46
	for <linux-sgx@archiver.kernel.org>; Sun, 24 Oct 2021 14:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhJXO1G (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 24 Oct 2021 10:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhJXO1G (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 24 Oct 2021 10:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49DFA60F12;
        Sun, 24 Oct 2021 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635085485;
        bh=oD9oCz1A1sLGb9Fqs9TJtU3PJPdPghafI7WTMyDTPh8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cJXa12WqH2DfJ5/bn7FOqAAdWGi42o3MdBHBVnP8Uek3/pVhshSbeMRxgbJX2QjPi
         EvWOQe9GMfOBPFiZF5Rjc4AxRcQ2luz3A9iy8k3MkL+vLHNQh13Ja3eR0QkqatbP5h
         Ljaz57TY4L05CpH9Yu7YLla48MaUhbIsZ2QCSSgNQokph8ygEblo1ZnLlgfmj/UtLg
         c3dgQj66hobFXk21sF7PlZeFSxuwse7xv/BUBVMlWuSxxM23yVksar1h8dwRHjYRPg
         zinudWLs97ioMtcPtp1uqo5sLDuwsOQhu8YoSnXF1C4fIhfcOPubq2DBfrupdoo/Uh
         ynAruX4icOSjw==
Message-ID: <2b30027eb017216986e88008fdc925d0e6c61ce0.camel@kernel.org>
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
Date:   Sun, 24 Oct 2021 17:24:43 +0300
In-Reply-To: <YXOsx8SvFJV5R7lU@kroah.com>
References: <20211018135744.45527-1-jarkko@kernel.org>
         <20211018135744.45527-2-jarkko@kernel.org> <YW2GLE89WxAeMZH4@kroah.com>
         <4050b7723f6f205c9afc3bdfa3888a6e8befa12a.camel@kernel.org>
         <YXOsx8SvFJV5R7lU@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, 2021-10-23 at 08:33 +0200, Greg Kroah-Hartman wrote:
> On Sat, Oct 23, 2021 at 04:02:48AM +0300, Jarkko Sakkinen wrote:
> > On Mon, 2021-10-18 at 16:35 +0200, Greg Kroah-Hartman wrote:
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ret =3D sysfs_create_group(&dev->kobj, &sgx_node_at=
tr_group);
> > >=20
> > > A huge hint, if a driver has to call a sysfs_* call, something is wro=
ng.
> > >=20
> > > Something is wrong here.
> > >=20
> > > Why are you messing around with a kobject?=C2=A0 This is a device, th=
at you
> > > control, you can just set the default attribute group for it and then
> > > the driver core will add and remove the sysfs group at the proper tim=
e,
> > > in the proper way.=C2=A0 Right now you are racing userspace and loosi=
ng.
> > >=20
> > > Use the default group list, that is what it is there for.
> >=20
> > I used sysfs_create_group() because node_devices is not owned by SGX
> > code. It is managed in drivers/base/node.c, and also initialized before
> > SGX.
>=20
> Then that is broken, please do not use that device as your code does not
> "own" it.=C2=A0 Or fix the logic to be initialized earlier.

To get a synchronous initialization, I'd need to add the attributes as
part of this declaration:

static struct attribute *node_dev_attrs[] =3D {
	&dev_attr_cpumap.attr,
	&dev_attr_cpulist.attr,
	&dev_attr_meminfo.attr,
	&dev_attr_numastat.attr,
	&dev_attr_distance.attr,
	&dev_attr_vmstat.attr,
	NULL
};
ATTRIBUTE_GROUPS(node_dev);

That guarantees that the attribute exists at the time when the
node is created, e.g. in that sense this will fix the race with
uevent code.

However, up until sgx_init() has been completed, the attribute
will emit '0'.

If I change sgx_init() from device_initcall() to
core_initcall() (i.e. one before postcore_initcall(), can I
expect these to work:

* node_isset()
* node_set()
* num_possibles_nodes()
* numa_node_id()
* next_node_in()

?

Dave, perhaps you know this?

[*] register_node_type() and kobject_event_init() are postcore init
    calls, so this would be non-racy.

> thanks,
>=20
> greg k-h

/Jarkko


