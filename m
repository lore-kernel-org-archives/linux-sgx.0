Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC6196C68;
	Fri,  7 Jun 2024 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717781410; cv=none; b=Qmy8uVc+XL52EXqqBE96RlLNHTHSMSKU5W92nPhdcppdiZ/BdeJXqDW9HaDbmqsLtK+yr99hLvbpHoag6HdRfihlsKJpwaiC+NVZowcDocuXqeWGElMvr7fP4mMPOyGsf1MFOdyAyp2DFfd2dmuAVEktZRgfhl2+lc3vfJAqLow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717781410; c=relaxed/simple;
	bh=B9tO+B2hT8Xk/eYrXZW//gyZWpphBGJke5m1suqOmjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dkrIbpe1NxUaN6LNBkYDj+yUGMDZn8ijsbt+7dY/CnJJW52MNc2t/KhS2REo7lxaKeA3hpHzVHyz5x+lpIBY8d9/BTkpKcejwqh+/0nBqHmcUTWoJyiTqitnsifffBMWcAQhewdZDLn4mHSgwY6zUnunq4HNlBhmisZI2zdq/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LcL0g5Lo; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LcL0g5Lo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717781409; x=1749317409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B9tO+B2hT8Xk/eYrXZW//gyZWpphBGJke5m1suqOmjk=;
  b=LcL0g5LoEeTTY7tXfPBb0kyWkeLx+oI2xDNZ2uvA4Fcrvc3nmoQWyQ1A
   r/p7CYEnX2TfZ8nPmTweGBfQGldkaSAZpT90UmRdadouffc+bBy06SnNN
   tMUQUSEvMoOXHicuP5AEaOa2S3qiY502myam72gmE+f/NYP0G9zfRuZAj
   yFztSpLNkDu+1fTA8PInOGuiiTuLZ8AicCrLO616B8gwTiXwjOGAoDZ/S
   RT/cOKD39Fqj1WSiP914SdbrGye28VFH1uGT+qbuIgcQQQex8lB/VMcZ5
   TlCoQEG3itoDIANnUhDSIJeJAu1bvY538WhZXDVEL+8RgZOMCPp6Jbnm7
   A==;
X-CSE-ConnectionGUID: SyC4y/+MTW+/WX5lxrTsLQ==
X-CSE-MsgGUID: SupNgW+NTPS6hREdBuN+bw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="18368118"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="18368118"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 10:30:08 -0700
X-CSE-ConnectionGUID: SpdaPTKvQbmoP0C/7JLRpw==
X-CSE-MsgGUID: h0v3KNYvSseJzFH9vNCMuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38472457"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 10:30:07 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: dave.hansen@intel.com
Cc: dave.hansen@linux.intel.com,
	dmitrii.kuvaiskii@intel.com,
	haitao.huang@linux.intel.com,
	jarkko@kernel.org,
	kai.huang@intel.com,
	kailun.qin@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	mona.vij@intel.com,
	reinette.chatre@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data race
Date: Fri,  7 Jun 2024 10:21:46 -0700
Message-Id: <20240607172146.536993-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <01bb6519-680e-45bf-b8bd-34763658aa17@intel.com>
References: <01bb6519-680e-45bf-b8bd-34763658aa17@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Tue, May 28, 2024 at 09:23:13AM -0700, Dave Hansen wrote:
> On 5/17/24 04:06, Dmitrii Kuvaiskii wrote:
> ...
>
> First, why is SGX so special here?  How is the SGX problem different
> than what the core mm code does?

Here is my understanding why SGX is so special and why I have to introduce
a new bit SGX_ENCL_PAGE_BEING_REMOVED.

In SGX's removal of the enclave page, two operations must happen
atomically: the PTE entry must be removed and the page must be EREMOVE'd.

Generally, to guarantee atomicity, encl->lock is acquired. Ideally, if
this encl->lock could be acquired at the beginning of
sgx_encl_remove_pages() and be released at the very end of this function,
there would be no EREMOVE page vs EAUG page data race, and my bug fix
(with SGX_ENCL_PAGE_BEING_REMOVED bit) wouldn't be needed.

However, the current implementation of sgx_encl_remove_pages() has to
release encl->lock before removing the PTE entry. Releasing the lock is
required because the function that removes the PTE entry --
sgx_zap_enclave_ptes() -- acquires another, enclave-MM lock:
mmap_read_lock(encl_mm->mm).

The two locks must be taken in this order:
1. mmap_read_lock(encl_mm->mm)
2. mutex_lock(&encl->lock)

This lock order is apparent from e.g. sgx_encl_add_page(). This order also
seems to make intuitive sense: VMA callbacks are called with the MM lock
being held, so the MM lock should be the first in lock order.

So, if sgx_encl_remove_pages() would _not_ release encl->lock before
calling sgx_zap_enclave_ptes(), this would violate the lock order and
might lead to deadlocks. At the same time, releasing encl->lock in the
middle of the two-operations flow leads to a data race that I found in
this patch series.

Quick summary:
- Removing the enclave page requires two operations: removing the PTE and
  performing EREMOVE.
- The complete flow of removing the enclave page cannot be protected by a
  single encl->lock, because it would violate the lock order and would
  lead to deadlocks.
- The current upstream implementation thus breaks the flow into two
  critical sections, releasing encl->lock before sgx_zap_enclave_ptes()
  and re-acquiring this lock afterwards. This leads to a data race.
- My patch restores "atomicity" of the flow by introducing a new flag
  SGX_ENCL_PAGE_BEING_REMOVED.

> > --- a/arch/x86/kernel/cpu/sgx/encl.h
> > +++ b/arch/x86/kernel/cpu/sgx/encl.h
> > @@ -25,6 +25,9 @@
> >  /* 'desc' bit marking that the page is being reclaimed. */
> >  #define SGX_ENCL_PAGE_BEING_RECLAIMED  BIT(3)
> >
> > +/* 'desc' bit marking that the page is being removed. */
> > +#define SGX_ENCL_PAGE_BEING_REMOVED    BIT(2)
>
> Second, convince me that this _needs_ a new bit.  Why can't we just have
> a bit that effectively means "return EBUSY if you see this bit when
> handling a fault".

As Haitao mentioned in his reply, the bit SGX_ENCL_PAGE_BEING_RECLAIMED is
also used in reclaimer_writing_to_pcmd(). If we would re-use this bit to
mark a page being removed, reclaimer_writing_to_pcmd() would incorrectly
return 1, meaning that the reclaimer is about to write to the PCMD page,
which is not true.

> >  struct sgx_encl_page {
> >     unsigned long desc;
> >     unsigned long vm_max_prot_bits:8;
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 5d390df21440..de59219ae794 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -1142,6 +1142,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
> >          * Do not keep encl->lock because of dependency on
> >          * mmap_lock acquired in sgx_zap_enclave_ptes().
> >          */
> > +       entry->desc |= SGX_ENCL_PAGE_BEING_REMOVED;
>
> This also needs a comment, no matter what.

Ok, I will write something along the lines that we want to prevent a data
race with an EAUG flow, and since we have to release encl->lock (which
would otherwise prevent the data race) we instead set a bit to mark this
enclave page as being in the process of removal, so that the EAUG flow
backs off and retries later.

--
Dmitrii Kuvaiskii
