Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000BCEB64DA
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Jun 2023 22:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjFVWBP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Jun 2023 18:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjFVWBO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 22 Jun 2023 18:01:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B47A2114
        for <linux-sgx@vger.kernel.org>; Thu, 22 Jun 2023 15:01:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-65026629c1eso3724133b3a.0
        for <linux-sgx@vger.kernel.org>; Thu, 22 Jun 2023 15:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687471270; x=1690063270;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rjGFqXSbWWovVsErl5aLIhVxVu6EowEQrPh42hkgPgU=;
        b=3URWSMGWZn9j6dG2EPdkRiGrUCpWT1H5JZ+lZQAcDYef/Qxz0MASkut0v2ZzEnjR/S
         jh6GNDSCsNLhIB1lLV3GIKXBIO8EG+DSOsHsVR+oNiyw9Pxt50FHMhASXN9CGyrbcjSZ
         8ZoNGIe3hwy+LU1dx66n7kFgmflA3o/ISHAiFNvhazDrbjUk/YFoC0FoxJKFIqTc/Fjd
         myUNWhEtehlCIgxpVq1Sv1rki6aOBjyf/DeX+FPJxFWv11r4qzKq7QS77toL/2btdZpM
         O561lbG7t2vKhNO85SkG9gXQx2lR6U2MF0jU2k0SwBbTuKfAanm17pnVjyEXllRAv+Ov
         t92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687471270; x=1690063270;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rjGFqXSbWWovVsErl5aLIhVxVu6EowEQrPh42hkgPgU=;
        b=DKPpS5kJKHtA1z/ElYJktbbZeynt1qzei1JFhsl68Ezlj/zKfhQE690Z4uA2S4A7sC
         bUJzBaLfEzAnvc2jrggzuYrMw0A56dhy5m2Suw+D90q1UT73YWvX1z1IBfCz8yW+wdk0
         alDBG4T9yFyCvBr5WQUtxU/kx7Bqol+KFKBo5NNPythbegAtG1stqhCw+TloC98QRO8J
         kXgcZk/okuQAW0yTK/+F2KhzP8WsRX6gFd5TChKE3/f95rstH9dO0H3k4gvBN6YbzC0q
         9753AFhue3o9J1BKx8yEVHTG9KGSfy4g9XwZ79t6Fi4SMK6NnG/SHWfirpPqLpgE5BWK
         n2ew==
X-Gm-Message-State: AC+VfDywKOMoBiopQQBO2Oi5XGUyqS6cf0pyFpR9I0fd7HTfwvcSOhlL
        vMjITbY9DDsjaJ4WfWdKQVAKL8yfSd4=
X-Google-Smtp-Source: ACHHUZ4PxI/it4oamFServOIAPptKkuZWq+dftb//ffqirvT6ufNw5PtjqoBjwzjqH8dnu/Looj7AVFfEnA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a3:b0:668:7ad6:81f2 with SMTP id
 u35-20020a056a0009a300b006687ad681f2mr3528142pfg.4.1687471269842; Thu, 22 Jun
 2023 15:01:09 -0700 (PDT)
Date:   Thu, 22 Jun 2023 15:01:08 -0700
In-Reply-To: <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
Mime-Version: 1.0
References: <Y/VBOkmi7VbVuzAh@kernel.org> <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com> <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
 <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com> <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
 <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
 <ZIzcrmU1RA7oEeQ7@google.com> <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
Message-ID: <ZJTEpH2yYtHmTRWr@google.com>
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

On Mon, Jun 19, 2023, Kai Huang wrote:
> On Fri, 2023-06-16 at 15:05 -0700, Sean Christopherson wrote:
> > But I think this is unrelated to what you really care about, e.g. a use=
rspace that
> > tightly controls its virtual memory could hardcode enclave placement (I=
IRC graphene
> > did/does do that).  I.e. the alignment issue is a completely different =
discussion.
> >=20
> > [*] https://lore.kernel.org/all/20190522153836.GA24833@linux.intel.com
>=20
> Right.  For the sake of making progress of this Haitao's series, we want =
to
> understand where did "SGX driver requires mmap(/dev/sgx_enclave) to use
> MAP_ANONYMOUS semantics" come from.
>=20
> But for this topic (how to reserve ELRANGE).  I am not sure the reason th=
at we
> prefer mmap(MAP_ANONYMOUS) still stands.  For instance, the discussion in=
 your
> above link was old implementation/assumption -- e.g., MAP_FIXED wasn't ev=
en
> used/supported for mmap()ing enclave chunks.
>=20
> So I am wondering now whether we suggest user to use mmap(MAP_ANONYMOUS) =
to get
> a size-aligned address still stands?  The current SGX driver's
> get_unmapped_area:
>=20
> static unsigned long sgx_get_unmapped_area(struct file *file,            =
     =20
>                                            unsigned long addr,
>                                            unsigned long len,            =
     =20
>                                            unsigned long pgoff,          =
     =20
>                                            unsigned long flags)          =
     =20
> {      =20
>         if ((flags & MAP_TYPE) =3D=3D MAP_PRIVATE)                       =
         =20
>                 return -EINVAL;
>        =20
>         if (flags & MAP_FIXED)
>                 return addr;
>                        =20
>         return current->mm->get_unmapped_area(file, addr, len, pgoff, fla=
gs); =20
> }              =20
> =20
>=20
> As you can see if we don't pass MAP_FIXED, which is the case for mmap() t=
o
> reserve ELRANGE, looks there's no difference between mmap(MAP_ANONYMOUS) =
and
> mmap(/dev/sgx_enclave)?

In practice, there's *probably* no significant difference.  Using an anonym=
ous
mapping is advantageous because there's no additional overhead, e.g. for lo=
cking
the file, it can be done in advance of actually opening /dev/sgx_enclave, h=
elps
document (in userspace) that the code isn't actually creating an enclave, j=
ust
finding a naturally aligned area in virtual memory (which isn't SGX specifi=
c), etc.

There are definitely differences, e.g. an LSM could restrict access to
/dev/sgx_enclave.  That particular one is obviously a "don't care", but it'=
s quite
difficult to say that mmap(/dev/sgx_enclave) and mmap(NULL) are equivalent =
due to
the amount of code that's involved in handling mmap().

> > > Also, if I am not missing something, the current driver doesn't preve=
nt using
> > > mmap(/dev/sgx_enclave, PROT_NONE) to reserve ELANGE.  So having clear
> > > documentation is helpful for SGX users to choose how to write their a=
pps.
> > >=20
> > > Go back to the "SGX driver uses MAP_ANONYMOUS semantics for mmap()", =
I believe
> > > this just is "SGX driver requires mmap() after ECREATE/EINIT to use M=
AP_SHARED |
> > > MAP_FIXED and pgoff is ignored".  Or more precisely, pgoff is "not _u=
sed_ by SGX
> > > driver".
> > >=20
> > > In fact, I think "pgoff is ignored/not used" is technically wrong for=
 enclave.
> >=20
> > Yeah, it's wrong.  It works because, until now apparently, there was ne=
ver a reason
> > a need to care about the file offset since ELRANGE base always provided=
 the necessary
> > information.  It wasn't a deliberate design choice, we simply overlooke=
d that detail
> > (unless Jarkko was holding back on me all those years ago :-) ).
>=20
> Yeah.  But I am not sure whether there are corner cases that we can have
> potential bug around here, since those VMA's are not aligned between the =
core-mm
> and the driver.
>=20
> I haven't thought carefully though.  I guess from core-mm's perspective t=
here
> are multi-VMAs mapping to the same/overlapping part of the enclave, while=
 the
> SGX driver treats them as mapping to different non-overlapping parts.  Pe=
rhaps
> it's OK as long as SGX driver doesn't use vma->pgoff to do something???

Ya, exactly.

> > > IMHO we should stop saying SGX driver uses MAP_ANONYMOUS semantics, b=
ecause the
> > > truth is it just takes advantage of MAP_FIXED and carelessly ignores =
the pgoff
> > > due to the nature of SGX w/o considering from core-MM's perspective.
> > >  =20
> > > And IMHO there are two ways to fix:
> > >=20
> > > 1) From now on, we ask SGX apps to use the correct pgoff in their
> > > mmap(/dev/sgx_enclave).  This shouldn't impact the existing SGX apps =
because SGX
> > > driver doesn't use vma->pgoff anyway.
> >=20
> > Heh, just "asking" won't help.  And breaking userspace, i.e. requiring =
all apps
> > to update, will just get you yelled at :-)
>=20
> We can document properly and assume the new apps will follow.  As I menti=
oned
> above, the old apps, which doesn't/shouldn't have been using fadvice() an=
yway,
> doesn't need to be changed, i.e.,  they should continue to work. :)
>=20
> No?

You can't build an ABI on assumptions.  E.g. even if userspace *intends* to=
 behave,
it wouldn't take much to compute the wrong offset (math is hard).

> > > 2) For the sake of avoiding having to ask existing SGX apps to change=
 their
> > > mmap()s, we _officially_ say that userspace isn't required to pass a =
correct
> > > pgoff to mmap() (i.e. passing 0 as did in existing apps), but the ker=
nel should
> > > fix the vma->pgoff internally.
> >=20
> > I recommend you don't do this.  Overwriting vm_pgoff would probably wor=
k, but it's
> > going to make a flawed API even messier.  E.g. you'll have painted SGX =
into a
> > corner if you ever want to decouple vma->start/end from encl->base.  I =
highly
> > doubt that will ever happen given how ELRANGE works, but I don't think =
a hack-a-fix
> > buys you enough to justify any more ugliness.
>=20
> I also found it's not feasible to cleanly fix the pgoff from userspace (I
> thought the pgoff could be fixed at very early stage of do_mmap() so ever=
ything
> later just worked, but it's not the case).  In do_mmap() the pgoff from
> userspace is already used to VMA merging/splitting etc before creating th=
e
> target VMA.
>=20
> Hmm.. Now I think we shouldn't silently fix pgoff in SGX driver as it may
> surprise the core-mm later because the core-mm has already done some job =
around
> VMAs before vma->pgoff is changed.
>=20
> >=20
> > > I do prefer option 2) because it has no harm to anyone: 1) No changes=
 to
> > > existing SGX apps; 2) It aligns with the core-MM to so all existing m=
map()
> > > operations should work as expected, meaning no surprise; 3) And this =
patchset
> > > from Haitao to use fadvice() to accelerate EAUG flow just works.
> >=20
> > I think you can have your cake and eat it too.  IIUC, the goal is to ge=
t fadvise()
> > working, and to do that without creating a truly heinous uAPI, you need=
 an accurate
> > vm_pgoff.  So, use a carrot and stick approach.
> >=20
> > If userspace properly defines vm_pgoff during mmap() and doesn't specif=
y MAP_ANONYMOUS,
> > then they get to use fadvise() (give 'em a carrot).  But if *any* mmap(=
) on the
> > enclave doesn't followo those rules, mark the enclave as tainted or wha=
tever and
> > disallow fadvise() (hit 'em with a stick).
>=20
> If we are supposed to use mmap(MAP_ANONYMOUS) to reserve ELRANGE, then I =
think
> userspace will just use MAP_FIXED for all mmap()s to /dev/sgx_enclave.

There is no "supposed" to.  Using mmap(NULL) is purely a suggestion to avoi=
d
running into overheads and checks that are ultimately unnecessary.  The onl=
y
requirement is that userspace provide a compatible chunk for virtual memory=
,
*how* userspace finds that chunk can be done in a number of ways.  mmap(NUL=
L)
just happens to be the most convenient one (IMO).

> To detect whether a VMA has the correct pgoff, we need to somehow mark it=
 in
> sgx_mmap(), but currently we don't have facility to do that.  Even we can=
 do,
> the core madvice() -> vfs_fadvice() cannot be aware of such VMA either, a=
nd
> in sgx_fadvice() we may have problem locating the correct VMA to do EAUG
> (because the vfs_fadvice()  uses  0 pgoff to calculate the file offset).
>=20
> So, now I think we should just let userspace itself to pass the correct p=
goff
> when it wants to use fadvice(), which is the option 1) I mentioned above.=
  The
> kernel doesn't/shouldn't need to fix vma->pgoff.
>=20
> In another words, I think:
>=20
>  - For the old apps, doesn't matter, continue to work;
>  - For new apps which want to use fadvice() to accelerate EAUG, it should=
 pass=EF=BF=BD
>    the correct pgoff in mmap(/dev/sgx_enclave) even with  MAP_FIXED.
>=20
> And we don't say "SGX driver uses MAP_ANONYMOUS semantics for
> mmap(/dev/sgx_enclave) any more".
>=20
> Does this make sense?

Yes, but as above, IMO the kernel needs to enforce that userspace has prope=
rly
set the offset, otherwise userspace will end up with completely nonsensical
behavior if it fails to set the correct offset.  The proposed sgx_fadvise()=
 already
takes mmap_lock for read, i.e. is mutually exclusive with sgx_mmap(), so en=
cforcing
the requirement should be quite straightforward, e.g.

        mmap_read_lock(current->mm);

        vma =3D find_vma(current->mm, start);
        if (!vma)
                goto unlock;
        if (vma->vm_private_data !=3D encl)
                goto unlock;
	if (encl->has_mismatched_offsets)  <=3D=3D=3D=3D=3D=3D
		goto unlock;

        pos =3D start;
        if (pos < vma->vm_start || end > vma->vm_end) {
                /* Don't allow any gaps */
                goto unlock;
        }
