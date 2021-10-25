Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC1DC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Oct 2021 05:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E315161076
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Oct 2021 05:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhJYFSR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 Oct 2021 01:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhJYFSQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 Oct 2021 01:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8704160F92;
        Mon, 25 Oct 2021 05:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635138955;
        bh=uGQcQonQKEkkt5td7fa6/bmH3oGktW9n3KzEh9S4/SU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YGcCGwfwNsTlKvwG2/mgFqhWEw2FEuc3zRufIwLkwh2Mu5Dv4brOD/odcXEX6HlIL
         RZOyorbP/NUjeGXZ9STePqQfE6wvvInv17DI77W5GCBwp44nUMIK0hrJz0pji8t4vJ
         UmEWO0Jb2MBgyhtp7PkrJrgS3Ro46IfAkjdGyX28=
Date:   Mon, 25 Oct 2021 07:15:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH v8 2/2] x86/sgx: Add an attribute for the amount of SGX
 memory in a NUMA node
Message-ID: <YXY9gsIn+VhmPhHU@kroah.com>
References: <20211018135744.45527-1-jarkko@kernel.org>
 <20211018135744.45527-2-jarkko@kernel.org>
 <YW2GLE89WxAeMZH4@kroah.com>
 <4050b7723f6f205c9afc3bdfa3888a6e8befa12a.camel@kernel.org>
 <YXOsx8SvFJV5R7lU@kroah.com>
 <2b30027eb017216986e88008fdc925d0e6c61ce0.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b30027eb017216986e88008fdc925d0e6c61ce0.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 24, 2021 at 05:24:43PM +0300, Jarkko Sakkinen wrote:
> On Sat, 2021-10-23 at 08:33 +0200, Greg Kroah-Hartman wrote:
> > On Sat, Oct 23, 2021 at 04:02:48AM +0300, Jarkko Sakkinen wrote:
> > > On Mon, 2021-10-18 at 16:35 +0200, Greg Kroah-Hartman wrote:
> > > > > +               ret = sysfs_create_group(&dev->kobj, &sgx_node_attr_group);
> > > > 
> > > > A huge hint, if a driver has to call a sysfs_* call, something is wrong.
> > > > 
> > > > Something is wrong here.
> > > > 
> > > > Why are you messing around with a kobject?  This is a device, that you
> > > > control, you can just set the default attribute group for it and then
> > > > the driver core will add and remove the sysfs group at the proper time,
> > > > in the proper way.  Right now you are racing userspace and loosing.
> > > > 
> > > > Use the default group list, that is what it is there for.
> > > 
> > > I used sysfs_create_group() because node_devices is not owned by SGX
> > > code. It is managed in drivers/base/node.c, and also initialized before
> > > SGX.
> > 
> > Then that is broken, please do not use that device as your code does not
> > "own" it.  Or fix the logic to be initialized earlier.
> 
> To get a synchronous initialization, I'd need to add the attributes as
> part of this declaration:
> 
> static struct attribute *node_dev_attrs[] = {
> 	&dev_attr_cpumap.attr,
> 	&dev_attr_cpulist.attr,
> 	&dev_attr_meminfo.attr,
> 	&dev_attr_numastat.attr,
> 	&dev_attr_distance.attr,
> 	&dev_attr_vmstat.attr,
> 	NULL
> };
> ATTRIBUTE_GROUPS(node_dev);
> 
> That guarantees that the attribute exists at the time when the
> node is created, e.g. in that sense this will fix the race with
> uevent code.
> 
> However, up until sgx_init() has been completed, the attribute
> will emit '0'.

Is that a problem?  Who would be wanting to use sgx until that happens?
You have this issue today anyway, right?

> If I change sgx_init() from device_initcall() to
> core_initcall() (i.e. one before postcore_initcall(), can I
> expect these to work:
> 
> * node_isset()
> * node_set()
> * num_possibles_nodes()
> * numa_node_id()
> * next_node_in()
> 
> ?

You should be able to test this out yourself :)

thanks,

greg k-h
