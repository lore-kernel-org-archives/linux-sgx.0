Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD0A33997
	for <linux-sgx@vger.kernel.org>; Sun, 29 Sep 2024 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727649371; cv=none; b=Yp+sSv2B4uy0i8U2C0QIbfFzlQAISJ56bs2Y2DpRxzeWtBHON4OlGxv99pGaZbx8GjccYioddfV6NAxk/MhR6LBYoKQwlNPAA3myeIBsZsIqr9hqHPIOtKpjU6k91HgPJBNXJC0zALmsYnvCJOolCPLC3/WfCAR4NG3z+FlMpT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727649371; c=relaxed/simple;
	bh=+oT88ihx576riDVg8OMIKoChpD2dVJJLaJZcCVzKiWI=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=bdMt/as5uTKJ9lVWoTVz+pwkTMEbZwuA+W1rVrxyxovkd+ppee/DNUNXMNE5B3N3ojAGn+XyR8sM3qnZHb0Vom5AeSEyn0JFm3l+M8XzXnE921I7ddjQKeiQSguX2Be8Cx6Q31s3O2eG/HZvYHPePmdpRPvRl9Jz+toVAiqpeys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtkZMsQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtkZMsQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81524C4CEC5;
	Sun, 29 Sep 2024 22:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727649371;
	bh=+oT88ihx576riDVg8OMIKoChpD2dVJJLaJZcCVzKiWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtkZMsQxLphBH5n60nHLoN/9CF140fir6RvA48RR03k2vfsu82GjlDhbWnlHD2xOF
	 90GPcGExlTPpeM0tdVSZF/qFm348ukjhAm69z59gpNIhuc2QX0KTORsjkTJjMtk3rw
	 nuAyLOvO240fnYjjy+txmzmJZJbbJJPyvvxsnXK71Crqr/q+a5ijjm6IlKQcDoCuFG
	 jOr/bMTeczSO2+dlA3tTywcqNWlgWPlrUxTqefs3t5QbolIgizgJii83ZAEKWxLolX
	 0OD6ze+eOnFqAJT2qoH6dKErJN7gffrGKB82WHpjNNSRA8Iwrv5Qz8kbajVbt493ak
	 MsC3OiE1zHoDQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 30 Sep 2024 01:36:06 +0300
Message-Id: <D4J4L636HVPC.QH7CETQ7SGVN@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Huang, Kai"
 <kai.huang@intel.com>
Cc: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>, <linux-sgx@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: VMA merging updateds?
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <2ba91a26-71b6-4150-9d8d-d5517d316808@lucifer.local>
In-Reply-To: <2ba91a26-71b6-4150-9d8d-d5517d316808@lucifer.local>

On Fri Sep 27, 2024 at 8:39 PM EEST, Lorenzo Stoakes wrote:
> Jumping into this thread mid-way to give my point of view.
>
> On Thu, Sep 26, 2024 at 12:07:02PM GMT, Huang, Kai wrote:
> >
> >
> > On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> > > On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> > > > > On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > > > > > Hi
> > > > > >
> > > > > > I started to look into this old issue with mm subsystem and SGX=
, i.e.
> > > > > > can we make SGX VMA's to merge together?
> > > > > >
> > > > > > This demonstrates the problem pretty well:
> > > > > >
> > > > > > https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd=
42018824f97.camel@kernel.org/
> > > > > >
> > > > > > It was result of brk() syscall being applied a few times.
> > > >
> > > > Briging some context here. This can be fixed in the run-time by boo=
k
> > > > keeping the ranges and doing unmapping/mapping. I guess this goes
> > > > beyond what mm should support?
>
> The reason you're seeing this is that the ranges are VM_PFNMAP (as well a=
s
> VM_IO, VM_DONTEXPAND) , which are part of the VM_SPECIAL bitmask and
> therefore explicitly not permitted to merge.
>
> VMA merging occurs not when VMAs are merely adjacent to one another, but
> when they are adjacent to one another AND share the same attributes.
>
> Obviously for most VMA attributes this is critically important - you can'=
t
> have a read-only range merge with a r/w range, it is the VMAs that are
> telling us this, equally so if different files/non-adjacent
> offsets/etc. etc.
>
> For these 'special' mappings each individual VMA may have distinct privat=
e
> state and may be tracked/managed by the driver, and indeed I see that
> vma->vm_private_data is used.
>
> Also SGX utilises custom VMA handling operations for fault handling and
> obviously does its own thing.
>
> Because of this, there's just no way mm can know whether it's ok to merge
> or not. Some of the attributes become in effect 'hidden'. You could map
> anything in these ranges and track that with any kind of state.
>
> So it's absolutely correct that we do not merge in these cases, as things
> currently stand.
>
> > > >
> > > > I thought to plain check this as it has been two years since my las=
t
> > > > query on topic (if we could improve either the driver or mm somehow=
).
> > >
> > > In the past I've substituted kernel's mm merge code with user space
> > > replacement:
> > >
> > > https://github.com/enarx/mmledger/blob/main/src/lib.rs
> > >
> > > It's essentially a reimplementation of al stuff that goes into
> > > mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> > > which map over existing ranges were working correctly, i.e. was
> > > the issue only concerning adjacent VMA's.
>
> mm/vma.c's vma_merge_existing_range() and vma_merge_new_range() now :) I
> have completely rewritten this code from 6.12 onwards.
>
> > >
> > > What I'm looking here is that can we make some cosntraints that
> > > if satisfied by the pfnmap code, it could leverage the code from
> > > vma_merge(). Perhaps by making explicit call to vma_merge()?
> > > I get that implicit use moves too much responsibility to the mm
> > > subsystem.
>
> Merging/splitting behaviour is an implementation detail and absolutely
> cannot be exposed like this (and would be dangerous to do so).

I can believe that (not unexpected)

I've been doing some initial research for possibility to integrate Enarx
(LF governed confidential computing run-time) with=20
https://github.com/rust-vmm/vm-memory, which is pretty solid mmap
abstraction, for which at least Paolo Bonzini is active contributor.

Enarx is multi-backend supporting also VM based private memory in
addition SGX. It has some a bit degraded parts at least SNP interfacing
code that need to be fixed. So I'm now just scoping what needs to be
done make it fresh again. It is just a leisure time sudoku just to
recover a rusty codebase whenever have some idle time.

>
> However, I think the only sensible way we could proceed with something li=
ke
> this is to add a new vma operation explicitly for pfnmap mappings which a=
re
> _otherwise mergeable_ like:
>
> 	vm_ops->may_merge_pfnmap(struct vm_area_struct *,
> 				 struct vm_area_struct *)
>
> Which the driver could implement to check internal state matches between
> the two VMAs.
>
> It's nicely opt-in as we'd not merge if this were not set, and it defers
> the decision as to 'hidden attributes' to the driver. Also we could ensur=
e
> all other merge characteristics were satisfied first to avoid any invalid
> merging between VMAs - in fact this function would only be called if:
>
> 1. Both VMAs are VM_PFNMAP.
> 2. Both VMAs are otherwise compatible.
> 3. Both VMAs implement vm_ops->may_merge_pfnmap() (should be implied by 2=
,
>    as vm_ops equality implies file equality).
> 4. vm_ops->may_merge_pfnmap(vma1, vma2) returns true.

OK strong maybe see what I wrote below.

>
> At which point we could merge. Note that the existence of .close() could
> cause issues here, though the existing merging rules should handle this
> correctly.
>
> I _suspect_ from a brief reading of the SGX stuff you only really need th=
e
> enclave value to be the same?
>
> So it could be something like:
>
> 	static bool sgx_may_merge_pfnmap(struct vma_area_struct *vma1,
> 					 struct vma_area_struct *vma2)
> 	{
> 		/* Merge if enclaves match. */
> 		return vma1->vm_private_data =3D=3D vma2->vm_private_data;
> 	}
>
> Since you seem to be doing mappings explicitly based on virtual addresses
> in these ranges?

Yep, so this is how it works now that I revisited the cod ea bit:

1. Enclave is a naturally aligned static address range of pow2 size.
   That is mapped first and everything happens inside. It is mapped
   with none permissions. With opcode ENCLS[ECREATE] this range is
   connected to a singe enclave.
2. With enclave or actually even SNP VM then internally has small
   engine and database that implements mmap() call and calls back
   to the outside world with a MAP_FIXED range. So actually in all
   cases my mmledger book keeper is in all cases needed. And it
   is needed to define what is expected from run-time.

   It must happen this way because of a distrust model. Without
   going too much details enclaves can set requirements for page
   permissions cryptographically and have structure (enclave
   page cache map) for this. Thus enclave (or SNP VM) leads,
   run-time follows that by delegating (fixed) mmap() calls,

   In practice the enclave will #GP if memory access is made
   with unexpected permission, even if page tables would allow
   it. In theory you could even just plain rwx map the range
   and base only on EPCM but in practice matching the page
   tables is useful and adds a bit defense in depth.

With SNP things obviously work correctly because it is just a
fancy VM with weird extra shenanigans.

With SGX things are fixed up by allocating a static heap and
never translating brk/sbrk to any syscall. Then for regular
mmaps() it just I guess hopes that user space software uses
it wisely :-)

>
> I could look into RFC'ing something for you guys to test when I get a
> chance?

So I got some ideas I could try out after reading your proposal and
restudying work I did over two years ago :-) I think it makes sense
for me to try to see how much I can improve first.

With pfnmap what did happen when you have a fixed map let's say
from A to B and you map from A to C where C > B? Cannot recall does
this success. Right, and as said vm_close() does not exist.

That could be used based mmledger to overwrite the old VMA. Or I
could do pro-active unmapping.

mmledger could tell "what changed" i.e.  provide syscall parameters for
0-2 munmaps and mmap(MAP_FIXED)  and ask run-time to execute those
instead of just mmap(MAP_FIXED)

I need to improve that crate anyway because I realized that you need
something like that to any trusted execution environment because they
reason what they want from memory :-)

So I get on this first and come back to this lore thread later when
I have some more experience on the topic.

> I'm guessing the problem is a concern that a map limit will be hit or VMA
> memory usage will be a problem? If not it may simply seem ugly...

Yea, so Enarx can take any software compiled to static wasm program and
put into a protected environment. It has a syscall shim and wasm
run-time and loader when it launches. If the application uses mm
syscalls like a good citizen it should not blow up VMA list but
that ofc is based on good faith ;-)

[1] Only for completeness:
    https://github.com/enarx/enarx/blob/main/crates/shim-sgx/src/heap.rs

BR, Jarkko
