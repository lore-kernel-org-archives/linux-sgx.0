Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39288EB64DC
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Jun 2023 14:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjF2OXs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjF2OXn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Jun 2023 10:23:43 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5AD210B
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 07:23:42 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5428d1915acso472015a12.0
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 07:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688048621; x=1690640621;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxwEwsUlz1dJZUy5cPlOkJrpYtvqOhZJR12nyrXjhe0=;
        b=H7CYovbiOBLYwefASkZ8W1qCjZMEDcc+hCNMS/8j3ZYJmjNKFDHHN6zqZ6EqvuOSAn
         OXePXhk4+Y7LJXMpkfPfSVh3dpar5Ha2HjbwgjppLwpPkaboKs3FiTjIpEJ/XlvREp5x
         yStl/GfNgpIZoBum7kyaC81oi1ynyYP7/oTYmnxl5dvtOMN2sSRuNcw+5voZvaf2Ixjv
         fHGL+h0OHjoFQA2xxf6rhgWpXGlCVOXth5gDe35pKHV4pP6gDGN/S2IOTndhnGlUcZii
         1O6N4anBItHimME8fMhxVuGMqotk91QbJSGL1qs/ReEa4su4ivNkvcuS3hntWzGnZBZc
         T3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688048621; x=1690640621;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yxwEwsUlz1dJZUy5cPlOkJrpYtvqOhZJR12nyrXjhe0=;
        b=lvxS+ZfdEzxg66ssX/mklt/+ezucZWFupw/B8Lc0iLxV5OnYMmmFHj+Ql0W2pFpz9v
         xEyUdgB04c+hgG2M68OEjzTm6iNsnOvc3H4r9cWsXFwBzFurNFUjEX2CTdRN5JLSeeGU
         E6Xoy3k7vJnGDAFut7aeio3vM5iRbLbuWj2+rmaHNkk3dboDt3NyBF07wlCYZivNUSyR
         NaoCNf5CmaUzRB9RZ8o6TiPSRkMDgAF4pteNeBtf/hUbSVfYRHpDcemVDCpqdqVHYm/B
         DxSbL5Q4hqsREGYh0LBzkkOVLCbAzoX9QMCFVRtSY5dOxyW6JOTB3eWR3QgZr7GZUgPb
         FP2A==
X-Gm-Message-State: AC+VfDy/e4Fg/H185MyPYtwxX7VoUy1p0tCRrS+2n7xAeLPRHQsx2DSX
        qcdf7TAd2ZOOE3Ldvhk5TgJf90sQsxI=
X-Google-Smtp-Source: ACHHUZ5jxjnJu5Zq+Tl2WPIaX1JeSK75eHIGTIPZQeeMkW1DGLK40lATwsC7aG43rZ6NuI9khcm5sjbc7Qw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:40c4:0:b0:53f:9a37:c199 with SMTP id
 u4-20020a6540c4000000b0053f9a37c199mr821074pgp.1.1688048621280; Thu, 29 Jun
 2023 07:23:41 -0700 (PDT)
Date:   Thu, 29 Jun 2023 07:23:39 -0700
In-Reply-To: <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
Mime-Version: 1.0
References: <ZIzcrmU1RA7oEeQ7@google.com> <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
 <ZJTEpH2yYtHmTRWr@google.com> <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
 <ZJoRHU1CHxIuDH29@google.com> <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
 <ZJr3PthzDgugKDcO@google.com> <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
 <ZJxKV1/2M+OeIXAN@google.com> <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
Message-ID: <ZJ2T6zJSnLtKMPnE@google.com>
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

On Thu, Jun 29, 2023, Kai Huang wrote:
> On Wed, 2023-06-28 at 07:57 -0700, Sean Christopherson wrote:
> > On Wed, Jun 28, 2023, Kai Huang wrote:
> > > (but requires MAP_FIXED).
> >=20
> > No, SGX doesn't require MAP_FIXED.  The requirements of ELRANGE make it=
 extremely
> > unlikely that mmap() will succeed, but it's not a strict requirement.=
=20
>=20
> Looks w/o MAP_FIXED, the driver just uses the generic mm->get_unmapped_ar=
ea() to
> return the address, which doesn't guarantee the right address will be ret=
urned
> at all.  Especially when ELRANGE is reserved via mmap(NULL), the
> mmap(/dev/sgx_enclave) will not return the correct address no matter what=
 pgoff
> is used IIUC.
>=20
> static unsigned long sgx_get_unmapped_area(struct file *file,
>                                            unsigned long addr,
>                                            unsigned long len,
>                                            unsigned long pgoff,
>                                            unsigned long flags)
> {
>         if ((flags & MAP_TYPE) =3D=3D MAP_PRIVATE)
>                 return -EINVAL;
>=20
>         if (flags & MAP_FIXED)
>                 return addr;
>=20
>         return current->mm->get_unmapped_area(file, addr, len, pgoff, fla=
gs);
> }
>=20
> So to me userspace has to use MAP_FIXED to get the correct address.

No.  As called out below, @addr is still used as a fairly strong hint:

unsigned long
arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0=
,
			  const unsigned long len, const unsigned long pgoff,
			  const unsigned long flags)
{
	struct vm_area_struct *vma;
	struct mm_struct *mm =3D current->mm;
	unsigned long addr =3D addr0;
	struct vm_unmapped_area_info info;

	/* requested length too big for entire address space */
	if (len > TASK_SIZE)
		return -ENOMEM;

	/* No address checking. See comment at mmap_address_hint_valid() */
	if (flags & MAP_FIXED)
		return addr;

	/* for MAP_32BIT mappings we force the legacy mmap base */
	if (!in_32bit_syscall() && (flags & MAP_32BIT))
		goto bottomup;

	/* requesting a specific address */  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
	if (addr) {
		addr &=3D PAGE_MASK;
		if (!mmap_address_hint_valid(addr, len))
			goto get_unmapped_area;

		vma =3D find_vma(mm, addr);
		if (!vma || addr + len <=3D vm_start_gap(vma))
			return addr;
	}

	...
}


In practice, I expect most/all userspace implementations do use MAP_FIXED, =
but
it's not strictly required.

> > > 2) Therefore,=EF=BF=BD"passing the correct pgoff" in new userspace ap=
p doesn't break the
> > > current ABI.  If the new app chooses to pass the correct pgoff, it wi=
ll work.
> >=20
> > Yep.
> >=20
> > > 3) With additional support of sgx_fadvice(WILLNEED) within the driver=
, the new
> > > app can use madvice(WILLNEED) if it passes the correct pgoff when mma=
p().  If
> > > wrong pgoff is passed, then madvice(WILLNEED) will work unexpectedly =
and could
> > > result in enclave being killed.  It's userspace app's responsibility =
to make
> > > sure the correctness, not the driver's.
> >=20
> > Hmm, yeah, it's probably ok to lean on documentation if userspace screw=
s up.  I
> > generally prefer explicit errors over "undefined behavior", but I don't=
 have a
> > super strong opinion, especially since this isn't my area these days :-=
)=20
>=20
> My argument is for normal file operations, if you use madvice(WILLNEED) b=
ut
> didn't mmap() with the correct pgoff, you will end up with kernel acting =
on the
> wrong portion of the file (which may not result in fatal error, but certa=
inly
> not the correct thing from userspace's perspective).
>=20
> So kernel doesn't guarantee anything here, but depends on userspace to do=
 things
> correctly.

Fair enough.

> > > 4) Old SGX apps which don't use file-based ABIs and still pass 0 pgof=
f should
> > > continue to work.  No break of old apps either.
> >=20
> > Yep.
> > =20
> > > 5) We encourage new apps to always pass the correct pgoff instead of =
passing 0.
> > >=20
> > > 6) If needed, we can modify sgx_mmap() to relax the needing to use MA=
P_FIXED,
> > > but return the enclave's address "based on pgoff from userspace".
> >=20
> > As above, this isn't a relaxation of anything since MAP_FIXED isn't str=
ictly
> > required, it's simply additional functionality.
> >=20
> > > This effectively provides additional mmap() ABI for userspace while n=
ot
> > > breaking the existing MAP_FIXED ABI.
> >=20
> > I don't think you want to do this.  The MAP_FIXED case won't be affecte=
d, but the
> > address provided to mmap() is also used as a hint in the !MAP_FIXED cas=
e,, i.e.
> > MAP_FIXED just means use *exactly* this address and don't try anything =
else.  It's
> > unlikely, but not _that_ unlikely, that there are userspace application=
s that
> > specify the exact address without MAP_FIXED and without the correct pgo=
ff.
