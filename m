Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FD0C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 00:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D17214DA
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 00:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfAJAVZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jan 2019 19:21:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:38106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfAJAVZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Jan 2019 19:21:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 16:21:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,459,1539673200"; 
   d="scan'208";a="290334557"
Received: from kmsmsx156.gar.corp.intel.com ([172.21.138.133])
  by orsmga005.jf.intel.com with ESMTP; 09 Jan 2019 16:21:20 -0800
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.246]) by
 KMSMSX156.gar.corp.intel.com ([169.254.1.83]) with mapi id 14.03.0415.000;
 Thu, 10 Jan 2019 08:21:19 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
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
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: x86/sgx: uapi change proposal
Thread-Topic: x86/sgx: uapi change proposal
Thread-Index: AQHUl3CouNmOMJQZHU2YX8Dh54+gQaWFODMAgAAIjACAAAbWAIAAVlWAgADM8wCAAnSJgIAc/6rw//+proCAAOdxMIAAWOyAgADzcOA=
Date:   Thu, 10 Jan 2019 00:21:19 +0000
Message-ID: <105F7BF4D0229846AF094488D65A0989355A994F@PGSMSX112.gar.corp.intel.com>
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
 <20190109171625.GB1821@linux.intel.com>
In-Reply-To: <20190109171625.GB1821@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDYzZGJlMTAtZThmOC00NTk3LTkxMDMtMjg5NDQxY2Y2ZThiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYVVPRGhkOGl4ckU5M1VoaFZjT0l6QVZndlwvTE8rT1FDYkVkeG9VRG5PejZ3clVXeElLa3R4NmMwZEVSWSt2bVoifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> > > That's possible, but it has several downsides.
> > >
> > >   - Duplicates a lot of code in KVM for managing memory regions.
> >
> > I don't see why there will be duplicated code. you can simply call
> > __x86_set_memory_region to create private slot. It is KVM x86
> > equivalent to KVM_SET_USER_MEMORY_REGION from userspace. The only
> > difference is Qemu is not aware of the private slot.
> 
> What about when we allow removing an EPC region?  At that point you'd be
> fully duplicating KVM_SET_USER_MEMORY_REGION.  And that's not a purely
> theoretical idea, it's something I'd like to support in the future, e.g.
> via the WIP virtio-mem interface.

OK. Isn't virtio-balloon good enough for us? 

Removing EPC is not consistent with hardware behaviour, but if you really want to support then should also be fine since we are not strictly following HW spec anyway.

> 
> https://events.linuxfoundation.org/wp-content/uploads/2017/12/virtio-
> mem-Paravirtualized-Memory-David-Hildenbrand-Red-Hat-1.pdf
> 
> >
> > >   - Artificially restricts userspace to a single EPC region, unless
> > >     even more code is duplicated to handle multiple private regions.
> >
> > You can have multiple private slots, by calling
> > __x86_set_memory_region for each EPC section. KVM receives EPC
> > section/sections info from Qemu, via CPUID, or dedicated IOCTL (is
> > this you are going to add?), and simply creates private EPC slot/slots.
> 
> This would require a dynamic number of private memslots, which breaks (or
> at least changes) the semantics of KVM_CAP_NR_MEMSLOTS.

You are right. I forgot this one.

> 
> >
> > >   - Requires additional ioctls() or capabilities to probe EPC
> > > support
> >
> > No. EPC info is from Qemu at the beginning (size is given by
> > parameter, base is calculated by Qemu), and actually it is Qemu
> > notifies KVM EPC info, so I don't think we require additional ioctls or
> capabilities here.
> 
> How does Qemu know KVM supports virtual EPC?  Probing /dev/sgx doesn't
> convey any information about KVM support.  Maybe you could report it via
> KVM_GET_SUPPORTED_CPUID, but that would be problematic for Qemu
> since it would have to create vCPUs before initializing the machine.

KVM_GET_SUPPORTED_CPUID is the one. I don't think KVM_GET_SUPPORTED_CPUID require creating vcpu prior, since it is global thing that platform  supports. No?

> 
> >
> > >   - Does not fit with Qemu/KVM's memory model, e.g. all other types of
> > >     memory are exposed to a guest through
> > > KVM_SET_USER_MEMORY_REGION.
> >
> > EPC is different. I am not sure whether EPC needs to fit such model.
> > There are already examples in KVM which uses private slot w/o using
> > KVM_SET_USER_MEMORY_REGION, for example, APIC access page.
> 
> EPC has unique access and lifecycle semantics, but that doesnt make it a
> special snowflake, e.g. NVDIMM has special properties, as does memory that
> is encrypted via SME or MKTME, and so on and so forth.
> 
> The private memslots are private for a reason, e.g. the guest is completely
> unaware that they exist and Qemu is only aware of their existence because
> KVM needs userspace to tell it what GPA range won't conflict with its
> memory model.  And in the APIC access page case, Qemu isn't aware at all
> since KVM doesn't allow relocating the guest's APIC.
> 
> The other aspect of private memslots is that they are not exposed to L2,
> because again, from the guest's perspective, they do not exist.  We can
> obviously hackaround that restriction, but it's yet another hint that shoving
> EPC into a private memslot is the wrong approach.

But guest is aware of SGX and EPC so I don't see why it cannot be exposed to L2 even with private slot.

But that doesn't matter. I agree with you letting Qemu create EPC slots is probably better since we can support multiple EPC  better (and potential EPC removal if needed).

And

[snip]

> 
> I'm all for getting KVM support in ASAP, i.e. I'd love to avoid having to wait
> for "full" SGX support, but that doesn't obviate the need to hammer out the
> uapi.  Taking a shortcut and shoving everything into KVM could bite us in the
> long run.

I agree. 

Thanks,
-Kai


