Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CC7C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 10:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbiDFKFW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347354AbiDFKEg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 06:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B966810E571
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 23:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 566C961976
        for <linux-sgx@vger.kernel.org>; Wed,  6 Apr 2022 06:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDCBC385A1;
        Wed,  6 Apr 2022 06:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649226721;
        bh=rZbfOOpnr6limn4uthGXZzoP7HK2oNPH5gZFH8R8WxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TNltRVHBRZCWNg7j5X3Ws8SONqt5cfQRrobMUcxWesPNu2T7rFAUoOOapkOvRzWVt
         AmWpT0/6gKC9VsuEtFVvwqPkltaNSUvwZVTn5cyHxnJcFro9HD6D8O15iVt0NiZIxF
         nfKYP5wxUcNHO/W2JeDfQPLim77LvbSVfOX0MTkgMnYMPh/M9e2ryrDW5s1AB+YWM6
         w86W77Ijie3pGaPvGA2+yYGo2Qea6e+4Enw29VbXxlnhLMHpoIuI0icja1gnsSkMIP
         e+pc75A80VqPbF4C2YLCyRCo07FlQF8wulpxma//nfo1L5ZMDoV6zQQQ0Ic6+fWuiF
         jDp8iT93r7OLg==
Message-ID: <e16bfc917ac85da8e2cb3bc131970207246975ce.camel@kernel.org>
Subject: Re: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Zhang, Cathy" <cathy.zhang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Date:   Wed, 06 Apr 2022 09:33:11 +0300
In-Reply-To: <62c5636814144fcdb61bb87f341232a0@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
         <20220401142409.26215-4-cathy.zhang@intel.com>
         <YklyFJpzsC+7zC5L@kernel.org> <62c5636814144fcdb61bb87f341232a0@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2022-04-06 at 03:31 +0000, Zhang, Cathy wrote:
>=20
>=20
> > -----Original Message-----
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > Sent: Sunday, April 3, 2022 6:08 PM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> > Ashok <ashok.raj@intel.com>
> > Subject: Re: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA =
page
> >=20
> > On Fri, Apr 01, 2022 at 10:24:02PM +0800, Cathy Zhang wrote:
> > > Tearing down all enclaves is required by SGX SVN update, which
> > > involves running the ENCLS[EREMOVE] instruction on every EPC page.
> > > This (tearing down all enclaves) should be coordinated with any
> > > enclaves that may be in the process of existing and thus already be
> > > running ENCLS[EREMOVE] as part of enclave release.
> > >=20
> > > In support of this coordination, it is required to know which enclave
> > > owns each in-use EPC page. It is already possible to locate the ownin=
g
> > > enclave of SECS and regular pages but not for VA pages.
> > >=20
> > > Save the enclave pointer for each VA page to support locating its
> > > owning enclave.
> > >=20
> > > Note: to track 2T EPC memory, this scheme of tracking will use
> > > additional 8M memory.
> > >=20
> > > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > > ---
> > > =C2=A0arch/x86/kernel/cpu/sgx/encl.h=C2=A0 | 1 +
> > > arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
> > > =C2=A02 files changed, 2 insertions(+)
> > >=20
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.h
> > > b/arch/x86/kernel/cpu/sgx/encl.h index 0c8571fc30cf..59fbd4ed5c64
> > > 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.h
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.h
> > > @@ -76,6 +76,7 @@ struct sgx_va_page {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sgx_epc_page *=
epc_page;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DECLARE_BITMAP(slots,=
 SGX_VA_SLOT_COUNT);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct list_head list=
;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sgx_encl *encl;
> > > =C2=A0};
> > >=20
> > > =C2=A0struct sgx_backing {
> > > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > > b/arch/x86/kernel/cpu/sgx/ioctl.c index f0ce96bd462a..da82abbb81b4
> > > 100644
> > > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > @@ -30,6 +30,7 @@ static struct sgx_va_page *sgx_encl_grow(struct
> > sgx_encl *encl)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!va_page)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
return ERR_PTR(-ENOMEM);
> > >=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0va_page->encl =3D encl;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0va_page->epc_page =3D sgx_alloc_va_page(va_page)=
;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0if (IS_ERR(va_page->epc_page)) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
err =3D ERR_CAST(va_page->epc_page);
> > > --
> > > 2.17.1
> > >=20
> >=20
> > Squash this with the previous patch. Then the code will provide
> > answer to one of the questions that I mentioned in 2/10 review.
> >=20
> > BR, Jarkko
>=20
> Squashed. How about re-write the commit log as follows:
>=20
> x86/sgx: Save enclave pointer for VA page
>=20
> Tearing down all enclaves is required by SGX SVN update, which
> involves running the ENCLS[EREMOVE] instruction on every EPC
> page. This (tearing down all enclaves) should be coordinated
> with any enclaves that may be in the process of existing and thus
> already be running ENCLS[EREMOVE] as part of enclave release.
>=20
> In support of this coordination, it is required to know which enclave
> owns each in-use EPC page. It is already possible to locate the
> owning enclave of SECS and regular pages but not for VA pages.
>=20
> Make the following changes for VA page's location:
> 1) Make epc->owner type-agnostic by change its type to 'void *'. So,
> =C2=A0=C2=A0 besides "struct sgx_encl_page", it can have other types, lik=
e
> =C2=A0=C2=A0 "struct sgx_va_page".
> 2) Save the enclave pointer for each VA page to support locating its
> =C2=A0=C2=A0 owning enclave.
>=20
> Note: to track 2T EPC memory, this scheme of tracking will use
> additional 8M memory.

Sounds good to me.

BR, Jarkko
