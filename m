Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93CDC43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 18:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A558920675
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 18:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbeLQSgO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 13:36:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:1438 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbeLQSgO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 13:36:14 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 10:36:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208";a="119043409"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga002.jf.intel.com with ESMTP; 17 Dec 2018 10:36:13 -0800
Date:   Mon, 17 Dec 2018 10:36:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-sgx@vger.kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181217183613.GD12491@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217180102.GA12560@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 08:01:02PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 17, 2018 at 09:45:40AM -0800, Dave Hansen wrote:
> > > +struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
> > > +{
> > ...
> > > +	kref_init(&encl->refcount);
> > > +	INIT_LIST_HEAD(&encl->add_page_reqs);
> > > +	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
> > > +	mutex_init(&encl->lock);
> > > +	INIT_WORK(&encl->add_page_work, sgx_add_page_worker);
> > > +
> > > +	encl->mm = current->mm;  <---------------------------------> +	encl->base = secs->base;
> > > +	encl->size = secs->size;
> > > +	encl->ssaframesize = secs->ssa_frame_size;
> > > +	encl->backing = backing;
> > > +
> > > +	return encl;
> > > +}
> > 
> > How is this OK without taking a reference on the mm?

It's subtle and the ordering is all kinds of weird, but technically we
are taking a reference on mm when the mmu_notifier is registered in
sgx_encl_create().  sgx_encl_alloc() and sgx_encl_create() are always
called in tandem and with mm->mm_users > 0, so we'll never use encl->mm
without holding a reference to mm.  We need to comment the weirdness
or maybe register the notifier before

> > I have a feeling a bunch of your bugs with the mmu notifiers and so
> > forth are because the refcounting is wrong here.

Eh, not really.  Maybe the mmu_notifier is more subtle, e.g. calling
do_unmap() after mmput() would be quite obvious, but there's no
fundamental bug, we just haven't needed to touch VMAs during release
prior to moving away from shmem.

> > Sean's SGX_ENCL_MM_RELEASED would, I think be unnecessary if you just
> > take a refcount here and release it when the enclave is destroyed.
> 
> Right, atomic_inc(encl->mm->count) here and once when releasing.
> 
> The we would not even need the whole mmu notifier in the first place.

I'm pretty sure doing mmget() would result in circular dependencies and
a zombie enclave.  In the do_exit() case where a task is abruptly killed:
 
  - __mmput() is never called because the enclave holds a ref
  - sgx_encl_release() is never be called because its VMAs hold refs
  - sgx_vma_close() is never called because __mmput()->exit_mmap() is
    blocked and the process itself is dead, i.e. won't unmap anything.
