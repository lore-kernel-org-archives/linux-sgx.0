Return-Path: <SRS0=Hssn=PR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E70CC43387
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jan 2019 17:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A87A20660
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jan 2019 17:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfAIRQ2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jan 2019 12:16:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:20277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfAIRQ2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Jan 2019 12:16:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 09:16:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,458,1539673200"; 
   d="scan'208";a="108583432"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 09 Jan 2019 09:16:25 -0800
Date:   Wed, 9 Jan 2019 09:16:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20190109171625.GB1821@linux.intel.com>
References: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A58F1@PGSMSX112.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105F7BF4D0229846AF094488D65A0989355A58F1@PGSMSX112.gar.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 08, 2019 at 09:24:38PM -0800, Huang, Kai wrote:
> > On Tue, Jan 08, 2019 at 11:27:11AM -0800, Huang, Kai wrote:
> > > > >
> > > > > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > > > > opening a new instance of /dev/sgx for each encalve?
> > > >
> > > > Directly associating /dev/sgx with an enclave means /dev/sgx can't
> > > > be used to provide ioctl()'s for other SGX-related needs, e.g. to
> > > > mmap() raw EPC and expose it a VM.  Proposed layout in the link
> > > > below.  I'll also respond to Jarkko's question about exposing EPC
> > > > through /dev/sgx instead of having KVM allocate it on behalf of the VM.
> > > >
> > > > https://lkml.kernel.org/r/20181218185349.GC30082@linux.intel.com
> > >
> > > Hi Sean,
> > >
> > > Sorry for replying to old email. But IMHO it is not a must that Qemu
> > > needs to open some /dev/sgx and allocate/mmap EPC for guest's virtual
> > > EPC slot, instead, KVM could create private slot, which is not visible
> > > to Qemu, for virtual EPC, and KVM could call core-SGX EPC allocation
> > > API directly.
> > 
> > That's possible, but it has several downsides.
> > 
> >   - Duplicates a lot of code in KVM for managing memory regions.
> 
> I don't see why there will be duplicated code. you can simply call
> __x86_set_memory_region to create private slot. It is KVM x86 equivalent
> to KVM_SET_USER_MEMORY_REGION from userspace. The only difference is Qemu
> is not aware of the private slot.

What about when we allow removing an EPC region?  At that point you'd be
fully duplicating KVM_SET_USER_MEMORY_REGION.  And that's not a purely
theoretical idea, it's something I'd like to support in the future, e.g.
via the WIP virtio-mem interface.

https://events.linuxfoundation.org/wp-content/uploads/2017/12/virtio-mem-Paravirtualized-Memory-David-Hildenbrand-Red-Hat-1.pdf

> 
> >   - Artificially restricts userspace to a single EPC region, unless
> >     even more code is duplicated to handle multiple private regions.
> 
> You can have multiple private slots, by calling __x86_set_memory_region
> for each EPC section. KVM receives EPC section/sections info from Qemu,
> via CPUID, or dedicated IOCTL (is this you are going to add?), and simply
> creates private EPC slot/slots.

This would require a dynamic number of private memslots, which breaks (or
at least changes) the semantics of KVM_CAP_NR_MEMSLOTS.

> 
> >   - Requires additional ioctls() or capabilities to probe EPC support
> 
> No. EPC info is from Qemu at the beginning (size is given by parameter,
> base is calculated by Qemu), and actually it is Qemu notifies KVM EPC info,
> so I don't think we require additional ioctls or capabilities here.

How does Qemu know KVM supports virtual EPC?  Probing /dev/sgx doesn't
convey any information about KVM support.  Maybe you could report it via
KVM_GET_SUPPORTED_CPUID, but that would be problematic for Qemu since it
would have to create vCPUs before initializing the machine.

> 
> >   - Does not fit with Qemu/KVM's memory model, e.g. all other types of
> >     memory are exposed to a guest through
> > KVM_SET_USER_MEMORY_REGION.
> 
> EPC is different. I am not sure whether EPC needs to fit such model. There
> are already examples in KVM which uses private slot w/o using
> KVM_SET_USER_MEMORY_REGION, for example, APIC access page.

EPC has unique access and lifecycle semantics, but that doesnt make it a
special snowflake, e.g. NVDIMM has special properties, as does memory that
is encrypted via SME or MKTME, and so on and so forth.

The private memslots are private for a reason, e.g. the guest is completely
unaware that they exist and Qemu is only aware of their existence because
KVM needs userspace to tell it what GPA range won't conflict with its memory
model.  And in the APIC access page case, Qemu isn't aware at all since KVM
doesn't allow relocating the guest's APIC.

The other aspect of private memslots is that they are not exposed to L2,
because again, from the guest's perspective, they do not exist.  We can
obviously hackaround that restriction, but it's yet another hint that
shoving EPC into a private memslot is the wrong approach.

> 
> >   - Prevents userspace from debugging a guest's enclave.  I'm not saying
> >     this is a likely scenario, but I also don't think we should preclude
> >     it without good reason.
> 
> I am not sure how important it is, so don't know whether this can be a
> justification. To me we don't need to consider this. Qemu normally doesn't
> access guest memory unless it has to (ie, for device model). 

In terms of debug, "Qemu" accesses guest memory all the time, e.g. reading
guest memory via Qemu's monitor interface is something I do on a regular
basis.  KVM even provides an ABI (KVM_SET_GUEST_DEBUG) to allow userspace
to set breakpoints on guest memory.  We'd be saying "you can break on
accesses in a debug enclave, but you can't actually access its memory".

> 
> >   - KVM is now responsible for managing the lifecycle of EPC, e.g. what
> >     happens if an EPC cgroup limit is lowered on a running VM and
> >     KVM can't gracefully reclaim EPC?  The userspace hypervisor should
> >     ultimately decide how to handle such an event.
> 
> Even using KVM_SET_USER_MEMORY_REGION, KVM is also responsible for managing the lifecycle of EPC, no? And "managing the lifecycle of EPC" you mean doesn't need to be "managing EPC itself" I suppose, since EPC should always be managed by core SGX code.
> 
> I don't see the difference between private slot and KVM_SET_USER_MEMORY_REGION,
> in terms of how does KVM reclaim EPC, or how does KVM do when it fails to
> reclaim EPC. 

Userspace can delete the EPC region via KVM_SET_USER_MEMORY_REGION.  As
mentioned above, on-demand deletion of a private memslot means duplicating
basically all of the KVM_SET_USER_MEMORY_REGION flow.

For example, consider a paravirtualized guest that allows EPC regions to
be "unplugged" if the host runs out of EPC.

> 
> >   - SGX logic is split between SGX and KVM, e.g. VA page management for
> >     oversubscription will likely be common to SGX and KVM.  From a long
> >     term maintenance perspective, this means that changes to the EPC
> >     management could potentially need to be Acked by KVM, and vice versa.
> 
> I think most of the code should be in core SGX code under x86. KVM should
> only have the code that is specifically related to virtualization, ie, ENCLV.
> 
> VA page allocation should be under code SGX code. KVM might need to call
> function such as alloc_va_page, etc, but this is not a problem. There are
> many other cases now.
> 
> And this is not related to private slot vs KVM_SET_USER_MEMORY_REGION.

Yes it is.  Allocating EPC via KVM means exporting additional functions
from SGX core, and using a private memslot effectively forces KVM to
allocate guest EPC.  E.g. using KVM_SET_USER_MEMORY_REGION and having
SGX own EPC allocation means KVM can be blissfully unaware of VA pages,
EPC swap backing, etc...

> 
> > 
> > > I am not sure what's the good of allowing userspace to alloc/mmap a
> > > raw EPC region? Userspace is not allowed to touch EPC anyway, expect
> > > enclave code.
> > >
> > > To me KVM creates private EPC slot is cleaner than exposing
> > > /dev/sgx/epc and allowing userspace to map some raw EPC region.
> > 
> > Cleaner in the sense that it's faster to get basic support up and running since
> > there are fewer touchpoints, but there are long term ramifications to
> > cramming EPC management in KVM.
> > 
> > And at this point I'm not stating any absolutes, e.g. how EPC will be handled
> > by KVM.  What I'm pushing for is to not eliminate the possibility of having
> > the SGX subsystem own all EPC management, e.g. don't tie /dev/sgx to a
> > single enclave.
> 
> I suppose "SGX subsystem" you mean here is core SGX code under x86. IMHO
> EPC should always be managed by such SGX subsystem, and KVM and SGX driver
> are just consumers (ie, calling EPC allocation function, etc).
> 
> IMHO I think /dev/sgx (or whatever /dev/sgx/xxx) should be in SGX driver,
> but not SGX core code. For example, if we don't consider KVM EPC
> oversubscription here, theoretically we only need below code in core SGX
> code to make KVM SGX work:
> 
> 1) SGX feature detection. There should be some core structure (such as
> boot_cpu_data, etc) where KVM can query SGX capabilities, ie, whether FLC
> is available.
> 2) EPC management. KVM simply calls EPC management APIs when it needs. For
> example, when EPC slot is created, we should populate all EPC pages, and
> fail to create VM if running out of EPC.
> 3) Other code to deal with ENCLS, SGX data structure, etc, since we have
> agreed even with EPC static allocation, we should trap EINIT. 
> 
> We probably even don't need code to deal with enclave, if only for KVM. Of
> course, in order to support KVM EPC oversubscription, we should also include
> enclave management code in core SGX code, but this doesn't necessary mean we
> should include /dev/sgx/xxx in core SGX code.
> 
> It seems there still are lots of design issues we haven't got consensus in
> terms of how SGX driver should be (or how SGX stack is supposed to work),
> but if we can focus on what core SGX code should really have (w/o involving
> SGX driver logic), we can at least get KVM SGX code working. After all, we
> also have window SGX support. 

I'm all for getting KVM support in ASAP, i.e. I'd love to avoid having to
wait for "full" SGX support, but that doesn't obviate the need to hammer
out the uapi.  Taking a shortcut and shoving everything into KVM could bite
us in the long run.
