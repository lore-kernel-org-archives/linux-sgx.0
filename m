Return-Path: <SRS0=nWD/=5D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A25C10DCE
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 16:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E95FF2076C
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Mar 2020 16:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgCRQDR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 12:03:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:12898 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCRQDR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 12:03:17 -0400
IronPort-SDR: eDTOjhv8wUnkuqIWnWALxrm3PsgE9aDytnSPK9ME7Q8NdxBrfUuBHj/ynMqAIbUr91TBDjqF4G
 j8U9dvqzB2nQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 09:03:16 -0700
IronPort-SDR: REr3CEwpaocXzjG8mZ7P9rHrrGq1QGDHDMv2vDxAE9XUukh017IE0MZyk/DFfQ7UUXiyf4jNiO
 5ZY0L/r/0xGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="391494743"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 18 Mar 2020 09:03:16 -0700
Date:   Wed, 18 Mar 2020 09:03:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Fix deadlock and race conditions between fork()
 and EPC reclaim
Message-ID: <20200318160316.GE24357@linux.intel.com>
References: <20200317051539.10447-1-sean.j.christopherson@intel.com>
 <20200318153903.GA37333@linux.intel.com>
 <20200318155043.GA37726@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318155043.GA37726@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 05:50:43PM +0200, Jarkko Sakkinen wrote:
> On Wed, Mar 18, 2020 at 05:39:07PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Mar 16, 2020 at 10:15:39PM -0700, Sean Christopherson wrote:
> > > @@ -223,10 +229,22 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
> > >  
> > >  	spin_lock(&encl->mm_lock);
> > >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > > +	/*
> > > +	 * Ensure the mm is added to the list before updating the version.
> > > +	 * Pairs with the smp_rmb() in sgx_reclaimer_block().
> > > +	 */
> > > +	smp_wmb();
> > > +	encl->mm_list_version++;
> > >  	spin_unlock(&encl->mm_lock);
> > >  
> > > -	synchronize_srcu(&encl->srcu);
> > > -
> > > +	/*
> > > +	 * DO NOT call synchronize_srcu()!  When this is called via dup_mmap(),
> > > +	 * mmap_sem is held for write in both the old mm and new mm, and the
> > > +	 * reclaimer may be holding srcu for read while waiting on down_read()
> > > +	 * for the old mm's mmap_sem, i.e. synchronizing will deadlock.
> > > +	 * Incrementing the list version ensures readers that must not race
> > > +	 * with a mm being added will see the updated list.
> > > +	 */
> 
> For this comment, please completely remove it. We either call something
> or do not call it. We do !call anything.

How on earth is someone doing to dredge up the above information without a
comment?  Anyone looking at this code without a priori knowledge of the
development history will assume the missing synchronize_srcu() is a bug.

> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> > > index 44b353aa8866..f0f72e591244 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.h
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.h
> > > @@ -74,6 +74,7 @@ struct sgx_encl {
> > >  	struct mutex lock;
> > >  	struct list_head mm_list;
> > >  	spinlock_t mm_lock;
> > > +	unsigned long mm_list_version;
> > >  	struct file *backing;
> > >  	struct kref refcount;
> > >  	struct srcu_struct srcu;
