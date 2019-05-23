Return-Path: <SRS0=njgX=TX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA54C282CE
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 02:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E1BF2173C
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 02:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfEWCfT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 May 2019 22:35:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:46690 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbfEWCfS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 May 2019 22:35:18 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 19:35:18 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 22 May 2019 19:35:17 -0700
Date:   Wed, 22 May 2019 19:35:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190523023517.GA31950@linux.intel.com>
References: <20190517000331.GD11204@linux.intel.com>
 <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 22, 2019 at 03:42:45PM -0700, Andy Lutomirski wrote:
> On Wed, May 22, 2019 at 8:38 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > And that straight up doesn't work with the v20 driver because mmap() with
> > the enclave_fd will run through sgx_get_unmapped_area(), which also does
> > the natural alignment adjustments (the idea being that mmap() is mapping
> > the entire enclave).  E.g. mmap() will map the wrong address if the offset
> > of a chunk is less than its size due to the driver adjusting the address.
> 
> That presumably needs to change.

If we want to allow mmap() on a subset of the enclave, yes.  I assume it's
a simple matter of respecting MAP_FIXED.

> Are we entirely missing an API to allocate a naturally aligned VA
> range?  That's kind of annoying.

Yes?

> > Eliminating sgx_get_unmapped_area() means userspace is once again on the
> > hook for naturally aligning the enclave, which is less than desirable.
> >
> > Looking back at the original API discussions around a builder process[1],
> > we never fleshed out the end-to-end flow.  While having a builder process
> > *sounds* reasonable, in practice it adds a lot of complexity without
> > providing much in the way of added security.  E.g. in addition to the
> > above mmap() issues, since the order of EADDs affects the enclave
> > measurement, the enclave owner would need to communicate the exact steps
> > to build the enclave, or the builder would need a priori knowledge of the
> > enclave format.
> >
> > Userspace can still restrict access to /dev/sgx/enclave, e.g. by having a
> > daemon that requires additional credentials to obtain a new enclave_fd.
> > So AFAICT, the only benefit to having a dedicated builder is that it can
> > do its own whitelisting of enclaves, but since we're trending towards
> > supporting whitelisting enclaves in the kernel, e.g. via sigstruct,
> > whitelisting in userspace purely in userspace also provides marginal value.
> >
> > TL;DR: Requiring VMA backing to build an enclave seems reasonable and sane.
> 
> This isn't necessarily a problem, but we pretty much have to use
> mprotect() then.

You lost me there.  Who needs to mprotect() what?

> Maybe the semantics could just be that mmap() on the SGX device gives
> natural alignment, but that there is no actual constraint enforced by
> the driver as to whether mmap() happens before or after ECREATE.
> After all, it's *ugly* for user code to reserve its address range with
> an awkward giant mmap(), there's nothing fundamentally wrong with it.
> 
> As far as I know from this whole discussion, we still haven't come up
> with any credible way to avoid tracking, per enclave page, whether
> that page came from unmodified PROT_EXEC memory.

Disallowing mmap() after ECREATE is credible, but apparently not
palatable. :-)

But actually, there's no need to disallow mmap() after ECREATE since the
LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
bypassed LSM checks?  The real problem is that mmap()'ng an existing
enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
at square one.

Tracking permissions per enclave page isn't difficult, it's the new SGX
specific LSM hooks and mprotect() interactions that I want to avoid.

Jumping back to mmap(), AIUI the fundamental issue is that we want to
allow building/running an enclave without FILE__WRITE and FILE__EXECUTE,
otherwise FILE__WRITE and FILE__EXECUTE become meaningless.  Assuming I'm
not off in the weeds, that means we really just need to special case
mmap() on enclaves so it can map enclave memory using the verified page
permissions so as not to run afoul of LSM checks.  All other behaviors,
e.g. mprotect(), can reuse the existing LSM checks for shared mappings.

So, what if we snapshot the permissions for each enclave page at EADD,
and then special case mmap() to propagate flags from the snapshot to the
VMA?  More or less the same idea as doing mprotect_fixup() using the
source VMA during EADD.  We could define the EADD semantics to match
this as well, e.g. only propagate the flags from the source VMA to the
enclave VMA if the EADD range is fully mapped with PROT_NONE.  This would
allow the enclave builder concept, albeit with funky semantics, and
wouldn't require new LSM hooks.

E.g. something like this:

static inline void sgx_mmap_update_prot_flags(struct vm_area_struct *vma,
					      struct sgx_encl *encl)
{
	struct radix_tree_iter iter;
	struct sgx_encl_page *entry;
	unsigned long addr;
	vm_flags_t flags;
	void **slot;

	/*
	 * SGX special: if userspace is requesting PROT_NONE and pages have
	 * been added to the enclave, then propagate the flags snapshot from
	 * the enclave to the VMA.  Do this if and only if all overlapped
	 * pages are defined and have identical permissions.  Stuffing the
	 * VMA on PROT_NONE allows userspace to map EPC pages without being
	 * incorrectly rejected by LSMs due to insufficient permissions (the
	 * snapshottted flags have alaredy been vetted).
	 */
	if (vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC))
		return;

	flags = 0;

	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
		entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);

		if (!entry && flags)
			return;
		if (!flags && entry) {
			if (addr == vma->vm_start) {
				flags = entry->vm_flags;
				continue;
			}
			return;
		}
		if (entry && flags && entry->vm_flags != flags)
			return;

	}
	vma->vm_flags |= flags;
}

