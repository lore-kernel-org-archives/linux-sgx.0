Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554EDC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 16:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252E121902
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 16:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbfCUQrP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:47:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:13857 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbfCUQrO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 12:47:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 09:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="127437552"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 21 Mar 2019 09:47:14 -0700
Date:   Thu, 21 Mar 2019 09:47:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190321164714.GE6519@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321155111.GR4603@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 05:51:11PM +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 19, 2019 at 02:19:51PM -0700, Sean Christopherson wrote:
> > IMO we should get rid of SGX_POWER_LOST_ENCLAVE and the SUSPEND flag.
> > 
> >   - Userspace needs to handle -EFAULT cleanly even if we hook into
> >     suspend/hibernate via sgx_encl_pm_notifier(), e.g. to handle virtual
> >     machine migration.
> >   - In the event that suspend is canceled after sgx_encl_pm_notifier()
> >     runs, we'll have prematurely invalidated the enclave.
> >   - Invalidating all enclaves could be slow on a system with GBs of EPC,
> >     i.e. probably not the best thing to do in the suspend path.
> > 
> > Removing SGX_POWER_LOST_ENCLAVE means we can drop all of the pm_notifier()
> > code, which will likely save us a bit of maintenance down the line.
> 
> I don't disgree. Isn't it a racy flag in the VM context i.e. because
> suspend can happen without SGX core noticing it (running inside a VM)?
> That would a bug.


...

> > > +#ifdef CONFIG_ACPI
> > > +static struct acpi_device_id sgx_device_ids[] = {
> > > +	{"INT0E0C", 0},
> > > +	{"", 0},
> > > +};
> > > +MODULE_DEVICE_TABLE(acpi, sgx_device_ids);
> > > +#endif
> > > +
> > > +static struct platform_driver sgx_drv = {
> > > +	.probe = sgx_drv_probe,
> > > +	.remove = sgx_drv_remove,
> > > +	.driver = {
> > > +		.name			= "sgx",
> > > +		.acpi_match_table	= ACPI_PTR(sgx_device_ids),
> > > +	},
> > > +};
> > 
> > Utilizing the platform driver is unnecessary, adds complexity and IMO is
> > flat out wrong given the current direction of implementing SGX as a
> > full-blooded architectural feature.
> > 
> >   - All hardware information is readily available via CPUID
> >   - arch_initcall hooks obviates the need for ACPI autoprobe
> >   - EPC manager assumes it has full control over all EPC, i.e. EPC
> >     sections are not managed as independent "devices"
> >   - BIOS will enumerate a single ACPI entry regardless of the number
> >     of EPC sections, i.e. the ACPI entry is *only* useful for probing
> >   - Userspace driver matches the EPC device, but doesn't actually
> >     "own" the EPC
> 
> It is for hotplugging. I don't really have strong opinions of this but
> having a driver for uapi allows things like blacklisting sgx.

Hotplugging what?  EPC can't be hotplugged, EPC enumeration through CPUID
won't change post-boot and the ACPI entry can't be relied upon for EPC
base/size information when there are multiple EPC sections.

> > > +
> > > +static int __init sgx_drv_subsys_init(void)
> > > +{
> > > +     int ret;
> > > +
> > > +     ret = bus_register(&sgx_bus_type);
> > 
> > Do we really need a bus/class?  Allocating a chrdev region also seems like
> > overkill.  At this point there is exactly one SGX device, and while there
> > is a pretty good chance we'll end up with a virtualization specific device
> > for exposing EPC to guest, there's no guarantee said device will be SGX
> > specific.  Using a dynamic miscdevice would eliminate a big chunk of code.
> 
> AFAIK misc is not recommended for any new drivers as it has suvere
> limitations like not allowing to add non-racy sysfs attributes. Whatever
> the solution is, lets not use misc.

Ah right, forgot about that.

> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_DRV_NR_DEVICES, "sgx");
> > > +	if (ret < 0) {
> > > +		bus_unregister(&sgx_bus_type);
> > > +		return ret;
> > > +	}
> > > +
> > > +	return 0;
> > > +}

...

> > > +static void sgx_vma_open(struct vm_area_struct *vma)
> > > +{
> > > +	struct sgx_encl *encl = vma->vm_private_data;
> > > +	struct sgx_encl_mm *mm;
> > > +
> > > +	if (!encl)
> > > +		return;
> > > +
> > > +	if (encl->flags & SGX_ENCL_DEAD)
> > > +		goto out;
> > > +
> > > +	mm = sgx_encl_get_mm(encl, vma->vm_mm);
> > > +	if (!mm) {
> > > +		mm = kzalloc(sizeof(*mm), GFP_KERNEL);
> > > +		if (!mm) {
> > > +			encl->flags |= SGX_ENCL_DEAD;
> > 
> > Failure to allocate memory for one user of the enclave shouldn't kill
> > the enclave, e.g. failing during fork() shouldn't kill the enclave in
> > the the parent.  And marking an enclave dead without holding its lock
> > is all kinds of bad.
> 
> This is almost non-existent occasion. Agree with the locking though..
> And I'm open for other fallbacks but given the rarity I think the
> current one in sustainable.

What if we clear vm_private_data?  And maybe do a pr_warn_ratelimited()
so that userspace gets some form of notification that forking an enclave
failed.  A NULL encl is easy to check in the fault handler and any where
else we consume vmas.

> 
> > 
> > > +			goto out;
> > > +		}
> > > +
> > > +		spin_lock(&encl->mm_lock);
> > > +		mm->encl = encl;
> > > +		mm->mm = vma->vm_mm;
> > > +		list_add(&mm->list, &encl->mm_list);
> > > +		kref_init(&mm->refcount);
> > 
> > Not that it truly matters, but list_add() is the only thing that needs
> > to be protected with the spinlock, everything else can be done ahead of
> > time.
> 
> True :-)
> 
> > 
> > > +		spin_unlock(&encl->mm_lock);
> > > +	} else {
> > > +		mmdrop(mm->mm);
> > > +	}
> > > +
> > > +out:
> > > +	kref_get(&encl->refcount);
> > > +}
> > > +
> > > +static void sgx_vma_close(struct vm_area_struct *vma)
> > > +{
> > > +	struct sgx_encl *encl = vma->vm_private_data;
> > > +	struct sgx_encl_mm *mm;
> > > +
> > > +	if (!encl)
> > > +		return;
> > > +
> > > +	mm = sgx_encl_get_mm(encl, vma->vm_mm);
> > 
> > Isn't this unnecessary?  sgx_vma_open() had to have been called on this
> > VMA, otherwise we wouldn't be here.
> 
> Not in the case when allocation fails in vma_open.

Ah, I see the flow.  If we do keep the enclave killing behavior then I
think it'd make sense to let this be handled by checking SGX_ENCL_DEAD.
But AFAICT things will "just work" if we nullify vm_private_data.
