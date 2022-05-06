Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EB6C433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  6 May 2022 22:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344976AbiEFWLY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 May 2022 18:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241939AbiEFWLX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 6 May 2022 18:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80FE5DA7D
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 15:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 834AB616C5
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 22:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD0C385A8;
        Fri,  6 May 2022 22:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651874857;
        bh=NO9U4yY+CE6pSJTnPN9LBcz/PLpIHUObC1zF6bTOT+4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lZdTCvZdSX3K+WKgEl7IVIugtKjuQ6DKE5UKXiPVQ9ocGSzSBWY3th5h4Q6dn2rzy
         9V4pfirCKHt2xim6ncHTl/hehGnIFZJ3Gmkh6/kTL829Z3AgN1iuYTGERsjvLIKbgz
         8T3Zu/OHGRRoEAWzc3p71k295vmfRhfZhD/GAvaycuhSnvAbaZcN5WbpSYjkdKCJjo
         tjyslIH+fVakLrKFs03IM2wdEjOYWG/mEpN8Pi417c4tm5fFKBEYzfMbmTb1NavFZq
         DOB4hXp7whjFzl4j00h9lMZK9epC2w0MyyXYfGHbzrcA/CkWueYo8N/DokgrHfFKiB
         ImYLSI6kSl63g==
Message-ID: <1ba347a1923a2daca6e63054f40c3aae184694a2.camel@kernel.org>
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Date:   Sat, 07 May 2022 01:09:12 +0300
In-Reply-To: <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
         <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
         <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2022-04-28 at 14:30 -0700, Dave Hansen wrote:
> On 4/28/22 13:11, Reinette Chatre wrote:
> >=20
> > The backing storage is freed after running ENCLS[ELDU],
> > whether ENCLS[ELDU] succeeded or not. If ENCLS[ELDU]
> > thus failed then the data within that page is lost.
> >=20
> > Exit with error without removing the backing storage if
> > it could not be restored to the enclave.
> >=20
> > Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the e=
nclave page")
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> > =C2=A0arch/x86/kernel/cpu/sgx/encl.c | 4 ++++
> > =C2=A01 file changed, 4 insertions(+)
> >=20
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/e=
ncl.c
> > index 1a2cbe44b8d9..e5d2661800ac 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -81,6 +81,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *enc=
l_page,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
ENCLS_WARN(ret, "ELDU");
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D -EFAULT;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0kunmap_atomic(pcmd_page);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0kunmap_atomic((void *)(unsigned long)pginfo.contents);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0sgx_encl_put_backing(&b, false);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return ret;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memset(pcmd_page + b.pc=
md_offset, 0, sizeof(struct sgx_pcmd));
>=20
> Are there any transient, recoverable errors that can come back from
> ELDU?=C2=A0 If so, this makes a lot of sense.=C2=A0 If not, then it doesn=
't make a
> lot of sense to preserve the swapped-out content because they enclave is
> going to die anyway.

Nope, it's pretty much game over then.

BR, Jarkko
