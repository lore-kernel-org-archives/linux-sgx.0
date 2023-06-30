Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97890EB64D9
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Jun 2023 01:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjF3B6D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Jun 2023 21:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjF3B6C (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Jun 2023 21:58:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C9C0
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 18:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D8FA6167E
        for <linux-sgx@vger.kernel.org>; Fri, 30 Jun 2023 01:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA41C433C0;
        Fri, 30 Jun 2023 01:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688090280;
        bh=TBig/a3mX4nVvgYobBuRnxYTSzwAcqFDxYDTvp2xaeo=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=u+SpOiDAFjo3+yIEDv3F9yGNUVrFmJYlbOrerP/dJIc2D2k3jGnzgTIwV9U56ICMv
         fS10XqpbUSwtteajKD8sClMnaAb+RBW6CgRWCoREE7VCH/1WW2os2xAN+osCJYu76f
         7FdLdWiykOTbJk7LugTLJsymFzJANMbeFdqO0qiDL4pq5nBExTDvL1zVmg0aWU0Efg
         NAP3LDHrfGwLznxvknzAHjRzeGWlfKRLBVD6rdNxg7rSfh3dG7y234h/cEe3jfSH8G
         2vGILz8M+Mc/SEHU/ORWz/4jFF8xkfPyFnqvNDU2vOPGcNIof7uS/zbR0NbAi94ApS
         lTkcfKr7C1cRw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Jun 2023 04:57:56 +0300
Message-Id: <CTPM273Z6Y6S.36I8EUC0M72B7@suppilovahvero>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jarkko Sakkinen" <jarkko@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
X-Mailer: aerc 0.14.0
References: <ZIzcrmU1RA7oEeQ7@google.com>
 <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
 <ZJTEpH2yYtHmTRWr@google.com>
 <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
 <ZJoRHU1CHxIuDH29@google.com>
 <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
 <ZJr3PthzDgugKDcO@google.com>
 <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
 <ZJxKV1/2M+OeIXAN@google.com>
 <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
 <ZJ2T6zJSnLtKMPnE@google.com>
 <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
 <CTPLZCBDSLUU.1CPR6DL9J2GE9@suppilovahvero>
In-Reply-To: <CTPLZCBDSLUU.1CPR6DL9J2GE9@suppilovahvero>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri Jun 30, 2023 at 4:54 AM EEST, Jarkko Sakkinen wrote:
> On Fri Jun 30, 2023 at 2:29 AM EEST, Huang, Kai wrote:
> > On Thu, 2023-06-29 at 07:23 -0700, Sean Christopherson wrote:
> > > On Thu, Jun 29, 2023, Kai Huang wrote:
> > > > On Wed, 2023-06-28 at 07:57 -0700, Sean Christopherson wrote:
> > > > > On Wed, Jun 28, 2023, Kai Huang wrote:
> > > > > > (but requires MAP_FIXED).
> > > > >=20
> > > > > No, SGX doesn't require MAP_FIXED.  The requirements of ELRANGE m=
ake it extremely
> > > > > unlikely that mmap() will succeed, but it's not a strict requirem=
ent.=20
> > > >=20
> > > > Looks w/o MAP_FIXED, the driver just uses the generic mm->get_unmap=
ped_area() to
> > > > return the address, which doesn't guarantee the right address will =
be returned
> > > > at all.  Especially when ELRANGE is reserved via mmap(NULL), the
> > > > mmap(/dev/sgx_enclave) will not return the correct address no matte=
r what pgoff
> > > > is used IIUC.
> > > >=20
> > > > static unsigned long sgx_get_unmapped_area(struct file *file,
> > > >                                            unsigned long addr,
> > > >                                            unsigned long len,
> > > >                                            unsigned long pgoff,
> > > >                                            unsigned long flags)
> > > > {
> > > >         if ((flags & MAP_TYPE) =3D=3D MAP_PRIVATE)
> > > >                 return -EINVAL;
> > > >=20
> > > >         if (flags & MAP_FIXED)
> > > >                 return addr;
> > > >=20
> > > >         return current->mm->get_unmapped_area(file, addr, len, pgof=
f, flags);
> > > > }
> > > >=20
> > > > So to me userspace has to use MAP_FIXED to get the correct address.
> > >=20
> > > No.  As called out below, @addr is still used as a fairly strong hint=
:
> > >=20
> > > unsigned long
> > > arch_get_unmapped_area_topdown(struct file *filp, const unsigned long=
 addr0,
> > > 			  const unsigned long len, const unsigned long pgoff,
> > > 			  const unsigned long flags)
> > > {
> > > 	struct vm_area_struct *vma;
> > > 	struct mm_struct *mm =3D current->mm;
> > > 	unsigned long addr =3D addr0;
> > > 	struct vm_unmapped_area_info info;
> > >=20
> > > 	/* requested length too big for entire address space */
> > > 	if (len > TASK_SIZE)
> > > 		return -ENOMEM;
> > >=20
> > > 	/* No address checking. See comment at mmap_address_hint_valid() */
> > > 	if (flags & MAP_FIXED)
> > > 		return addr;
> > >=20
> > > 	/* for MAP_32BIT mappings we force the legacy mmap base */
> > > 	if (!in_32bit_syscall() && (flags & MAP_32BIT))
> > > 		goto bottomup;
> > >=20
> > > 	/* requesting a specific address */  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > 	if (addr) {
> > > 		addr &=3D PAGE_MASK;
> > > 		if (!mmap_address_hint_valid(addr, len))
> > > 			goto get_unmapped_area;
> > >=20
> > > 		vma =3D find_vma(mm, addr);
> > > 		if (!vma || addr + len <=3D vm_start_gap(vma))
> > > 			return addr;
> > > 	}
> > >=20
> > > 	...
> > > }
> > >=20
> > >=20
> > > In practice, I expect most/all userspace implementations do use MAP_F=
IXED, but
> > > it's not strictly required.
> > >=20
> >
> > Yeah I agree it's a strong hint, but from ABI's perspective, I think ev=
en a
> > strong hint isn't good enough.  If there's no guarantee userspace can 1=
00% get
> > the correct enclave address, then userspace will always need to verify =
the
> > return address and if not do mmap() again.
> >
> > Btw, my reading of above function is if @addr hint doesn't work if the =
ELRANGE
> > is reserved using mmap(NULL), because below code will always NOT return=
 addr:
> >
> > 		vma =3D find_vma(mm, addr);	<--- A valid VMA will be found
> > 		if (!vma || addr + len <=3D vm_start_gap(vma))	<--  This check
> > 								 will be false
> > 			return addr;
> >
> > This is kinda reasonable because ELRANGE via mmap(NULL) doesn't have a =
file
> > backed, so the mmap(/dev/sgx_enclave) should never return an overlappin=
g address
> > even we pass a addr within ELRANGE.
> >
> > But my true argument is from ABI's perspective, although @addr is a hin=
t, but
> > it's not guaranteed the *exact* addr will be returned  (see man page be=
low):
> >
> > "
> > If addr is not NULL, then the kernel takes it as a hint about where to =
place the
> > mapping; ...... If another mapping already exists there, the kernel pic=
ks a new
> > address that may or may not depend on the hint.
> > "
> >
> > But SGX usrespace needs a *exact* address.  MAP_FIXED is the only ABI c=
an
> > guarantee this.
>
> A practical point of view: I don't see much any other point with Intel
> SDK than provide environment to compile and run attestation shenanigans.
>
> Is there something people *actually* use it in the cloud?
>
> I'm starting to miss the perspective on why waste so much energy on this?
> Feels fuzzy.

Does this map to any of the runtimes that people *actually* use for
their workloads?

BR, Jarkko
