Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB23DC43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 00:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C1F214C6
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 00:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfAJAkm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jan 2019 19:40:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:41474 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbfAJAkm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Jan 2019 19:40:42 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 16:40:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,459,1539673200"; 
   d="scan'208";a="309104230"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jan 2019 16:40:40 -0800
Date:   Wed, 9 Jan 2019 16:40:40 -0800
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
Message-ID: <20190110004040.GD1697@linux.intel.com>
References: <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A58F1@PGSMSX112.gar.corp.intel.com>
 <20190109171625.GB1821@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A994F@PGSMSX112.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105F7BF4D0229846AF094488D65A0989355A994F@PGSMSX112.gar.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 09, 2019 at 04:21:19PM -0800, Huang, Kai wrote:
> > > > That's possible, but it has several downsides.
> > > >
> > > >   - Duplicates a lot of code in KVM for managing memory regions.
> > >
> > > I don't see why there will be duplicated code. you can simply call
> > > __x86_set_memory_region to create private slot. It is KVM x86
> > > equivalent to KVM_SET_USER_MEMORY_REGION from userspace. The only
> > > difference is Qemu is not aware of the private slot.
> > 
> > What about when we allow removing an EPC region?  At that point you'd be
> > fully duplicating KVM_SET_USER_MEMORY_REGION.  And that's not a purely
> > theoretical idea, it's something I'd like to support in the future, e.g.
> > via the WIP virtio-mem interface.
> 
> OK. Isn't virtio-balloon good enough for us? 
> 
> Removing EPC is not consistent with hardware behaviour, but if you really
> want to support then should also be fine since we are not strictly
> following HW spec anyway.

Even if virtio-balloon is sufficient from a performance perspective, the
virtio-mem approach can provide unique capabilities, e.g. hotplugging
EPC into a VM or "I'm done with SGX, have all of my EPC back".

> > 
> > https://events.linuxfoundation.org/wp-content/uploads/2017/12/virtio-
> > mem-Paravirtualized-Memory-David-Hildenbrand-Red-Hat-1.pdf
> > 
> > > No. EPC info is from Qemu at the beginning (size is given by
> > > parameter, base is calculated by Qemu), and actually it is Qemu
> > > notifies KVM EPC info, so I don't think we require additional ioctls or
> > capabilities here.
> > 
> > How does Qemu know KVM supports virtual EPC?  Probing /dev/sgx doesn't
> > convey any information about KVM support.  Maybe you could report it via
> > KVM_GET_SUPPORTED_CPUID, but that would be problematic for Qemu
> > since it would have to create vCPUs before initializing the machine.
> 
> KVM_GET_SUPPORTED_CPUID is the one. I don't think KVM_GET_SUPPORTED_CPUID
> require creating vcpu prior, since it is global thing that platform  supports. No?

It's not a KVM requirement, but rather Qemu's code flow.  It sets up the
"machine" and then creates the vCPUs.  The CPUID info is a CPU capability
and so isn't necessarily available when the "machine" is being created.

> > 
> > The other aspect of private memslots is that they are not exposed to L2,
> > because again, from the guest's perspective, they do not exist.  We can
> > obviously hackaround that restriction, but it's yet another hint that shoving
> > EPC into a private memslot is the wrong approach.
> 
> But guest is aware of SGX and EPC so I don't see why it cannot be exposed
> to L2 even with private slot.

It's not that it can't be done, but rather we'd have to explicitly tell
KVM "this private slot isn't really private, expose it to L2".  See
commit 3a2936dedd20 ("kvm: mmu: Don't expose private memslots to L2").
