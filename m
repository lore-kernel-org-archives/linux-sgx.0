Return-Path: <SRS0=Hssn=PR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58638C43387
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jan 2019 16:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 265E52054F
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jan 2019 16:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfAIQbi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:31:38 -0500
Received: from mga04.intel.com ([192.55.52.120]:21981 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfAIQbi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Jan 2019 11:31:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 08:31:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,458,1539673200"; 
   d="scan'208";a="108570223"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 09 Jan 2019 08:31:37 -0800
Date:   Wed, 9 Jan 2019 08:31:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
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
Message-ID: <20190109163135.GA1821@linux.intel.com>
References: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
> On Tue, Jan 8, 2019 at 2:09 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Cleaner in the sense that it's faster to get basic support up and running
> > since there are fewer touchpoints, but there are long term ramifications
> > to cramming EPC management in KVM.
> >
> > And at this point I'm not stating any absolutes, e.g. how EPC will be
> > handled by KVM.  What I'm pushing for is to not eliminate the possibility
> > of having the SGX subsystem own all EPC management, e.g. don't tie
> > /dev/sgx to a single enclave.
> 
> I haven't gone and re-read all the relevant SDM bits, so I'll just
> ask: what, if anything, are the actual semantics of mapping "raw EPC"
> like this?  You can't actually do anything with the mapping from user
> mode unless you actually get an enclave created and initialized in it
> and have it mapped at the correct linear address, right?  I still
> think you have the right idea, but it is a bit unusual.

Correct, the EPC is inaccessible until a range is "mapped" with ECREATE.
But I'd argue that it's not unusual, just different.  And really it's not
all that different than userspace mmap'ing /dev/sgx/enclave prior to
ioctl(ENCLAVE_CREATE).  In that case, userspace can still (attempt to)
access the "raw" EPC, i.e. generate a #PF, the kernel/driver just happens
to consider any faulting EPC address without an associated enclave as
illegal, e.g. signals SIGBUS.

The /dev/sgx/epc case simply has different semantics for moving pages in
and out of the EPC, i.e. different fault and eviction semantics.  Yes,
this allows the guest kernel to directly access the "raw" EPC, but that's
conceptually in line with hardware where priveleged software can directly
"access" the EPC (or rather, the abort page for all intents and purposes).
I.e. it's an argument for requiring certain privileges to open /dev/sgx/epc,
but IMO it's not unusual.

Maybe /dev/sgx/epc is a poor name and is causing confusion, e.g.
/dev/sgx/virtualmachine might be more appropriate.

> I do think it makes sense to have QEMU delegate the various ENCLS
> operations (especially EINIT) to the regular SGX interface, which will
> mean that VM guests will have exactly the same access controls applied
> as regular user programs, which is probably what we want.

To what end?  Except for EINIT, none of the ENCLS leafs are interesting
from a permissions perspective.  Trapping and re-executing ENCLS leafs
is painful, e.g. most leafs have multiple virtual addresses that need to
be translated.  And routing everything through the regular interface
would make SGX even slower than it already is, e.g. every ENCLS would
take an additional ~900 cycles just to handle the VM-Exit, and that's
not accounting for any additional overhead in the SGX code, e.g. using
the regular interface would mean superfluous locks, etc...

The only benefit is that it would theoretically allow oversubscribing
guest EPC without hardware support, but that would require a lot of code
to do the necessary SECS tracking and refcounting.

> If so,
> there will need to be a way to get INITTOKEN privilege for the purpose
> of running non-Linux OSes in the VM, which isn't the end of the world.

Couldn't we require the same privilege/capability for VMs and and EINIT
tokens?  I.e. /dev/sgx/virtualmachine can only be opened by a user that
can also generate tokens.

> We might still want the actual ioctl to do EINIT using an actual
> explicit token to be somehow restricted in a way that strongly
> discourages its use by anything other than a hypervisor.  Or I suppose
> we could just straight-up ignore the guest-provided init token.
>
> P.S. Is Intel ever going to consider a way to make guests get their
> own set of keys that are different from the host's keys and other
> guests' keys?

