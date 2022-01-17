Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30510C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jan 2022 06:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiAQG6V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jan 2022 01:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiAQG6V (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Jan 2022 01:58:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0E9C061574
        for <linux-sgx@vger.kernel.org>; Sun, 16 Jan 2022 22:58:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D96C60F4D
        for <linux-sgx@vger.kernel.org>; Mon, 17 Jan 2022 06:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8792AC36AE3;
        Mon, 17 Jan 2022 06:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642402700;
        bh=CIdMFP/wxHSUrB+5c2DLxDopAZ7ik6qzqInWfiFDhRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PzMWkm684QyvEfJHoZcx4uKnk4ZN3YV41i/VzaEHB7W/zNo2zEx3w2R3Oupu0iH9A
         VPos7LTgHULRxYgzjEr+psCvQABwrW0nbnH21cs39augbngA3dU16LJyZI7suyoZvG
         tUya9ZKqoLQieFYF+aeT3uKRgeKlSVfeGW9MofYe9nqMbVRb7mhtpA9M7q70fQ1bFi
         SUWejBcjJ+4c8bUj8oENNjD9J40wzmxBVCpFRV32j3FM1PH4vMCK3RdP1B1GeyEyB6
         H5RC037U0D6FnbQIx+a6lC1vvjXv1h2wVisyvSERCZti+cJhoCvP5lIeKst6yGLHMc
         O5FY/tiX4oSfQ==
Date:   Mon, 17 Jan 2022 08:58:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, eblake@redhat.com,
        linux-sgx@vger.kernel.org
Subject: Re: unable to execute QEMU command 'qom-get': Property
 'sgx-epc.unavailable-features' not found
Message-ID: <YeUTfZd4ppreJPlL@iki.fi>
References: <20211125124722.GA25401@yangzhon-Virtual>
 <20211130121536.GA32686@yangzhon-Virtual>
 <YeTaOVpWeGLa2xzb@iki.fi>
 <20220117060900.GA20805@yangzhon-Virtual>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117060900.GA20805@yangzhon-Virtual>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 17, 2022 at 02:09:00PM +0800, Yang Zhong wrote:
> On Mon, Jan 17, 2022 at 04:53:45AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 30, 2021 at 08:15:36PM +0800, Yang Zhong wrote:
> > > On Thu, Nov 25, 2021 at 08:47:22PM +0800, Yang Zhong wrote:
> > > > Hello Paolo,
> > > > 
> > > > Our customer used the Libvirt XML to start a SGX VM, but failed.
> > > > 
> > > > libvirt.libvirtError: internal error: unable to execute QEMU command 'qom-get': Property 'sgx-epc.unavailable-features' not found
> > > > 
> > > > The XML file,
> > > > <qemu:commandline>
> > > >     <qemu:arg value="-cpu"/>
> > > >     <qemu:arg value="host,+sgx,+sgx-debug,+sgx-exinfo,+sgx-kss,+sgx-mode64,+sgx-provisionkey,+sgx-tokenkey,+sgx1,+sgx2,+sgxlc"/>
> > > >     <qemu:arg value="-object"/>
> > > >     <qemu:arg value="memory-backend-epc,id=mem1,size=16M,prealloc=on"/>
> > > >     <qemu:arg value="-M"/>
> > > >     <qemu:arg value="sgx-epc.0.memdev=mem1"/>
> > > >   </qemu:commandline>
> > > > 
> > > > The new compound property command should be located in /machine path,
> > > > which are different with old command '-sgx-epc id=epc1,memdev=mem1'.
> > > > 
> > > > I also tried this from Qemu monitor tool, 
> > > > (qemu) qom-list /machine
> > > > type (string)
> > > > kernel (string)
> > > > ......
> > > > sgx-epc (SgxEPC)
> > > > ......
> > > > sgx-epc[0] (child<memory-region>)
> > > > ......
> > > > 
> > > > We can find sgx-epc from /machine list.
> > > > 
> > > 
> > >   This issue is clear now, which is caused by Libvirt to get the CPU's unavailable-features by below command:
> > >   {"execute":"qom-get","arguments":{"path":"/machine/unattached/device[0]","property":"unavailable-features"}
> > > 
> > >   but in SGX vm, since the sgx is initialized before VCPU because sgx need set the virtual EPC info in the cpuid.  
> > > 
> > >   So the /machine/unattached/device[0] is occupied by sgx, which fail to get the unvailable-features from
> > >   /machine/unattached/device[0].
> > > 
> > > 
> > >   We need fix this issue, but this can be done in Qemu or Libvirt side.
> > > 
> > >   1) Libvirt side
> > >      If the libvirt support SGX EPCs, libvirt can use /machine/unattached/device[n] to check "unavailable-features".
> > >      n is the next number of sgx's unattached_count.
> > > 
> > >   2) Qemu side
> > >     
> > >      One temp patch to create one /sgx in the /machine in the device_set_realized() 
> > > diff --git a/hw/core/qdev.c b/hw/core/qdev.c
> > > index 84f3019440..4154eef0d8 100644
> > > --- a/hw/core/qdev.c
> > > +++ b/hw/core/qdev.c
> > > @@ -497,7 +497,7 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
> > >      NamedClockList *ncl;
> > >      Error *local_err = NULL;
> > >      bool unattached_parent = false;
> > > -    static int unattached_count;
> > > +    static int unattached_count, sgx_count;
> > > 
> > >      if (dev->hotplugged && !dc->hotpluggable) {
> > >          error_setg(errp, QERR_DEVICE_NO_HOTPLUG, object_get_typename(obj));
> > > @@ -509,7 +509,15 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
> > >              goto fail;
> > >          }
> > > 
> > > -        if (!obj->parent) {
> > > +        if (!obj->parent && !strcmp(object_get_typename(obj), "sgx-epc")) {
> > > +            gchar *name = g_strdup_printf("device[%d]", sgx_count++);
> > > +
> > > +            object_property_add_child(container_get(qdev_get_machine(),
> > > +                                                    "/sgx"),
> > > +                                      name, obj);
> > > +            unattached_parent = true;
> > > +            g_free(name);
> > > +        } else if (!obj->parent) {
> > >              gchar *name = g_strdup_printf("device[%d]", unattached_count++);
> > > 
> > >              object_property_add_child(container_get(qdev_get_machine()
> > >    
> > >     This patch can make sure vcpu is still /machine/unattached/device[0].
> > > 
> > > 
> > >     Which solution is best?  thanks!
> > 
> > Has either of the fixes reached yet reached upstream or not?
> 
> 
>   Jarkko, I sent out one patch to fix this issue last week,
>   https://lists.nongnu.org/archive/html/qemu-devel/2022-01/msg02502.html
> 
>   Daniel regarded this fix is special code for SGX in the generic object code.
>   So, this fix can be done in Libvirt side. Did you face this issue? or you can
>   use this patch as TEMP fix. thanks!

Great, thank you! You can add my tested-by to the patch.

>   Yang  

BR, Jarkko
