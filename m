Return-Path: <SRS0=ibNi=PT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C392AC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 00:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89541214C6
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547166622;
	bh=GhjNZeaFrFOl6BRL7aoWZ7fWABm9Kl+kAat9qQOV0RI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=o+XOmNQ84AAqOfQKiwXqtl2unVkZClD8SMRz/HRylUcu7dqxMNm8y3sc/ojVckmwJ
	 rVLEAR84adUGsq130Yh7haCnEHc3D+aIuiM8BMqMvphLFbLwHqCXggwZm1OERJa7VV
	 E9oFJmE6wbAHeMwksvaU9V73NgbDNFxu+R1+VfA4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfAKAaW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 19:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbfAKAaV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 19:30:21 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36015218B0
        for <linux-sgx@vger.kernel.org>; Fri, 11 Jan 2019 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547166620;
        bh=GhjNZeaFrFOl6BRL7aoWZ7fWABm9Kl+kAat9qQOV0RI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q6Zfod1M29jhY7yiz2WRKWgAmqqgUKUmoS8vLkp0rDk7qFAhCcFbeP+A2m4dw16Vl
         D1RZ2XYqTKHduIxAwugHV5p9/VuVE5gD/He9JllzUqz4WbWv3XfcFDYG/LKKW1IEzW
         ahugusoUCK9rC/gem93GC7prPa5mz9VGv3rdmYig=
Received: by mail-wm1-f45.google.com with SMTP id d15so749138wmb.3
        for <linux-sgx@vger.kernel.org>; Thu, 10 Jan 2019 16:30:20 -0800 (PST)
X-Gm-Message-State: AJcUukeqfaRKdpdYDXB8wA8djIJyt5aP46JbbyQQfrd85OC+/EqTyK6H
        Q877k9+U7NCSC9lzyjcPG3IjiS62/LaM5Ar7y4TV9A==
X-Google-Smtp-Source: ALg8bN7tz8lieNI5xeB9nJNvN9juxR/2CmjHMsD+uQIv/smYKUZ0WUgXlH6qhRo3tUhchfesQqCWFTRCY0dIgkGM/Zs=
X-Received: by 2002:a1c:f112:: with SMTP id p18mr188067wmh.83.1547166618440;
 Thu, 10 Jan 2019 16:30:18 -0800 (PST)
MIME-Version: 1.0
References: <20181219091148.GA5121@linux.intel.com> <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com> <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com> <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com> <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190109163135.GA1821@linux.intel.com> <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
 <20190110235406.GB2365@linux.intel.com>
In-Reply-To: <20190110235406.GB2365@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 10 Jan 2019 16:30:06 -0800
X-Gmail-Original-Message-ID: <CALCETrUsj1YBwcEDiyU-seTiCuyFJW+BvunzOUUiUYQj+ojpEg@mail.gmail.com>
Message-ID: <CALCETrUsj1YBwcEDiyU-seTiCuyFJW+BvunzOUUiUYQj+ojpEg@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 10, 2019 at 3:54 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Jan 10, 2019 at 01:34:44PM -0800, Andy Lutomirski wrote:
> > >> On Jan 9, 2019, at 8:31 AM, Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
> > >>
> > >> On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
> > >
> > >> I do think it makes sense to have QEMU delegate the various ENCLS
> > >> operations (especially EINIT) to the regular SGX interface, which wi=
ll
> > >> mean that VM guests will have exactly the same access controls appli=
ed
> > >> as regular user programs, which is probably what we want.
> > >
> > > To what end?  Except for EINIT, none of the ENCLS leafs are interesti=
ng
> > > from a permissions perspective.  Trapping and re-executing ENCLS leaf=
s
> > > is painful, e.g. most leafs have multiple virtual addresses that need=
 to
> > > be translated.  And routing everything through the regular interface
> > > would make SGX even slower than it already is, e.g. every ENCLS would
> > > take an additional ~900 cycles just to handle the VM-Exit, and that's
> > > not accounting for any additional overhead in the SGX code, e.g. usin=
g
> > > the regular interface would mean superfluous locks, etc...
> >
> > Trapping EINIT is what I have in mind.
>
> Phew, had me worried :-)
>
> > >
> > > Couldn't we require the same privilege/capability for VMs and and EIN=
IT
> > > tokens?  I.e. /dev/sgx/virtualmachine can only be opened by a user th=
at
> > > can also generate tokens.
> >
> > Hmm, maybe.  Or we can use Jarkko=E2=80=99s securityfs attribute thingy=
.
> >
> > Concretely, I think there are two things we care about:
> >
> > First, if the host enforces some policy as to which enclaves can
> > launch, then it should apply the same policy to guests =E2=80=94 otherw=
ise KVM
> > lets programs do an end run around the policy. So, in the initial
> > incarnation of this, QEMU should probably have to open the provision
> > attribute fd if it wants its guest to be able to EINIT a provisioning
> > enclave.  When someone inevitably adds an EINIT LSM hook, the KVM
> > interface should also call it.
>
> Sort of.  A guest that is running under KVM (i.e. VMX) is much more
> contained than a random userspace program.  A rogue enclave in a VMX
> guest can attack the guest kernel/OS, but barring a bug (or more likely,
> several major bugs) elsewhere in the virtualization stack the enclave
> can't do anything nasty to the host.  An enclave would let someone hide
> code, but enclaves are even more restricted than cpl3, i.e. there's not
> a lot it can do without coordinating with unencrypted code in the guest.
>
> And if someone has sufficient permissions to run a KVM guest, they're
> much more likely to do something malcious in the guest kernel, not an
> enclave.

Are you sure?  On my laptop, /dev/kvm is 0666, and that's the distro
default.  I don't think this is at all unusual.  I'm not particularly
concerned about a guest attacking itself, but it's conceptually
straightforward to bypass whatever restrictions the host has by simply
opening /dev/kvm and sticking your enclave in a VM.

>
> All that aside, I don't see any justification for singling out SGX for
> extra scrutiny, there are other ways for a user with KVM permissions to
> hide malicious code in guest (and at cpl0!), e.g. AMD's SEV{-ES}.

I'm not singling out SGX.  I'm just saying that the KVM should not
magically bypass host policy.  If you want to assign a virtual
function on your NIC to a KVM guest, you need to give your QEMU
process that privilege.  Similarly, if someone has a MAC policy that
controls which processes can launch which enclaves and they want to
run Windows with full SGX support in a VM guest, then they should
authorize that in their MAC policy by giving QEMU unrestricted launch
privileges.

Similarly, if access to a persistent provisioning identifier is
restricted, access to /dev/kvm shouldn't magically bypass it.  Just
give the QEMU process the relevant privileges.
