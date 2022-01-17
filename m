Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960A1C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jan 2022 06:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbiAQGYU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jan 2022 01:24:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:32785 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234643AbiAQGYT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jan 2022 01:24:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642400659; x=1673936659;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=90yPxa/VRWw12d0ujnqJsaOq4CjYhc0E8jhoyxN5uw0=;
  b=d6cpHT2628ohXIyXiZTwNFLAagtoO6cR0qlULkA/GjDw55GvMg2PzcO5
   lb5IJivBoZ1HIteNEmp0SYYUGYj8qqSW686t58tCOOhY4PNWtpUgd0LWX
   xIFxzXipxh2bUBkEJ/7Bbx7i+GdOBOTdxzxC/m8B9oq/qs+Ee82ClpdLw
   +PbnW2XLHdgRa1OB+QFUeaN0isMU0ZrBrkpVHYbLt+usJiq9vV7HkgI1G
   aD07FQQAh+8iYeqsrHMqJZolLcyI6h7oe/G2v3GHyl73IXP1jTGIBeQ9x
   59f0wJAnhW6Awl0z1xfWjU5Ph7oOJDyLmcjtx9UAccUO/6g4NRB32v5sS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="225241374"
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="225241374"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 22:24:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,294,1635231600"; 
   d="scan'208";a="517294084"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.145.56])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 16 Jan 2022 22:24:17 -0800
Date:   Mon, 17 Jan 2022 14:09:00 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, eblake@redhat.com,
        linux-sgx@vger.kernel.org, yang.zhong@intel.com
Subject: Re: unable to execute QEMU command 'qom-get': Property
 'sgx-epc.unavailable-features' not found
Message-ID: <20220117060900.GA20805@yangzhon-Virtual>
References: <20211125124722.GA25401@yangzhon-Virtual>
 <20211130121536.GA32686@yangzhon-Virtual>
 <YeTaOVpWeGLa2xzb@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeTaOVpWeGLa2xzb@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 17, 2022 at 04:53:45AM +0200, Jarkko Sakkinen wrote:
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


  Jarkko, I sent out one patch to fix this issue last week,
  https://lists.nongnu.org/archive/html/qemu-devel/2022-01/msg02502.html

  Daniel regarded this fix is special code for SGX in the generic object code.
  So, this fix can be done in Libvirt side. Did you face this issue? or you can
  use this patch as TEMP fix. thanks!

  Yang  

> 
> >     Yang
> 
> BR, Jarkko
