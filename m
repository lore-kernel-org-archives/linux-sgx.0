Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36520C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 23:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F2620872
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 23:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfAJXyI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 18:54:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:47789 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbfAJXyI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 18:54:08 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 15:54:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,463,1539673200"; 
   d="scan'208";a="309414047"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jan 2019 15:54:06 -0800
Date:   Thu, 10 Jan 2019 15:54:06 -0800
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
Message-ID: <20190110235406.GB2365@linux.intel.com>
References: <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190109163135.GA1821@linux.intel.com>
 <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 10, 2019 at 01:34:44PM -0800, Andy Lutomirski wrote:
> >> On Jan 9, 2019, at 8:31 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >>
> >> On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
> >
> >> I do think it makes sense to have QEMU delegate the various ENCLS
> >> operations (especially EINIT) to the regular SGX interface, which will
> >> mean that VM guests will have exactly the same access controls applied
> >> as regular user programs, which is probably what we want.
> >
> > To what end?  Except for EINIT, none of the ENCLS leafs are interesting
> > from a permissions perspective.  Trapping and re-executing ENCLS leafs
> > is painful, e.g. most leafs have multiple virtual addresses that need to
> > be translated.  And routing everything through the regular interface
> > would make SGX even slower than it already is, e.g. every ENCLS would
> > take an additional ~900 cycles just to handle the VM-Exit, and that's
> > not accounting for any additional overhead in the SGX code, e.g. using
> > the regular interface would mean superfluous locks, etc...
> 
> Trapping EINIT is what I have in mind.

Phew, had me worried :-)

> >
> > Couldn't we require the same privilege/capability for VMs and and EINIT
> > tokens?  I.e. /dev/sgx/virtualmachine can only be opened by a user that
> > can also generate tokens.
> 
> Hmm, maybe.  Or we can use Jarkko’s securityfs attribute thingy.
> 
> Concretely, I think there are two things we care about:
> 
> First, if the host enforces some policy as to which enclaves can
> launch, then it should apply the same policy to guests — otherwise KVM
> lets programs do an end run around the policy. So, in the initial
> incarnation of this, QEMU should probably have to open the provision
> attribute fd if it wants its guest to be able to EINIT a provisioning
> enclave.  When someone inevitably adds an EINIT LSM hook, the KVM
> interface should also call it.

Sort of.  A guest that is running under KVM (i.e. VMX) is much more
contained than a random userspace program.  A rogue enclave in a VMX
guest can attack the guest kernel/OS, but barring a bug (or more likely,
several major bugs) elsewhere in the virtualization stack the enclave
can't do anything nasty to the host.  An enclave would let someone hide
code, but enclaves are even more restricted than cpl3, i.e. there's not
a lot it can do without coordinating with unencrypted code in the guest.

And if someone has sufficient permissions to run a KVM guest, they're
much more likely to do something malcious in the guest kernel, not an
enclave.

All that aside, I don't see any justification for singling out SGX for
extra scrutiny, there are other ways for a user with KVM permissions to
hide malicious code in guest (and at cpl0!), e.g. AMD's SEV{-ES}.

> Second, the normal enclave interface won't allow user code to supply
> an EINITTOKEN, so the KVM interface will presumably need to be
> different, unless we're going to emulate EINIT by ignoring the token.
> That seems like a very strange thing to do.
