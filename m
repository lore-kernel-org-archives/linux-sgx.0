Return-Path: <SRS0=ibNi=PT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB39C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 01:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B63720879
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 01:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfAKBcJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 20:32:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:30710 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfAKBcJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 20:32:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 17:32:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,463,1539673200"; 
   d="scan'208";a="266250032"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga004.jf.intel.com with ESMTP; 10 Jan 2019 17:32:08 -0800
Date:   Thu, 10 Jan 2019 17:32:08 -0800
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
Message-ID: <20190111013208.GC2365@linux.intel.com>
References: <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190109163135.GA1821@linux.intel.com>
 <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
 <20190110235406.GB2365@linux.intel.com>
 <CALCETrUsj1YBwcEDiyU-seTiCuyFJW+BvunzOUUiUYQj+ojpEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUsj1YBwcEDiyU-seTiCuyFJW+BvunzOUUiUYQj+ojpEg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 10, 2019 at 04:30:06PM -0800, Andy Lutomirski wrote:
> On Thu, Jan 10, 2019 at 3:54 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Sort of.  A guest that is running under KVM (i.e. VMX) is much more
> > contained than a random userspace program.  A rogue enclave in a VMX
> > guest can attack the guest kernel/OS, but barring a bug (or more likely,
> > several major bugs) elsewhere in the virtualization stack the enclave
> > can't do anything nasty to the host.  An enclave would let someone hide
> > code, but enclaves are even more restricted than cpl3, i.e. there's not
> > a lot it can do without coordinating with unencrypted code in the guest.
> >
> > And if someone has sufficient permissions to run a KVM guest, they're
> > much more likely to do something malcious in the guest kernel, not an
> > enclave.
> 
> Are you sure?  On my laptop, /dev/kvm is 0666, and that's the distro
> default.  I don't think this is at all unusual.

Wow, that's suprising.  A quick search suggests that this may be Debian
specific[1], e.g. my Ubuntu systems have:

crw-rw---- 1 root kvm 10, 232 Jan  9 09:30 /dev/kvm

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1431876

>  I'm not particularly
> concerned about a guest attacking itself, but it's conceptually
> straightforward to bypass whatever restrictions the host has by simply
> opening /dev/kvm and sticking your enclave in a VM.

VMs by nature allow a user to bypass all sorts of restrictions, e.g. the
kernel doesn't let userspace run arbitrary cpl0 code, but launch a VM
and voila.  It's what you can do with the new privileges that matters.

> > All that aside, I don't see any justification for singling out SGX for
> > extra scrutiny, there are other ways for a user with KVM permissions to
> > hide malicious code in guest (and at cpl0!), e.g. AMD's SEV{-ES}.
> 
> I'm not singling out SGX.  I'm just saying that the KVM should not
> magically bypass host policy.  If you want to assign a virtual
> function on your NIC to a KVM guest, you need to give your QEMU
> process that privilege.  Similarly, if someone has a MAC policy that
> controls which processes can launch which enclaves and they want to
> run Windows with full SGX support in a VM guest, then they should
> authorize that in their MAC policy by giving QEMU unrestricted launch
> privileges.

MAC systems exist to protect assets, and IMO an enclave isn't an asset.
E.g. AppArmor (via LSM) isn't protecting files, it's protecting the
contents of the file or what can be done with the file.  And the MAC
is only part of the overall protection scheme, e.g. userspace is also
relying on the kernel to not screw up the page tables.

In SGX terms, a LSM hook might use enclave signatures to protect some
asset 'X', e.g. access to persistent identifier.  But that doesn't mean
that whitelisting enclave signatures is the only way to protect 'X'.

> Similarly, if access to a persistent provisioning identifier is
> restricted, access to /dev/kvm shouldn't magically bypass it.  Just
> give the QEMU process the relevant privileges.

Agreed, but that's not same as applying a host's whitelist against a
guest's enclaves.
