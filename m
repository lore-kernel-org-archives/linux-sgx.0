Return-Path: <SRS0=njgX=TX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFECC282DD
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 10:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6F221019
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 10:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfEWK0l (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 May 2019 06:26:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:16848 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfEWK0k (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 May 2019 06:26:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 03:26:39 -0700
X-ExtLoop1: 1
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga004.jf.intel.com with ESMTP; 23 May 2019 03:26:30 -0700
Date:   Thu, 23 May 2019 13:26:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Message-ID: <20190523102628.GC10955@linux.intel.com>
References: <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523023517.GA31950@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
> But actually, there's no need to disallow mmap() after ECREATE since the
> LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
> mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
> bypassed LSM checks?  The real problem is that mmap()'ng an existing
> enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
> at square one.

I'm lost with the constraints we want to set.

We can still support fork() if we take a step back from v20 and require
the mmap(). Given the recent comments, I'd guess that is the best
compromise i.e. multiple processes can still share an enclave within
the limitations of ancestor hierarchy. Is this the constraint we agree
now upon? Some emails are a bit contradicting in this sense.

> Tracking permissions per enclave page isn't difficult, it's the new SGX
> specific LSM hooks and mprotect() interactions that I want to avoid.
> 
> Jumping back to mmap(), AIUI the fundamental issue is that we want to
> allow building/running an enclave without FILE__WRITE and FILE__EXECUTE,
> otherwise FILE__WRITE and FILE__EXECUTE become meaningless.  Assuming I'm
> not off in the weeds, that means we really just need to special case
> mmap() on enclaves so it can map enclave memory using the verified page
> permissions so as not to run afoul of LSM checks.  All other behaviors,
> e.g. mprotect(), can reuse the existing LSM checks for shared mappings.
> 
> So, what if we snapshot the permissions for each enclave page at EADD,
> and then special case mmap() to propagate flags from the snapshot to the
> VMA?  More or less the same idea as doing mprotect_fixup() using the
> source VMA during EADD.  We could define the EADD semantics to match
> this as well, e.g. only propagate the flags from the source VMA to the
> enclave VMA if the EADD range is fully mapped with PROT_NONE.  This would
> allow the enclave builder concept, albeit with funky semantics, and
> wouldn't require new LSM hooks.

Dropped off here completely. What if the mmap() is done before any of
the EADD operations?

> 
> E.g. something like this:
> 
> static inline void sgx_mmap_update_prot_flags(struct vm_area_struct *vma,
> 					      struct sgx_encl *encl)
> {
> 	struct radix_tree_iter iter;
> 	struct sgx_encl_page *entry;
> 	unsigned long addr;
> 	vm_flags_t flags;
> 	void **slot;
> 
> 	/*
> 	 * SGX special: if userspace is requesting PROT_NONE and pages have
> 	 * been added to the enclave, then propagate the flags snapshot from
> 	 * the enclave to the VMA.  Do this if and only if all overlapped
> 	 * pages are defined and have identical permissions.  Stuffing the
> 	 * VMA on PROT_NONE allows userspace to map EPC pages without being
> 	 * incorrectly rejected by LSMs due to insufficient permissions (the
> 	 * snapshottted flags have alaredy been vetted).
> 	 */
> 	if (vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC))
> 		return;
> 
> 	flags = 0;
> 
> 	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
> 		entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
> 
> 		if (!entry && flags)
> 			return;
> 		if (!flags && entry) {
> 			if (addr == vma->vm_start) {
> 				flags = entry->vm_flags;
> 				continue;
> 			}
> 			return;
> 		}
> 		if (entry && flags && entry->vm_flags != flags)
> 			return;
> 
> 	}
> 	vma->vm_flags |= flags;
> }

This looks flakky and error prone. You'd better have some "shadow VMAs"
and check that you have such matching size of the VMA you try to mmap()
and check flags from that.

Who would call this function anyhow and when?

Would be better to first agree on constraints. I have zero idea within
which kind of enviroment this snippet would live e.g.

- mmap() (before, after?)
- multi process constraint (only fork or full on versatility)

/Jarkko
