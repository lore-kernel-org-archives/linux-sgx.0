Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C904C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jan 2022 06:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiAQG5L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jan 2022 01:57:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53634 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiAQG5K (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Jan 2022 01:57:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8934D60F4D
        for <linux-sgx@vger.kernel.org>; Mon, 17 Jan 2022 06:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71500C36AE7;
        Mon, 17 Jan 2022 06:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642402630;
        bh=hnBp+MFCq+8o5Pw+2PrhdhlpgItWWiCqNUQGGE3gFb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dNJUjA3B3MPFqZh5ljcmWp93A21x+SOpSrsFk4Krh83OM5XSLUj6vjBACuDmn61sZ
         WgqE68sfzs38PLKRqHB8zi8/YlcEOvF+p5ltB6Po0EaIvzKWe+VPUfDC1vpi3US2wN
         22Zw+v0JMMv8r0bUV0tEZ7UcuOI86Lr0Dgcy6J8Ek6L/ZNTyqCCi9ESasY8k7qUnU/
         EZAFhyo0x4dV4q3D8uW0t9cocrgWRtueVhG66ptfk6LoBvfwVQHLYc190B3Q/nCXoz
         tFlS1giBr7GTAzNsAayC9bI0xHwSP8sjg3EqkoyHNSl8xO6ckjIV7T12ebQ6PrIgm8
         9H0oeEnSD/Clw==
Date:   Mon, 17 Jan 2022 08:56:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, eblake@redhat.com,
        linux-sgx@vger.kernel.org
Subject: Re: unable to execute QEMU command 'qom-get': Property
 'sgx-epc.unavailable-features' not found
Message-ID: <YeUTNptmJYRaFr/u@iki.fi>
References: <20211125124722.GA25401@yangzhon-Virtual>
 <20211130121536.GA32686@yangzhon-Virtual>
 <YeTaOVpWeGLa2xzb@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeTaOVpWeGLa2xzb@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 17, 2022 at 04:53:48AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 30, 2021 at 08:15:36PM +0800, Yang Zhong wrote:
> > On Thu, Nov 25, 2021 at 08:47:22PM +0800, Yang Zhong wrote:
> > > Hello Paolo,
> > > 
> > > Our customer used the Libvirt XML to start a SGX VM, but failed.
> > > 
> > > libvirt.libvirtError: internal error: unable to execute QEMU command 'qom-get': Property 'sgx-epc.unavailable-features' not found
> > > 
> > > The XML file,
> > > <qemu:commandline>
> > >     <qemu:arg value="-cpu"/>
> > >     <qemu:arg value="host,+sgx,+sgx-debug,+sgx-exinfo,+sgx-kss,+sgx-mode64,+sgx-provisionkey,+sgx-tokenkey,+sgx1,+sgx2,+sgxlc"/>
> > >     <qemu:arg value="-object"/>
> > >     <qemu:arg value="memory-backend-epc,id=mem1,size=16M,prealloc=on"/>
> > >     <qemu:arg value="-M"/>
> > >     <qemu:arg value="sgx-epc.0.memdev=mem1"/>
> > >   </qemu:commandline>
> > > 
> > > The new compound property command should be located in /machine path,
> > > which are different with old command '-sgx-epc id=epc1,memdev=mem1'.
> > > 
> > > I also tried this from Qemu monitor tool, 
> > > (qemu) qom-list /machine
> > > type (string)
> > > kernel (string)
> > > ......
> > > sgx-epc (SgxEPC)
> > > ......
> > > sgx-epc[0] (child<memory-region>)
> > > ......
> > > 
> > > We can find sgx-epc from /machine list.
> > > 
> > 
> >   This issue is clear now, which is caused by Libvirt to get the CPU's unavailable-features by below command:
> >   {"execute":"qom-get","arguments":{"path":"/machine/unattached/device[0]","property":"unavailable-features"}
> > 
> >   but in SGX vm, since the sgx is initialized before VCPU because sgx need set the virtual EPC info in the cpuid.  
> > 
> >   So the /machine/unattached/device[0] is occupied by sgx, which fail to get the unvailable-features from
> >   /machine/unattached/device[0].
> > 
> > 
> >   We need fix this issue, but this can be done in Qemu or Libvirt side.
> > 
> >   1) Libvirt side
> >      If the libvirt support SGX EPCs, libvirt can use /machine/unattached/device[n] to check "unavailable-features".
> >      n is the next number of sgx's unattached_count.
> > 
> >   2) Qemu side
> >     
> >      One temp patch to create one /sgx in the /machine in the device_set_realized() 
> > diff --git a/hw/core/qdev.c b/hw/core/qdev.c
> > index 84f3019440..4154eef0d8 100644
> > --- a/hw/core/qdev.c
> > +++ b/hw/core/qdev.c
> > @@ -497,7 +497,7 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
> >      NamedClockList *ncl;
> >      Error *local_err = NULL;
> >      bool unattached_parent = false;
> > -    static int unattached_count;
> > +    static int unattached_count, sgx_count;
> > 
> >      if (dev->hotplugged && !dc->hotpluggable) {
> >          error_setg(errp, QERR_DEVICE_NO_HOTPLUG, object_get_typename(obj));
> > @@ -509,7 +509,15 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
> >              goto fail;
> >          }
> > 
> > -        if (!obj->parent) {
> > +        if (!obj->parent && !strcmp(object_get_typename(obj), "sgx-epc")) {
> > +            gchar *name = g_strdup_printf("device[%d]", sgx_count++);
> > +
> > +            object_property_add_child(container_get(qdev_get_machine(),
> > +                                                    "/sgx"),
> > +                                      name, obj);
> > +            unattached_parent = true;
> > +            g_free(name);
> > +        } else if (!obj->parent) {
> >              gchar *name = g_strdup_printf("device[%d]", unattached_count++);
> > 
> >              object_property_add_child(container_get(qdev_get_machine()
> >    
> >     This patch can make sure vcpu is still /machine/unattached/device[0].
> > 
> > 
> >     Which solution is best?  thanks!
> 
> Has either of the fixes reached yet reached upstream or not?

I built qemu from git with the fix applied. It fixed the issue for me.

Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

> >     Yang

BR, Jarkko
