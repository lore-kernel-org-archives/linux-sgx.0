Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C873C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 09:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C1882080A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 09:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601890922;
	bh=KOf5TC9k5uct+kmBvXnOAdn5lDSOSfLzFgI/SdGie+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vI2JE1ZsCsn2+/9H863OgNhlaGaR4G9SZXBPr/OQ6QWq7q3GHSjdLdiHJvcp+Z67l
	 GulBC8Pe2E9GW6KMfg7TAPTDtwb6Ls2582/3iCFGwBPxSmHaqexz/P1bZIOXXe8Vq3
	 LX3PwvNUvwq2TRfzjgNpJJUL52KFdxPqcDisRoF8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJEJmB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgJEJmB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 05:42:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C276A20796;
        Mon,  5 Oct 2020 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601890920;
        bh=KOf5TC9k5uct+kmBvXnOAdn5lDSOSfLzFgI/SdGie+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJQgCR+Z323M2j68V32QggNeeh+d5VgpmrZZQnpOEK3hD8adRVC3wKtVg5xPzmi5A
         i2gbP174ToQ8R5exW1LRuiC9jXnYOGETza2QQnqThaYYpFdMwEDJ5JbpSD1FExrdDQ
         F7d9nOV5GQUXoCZylC2cORfxCt1FyRmy+J1Gp1XQ=
Date:   Mon, 5 Oct 2020 11:42:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201005094246.GB151835@kroah.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201004143246.GA3561@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004143246.GA3561@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 04, 2020 at 05:32:46PM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 03, 2020 at 04:39:25PM +0200, Greg KH wrote:
> > On Sat, Oct 03, 2020 at 07:50:46AM +0300, Jarkko Sakkinen wrote:
> > > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that can
> > > be used by applications to set aside private regions of code and data. The
> > > code outside the SGX hosted software entity is prevented from accessing the
> > > memory inside the enclave by the CPU. We call these entities enclaves.
> > > 
> > > Add a driver that provides an ioctl API to construct and run enclaves.
> > > Enclaves are constructed from pages residing in reserved physical memory
> > > areas. The contents of these pages can only be accessed when they are
> > > mapped as part of an enclave, by a hardware thread running inside the
> > > enclave.
> > > 
> > > The starting state of an enclave consists of a fixed measured set of
> > > pages that are copied to the EPC during the construction process by
> > > using the opcode ENCLS leaf functions and Software Enclave Control
> > > Structure (SECS) that defines the enclave properties.
> > > 
> > > Enclaves are constructed by using ENCLS leaf functions ECREATE, EADD and
> > > EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> > > the EPC and EINIT checks a given signed measurement and moves the enclave
> > > into a state ready for execution.
> > > 
> > > An initialized enclave can only be accessed through special Thread Control
> > > Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
> > > function converts a thread into enclave mode and continues the execution in
> > > the offset defined by the TCS provided to EENTER. An enclave is exited
> > > through syscall, exception, interrupts or by explicitly calling another
> > > ENCLU leaf EEXIT.
> > > 
> > > The mmap() permissions are capped by the contained enclave page
> > > permissions. The mapped areas must also be populated, i.e. each page
> > > address must contain a page. This logic is implemented in
> > > sgx_encl_may_map().
> > > 
> > > Cc: linux-security-module@vger.kernel.org
> > > Cc: linux-mm@kvack.org
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > > Tested-by: Jethro Beekman <jethro@fortanix.com>
> > > Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> > > Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> > > Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> > > Tested-by: Seth Moore <sethmo@google.com>
> > > Tested-by: Darren Kenny <darren.kenny@oracle.com>
> > > Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
> > > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/Makefile |   2 +
> > >  arch/x86/kernel/cpu/sgx/driver.c | 173 ++++++++++++++++
> > >  arch/x86/kernel/cpu/sgx/driver.h |  29 +++
> > >  arch/x86/kernel/cpu/sgx/encl.c   | 331 +++++++++++++++++++++++++++++++
> > >  arch/x86/kernel/cpu/sgx/encl.h   |  85 ++++++++
> > >  arch/x86/kernel/cpu/sgx/main.c   |  11 +
> > >  6 files changed, 631 insertions(+)
> > >  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
> > >  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
> > >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
> > >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> > > index 79510ce01b3b..3fc451120735 100644
> > > --- a/arch/x86/kernel/cpu/sgx/Makefile
> > > +++ b/arch/x86/kernel/cpu/sgx/Makefile
> > > @@ -1,2 +1,4 @@
> > >  obj-y += \
> > > +	driver.o \
> > > +	encl.o \
> > >  	main.o
> > > diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> > > new file mode 100644
> > > index 000000000000..f54da5f19c2b
> > > --- /dev/null
> > > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > > @@ -0,0 +1,173 @@
> > > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > 
> > You use gpl-only header files in this file, so how in the world can it
> > be bsd-3 licensed?
> > 
> > Please get your legal department to agree with this, after you explain
> > to them how you are mixing gpl2-only code in with this file.
> 
> I'll do what I already stated that I will do. Should I do something
> more?

This was written before your previous response.

> > > +	mutex_lock(&encl->lock);
> > > +	atomic_or(SGX_ENCL_DEAD, &encl->flags);
> > 
> > So you set a flag that this is dead, and then instantly delete it?  Why
> > does that matter?  I see you check for this flag elsewhere, but as you
> > are just about to delete this structure, how can this be an issue?
> 
> It matters because ksgxswapd (sgx_reclaimer_*) might be processing it.

I don't see that happening in this patch, did I miss it?

> It will use the flag to skip the operations that it would do to a victim
> page, when the enclave is still alive.

Again, why are you adding flags when the patch does not use them?
Please put new functionality in the specific patch that uses it.

And can you really rely on this?  How did sgx_reclaimer_* (whatever that
is), get the reference on this object in the first place?  Again, I
don't see that happening at all in here, and at a quick glance in the
other patches I don't see it there either.  What am I missing?

> > > +	mutex_unlock(&encl->lock);
> > > +
> > > +	kref_put(&encl->refcount, sgx_encl_release);
> > 
> > Don't you need to hold the lock across the put?  If not, what is
> > serializing this?
> > 
> > But an even larger comment, why is this reference count needed at all?
> > 
> > You never grab it except at init time, and you free it at close time.
> > Why not rely on the reference counting that the vfs ensures you?
> 
> Because ksgxswapd needs the alive enclave instance while it is in the
> process of swapping a victim page. The reason for this is the
> hierarchical nature of the enclave pages.
> 
> As an example, a write operation to main memory, EWB (SDM vol 3D 40-79)

What is that referencing?

> needs to access SGX Enclave Control Structure (SECS) page, which is
> contains global data for an enclave, like the unswapped child count.

Ok, but how did it get access to this structure in the first place, like
I ask above?

> > > +	return 0;
> > > +}
> > > +
> > > +static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> > > +{
> > > +	struct sgx_encl *encl = file->private_data;
> > > +	int ret;
> > > +
> > > +	ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = sgx_encl_mm_add(encl, vma->vm_mm);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	vma->vm_ops = &sgx_vm_ops;
> > > +	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
> > > +	vma->vm_private_data = encl;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static unsigned long sgx_get_unmapped_area(struct file *file,
> > > +					   unsigned long addr,
> > > +					   unsigned long len,
> > > +					   unsigned long pgoff,
> > > +					   unsigned long flags)
> > > +{
> > > +	if ((flags & MAP_TYPE) == MAP_PRIVATE)
> > > +		return -EINVAL;
> > > +
> > > +	if (flags & MAP_FIXED)
> > > +		return addr;
> > > +
> > > +	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
> > > +}
> > > +
> > > +static const struct file_operations sgx_encl_fops = {
> > > +	.owner			= THIS_MODULE,
> > > +	.open			= sgx_open,
> > > +	.release		= sgx_release,
> > > +	.mmap			= sgx_mmap,
> > > +	.get_unmapped_area	= sgx_get_unmapped_area,
> > > +};
> > > +
> > > +static struct miscdevice sgx_dev_enclave = {
> > > +	.minor = MISC_DYNAMIC_MINOR,
> > > +	.name = "enclave",
> > > +	.nodename = "sgx/enclave",
> > 
> > A subdir for a single device node?  Ok, odd, but why not just
> > "sgx_enclave"?  How "special" is this device node?
> 
> There is a patch that adds "sgx/provision".

What number in this series?

> Either works for me. Should I flatten them to "sgx_enclave" and
> "sgx_provision", or keep them as they are?

Having 2 char nodes in a subdir is better than one, I will give you
that.  But none is even better, don't you think?

thanks,

greg k-h
