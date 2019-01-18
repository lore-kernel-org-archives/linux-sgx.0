Return-Path: <SRS0=m09p=P2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736DEC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jan 2019 14:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F502063F
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jan 2019 14:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfAROhX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Jan 2019 09:37:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:65054 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfAROhW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Jan 2019 09:37:22 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2019 06:37:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,491,1539673200"; 
   d="scan'208";a="268157714"
Received: from unknown (HELO localhost) ([10.249.254.249])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2019 06:37:14 -0800
Date:   Fri, 18 Jan 2019 16:37:11 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
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
Message-ID: <20190118143711.GC4080@linux.intel.com>
References: <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190109163135.GA1821@linux.intel.com>
 <20190111125826.GA5400@linux.intel.com>
 <20190111231956.GB29769@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111231956.GB29769@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 11, 2019 at 03:19:56PM -0800, Sean Christopherson wrote:
> On Fri, Jan 11, 2019 at 02:58:26PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Jan 09, 2019 at 08:31:37AM -0800, Sean Christopherson wrote:
> > > On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
> > > > On Tue, Jan 8, 2019 at 2:09 PM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > >
> > > > > Cleaner in the sense that it's faster to get basic support up and running
> > > > > since there are fewer touchpoints, but there are long term ramifications
> > > > > to cramming EPC management in KVM.
> > > > >
> > > > > And at this point I'm not stating any absolutes, e.g. how EPC will be
> > > > > handled by KVM.  What I'm pushing for is to not eliminate the possibility
> > > > > of having the SGX subsystem own all EPC management, e.g. don't tie
> > > > > /dev/sgx to a single enclave.
> > > > 
> > > > I haven't gone and re-read all the relevant SDM bits, so I'll just
> > > > ask: what, if anything, are the actual semantics of mapping "raw EPC"
> > > > like this?  You can't actually do anything with the mapping from user
> > > > mode unless you actually get an enclave created and initialized in it
> > > > and have it mapped at the correct linear address, right?  I still
> > > > think you have the right idea, but it is a bit unusual.
> > > 
> > > Correct, the EPC is inaccessible until a range is "mapped" with ECREATE.
> > > But I'd argue that it's not unusual, just different.  And really it's not
> > > all that different than userspace mmap'ing /dev/sgx/enclave prior to
> > > ioctl(ENCLAVE_CREATE).  In that case, userspace can still (attempt to)
> > > access the "raw" EPC, i.e. generate a #PF, the kernel/driver just happens
> > > to consider any faulting EPC address without an associated enclave as
> > > illegal, e.g. signals SIGBUS.
> > > 
> > > The /dev/sgx/epc case simply has different semantics for moving pages in
> > > and out of the EPC, i.e. different fault and eviction semantics.  Yes,
> > > this allows the guest kernel to directly access the "raw" EPC, but that's
> > > conceptually in line with hardware where priveleged software can directly
> > > "access" the EPC (or rather, the abort page for all intents and purposes).
> > > I.e. it's an argument for requiring certain privileges to open /dev/sgx/epc,
> > > but IMO it's not unusual.
> > > 
> > > Maybe /dev/sgx/epc is a poor name and is causing confusion, e.g.
> > > /dev/sgx/virtualmachine might be more appropriate.
> > 
> > What do you mean by saying "requiring certain privileges"? Are you
> > saying that "raw EPC" (lets say /dev/vmsgx, which probably the name I
> > will use for the device *if* it is required) device would require
> > differet privileged than /dev/sgx?
> 
> I don't think it would be mandatory, especially if PROVISION and EINITTOKEN
> attributes are routed through securityfs, but it might be nice to have
> since the functionality provided by /dev/vmsgx would be different than
> /dev/sgx.
> 
> Side topic, what's the reasoning for doing /dev/sgx and /dev/vmsgx instead
> of /dev/sgx/{enclave,vm,etc...}?

I don't see we having more than two devices.

Directory hierarchies would make sense if there was variable numer of
stuff initialized.

/Jarkko
