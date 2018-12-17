Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F06AC43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 22:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EABDA20874
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 22:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbeLQWUt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 17:20:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:13641 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbeLQWUt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 17:20:49 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 14:20:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208";a="111269674"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga003.jf.intel.com with ESMTP; 17 Dec 2018 14:20:48 -0800
Date:   Mon, 17 Dec 2018 14:20:48 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181217222047.GG12491@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 11:12:21AM -0800, Andy Lutomirski wrote:
> On Mon, Dec 17, 2018 at 10:47 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 12/17/18 10:43 AM, Jarkko Sakkinen wrote:
> > > On Mon, Dec 17, 2018 at 10:36:13AM -0800, Sean Christopherson wrote:
> > >> I'm pretty sure doing mmget() would result in circular dependencies and
> > >> a zombie enclave.  In the do_exit() case where a task is abruptly killed:
> > >>
> > >>   - __mmput() is never called because the enclave holds a ref
> > >>   - sgx_encl_release() is never be called because its VMAs hold refs
> > >>   - sgx_vma_close() is never called because __mmput()->exit_mmap() is
> > >>     blocked and the process itself is dead, i.e. won't unmap anything.
> > > Right, it does, you are absolutely right. Tried it and removed the
> > > commit already.
> > >
> > > Well, what we came up from your suggestion i.e. setting mm to NULL
> > > and checking that is very subtle change and does not have any such
> > > circular dependencies. We'll go with that.
> >
> > This all screams that you need to break out this code from the massive
> > "18" patch and get the mm interactions reviewed more thoroughly.
> >
> > Also, no matter what method you go with, you have a bunch of commenting
> > and changelogging to do here.
> 
> I'm going to ask an obnoxious high-level question: why does an enclave
> even refer to a specific mm?

Primarily because that's what the code has "always" done.  I can't
speak for Jarkko, but I got involved with this joyful project long after
the code was originally written.

> If I were designing this thing, and if I hadn't started trying to
> implement it, my first thought would be that an enclave tracks its
> linear address range, which is just a pair of numbers, and also keeps
> track of a whole bunch of physical EPC pages, data structures, etc.
> And that mmap() gets rejected unless the requested virtual address
> matches the linear address range that the enclave wants and, aside
> from that, just creates a VMA that keeps a reference to the enclave.
> (And, for convenience, I suppose that the first mmap() call done
> before any actual enclave setup happens could choose any address and
> then cause the enclave to lock itself to that address, although a
> regular anonymous PROT_NONE MAP_NORESERVE mapping would do just fine,
> too.)  And the driver would explicitly allow multiple different mms to
> have the same enclave mapped.  More importantly, a daemon could set up
> an enclave without necessarily mapping it at all and then SCM_RIGHTS
> the enclave over to the process that plans to run it.

Hmm, this could work, the obvious weirdness would be ensuring the linear
range is available in the destination mm, but that'd be userspace's
problem.

I don't think we'd need to keep a reference to the enclave in the VMA.
The enclave's ref could be held by the fd.  Assuming the kernel is using
its private mapping to access the enclave, that's all we'd need to be
able to manipulate the enclave, e.g. reclaim EPC pages.  Userspace would
need to keep the fd alive in order to use the VMA, but that sort of goes
without saying.  The mm/VMA juggling today is for zapping/testing the
correct PTEs, but as you pointed out in a different email we can use
unmap_mapping_range(), with the enclave's fd being the source of the
address space passed to unmap_mapping_range().  Removing a VMA simply
means we don't need to zap it or test its age.
 
> Now I'm sure this has all kinds of problems, such as the ISA possibly
> making it rather obnoxious to add pages to the enclave without having
> it mapped.  But these operations could, in principle, be done by
> having the enclave own a private mm that's used just for setup.  While
> this would be vaguely annoying, Nadav's still-pending-but-nearly-done
> text_poke series adds all the infrastructure that's needed for the
> kernel to manage little private mms.  But some things get simpler --
> invalidating the enclave can presumably use the regular rmap APIs to
> zap all the PTEs in all VMAs pointing into the enclave.

We don't even need a private mm, we can (and already do) use the kernel's
translations for ENCLS instructions.  Hardware only enforces the linear
address stuff when it's actually in enclave mode, i.e. executing the
enclave.  ENCLS instructions aren't subject to the ELRANGE checks and
can use any VA->PA combination.

> So I'm not saying that you shouldn't do it the way you are now, but I
> do think that the changelog or at least some emails should explain
> *why* the enclave needs to keep a pointer to the creating process's
> mm.  And, if you do keep the current model, it would be nice to
> understand what happens if you do something awful like mremap()ing an
> enclave, or calling madvise on it, or otherwise abusing the vma.  Or
> doing fork(), for that matter.
> 
> I also find it suspicious that the various ioctl handlers
> systematically ignore their "filep" parameters and instead use
> find_vma() to find the relevant mm data structures.  That seems
> backwards.

My brain is still sorting out the details, but I generally like the idea
of allocating an anon inode when creating an enclave, and exposing the
other ioctls() via the returned fd.  This is essentially the approach
used by KVM to manage multiple "layers" of ioctls across KVM itself, VMs
and vCPUS.  There are even similarities to accessing physical memory via
multiple disparate domains, e.g. host kernel, host userspace and guest.

The only potential hiccup I can see is the build flow.  Currently,
EADD+EEXTEND is done via a work queue to avoid major performance issues
(10x regression) when userspace is building multiple enclaves in parallel
using goroutines to wrap Cgo (the issue might apply to any M:N scheduler,
but I've only confirmed the Golang case).  The issue is that allocating
an EPC page acts like a blocking syscall when the EPC is under pressure,
i.e. an EPC page isn't immediately available.  This causes Go's scheduler
to thrash and tank performance[1].

That being said, I think we could simply do mmgrab()/mmdrop() for each
page to be added, and then do mmget_not_zero()/mmput() when actually
inserting into the mm's page tables.  Conceptually that seems cleaner
than implicitly relying on the mmu_notifier to guarantee the lifecycle
of the mm.

Alternatively, we could change the EADD+EEXTEND flow to not insert the
added page's PFN into the owner's process space, i.e. force userspace to
fault when it runs the enclave.  But that only delays the issue because
eventually we'll want to account EPC pages, i.e. add a cgroup, at which
point we'll likely need current->mm anyways.

[1] https://github.com/golang/go/issues/19574
