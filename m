Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD6CC433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 24 Apr 2022 02:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbiDXCeO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Apr 2022 22:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237712AbiDXCeM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 23 Apr 2022 22:34:12 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75D625294
        for <linux-sgx@vger.kernel.org>; Sat, 23 Apr 2022 19:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650767473; x=1682303473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K4C1gKWRmf1ph4HHJCwVzv58V97Yq284iI95fugcpXk=;
  b=lKzYhDRR2uVD5VxAjqsSzeMJkduP/3dpRM4+5ceKdvgmx2gqkjwJwwgu
   zS68ifLyG8I0ZbUrrWhi3gtZd4DOnqO9xM5oT18rCyYWq4WikRDy1v30X
   7BB9jdq0SCKCumOOTHnGnf+mABJJpGXTBAxK7UqH64PoCA5XOaPdNc7Q7
   MhBAnI3iqBjpeGOavGIL6DT0E0ruX0VWkFCz/3rJ6lVs35XAjXr1blKSF
   WPIDEsSEoXS/dA6+5wzsH94PVTbwZLmghzqoUze7PKt904yYG/mLqN36G
   i7jsRPNuWUQzkhyPCL5nwJsnI2W3JODimKQ/po6K3rRC1S6krc1rdmKZX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264479049"
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="264479049"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 19:31:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="578619383"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 23 Apr 2022 19:31:13 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sat, 23 Apr 2022 19:31:12 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Sat, 23 Apr 2022 19:31:12 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v4 2/9] x86/sgx: Save enclave pointer for VA page
Thread-Topic: [PATCH v4 2/9] x86/sgx: Save enclave pointer for VA page
Thread-Index: AQHYVW+P+QvGsLG+xkex9CVEeMX/E6z6/V0AgANeVEA=
Date:   Sun, 24 Apr 2022 02:31:12 +0000
Message-ID: <5f05bfb3613841a2bf2d0fc99999e5e1@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
 <20220421110326.856-3-cathy.zhang@intel.com> <YmGAfiiog/NRHIvq@kernel.org>
In-Reply-To: <YmGAfiiog/NRHIvq@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Friday, April 22, 2022 12:04 AM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>; Peng, Chao P <chao.p.peng@intel.com>;
> Zhong, Yang <yang.zhong@intel.com>
> Subject: Re: [PATCH v4 2/9] x86/sgx: Save enclave pointer for VA page
>=20
> On Thu, Apr 21, 2022 at 07:03:19PM +0800, Cathy Zhang wrote:
> > Tearing down all enclaves is required by SGX SVN update, which
> > involves running the ENCLS[EREMOVE] instruction on every EPC page.
> > This (tearing down all enclaves) should be coordinated with any
> > enclaves that may be in the process of existing and thus already be
> > running ENCLS[EREMOVE] as part of enclave release.
> >
> > In support of this coordination, it is required to know which enclave
> > owns each in-use EPC page. It is already possible to locate the owning
> > enclave of SECS and regular pages but not for VA pages.
> >
> > Make the following changes for VA pages' location:
> > 1) Make epc->owner type-agnostic by changing its type to 'void *'. So,
> >    besides "struct sgx_encl_page", it can have other types, like
> >    "struct sgx_va_page".
> > 2) Save the enclave pointer for each VA page to support locating its
> >    owning enclave.
> >
> > Note: to track 2T EPC memory, this scheme of tracking will use
> > additional 8M memory.
> >
> > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> >
> > ---
> > Changes since v3:
> >  - Squash patch "x86/sgx: Provide VA page non-NULL owner" and
> >    "x86/sgx: Save enclave pointer for VA page". Update commit log.
> >    (Suggested by Jarkko Sakkinen)
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.h  | 4 ++--
> >  arch/x86/kernel/cpu/sgx/sgx.h   | 2 +-
> >  arch/x86/kernel/cpu/sgx/encl.c  | 5 +++--
> > arch/x86/kernel/cpu/sgx/ioctl.c | 3 ++-
> >  4 files changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.h
> > b/arch/x86/kernel/cpu/sgx/encl.h index 7cdc351bc273..59fbd4ed5c64
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.h
> > +++ b/arch/x86/kernel/cpu/sgx/encl.h
> > @@ -76,6 +76,7 @@ struct sgx_va_page {
> >  	struct sgx_epc_page *epc_page;
> >  	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
> >  	struct list_head list;
> > +	struct sgx_encl *encl;
> >  };
> >
> >  struct sgx_backing {
> > @@ -112,8 +113,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl,
> > unsigned long page_index,  void sgx_encl_put_backing(struct
> > sgx_backing *backing, bool do_write);  int
> sgx_encl_test_and_clear_young(struct mm_struct *mm,
> >  				  struct sgx_encl_page *page);
> > -
>=20
> This line removal is not related to the patch.

Yes, added back.

>=20
> > -struct sgx_epc_page *sgx_alloc_va_page(void);
> > +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page);
> >  unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);  void
> > sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
> > bool sgx_va_page_full(struct sgx_va_page *va_page); diff --git
> > a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h index
> > d7a1490d90bb..f8ed9deac18b 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -33,7 +33,7 @@ struct sgx_epc_page {
> >  	unsigned int section;
> >  	u16 flags;
> >  	u16 poison;
> > -	struct sgx_encl_page *owner;
> > +	void *owner;
> >  	struct list_head list;
> >  };
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > b/arch/x86/kernel/cpu/sgx/encl.c index 68c8d65a8dee..c0725111cc25
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -753,6 +753,7 @@ int sgx_encl_test_and_clear_young(struct
> mm_struct
> > *mm,
> >
> >  /**
> >   * sgx_alloc_va_page() - Allocate a Version Array (VA) page
> > + * @va_page:	struct sgx_va_page connected to this VA page
> >   *
> >   * Allocate a free EPC page and convert it to a Version Array (VA) pag=
e.
> >   *
> > @@ -760,12 +761,12 @@ int sgx_encl_test_and_clear_young(struct
> mm_struct *mm,
> >   *   a VA page,
> >   *   -errno otherwise
> >   */
> > -struct sgx_epc_page *sgx_alloc_va_page(void)
> > +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page)
> >  {
> >  	struct sgx_epc_page *epc_page;
> >  	int ret;
> >
> > -	epc_page =3D sgx_alloc_epc_page(NULL, true);
> > +	epc_page =3D sgx_alloc_epc_page(va_page, true);
> >  	if (IS_ERR(epc_page))
> >  		return ERR_CAST(epc_page);
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/ioctl.c index a4df72f715d7..b77343eb2d49
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -30,7 +30,8 @@ static struct sgx_va_page *sgx_encl_grow(struct
> sgx_encl *encl)
> >  		if (!va_page)
> >  			return ERR_PTR(-ENOMEM);
> >
> > -		va_page->epc_page =3D sgx_alloc_va_page();
> > +		va_page->encl =3D encl;
> > +		va_page->epc_page =3D sgx_alloc_va_page(va_page);
> >  		if (IS_ERR(va_page->epc_page)) {
> >  			err =3D ERR_CAST(va_page->epc_page);
> >  			kfree(va_page);
> > --
> > 2.17.1
> >
>=20
> BR, Jarkko
