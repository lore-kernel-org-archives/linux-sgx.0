Return-Path: <SRS0=xoGn=PK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED924C43387
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Jan 2019 20:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC9842073F
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Jan 2019 20:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfABUry (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Jan 2019 15:47:54 -0500
Received: from mga18.intel.com ([134.134.136.126]:55885 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfABUry (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Jan 2019 15:47:54 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2019 12:47:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,432,1539673200"; 
   d="scan'208";a="131018704"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jan 2019 12:47:52 -0800
Date:   Wed, 2 Jan 2019 12:47:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20190102204752.GG7460@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181220103204.GB26410@linux.intel.com>
 <20181222081649.GB8895@linux.intel.com>
 <20181222082502.GA13275@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181222082502.GA13275@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Dec 22, 2018 at 10:25:02AM +0200, Jarkko Sakkinen wrote:
> On Sat, Dec 22, 2018 at 10:16:49AM +0200, Jarkko Sakkinen wrote:
> > On Thu, Dec 20, 2018 at 12:32:04PM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
> > > > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > > > opening a new instance of /dev/sgx for each encalve?
> > > 
> > > I think that fits better to the SCM_RIGHTS scenario i.e. you could send
> > > the enclav to a process that does not have necessarily have rights to
> > > /dev/sgx. Gives more robust environment to configure SGX.
> > 
> > Sean, is this why you wanted enclave fd and anon inode and not just use
> > the address space of /dev/sgx? Just taking notes of all observations.
> > I'm not sure what your rationale was (maybe it was somewhere). This was
> > something I made up, and this one is wrong deduction. You can easily
> > get the same benefit with /dev/sgx associated fd representing the
> > enclave.
> > 
> > This all means that for v19 I'm going without enclave fd involved with
> > fd to /dev/sgx representing the enclave. No anon inodes will be
> > involved.
> 
> Based on these observations I updated the uapi.
> 
> As far as I'm concerned there has to be a solution to do EPC mapping
> with a sequence:
> 
> 1. Ping /dev/kvm to do something.
> 2. KVM asks SGX core to do something.
> 3. SGX core does something.
> 
> I don't care what the something is exactly is, but KVM is the only sane
> place for KVM uapi. I would be surprised if KVM maintainers didn't agree
> that they don't want to sprinkle KVM uapi to random places in other
> subsystems.

It's not a KVM uapi.

KVM isn't a hypervisor in the traditional sense.  The "real" hypervisor
lives in userspace, e.g. Qemu, KVM is essentially just a (very fancy)
driver for hardware accelerators, e.g. VMX.  Qemu for example is fully
capable of running an x86 VM without KVM, it's just substantially slower.

In terms of guest memory, KVM doesn't care or even know what a particular
region of memory represents or what, if anything, is backing a region in
the host.  There are cases when KVM is made aware of certain aspects of
guest memory for performance or functional reasons, e.g. emulated MMIO
and encrypted memory, but in all cases the control logic ultimately
resides in userspace.

SGX is a weird case because ENCLS can't be emulated in software, i.e.
exposing SGX to a VM without KVM's help would be difficult.  But, it
wouldn't be impossible, just slow and ugly.

And so, ignoring host oversubscription for the moment, there is no hard
requirement that SGX EPC can only be exposed to a VM through KVM.  In
other words, allocating and exposing EPC to a VM is orthogonal to KVM
supporting SGX.  Exposing EPC to userspace via /dev/sgx/epc would mean
that KVM would handle it like any other guest memory region, and all EPC
related code/logic would reside in the SGX subsystem.

Oversubscription throws a wrench in the system because ENCLV can only
be executed post-VMXON and EPC conflicts generate VMX VM-Exits.  But
even then, KVM doesn't need to own the EPC uapi, e.g. it can call into
the SGX subsystem to handle EPC conflict VM-Exits and the SGX subsystem
can wrap ENCLV with exception fixup and forcefully reclaim EPC pages if
ENCLV faults.

I can't be 100% certain the oversubscription scheme will be sane without
actually writing the code, but I'd like to at least keep the option open,
i.e. not structure /dev/sgx/ in such a way that adding e.g. /dev/sgx/epc
is impossible or ugly.
