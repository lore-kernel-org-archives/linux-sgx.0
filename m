Return-Path: <SRS0=ibNi=PT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D37AC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 13:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D73C320836
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbfAKNAL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Jan 2019 08:00:11 -0500
Received: from mga07.intel.com ([134.134.136.100]:44753 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731545AbfAKNAL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Jan 2019 08:00:11 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jan 2019 05:00:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,465,1539673200"; 
   d="scan'208";a="133688153"
Received: from gandrejc-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.144])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jan 2019 05:00:03 -0800
Date:   Fri, 11 Jan 2019 15:00:02 +0200
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
Message-ID: <20190111130002.GB5400@linux.intel.com>
References: <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190109163135.GA1821@linux.intel.com>
 <20190111125826.GA5400@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111125826.GA5400@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 11, 2019 at 02:58:26PM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 09, 2019 at 08:31:37AM -0800, Sean Christopherson wrote:
> > On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
> > > On Tue, Jan 8, 2019 at 2:09 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > Cleaner in the sense that it's faster to get basic support up and running
> > > > since there are fewer touchpoints, but there are long term ramifications
> > > > to cramming EPC management in KVM.
> > > >
> > > > And at this point I'm not stating any absolutes, e.g. how EPC will be
> > > > handled by KVM.  What I'm pushing for is to not eliminate the possibility
> > > > of having the SGX subsystem own all EPC management, e.g. don't tie
> > > > /dev/sgx to a single enclave.
> > > 
> > > I haven't gone and re-read all the relevant SDM bits, so I'll just
> > > ask: what, if anything, are the actual semantics of mapping "raw EPC"
> > > like this?  You can't actually do anything with the mapping from user
> > > mode unless you actually get an enclave created and initialized in it
> > > and have it mapped at the correct linear address, right?  I still
> > > think you have the right idea, but it is a bit unusual.
> > 
> > Correct, the EPC is inaccessible until a range is "mapped" with ECREATE.
> > But I'd argue that it's not unusual, just different.  And really it's not
> > all that different than userspace mmap'ing /dev/sgx/enclave prior to
> > ioctl(ENCLAVE_CREATE).  In that case, userspace can still (attempt to)
> > access the "raw" EPC, i.e. generate a #PF, the kernel/driver just happens
> > to consider any faulting EPC address without an associated enclave as
> > illegal, e.g. signals SIGBUS.
> > 
> > The /dev/sgx/epc case simply has different semantics for moving pages in
> > and out of the EPC, i.e. different fault and eviction semantics.  Yes,
> > this allows the guest kernel to directly access the "raw" EPC, but that's
> > conceptually in line with hardware where priveleged software can directly
> > "access" the EPC (or rather, the abort page for all intents and purposes).
> > I.e. it's an argument for requiring certain privileges to open /dev/sgx/epc,
> > but IMO it's not unusual.
> > 
> > Maybe /dev/sgx/epc is a poor name and is causing confusion, e.g.
> > /dev/sgx/virtualmachine might be more appropriate.
> 
> What do you mean by saying "requiring certain privileges"? Are you
> saying that "raw EPC" (lets say /dev/vmsgx, which probably the name I
> will use for the device *if* it is required) device would require
> differet privileged than /dev/sgx?

I'd say that it would be a good goal to be able to create a VM as a
normal user and use SGX.

/Jarkko
