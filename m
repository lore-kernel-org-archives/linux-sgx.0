Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7579AC43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 21:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385432173B
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 21:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547156100;
	bh=V3reuBOkp9sf/Vb+CQYQ1QVoEay/cabzsBnJpstF/fA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=1FkYymKCPEOjig7P6uMc77mkLoKDKHbYXs9pxhXZ8KGnYRbtXbt13ACd2fH4nJtgY
	 rLUavRcQOgXzs2yEmzcd8C5dg2nh0CgAf4dsh/HLU0B+7S9Yy8h65wLmjEaYbYRtb3
	 dYG8a8NpVWaHxGEfbYiOLezcpcFz9Cxg4r8MCvWQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfAJVfA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 16:35:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfAJVe7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 16:34:59 -0500
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9412173B
        for <linux-sgx@vger.kernel.org>; Thu, 10 Jan 2019 21:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547156098;
        bh=V3reuBOkp9sf/Vb+CQYQ1QVoEay/cabzsBnJpstF/fA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j2fD8EgL6Q5JkF/dovjykaxsuNoTxOqLbFndHaMe2IPuFRIwXL1mhyFq5iHmEPPEe
         u5YYvL58Pxp6lacbPxKtLNm75A45D2Bgm8J85+2Sdr90IPSyCE3s4PwMt5eFsoTZXz
         pjeyOnaUH7wlXN/rdzkmguQPGoYtvo3aQMIAXP0c=
Received: by mail-wm1-f47.google.com with SMTP id g67so470627wmd.2
        for <linux-sgx@vger.kernel.org>; Thu, 10 Jan 2019 13:34:58 -0800 (PST)
X-Gm-Message-State: AJcUukdBDSLhRd6d57ICT0HvOgLrfl3DF/otWOg1sVetj9yakze61YtG
        u6YWB/rhKnRXA988yd6Fdki6gJBgaxZlWvf/VpVygw==
X-Google-Smtp-Source: ALg8bN7ysAT27PT3oDeaoG8Tzw6DKxhrFLzg9WwazDhmVDpDikKVUq2G1yfo7wrAH9EyiaiO1uErtbUkX8W2X5zjomk=
X-Received: by 2002:a1c:aa0f:: with SMTP id t15mr401172wme.108.1547156096726;
 Thu, 10 Jan 2019 13:34:56 -0800 (PST)
MIME-Version: 1.0
References: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com> <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com> <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com> <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190109163135.GA1821@linux.intel.com>
In-Reply-To: <20190109163135.GA1821@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 10 Jan 2019 13:34:44 -0800
X-Gmail-Original-Message-ID: <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
Message-ID: <CALCETrW2wPq_umu6jNzCMvR6kphTZhcEody6ok64yyLWvfrvTg@mail.gmail.com>
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

>> On Jan 9, 2019, at 8:31 AM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>>
>> On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
>> On Tue, Jan 8, 2019 at 2:09 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>>
>>> Cleaner in the sense that it's faster to get basic support up and runni=
ng
>>> since there are fewer touchpoints, but there are long term ramification=
s
>>> to cramming EPC management in KVM.
>>>
>>> And at this point I'm not stating any absolutes, e.g. how EPC will be
>>> handled by KVM.  What I'm pushing for is to not eliminate the possibili=
ty
>>> of having the SGX subsystem own all EPC management, e.g. don't tie
>>> /dev/sgx to a single enclave.
>>
>> I haven't gone and re-read all the relevant SDM bits, so I'll just
>> ask: what, if anything, are the actual semantics of mapping "raw EPC"
>> like this?  You can't actually do anything with the mapping from user
>> mode unless you actually get an enclave created and initialized in it
>> and have it mapped at the correct linear address, right?  I still
>> think you have the right idea, but it is a bit unusual.
>
> Correct, the EPC is inaccessible until a range is "mapped" with ECREATE.
> But I'd argue that it's not unusual, just different.  And really it's not
> all that different than userspace mmap'ing /dev/sgx/enclave prior to
> ioctl(ENCLAVE_CREATE).  In that case, userspace can still (attempt to)
> access the "raw" EPC, i.e. generate a #PF, the kernel/driver just happens
> to consider any faulting EPC address without an associated enclave as
> illegal, e.g. signals SIGBUS.
>
> The /dev/sgx/epc case simply has different semantics for moving pages in
> and out of the EPC, i.e. different fault and eviction semantics.  Yes,
> this allows the guest kernel to directly access the "raw" EPC, but that's
> conceptually in line with hardware where priveleged software can directly
> "access" the EPC (or rather, the abort page for all intents and purposes)=
.
> I.e. it's an argument for requiring certain privileges to open /dev/sgx/e=
pc,
> but IMO it's not unusual.
>
> Maybe /dev/sgx/epc is a poor name and is causing confusion, e.g.
> /dev/sgx/virtualmachine might be more appropriate.
>
>> I do think it makes sense to have QEMU delegate the various ENCLS
>> operations (especially EINIT) to the regular SGX interface, which will
>> mean that VM guests will have exactly the same access controls applied
>> as regular user programs, which is probably what we want.
>
> To what end?  Except for EINIT, none of the ENCLS leafs are interesting
> from a permissions perspective.  Trapping and re-executing ENCLS leafs
> is painful, e.g. most leafs have multiple virtual addresses that need to
> be translated.  And routing everything through the regular interface
> would make SGX even slower than it already is, e.g. every ENCLS would
> take an additional ~900 cycles just to handle the VM-Exit, and that's
> not accounting for any additional overhead in the SGX code, e.g. using
> the regular interface would mean superfluous locks, etc...

Trapping EINIT is what I have in mind.

>
> Couldn't we require the same privilege/capability for VMs and and EINIT
> tokens?  I.e. /dev/sgx/virtualmachine can only be opened by a user that
> can also generate tokens.

Hmm, maybe.  Or we can use Jarkko=E2=80=99s securityfs attribute thingy.

Concretely, I think there are two things we care about:

First, if the host enforces some policy as to which enclaves can
launch, then it should apply the same policy to guests =E2=80=94 otherwise =
KVM
lets programs do an end run around the policy. So, in the initial
incarnation of this, QEMU should probably have to open the provision
attribute fd if it wants its guest to be able to EINIT a provisioning
enclave.  When someone inevitably adds an EINIT LSM hook, the KVM
interface should also call it.

Second, the normal enclave interface won't allow user code to supply
an EINITTOKEN, so the KVM interface will presumably need to be
different, unless we're going to emulate EINIT by ignoring the token.
That seems like a very strange thing to do.
