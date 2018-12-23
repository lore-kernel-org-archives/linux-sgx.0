Return-Path: <SRS0=9ERu=PA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD49C43387
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Dec 2018 20:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9435A217FA
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Dec 2018 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545597725;
	bh=fhT5Upcb0BchNqADsZC/UUWpgZhEkUrGArd6HV8u0Sw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=BsJDdJaTUhazuR4HNFXkovb/16KB1mx1t96J+IV3RgCuSX8jZk07VAICgOBUOwNbE
	 eUL9sP32Ep3+YgsDYYua5Z76cbIyXCeisRfmAJzUtszhqdBB6pIHonYVsUBchKve9E
	 SFPNI0tRH0tnMPCWtlcr/Eojt6ZgFVrUbbQ6rOt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbeLWUmF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Dec 2018 15:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbeLWUmF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Dec 2018 15:42:05 -0500
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D22217FA
        for <linux-sgx@vger.kernel.org>; Sun, 23 Dec 2018 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545597723;
        bh=fhT5Upcb0BchNqADsZC/UUWpgZhEkUrGArd6HV8u0Sw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qv9ixfO/XNd0CdOctpaSzFbMiMu0I23RSVVMo+7iGD9MWI39QQoGTXtKUVknLEmyM
         RzJ9/aL4fI8Q8mXGX4Wn0rbMF7RdPpDVSmFAxDfV7GdyLnSZhwCV5/jUroncEP8Eln
         psp8LWASDYU7CCbZWzLInBKc316d1F9IE6CKu8Pk=
Received: by mail-wr1-f42.google.com with SMTP id p4so10094675wrt.7
        for <linux-sgx@vger.kernel.org>; Sun, 23 Dec 2018 12:42:03 -0800 (PST)
X-Gm-Message-State: AJcUukfrelVwKGOzPUYn6BAk3YGQkoUuuDPQlL3CEGnggKoHRFA2B1c3
        SMlb5Dx9KG+wuFUugchRQVpUoFzBp6eahsOIRv6GVA==
X-Google-Smtp-Source: ALg8bN4B8Wo7LvrUnx79wH9PcoE9dJ3nYs0VuMJQbc42lCSgQpMCjQsqMQs7iCnexW/I3X6ifZRMmx2DYUv95XN6VqI=
X-Received: by 2002:adf:ea81:: with SMTP id s1mr9321804wrm.309.1545597721601;
 Sun, 23 Dec 2018 12:42:01 -0800 (PST)
MIME-Version: 1.0
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com> <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com> <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
 <20181221182454.GA27371@linux.intel.com>
In-Reply-To: <20181221182454.GA27371@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 23 Dec 2018 12:41:49 -0800
X-Gmail-Original-Message-ID: <CALCETrVYJmutVEemMZRc=neFT4Ph+JUgapTWy5JS6KTH9eamHA@mail.gmail.com>
Message-ID: <CALCETrVYJmutVEemMZRc=neFT4Ph+JUgapTWy5JS6KTH9eamHA@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Dec 21, 2018, at 11:24 AM, Sean Christopherson <sean.j.christopherson@=
intel.com> wrote:
>
> On Fri, Dec 21, 2018 at 09:12:46AM -0800, Andy Lutomirski wrote:
>>> On Dec 21, 2018, at 9:28 AM, Sean Christopherson <sean.j.christopherson=
@intel.com> wrote:
>>>
>>> On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
>>>>> On Dec 19, 2018, at 6:45 AM, Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
>>>>>
>>>>>>> On Wed, Dec 19, 2018 at 09:36:16AM +0000, Jethro Beekman wrote:
>>>>>
>>>>> I agree with Jethro, passing the enclave_fd as a param is obnoxious.
>>>>> And it means the user needs to open /dev/sgx to do anything with an
>>>>> enclave fd, e.g. the enclave fd might be passed to a builder thread,
>>>>> it shouldn't also need the device fd.
>>>>>
>>>>> E.g.:
>>>>>
>>>>>  sgx_fd =3D open("/dev/sgx", O_RDWR);
>>>>>  BUG_ON(sgx_fd < 0);
>>>>>
>>>>>  enclave_fd =3D ioctl(sgx_fd, SGX_ENCLAVE_CREATE, &ecreate);
>>>>>  BUG_ON(enclave_fd < 0);
>>>>>
>>>>>  ret =3D ioctl(enclave_fd, SGX_ENCLAVE_ADD_PAGE, &eadd);
>>>>>  BUG_ON(ret);
>>>>>
>>>>>  ...
>>>>>
>>>>>  ret =3D ioctl(enclave_fd, SGX_ENCLAVE_INIT, &einit);
>>>>>  BUG_ON(ret);
>>>>>
>>>>>  ...
>>>>>
>>>>>  close(enclave_fd);
>>>>>  close(sgx_fd);
>>>>>
>>>>>
>>>>> Take a look at virt/kvm/kvm_main.c to see how KVM manages anon inodes
>>>>> and ioctls for VMs and vCPUs.
>>>>
>>>> Can one of you explain why SGX_ENCLAVE_CREATE is better than just
>>>> opening a new instance of /dev/sgx for each encalve?
>>>
>>> Directly associating /dev/sgx with an enclave means /dev/sgx can't be
>>> used to provide ioctl()'s for other SGX-related needs, e.g. to mmap()
>>> raw EPC and expose it a VM.  Proposed layout in the link below.  I'll
>>> also respond to Jarkko's question about exposing EPC through /dev/sgx
>>> instead of having KVM allocate it on behalf of the VM.
>>
>> Hmm. I guess this makes some sense.  My instinct would be to do it a
>> little differently and have:
>>
>> /dev/sgx/enclave: Each instance is an enclave.
>>
>> /dev/sgx/epc: Used to get raw EPC for KVM. Might have different
>> permissions, perhaps 0660 and group kvm.
>>
>> /dev/sgx/something_else: For when SGX v3 adds something else :)
>
> Mmmm, I like this approach a lot.  It would allow userspace to easily
> manage permissions for each "feature", e.g. give all users access to
> /dev/sgx/epc but restrict /dev/sgx/enclave.
>
> And we could add e.g. /dev/sgx/admin if we wanted to exposed ioctls()
> that apply to all aspects of SGX.
>
> Do you know if /dev/sgx/epc could be dynamically created, e.g. by
> KVM when the kvm_intel module is loaded?

Presumably sgx would create a bus and enumerate the devices as needed.
Or I suppose these things could be platform or system devices. I=E2=80=99m =
not
really a device model expert, and the one time I tried to implement a
character device, I got so disgusted that I wrote a whole library for
it.  It=E2=80=99s still in limbo somewhere.


>  That would seal the deal for
> me as it'd keep open the option of having KVM handle oversubscription
> of guest EPC while exposing EPC through /dev/sgx instead of /dev/kvm.
