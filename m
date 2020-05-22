Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BFBC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 03:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BCCC20812
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 03:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgEVDdm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 May 2020 23:33:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:31472 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgEVDdm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 May 2020 23:33:42 -0400
IronPort-SDR: H/ihoj3BjQqTboe2SNh17xKfTVsR67Tvyh2CxgJbMfHE0hUvMy0gu8cq/1GgVjinhj1OFlUETB
 aY3RIt/fg/4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 20:33:41 -0700
IronPort-SDR: 6Oi3dGVXxH8PRgoerk4WKGC1UAawi03NxYcSSdFN3TzL8k2eGY6ooz7giyX/beEhnU3RfLAFgn
 Gcv4mcwAWuFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="300996064"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2020 20:33:40 -0700
Date:   Thu, 21 May 2020 20:33:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 10/20] x86/sgx: Linux Enclave Driver
Message-ID: <20200522033340.GB23459@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-11-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515004410.723949-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 03:44:00AM +0300, Jarkko Sakkinen wrote:
> +static int sgx_open(struct inode *inode, struct file *file)
> +{
> +	struct sgx_encl *encl;
> +	int ret;
> +
> +	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
> +	if (!encl)
> +		return -ENOMEM;
> +
> +	atomic_set(&encl->flags, 0);
> +	kref_init(&encl->refcount);
> +	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
> +	mutex_init(&encl->lock);
> +	INIT_LIST_HEAD(&encl->mm_list);
> +	spin_lock_init(&encl->mm_lock);
> +
> +	ret = init_srcu_struct(&encl->srcu);

We're leaking a wee bit of memory here; enough to burn through 14gb in a few
minutes with my newly resurrected EPC cgroup test.  The possibility for
failure should have been a dead giveaway that this allocates memory, but the
"init" name threw me off. :-/

> +	if (ret) {
> +		kfree(encl);
> +		return ret;
> +	}
> +
> +	file->private_data = encl;
> +
> +	return 0;
> +}

...

> +/**
> + * sgx_encl_release - Destroy an enclave instance
> + * @kref:	address of a kref inside &sgx_encl
> + *
> + * Used together with kref_put(). Frees all the resources associated with the
> + * enclave and the instance itself.
> + */
> +void sgx_encl_release(struct kref *ref)
> +{
> +	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
> +
> +	sgx_encl_destroy(encl);
> +
> +	if (encl->backing)
> +		fput(encl->backing);

The above mem leak can be fixed by adding

	cleanup_srcu_struct(&encl->srcu);
> +
> +	WARN_ON_ONCE(!list_empty(&encl->mm_list));
> +
> +	/* Detect EPC page leak's. */
> +	WARN_ON_ONCE(encl->secs_child_cnt);
> +	WARN_ON_ONCE(encl->secs.epc_page);
> +
> +	kfree(encl);
> +}

...

> +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> +			     unsigned long offset, unsigned long length,
> +			     struct sgx_secinfo *secinfo, unsigned long flags)
> +{

...

> +err_out:
> +	radix_tree_delete(&encl_page->encl->page_tree,
> +			  PFN_DOWN(encl_page->desc));
> +
> +err_out_unlock:
> +	mutex_unlock(&encl->lock);
> +	up_read(&current->mm->mmap_sem);
> +
> +err_out_free:
> +	sgx_free_page(epc_page);
> +	kfree(encl_page);
> +
> +	/*
> +	 * Destroy enclave on ENCLS failure as this means that EPC has been
> +	 * invalidated.
> +	 */
> +	if (ret == -EIO)
> +		sgx_encl_destroy(encl);

This needs to be called with encl->lock held to prevent racing with the
reclaimer, e.g. sgx_encl_destroy() and sgx_reclaimer_write() can combine to
corrupt secs_child_cnt, among other badness.

It's probably worth adding a lockdep assert in sgx_encl_destroy() as well.

We can either keep the lock across the above frees or retake the lock.  I
like retaking the lock to avoid inverting the ordering between encl->lock
and mmap_sem (even though it's benign).  This is an extremely rare path,
no need to shave cycles.

> +
> +	return ret;
> +}
