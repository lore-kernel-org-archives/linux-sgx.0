Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E16C606C1
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 14:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A2F921670
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 14:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfGHO5J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 10:57:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:50643 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbfGHO5I (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 10:57:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 07:57:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="340467850"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga005.jf.intel.com with ESMTP; 08 Jul 2019 07:57:07 -0700
Date:   Mon, 8 Jul 2019 07:57:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 01/12] x86/sgx: Use mmu_notifier.release() instead
 of per-vma refcounting
Message-ID: <20190708145707.GC20433@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-2-sean.j.christopherson@intel.com>
 <20190620210324.GF15383@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620210324.GF15383@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 21, 2019 at 12:03:36AM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 19, 2019 at 03:23:50PM -0700, Sean Christopherson wrote:
> > Using per-vma refcounting to track mm_structs associated with an enclave
> > requires hooking .vm_close(), which in turn prevents the mm from merging
> > vmas (precisely to allow refcounting).
> 
> Why having sgx_vma_close() prevents that? I do not understand the
> problem statement.

vmas that define .vm_close() cannot be merged.

  /*
   * If the vma has a ->close operation then the driver probably needs to release
   * per-vma resources, so we don't attempt to merge those.
   */
  static inline int is_mergeable_vma(struct vm_area_struct *vma,
				struct file *file, unsigned long vm_flags,
				struct vm_userfaultfd_ctx vm_userfaultfd_ctx)
  {
	...

	if (vma->vm_ops && vma->vm_ops->close)
		return 0;
	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
		return 0;
	return 1;
  }


> 
> > Avoid refcounting encl_mm altogether by registering an mmu_notifier at
> > .mmap(), removing the dying encl_mm at mmu_notifier.release() and
> > protecting mm_list during reclaim via a per-enclave SRCU.
> 
> Right, there is the potential collision with my changes:
> 
> 1. Your patch: enclave life-cycle equals life-cycle of all processes
>    that are associated with the enclave.
> 2. My (yet be sent) patch: enclave life-cycle equals the life cycle.
> 
> I won't rush with my patch. I rather merge neither at this point and
> you can review mine after you come back from your vacation.
> 
> > Removing refcounting/vm_close() allows merging of enclave vmas, at the
> > cost of delaying removal of encl_mm structs from mm_list, i.e. an mm is
> > disassociated from an enclave when the mm exits or the enclave dies, as
> > opposed to when the last vma (in a given mm) is closed.
> > 
> > The impact of delying encl_mm removal is its memory footprint and
> > whatever overhead is incurred during EPC reclaim (to walk an mm's vmas).
> > Practically speaking, a stale encl_mm will exist for a meaningful amount
> > of time if and only if the enclave is mapped in a long-lived process and
> > then passed off to another long-lived process.  It is expected that the
> > vast majority of use cases will not encounter this condition, e.g. even
> > using a daemon to build enclaves should not result in a stale encl_mm as
> > the builder should never need to mmap() the enclave.
> 
> This paragraph speaks only about "well behaving" software.

Malicious software isn't all that interesting as there are far easier ways
to waste system resources.  That being said, the encl_mm allocation can
use GFP_KERNEL_ACCOUNT.

> > Even if there are scenarios that lead to defunct encl_mms, the cost is
> > likely far outweighed by the benefits of reducing the number of vmas
> > across all enclaves.
> > 
> > Note, using SRCU to protect mm_list is not strictly necessary, i.e. the
> > existing walker with encl_mm refcounting could be massaged to work with
> > mmu_notifier.release(), but the resulting code is subtle and fragile (I
> > never actually got it working).  The primary issue is that an encl_mm
> > can't be moved off the list until its refcount goes to zero, otherwise
> > the custom walker goes off into the weeds.  The refcount requirement
> > then prevents using mm_list to identify if an mmu_notifier.release()
> > has fired, i.e. another mechanism is needed to guard against races
> > between exit_mmap() and sgx_release().
> 
> Is it really impossible to send a separate SRCU patch?

I can split out the SRCU as a precursor.  It'll likely take me a few days
to get it sent.

> I fully agree with the SRCU whereas rest of this patch is still
> under debate.
> 
> If you could do that, I can merge it in no time. It is a small
> step into better direction.
> 
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Needs to be rebased because the master missing your earlier bug fix.

...

> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 9566eb72d417..c6436bbd4a68 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -132,103 +132,125 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
> >  	return entry;
> >  }
> >  
> > -struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
> > -				    struct mm_struct *mm)
> > +static void sgx_encl_mm_release_wq(struct work_struct *work)
> > +{
> > +	struct sgx_encl_mm *encl_mm =
> > +		container_of(work, struct sgx_encl_mm, release_work);
> > +
> > +	sgx_encl_mm_release(encl_mm);
> > +}
> > +
> > +/*
> > + * Being a call_srcu() callback, this needs to be short, and sgx_encl_release()
> > + * is anything but short.  Do the final freeing in yet another async callback.
> > + */
> > +static void sgx_encl_mm_release_delayed(struct rcu_head *rcu)
> 
> Would rename this either as *_tail() or *_deferred().

Deferred works for me.

> > +{
> > +	struct sgx_encl_mm *encl_mm =
> > +		container_of(rcu, struct sgx_encl_mm, rcu);
> > +
> > +	INIT_WORK(&encl_mm->release_work, sgx_encl_mm_release_wq);
> > +	schedule_work(&encl_mm->release_work);
> > +}
> > +

...

> > @@ -118,11 +123,13 @@ void sgx_encl_destroy(struct sgx_encl *encl);
> >  void sgx_encl_release(struct kref *ref);
> >  pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page);
> >  struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
> > -struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
> > -				     struct sgx_encl_mm *encl_mm, int *iter);
> > -struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
> > -				    struct mm_struct *mm);
> > -void sgx_encl_mm_release(struct kref *ref);
> > +int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
> > +static inline void sgx_encl_mm_release(struct sgx_encl_mm *encl_mm)
> > +{
> > +	kref_put(&encl_mm->encl->refcount, sgx_encl_release);
> > +
> > +	kfree(encl_mm);
> > +}
> 
> Please just open code this to the two call sites. Makes the code hard to
> follow.

Heh, I waffled between a helper and open coding.  I chose poorly :-)

> Right now I did not find anything else questionable from the code
> changes. Repeating myself but if it is by any means possible before
> going away, can you construct a pure SRCU patch.
>
> I could then reconstruct my changes on top off that, which would
> make evalution of both heck a lot easier.
> 
> /Jarkko
