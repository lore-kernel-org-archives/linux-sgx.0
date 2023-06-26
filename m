Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270D6EB64D7
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Jun 2023 22:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjFZW2t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Jun 2023 18:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFZW2t (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 26 Jun 2023 18:28:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E86912D
        for <linux-sgx@vger.kernel.org>; Mon, 26 Jun 2023 15:28:47 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b7f2239a04so20015725ad.3
        for <linux-sgx@vger.kernel.org>; Mon, 26 Jun 2023 15:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687818527; x=1690410527;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gx7RjG9R3GBnUACZsXn8vxnJA72ei9ER8tbUfehRpk8=;
        b=lUsnj9D2sAdM4MpMHnc7pFzf49etr7xavShOcn7S97deiY0WfIk0M/wyGOeB7rwZrE
         BOCtDLGskVJQMw32ACXzWwxNfxtzsU5hzsZ/aCyuLsOEXACtLQTBYt+hSdZVb4eOFF3K
         o/ihkryxhgP32ZJpv5Y/IgROrC/8sYe90G88lMBOMgiX9TZSjMpaaVQy/Jj1mbzaNSIH
         YMICTtxcHokKobF4LFZfm2bflKwLzFJB8mCM2B6s9UrQEYUZlV0DlexojV7Yv78e1fp/
         GD0cLwrfNuPJ8lzp8zFozf8CWcppxQRS+yJhamtluDMHsBQrCoP60ZSIC2aF1dwcR8Xa
         0vBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687818527; x=1690410527;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gx7RjG9R3GBnUACZsXn8vxnJA72ei9ER8tbUfehRpk8=;
        b=MKo6nShiY7FphU8YmkkPnBzzQKlF8J5yE6jE3eZIIzZ4J7wPEiQXDEGIEi079z9xmr
         v7KvOI+TxjvMQWlW/jAtm+uleCZv3f/c9GFWIb05XF7n7st5pw9NneyrZ17ZjfSboU5x
         u3XE3fKbzygX4AiUPsgvNXThIIP1fxg0A9PuJ0SW8adr41gESfFlMrrNWib11bruphvC
         Z/3GIf0K3xJ8Ws+THuYFSElEu4d1LFRbw+9bGFL7fW06JMJRKKJyWN5V8BYwGewf7t2z
         HfimLdfKb8hbvdF/RcrzYNq4OjxLkAIk+O8f+njmaLAXb8bUStn3iHaC14WD2yvWvrBd
         /QUg==
X-Gm-Message-State: AC+VfDx9cNg8g5g/AGpv3ARZRiJy641ODuzef0GFgFs0dbW+K+9cqdEW
        UivlMs3JMSNgFfJiQHu1QkGdYBrM8BU=
X-Google-Smtp-Source: ACHHUZ6XjkgNiuACNHr3aMspG5QtA1cN7FOX6tjGtliFXovUIB3Q5nC2OaVgmtzBWiizWTzuHbQsIXwJrv8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8c84:b0:1b5:64:1862 with SMTP id
 t4-20020a1709028c8400b001b500641862mr671282plo.9.1687818526840; Mon, 26 Jun
 2023 15:28:46 -0700 (PDT)
Date:   Mon, 26 Jun 2023 15:28:45 -0700
In-Reply-To: <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
Mime-Version: 1.0
References: <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com> <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
 <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com> <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
 <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
 <ZIzcrmU1RA7oEeQ7@google.com> <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
 <ZJTEpH2yYtHmTRWr@google.com> <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
Message-ID: <ZJoRHU1CHxIuDH29@google.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 22, 2023, Kai Huang wrote:
> On Thu, 2023-06-22 at 15:01 -0700, Sean Christopherson wrote:
> > On Mon, Jun 19, 2023, Kai Huang wrote:
> > > On Fri, 2023-06-16 at 15:05 -0700, Sean Christopherson wrote:
> > > As you can see if we don't pass MAP_FIXED, which is the case for mmap=
() to
> > > reserve ELRANGE, looks there's no difference between mmap(MAP_ANONYMO=
US) and
> > > mmap(/dev/sgx_enclave)?
> >=20
> > In practice, there's *probably* no significant difference.  Using an an=
onymous
> > mapping is advantageous because there's no additional overhead, e.g. fo=
r locking
> > the file, it can be done in advance of actually opening /dev/sgx_enclav=
e, helps
> > document (in userspace) that the code isn't actually creating an enclav=
e, just
> > finding a naturally aligned area in virtual memory (which isn't SGX spe=
cific), etc.
>=20
> Sure, and I agree this perhaps is cleaner and simpler for SGX.  But for t=
his
> purpose I think we should just enforce this policy in SGX driver, i.e., w=
e
> should disable mmap(/dev/sgx_enclave) before ECREATE.
>=20
> To me at least the SGX driver should be clear whether it supports userspa=
ce to
> use mmap(/dev/sgx_enclave) to reserve ELRANGE.  There should be no ambigu=
ity
> here.
>=20
> The current driver only disallows mmap(/dev/sgx_enclave) outside of encla=
ve
> range after EINIT:
>=20
> int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
>                      unsigned long end, unsigned long vm_flags)
> {
> 	...
>=20
>         /* Disallow mapping outside enclave's address range. */
>         if (test_bit(SGX_ENCL_INITIALIZED, &encl->flags) &&
>             (start < encl->base || end > encl->base + encl->size))
>                 return -EACCES;
> }
>=20
> which has what value btw?

That code came in after my involvement, see commit 7b013e723a1f ("x86/sgx: =
Tighten
accessible memory range after enclave initialization").

> > There are definitely differences, e.g. an LSM could restrict access to
> > /dev/sgx_enclave. =EF=BF=BDThat particular one is obviously a "don't ca=
re",=EF=BF=BD
> >=20
>=20
> I think you meant "RW->RX" requires EXECMOD, etc?

I meant access to /dev/sgx_enclave itself.  What I was pointing out is that=
,
in theory, an LSM could deny mmap() on /dev/sgx_enclave, but it's a pointle=
ss
distinction since in that case userspace can't create SGX enclaves anyways,=
 i.e.
how userspace finds ELRANGE for an enclave it can't create is irrelevant :-=
)

> Yeah I am not sure whether this matters to reserving ELRANGE.  That part =
should
> apply to the mmap(/dev/sgx_enclave) after ECREATE.
>=20
> > but it's quite
> > difficult to say that mmap(/dev/sgx_enclave) and mmap(NULL) are equival=
ent due to
> > the amount of code that's involved in handling mmap().
>=20
> Sure.  I was talking about only from "allocating size-aligned" part.  Arg=
uably,
> in terms of reserving ELRANGE, userspace only cares about:
>=20
>  1) The ELRANGE is big enough to hold the enclave
>  2) The ELRANGE meets alignment requirement
>  3) Usperspace can mmap(/dev/sgx_enclave) and/or mprotect() small areas t=
o get
>     the correct enclave addr within ELRANGE with desired permission
>=20
> >=20
> > > > > Also, if I am not missing something, the current driver doesn't p=
revent using
> > > > > mmap(/dev/sgx_enclave, PROT_NONE) to reserve ELANGE.  So having c=
lear
> > > > > documentation is helpful for SGX users to choose how to write the=
ir apps.
> > > > >=20
> > > > > Go back to the "SGX driver uses MAP_ANONYMOUS semantics for mmap(=
)", I believe
> > > > > this just is "SGX driver requires mmap() after ECREATE/EINIT to u=
se MAP_SHARED |
> > > > > MAP_FIXED and pgoff is ignored".  Or more precisely, pgoff is "no=
t _used_ by SGX
> > > > > driver".
> > > > >=20
> > > > > In fact, I think "pgoff is ignored/not used" is technically wrong=
 for enclave.
> > > >=20
> > > > Yeah, it's wrong.  It works because, until now apparently, there wa=
s never a reason
> > > > a need to care about the file offset since ELRANGE base always prov=
ided the necessary
> > > > information.  It wasn't a deliberate design choice, we simply overl=
ooked that detail
> > > > (unless Jarkko was holding back on me all those years ago :-) ).
> > >=20
> > > Yeah.  But I am not sure whether there are corner cases that we can h=
ave
> > > potential bug around here, since those VMA's are not aligned between =
the core-mm
> > > and the driver.
> > >=20
> > > I haven't thought carefully though.  I guess from core-mm's perspecti=
ve there
> > > are multi-VMAs mapping to the same/overlapping part of the enclave, w=
hile the
> > > SGX driver treats them as mapping to different non-overlapping parts.=
  Perhaps
> > > it's OK as long as SGX driver doesn't use vma->pgoff to do something?=
??
> >=20
> > Ya, exactly.
> >=20
> > > > > IMHO we should stop saying SGX driver uses MAP_ANONYMOUS semantic=
s, because the
> > > > > truth is it just takes advantage of MAP_FIXED and carelessly igno=
res the pgoff
> > > > > due to the nature of SGX w/o considering from core-MM's perspecti=
ve.
> > > > >  =20
> > > > > And IMHO there are two ways to fix:
> > > > >=20
> > > > > 1) From now on, we ask SGX apps to use the correct pgoff in their
> > > > > mmap(/dev/sgx_enclave).  This shouldn't impact the existing SGX a=
pps because SGX
> > > > > driver doesn't use vma->pgoff anyway.
> > > >=20
> > > > Heh, just "asking" won't help.  And breaking userspace, i.e. requir=
ing all apps
> > > > to update, will just get you yelled at :-)
> > >=20
> > > We can document properly and assume the new apps will follow.  As I m=
entioned
> > > above, the old apps, which doesn't/shouldn't have been using fadvice(=
) anyway,
> > > doesn't need to be changed, i.e.,  they should continue to work. :)
> > >=20
> > > No?
> >=20
> > You can't build an ABI on assumptions.  E.g. even if userspace *intends=
* to behave,
> > it wouldn't take much to compute the wrong offset (math is hard).
>=20
> But I don't think we have an well established ABI now?  Nothing is docume=
nted.

Heh, just because the ABI isn't formally documented doesn't mean it doesn't=
 exist.
In fact, the most problematic ABIs are the ones that aren't documented.

> > There is no "supposed" to.  Using mmap(NULL) is purely a suggestion to =
avoid
> > running into overheads and checks that are ultimately unnecessary.  The=
 only
> > requirement is that userspace provide a compatible chunk for virtual me=
mory,
> > *how* userspace finds that chunk can be done in a number of ways.  mmap=
(NULL)
> > just happens to be the most convenient one (IMO).
>=20
> Even this, I think we should document it IMO, at least whether
> mmap(/dev/sgx_enclave) can be used to reserve ELRANGE.

See below.

> > > To detect whether a VMA has the correct pgoff, we need to somehow mar=
k it in
> > > sgx_mmap(), but currently we don't have facility to do that.  Even we=
 can do,
> > > the core madvice() -> vfs_fadvice() cannot be aware of such VMA eithe=
r, and
> > > in sgx_fadvice() we may have problem locating the correct VMA to do E=
AUG
> > > (because the vfs_fadvice()  uses  0 pgoff to calculate the file offse=
t).
> > >=20
> > > So, now I think we should just let userspace itself to pass the corre=
ct pgoff
> > > when it wants to use fadvice(), which is the option 1) I mentioned ab=
ove.  The
> > > kernel doesn't/shouldn't need to fix vma->pgoff.
> > >=20
> > > In another words, I think:
> > >=20
> > >  - For the old apps, doesn't matter, continue to work;
> > >  - For new apps which want to use fadvice() to accelerate EAUG, it sh=
ould pass=EF=BF=BD
> > >    the correct pgoff in mmap(/dev/sgx_enclave) even with  MAP_FIXED.
> > >=20
> > > And we don't say "SGX driver uses MAP_ANONYMOUS semantics for
> > > mmap(/dev/sgx_enclave) any more".
> > >=20
> > > Does this make sense?
> >=20
> > Yes, but as above, IMO the kernel needs to enforce that userspace has p=
roperly
> > set the offset, otherwise userspace will end up with completely nonsens=
ical
> > behavior if it fails to set the correct offset.  The proposed sgx_fadvi=
se() already
> > takes mmap_lock for read, i.e. is mutually exclusive with sgx_mmap(), s=
o encforcing
> > the requirement should be quite straightforward, e.g.
> >=20
> >         mmap_read_lock(current->mm);
> >=20
> >         vma =3D find_vma(current->mm, start);
>=20
> The "start" here may already be wrong because before vfs_fadvice() uses V=
MA's pgoff
> to calculate the start before passing it to sgx_fadvice().

Not my code :-)

> >         if (!vma)
> >                 goto unlock;
> >         if (vma->vm_private_data !=3D encl)
> >                 goto unlock;
> > 	if (encl->has_mismatched_offsets)  <=3D=3D=3D=3D=3D=3D
> > 		goto unlock;
>=20
> Sorry I am a little bit slow, how do you set "has_mismatched_offsests" to=
 true?

During sgx_mmap().  Though there's a wrinkle I initially missed: if the enc=
lave
hasn't gone through ECREATE, encl->base is garbage.  So either sgx_mmap() n=
eeds
to assume the !CREATED is creating a mismatched offset, or sgx_encl_create(=
) needs
to iterate over and check all VMAs.

Since there are advantages to usuing mmap(NULL) to find ELRANGE, IMO your b=
est
option is to do the below.  And then that mostly answers the question about
using mmap(/dev/sgx_enclave) to reserve ELRANGE, i.e. if userspace wants to=
 use
fallocate(), then it effectively *must not* use mmap(/dev/sgx_enclave).

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/dri=
ver.c
index 262f5fb18d74..63fb41da35aa 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -94,6 +94,11 @@ static int sgx_mmap(struct file *file, struct vm_area_st=
ruct *vma)
        if (ret)
                return ret;
=20
+       if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
+           vma->vm_pgoff !=3D PFN_DOWN(vma->vm_start - encl->base))
+               encl->has_mismatched_offsests =3D true;
+
+
        vma->vm_ops =3D &sgx_vm_ops;
        vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO);
        vma->vm_private_data =3D encl;

