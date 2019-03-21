Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B73C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 17:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00EBF2190A
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 17:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfCURiO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:38:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:65154 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfCURiO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 13:38:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 10:38:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="124702249"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2019 10:38:13 -0700
Date:   Thu, 21 Mar 2019 10:38:13 -0700
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
Message-ID: <20190321173813.GF6519@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319230047.GL25575@linux.intel.com>
 <20190321161827.GT4603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321161827.GT4603@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 06:18:27PM +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 19, 2019 at 04:00:47PM -0700, Sean Christopherson wrote:
> > On Sun, Mar 17, 2019 at 11:14:45PM +0200, Jarkko Sakkinen wrote:
> > > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > > can be used by applications to set aside private regions of code and
> > > data. The code outside the enclave is disallowed to access the memory
> > > inside the enclave by the CPU access control.
> > > 
> > > This commit adds the Linux SGX Enclave Driver that provides an ioctl API
> > > to manage enclaves. The address range for an enclave, commonly referred
> > > as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
> > > mmap() against /dev/sgx. After that a set ioctls is used to build
> > > the enclave to the ELRANGE.
> > 
> > 
> > ...
> > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > > new file mode 100644
> > > index 000000000000..bd8bcd748976
> > > --- /dev/null
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > 
> > ...
> > 
> > > +/**
> > > + * sgx_encl_next_mm() - Iterate to the next mm
> > > + * @encl:	an enclave
> > > + * @mm:		an mm list entry
> > > + * @iter:	iterator status
> > > + *
> > > + * Return: the enclave mm or NULL
> > > + */
> > > +struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
> > > +				     struct sgx_encl_mm *mm, int *iter)
> > > +{
> > > +	struct list_head *entry;
> > > +
> > > +	WARN(!encl, "%s: encl is NULL", __func__);
> > > +	WARN(!iter, "%s: iter is NULL", __func__);
> > > +
> > > +	spin_lock(&encl->mm_lock);
> > > +
> > > +	entry = mm ? mm->list.next : encl->mm_list.next;
> > > +	WARN(!entry, "%s: entry is NULL", __func__);
> > > +
> > > +	if (entry == &encl->mm_list) {
> > > +		mm = NULL;
> > > +		*iter = SGX_ENCL_MM_ITER_DONE;
> > > +		goto out;
> > > +	}
> > > +
> > > +	mm = list_entry(entry, struct sgx_encl_mm, list);
> > > +
> > > +	if (!kref_get_unless_zero(&mm->refcount)) {
> > > +		*iter = SGX_ENCL_MM_ITER_RESTART;
> > > +		mm = NULL;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (!atomic_add_unless(&mm->mm->mm_count, 1, 0)) {
> > 
> > This is a use-after-free scenario if mm_count==0.  Once the count goes
> > to zero, __mmdrop() begins, at which point this code is racing against
> > free_mm().  What you want here (or rather, in flows where mm != current->mm
> > and you want to access PTEs) is mmget_not_zero(), i.e. "unless zero"
> > on mm_users.  mm_count prevents the mm_struct from being freed, but
> > doesn't protect the page tables.  mm_users protects the page tables,
> > i.e. lets us safely call sgx_encl_test_and_clear_young in the reclaimer.
> > 
> > To ensure liveliness of the mm itself, register an mmu_notifier for each
> > mm_struct (I think in sgx_vma_open()).  The enclave's .release callback
> > would then delete the mm from its list and drop its reference (exit_mmap()
> > holds a reference to mm_count so it's safe to do mmdrop() in the .release
> > callback).  E.g.:
> > 
> > static void sgx_vma_open(struct vm_area_struct *vma)
> > {
> > 	...
> > 
> > 	rcu_read_lock();
> > 	list_for_each_entry_rcu(...) {
> > 		if (vma->vm_mm == tmp->mm) {
> > 			encl_mm = tmp;
> > 			break;
> > 		}
> > 	}
> > 	rcu_read_unlock();
> > 
> > 	if (!encl_mm) {
> > 		mm = kzalloc(sizeof(*mm), GFP_KERNEL);
> > 		if (!mm) {
> > 			goto error;
> > 
> > 		encl_mm->encl = encl;
> > 		encl_mm->mm = vma->vm_mm;
> > 
> > 		if (mmu_notifier_register(&encl->mmu_notifier, encl_mm)) {
> > 			kfree(encl_mm);
> > 			goto error;
> > 		}
> 
> OK, thanks for catching the bug. I'm cool with adding MMU notifier back.
> Just wondering when unregister should be called.

We'd need to refcount the encl_mm and unregister its callback when its
refcount goes to zero.  I dislike the idea of refcounting both encl and
encl_mm, but it does seem to be the most (only?) robust solution.

The alternative is to not refcount encl_mm, e.g. unregister the callback
when the encl itself is freed, but then there is no way to detect when
the last vma is closed, i.e. we have to hold the encl_mm until the entire
mm_struct dies.

> 
> > 
> > 		spin_lock(&encl->mm_lock);
> > 		list_add(&encl_mm->list, &encl->mm_list);
> > 		spin_unlock(&encl->mm_lock);
> > 	}
> > 
> > 	...
> > error:
> > 	<not sure what should go here if we don't kill the enclave>
> > }
> > 
> > static void sgx_encl_mmu_release(struct mmu_notifier *mn, struct mm_struct *mm)
> > {
> > 	struct sgx_encl_mm *encl_mm =
> > 		container_of(mn, struct sgx_encl_mm, mmu_notifier);
> > 
> > 	spin_lock(encl_mm->encl->mm_lock);
> > 	list_del_rcu(&encl_mm->list);
> > 	spin_unlock(encl_mm->encl->mm_lock);
> > 
> > 	synchronize_rcu();
> > 
> > 	mmdrop(mm);
> > }
> > 
> > Alternatively, the sgx_encl_mmu_release() could mark the encl_mm as dead
> > instead of removing it from the list, but I don't think that'd mesh well
> > with an RCU list, i.e. we'd need a regular lock-protected list and a
> > custom walker.
> > 
> > The only downside with the RCU approach that I can think of is that the
> > encl_mm would stay on the enclave's list until the enclave or the mm
> > itself died.  That could result in unnecessary IPIs during reclaim (or
> > invalidation), but that seems like a minor corner case that could be
> > avoided in userspace, e.g. don't mmap() an enclave unless you actually
> > plan on running it.
> 
> Yeah, that is really the root why ended up what I have i.e to be able
> to move them real time. If they can be in the list forever, then RCU
> is doable. I was wondering with your RCU comments how you would deal
> with this.

Aha!  Similar to the old 1:1 encl:mm approach, the release callback would
simply mark the associated entity "dead", in this case the encl_mm.  We'd
still refcount encl_mm and handle unregistering and whatnot when the last
vma is closed, i.e. refcount goes to zero.  Marking the encl_mm as dead
instead of trying to delete it from the list avoids scenarios where we're
holding a reference to the encl_mm but it's no longer on the list.

The synchronize_srcu() during release ensures we don't operate on a dead
enclave.  And the only time we'd take mm_lock is to insert/delete to/from
the list, i.e. vma open/close, thus sidestepping lock ordering issues
between mm_lock and mmap_sem.  Traversing the list in the fault handler
can be avoided by nullifying vm_private_data or by checking the liveliness
of the enclave iself.

E.g.:

static void sgx_encl_mmu_release(struct mmu_notifier *mn, struct mm_struct *mm)
{
        struct sgx_encl_mm *encl_mm =
                container_of(mn, struct sgx_encl_mm, mmu_notifier);

	encl_mm->dead = true;

        synchronize_srcu(&encl_srcu);
}


And reclaim looks something like:

static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
{
	...

	id = srcu_read_lock(&encl_srcu);

	list_for_each_entry_rcu(...) {
		if (encl_mm->dead)
			continue;

		down_read(&encl_mm->mm->mmap_sem);

		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
		if (!ret && encl == vma->vm_private_data)
			zap_vma_ptes(vma, addr, PAGE_SIZE);

		up_read(&encl_mm->mm->mmap_sem);
	}

	srcu_read_unlock(&encl_srcu, id);

	mutex_lock(&encl->lock);

	if (!(encl->flags & SGX_ENCL_DEAD)) {
		ret = __eblock(sgx_epc_addr(epc_page));
		if (encls_failed(ret))
			ENCLS_WARN(ret, "EBLOCK");
	}

	mutex_unlock(&encl->lock);
}


