Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B66C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 16:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A19B21773
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558716225;
	bh=ggW23MrZkRt9rW5CmH9tG1BXOSlW9TRFJp98uIdvoKI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ecU9HOODF8jwRqZI4zGYasMcCQlTQ6/UrA5qTyRRh7sCH88dP3bmkZUaKP4fINDYM
	 5bptFVB7vbigktxT2pO6pchRELvzPSsjxz3kWQpsMHj6J3iAK8XIm8Ujpz0FbFIYRJ
	 9YeZaLyHiZY9MgTeaUXtAGG2czC95c3BWhLk+4Xc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390834AbfEXQno (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 12:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390532AbfEXQnn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 12:43:43 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06C42186A
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558716222;
        bh=ggW23MrZkRt9rW5CmH9tG1BXOSlW9TRFJp98uIdvoKI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jBQ0Q2nxFeX8XMrkvwPiJGo7pwylggWf2/AyVI2PbYXi7qr65UaaQpTHCRAVkeNQd
         SkIjpqT59HmsQJkrUovhNQAVEdd1GqLw7qi5lCcFYpOKaEWViUELx9+sl5g67pPwey
         USG1epbHZl0BoGkrG+LWoa7w/PJlzomL6a1Q3Lq0=
Received: by mail-wr1-f53.google.com with SMTP id b18so10645214wrq.12
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 09:43:41 -0700 (PDT)
X-Gm-Message-State: APjAAAW/QaWW7+kY2MDeM9F/6ih8RjZa9mZvCxy4fVPel8/EeoavhUmP
        gGI0/fTddAnnHzbc7M0iLtwBX40FdktmmKSrKZlWvQ==
X-Google-Smtp-Source: APXvYqyggkvONNjNv0hDqKOGkisM3NKy4emIEsenROzIg+slkkM4mIbFl4MeDSbBPYXfV6Uy6VAslybbXyN+JYL5RVA=
X-Received: by 2002:adf:e9ca:: with SMTP id l10mr5325072wrn.47.1558716220228;
 Fri, 24 May 2019 09:43:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190521155140.GE22089@linux.intel.com> <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com> <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com> <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com> <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com> <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 24 May 2019 09:43:27 -0700
X-Gmail-Original-Message-ID: <CALCETrX0WqouSWgdM+LNxMzypa0ZHZXTmJ+nNkuPuL8UOF_f2w@mail.gmail.com>
Message-ID: <CALCETrX0WqouSWgdM+LNxMzypa0ZHZXTmJ+nNkuPuL8UOF_f2w@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 12:24 AM Xing, Cedric <cedric.xing@intel.com> wrote=
:
>
> Hi Andy,
>
> > From: Andy Lutomirski [mailto:luto@kernel.org]
> > Sent: Thursday, May 23, 2019 6:18 PM
> >
> > On Thu, May 23, 2019 at 4:40 PM Sean Christopherson <sean.j.christopher=
son@intel.com>
> > wrote:
> > >
> > > On Thu, May 23, 2019 at 08:38:17AM -0700, Andy Lutomirski wrote:
> > > > On Thu, May 23, 2019 at 7:17 AM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > >
> > > > > On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
> > > > > > On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson w=
rote:
> > > > > > > But actually, there's no need to disallow mmap() after ECREAT=
E
> > > > > > > since the LSM checks also apply to mmap(), e.g. FILE__EXECUTE
> > > > > > > would be needed to
> > > > > > > mmap() any enclave pages PROT_EXEC.  I guess my past self
> > > > > > > thought mmap() bypassed LSM checks?  The real problem is that
> > > > > > > mmap()'ng an existing enclave would require FILE__WRITE and
> > > > > > > FILE__EXECUTE, which puts us back at square one.
> > > > > >
> > > > > > I'm lost with the constraints we want to set.
> > > > >
> > > > > As is today, SELinux policies would require enclave loaders to
> > > > > have FILE__WRITE and FILE__EXECUTE permissions on
> > > > > /dev/sgx/enclave.  Presumably other LSMs have similar
> > > > > requirements.  Requiring all processes to have
> > > > > FILE__{WRITE,EXECUTE} permissions means the permissions don't add
> > > > > much value, e.g. they can't be used to distinguish between an
> > > > > enclave that is being loaded from an unmodified file and an encla=
ve that is being
> > generated on the fly, e.g. Graphene.
> > > > >
> > > > > Looking back at Andy's mail, he was talking about requiring
> > > > > FILE__EXECUTE to run an enclave, so perhaps it's only FILE__WRITE
> > > > > that we're trying to special case.
> > > > >
> > > >
> > > > I thought about this some more, and I have a new proposal that help=
s
> > > > address the ELRANGE alignment issue and the permission issue at the
> > > > cost of some extra verbosity.  Maybe you all can poke holes in it :=
)
> > > > The basic idea is to make everything more explicit from a user's
> > > > perspective.  Here's how it works:
> > > >
> > > > Opening /dev/sgx/enclave gives an enclave_fd that, by design,
> > > > doesn't give EXECUTE or WRITE.  mmap() on the enclave_fd only works
> > > > if you pass PROT_NONE and gives the correct alignment.  The
> > > > resulting VMA cannot be mprotected or mremapped.  It can't be
> > > > mmapped at all until
> > >
> > > I assume you're thinking of clearing all VM_MAY* flags in sgx_mmap()?
> > >
> > > > after ECREATE because the alignment isn't known before that.
> > >
> > > I don't follow.  The alignment is known because userspace knows the
> > > size of its enclave.  The initial unknown is the address, but that
> > > becomes known once the initial mmap() completes.
> >
> > [...]
> >
> > I think I made the mistake of getting too carried away with implementat=
ion details rather
> > than just getting to the point.  And I misremembered the ECREATE flow -=
- oops.  Let me try
> > again.  First, here are some problems with some earlier proposals (mine=
, yours
> > Cedric's):
> >
> >  - Having the EADD operation always work but have different effects dep=
ending on the
> > source memory permissions is, at the very least, confusing.
>
> Inheriting permissions from source pages IMHO is the easiest way to valid=
ate the EPC permissions without any changes to LSM. And the argument about =
its security is also easy to make.
>
> I understand that it may take some effort to document it properly but oth=
erwise don't see any practical issues with it.

My objection is to the fact that it's implicit.  I have no problem
with some operation succeeding if the source address is X and failing
if it's !X, but I don't think it's fantastic to have it succeed in
either case but do different things.

For what it's worth, while this is a bit of a theoretical issue for X,
but I think it's a real problem with W.  To avoid accidentally mapping
an enclave page X and then later mapping the same page W (potentially
in a different VMA), I think it will be a lot simpler if the driver
can track which pages are allowed to ever be W.  We definitely *don't*
want an interface in which the eventual writability of a page is
inferred from the W permission on the source address, since we do
*not* want to force anyone to map their enclave file PROT_WRITE or
even to open it O_RDWR.

With the explicit MAXPERM passed in, this issue goes away.  You can
specify W if you want W.

>
> >
> >  - If we want to encourage user programs to be well-behaved, we want to=
 make it easy to
> > map the RX parts of an enclave RX, the RW parts RW, the RO parts R, etc=
.  But this
> > interacts poorly with the sgx_mmap() alignment magic, as you've pointed=
 out.
> >
> >  - We don't want to couple LSMs with SGX too tightly.
> >
> > So here's how a nice interface might work:
> >
> > int enclave_fd =3D open("/dev/sgx/enclave", O_RDWR);
> >
> > /* enclave_fd points to a totally blank enclave. Before ECREATE, we nee=
d to decide on an
> > address. */
> >
> > void *addr =3D mmap(NULL, size, PROT_NONE, MAP_SHARED, enclave_fd, 0);
> >
> > /* we have an address! */
> >
> > ioctl(enclave_fd, ECREATE, ...);
> >
> > /* now add some data to the enclave.  We want the RWX addition to fail
> > immediately unless we have the relevant LSM pemission.   Similarly, we
> > want the RX addition to fail immediately unless the source VMA is appro=
priate. */
> >
> > ioctl(enclave_fd, EADD, rx_source_1, MAXPERM=3DRX, ...);  [the ...
> > includes SECINFO, which the kernel doesn't really care about] ioctl(enc=
lave_fd, EADD,
> > ro_source_1, MAXPERM=3DRX ...); ioctl(enclave_fd, EADD, rw_source_1, MA=
XPERM=3DRW ...);
> > ioctl(enclave_fd, EADD, rwx_source_1, MAXPERM=3DRWX ...);
>
> If MAXPERM is taken from ioctl parameters, the real question here is how =
to validate MAXPERM. Guess we shouldn't allow arbitrary MAXPERM to be speci=
fied by user code, and the only logical source I can think of is from the s=
ource pages (or from the enclave source file, but memory mapping is preferr=
ed because it offers more flexibility).

That's exactly what I intended here.  If you specify MAXPERM=3DRX, then
the kernel can validate that the source address is executable.

>
> >
> > ioctl(enclave_fd, EINIT, ...);  /* presumably pass sigstruct_fd here, t=
oo. */
> >
> > /* at this point, all is well except that the enclave is mapped PROT_NO=
NE. There are a
> > couple ways I can imagine to fix this. */
> >
> > We could use mmap:
> >
> > mmap(baseaddr+offset, len, PROT_READ, MAP_SHARED | MAP_FIXED, enclave_f=
d, 0);  /* only
> > succeeds if MAXPERM & R =3D=3D R */
> >
> > But this has some annoying implications with regard to sgx_get_unmapped=
_area().  We could
> > use an ioctl:
>
> There's an easy fix. Just let sgx_get_unmapped_area() do the natural alig=
nment only if MAP_FIXED is *not* set, otherwise, honor both address and len=
.
>
> But mmap() is subject to LSM check (probably against /dev/sgx/enclave?). =
How to do mmap(RX) if FILE__EXECUTE is *not* granted for /dev/sgx/enclave, =
even if MAXPERM=3DRX?

I think we just let /dev/sgx/enclave be FILE__EXECUTE.  We don't
*have* to make it so that FILE__WRITE and FILE__EXECUTE on
/dev/sgx/enclave means you can create RWX enclave mappings.

>
> >
> > ioctl(enclave_fd, SGX_IOC_MPROTECT, offset, len, PROT_READ);
> >
> > which has the potentially nice property that we can completely bypass t=
he LSM hooks,
> > because the LSM has *already* vetted everything when the EADD calls wer=
e allowed.  Or we
> > could maybe even just use
> > mprotect() itself:
> >
> > mprotect(baseaddr + offset, len, PROT_READ);
>
> How to bypass LSM hooks in this mprotect()?

Hmm.  I guess we either use FILE__WRITE and FILE__EXECUTE or we use ioctl()=
.

>
> >
> > Or, for the really evil option, we could use a bit of magic in .fault a=
nd do nothing here.
> > Instead we'd make the initial mapping PROT_READ|PROT_WRITE|PROT_EXEC an=
d have .fault
> > actually instantiate the PTEs with the intersection of the VMA permissi=
ons and MAXPERM.  I
> > don't think I like this alternative, since it feels more magical than n=
eeded and it will
> > be harder to debug.  I like the fact that /proc/self/maps shows the act=
ual permissions in
> > all the other variants.
>
> Agreed.
>
> >
> >
> > All of the rest of the crud in my earlier email was just implementation=
 details.  The
> > point I was trying to make was that I think it's possible to implement =
this without making
> > too much of a mess internally.  I think I favor the mprotect() approach=
 since it makes the
> > behavior fairly obvious.
> >
> > I don't think any of this needs to change for SGX2.  We'd have an
> > ioctl() that does EAUG and specifies MAXPERM.  Trying to mprotect() a p=
age that hasn't
> > been added yet with any permission other than PROT_NONE would fail.  I =
suppose we might
> > end up needing a way to let the EAUG operation *change* MAXPERM, and th=
is operation would
> > have to do some more LSM checks and walk all the existing mappings to m=
ake sure they're
> > consistent with the new MAXPERM.
>
> EAUG ioctl could be a solution, but isn't optimal at least. What we've do=
ne is #PF based. Specifically, an SGX2 enclave will have its heap mapped as=
 RW, but without any pages populated before EINIT. Then when the enclave ne=
eds a new page in its heap, it issues EACCEPT, which will cause a #PF and t=
he driver will respond by EAUG a new EPC page. And then the enclave will be=
 resumed and the faulted EACCEPT will be retried (and succeed).
>

If the driver works like that, then whatever call sets up this lazily
allocated heap could do the MAXPERM part.

That being said, is the performance advantage from putting this logic
in the kernel instead of in the untrusted part of the SDK really
worthwhile?

> >
> > As an aside, I wonder if Linus et all would be okay with a new MAP_FULL=
Y_ALIGNED mmap()
> > flag that allocated memory aligned to the requested size.  Then we coul=
d get rid of yet
> > another bit of magic.
> >
> > --Andy
>
> I've also got a chance to think more about it lately.
>
> When we talk about EPC page permissions with SGX2 in mind, I think we sho=
uld distinguish between initial permissions and runtime permissions. Initia=
l permissions refer to the page permissions set at EADD. They are technical=
ly set by "untrusted" code so should go by policies similar to those applic=
able to regular shared objects. Runtime permissions refer to the permission=
s granted by EMODPE, EAUG and EACCEPTCOPY. They are resulted from inherent =
behavior of the enclave, which in theory is determined by the enclave's mea=
surements (MRENCLAVE and/or MRSIGNER).
>
> And we have 2 distinct files to work with - the enclave file and /dev/sgx=
/enclave. And I consider the enclave file a logical source for initial perm=
issions while /dev/sgx/enclave is a means to control runtime permissions. T=
hen we can have a simpler approach like the pseudo code below.
>
> /**
>  * Summary:
>  * - The enclave file resembles a shared object that contains RO/RX/RW se=
gments
>  * - FILE__* are assigned to /dev/sgx/enclave, to determine acceptable pe=
rmissions to mmap()/mprotect(), valid combinations are
>  *   + FILE__READ - Allow SGX1 enclaves only
>  *   + FILE__READ|FILE__WRITE - Allow SGX2 enclaves to expand data segmen=
ts (e.g. heaps, stacks, etc.)

I think this is a non-starter :(  FILE__WRITE also means that you can
write to the file, and the admin / policy author will almost never
want to allow that.
