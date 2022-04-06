Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EE0C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 12:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiDFMSR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiDFMRR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 08:17:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E246C8B8
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 20:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649215911; x=1680751911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0M3ComKKio1gQzDVsl72uxbrLXg1lUGDhwc7CEM8U90=;
  b=YLe4JP3ylzUYyR9Wa1g/sREcnQAc//kRpxqk7EBM33ZPf3u7mNhBcSGY
   L3VbkbM7P1WLqJZ3S1uYcfdI/wGRiVdkOQ0d1hZAapgHzxKJCcuU3XBXu
   wU6iSWXNw+OT1sWmamwCQzLC9yl9JNhFPzfsApc7VnVE+POajE3Lm3H04
   yFx99vSZIc9BJ5iGkix/rf1XWqC6We+M8wa/kvMyrq8hcYF5VoesKtasl
   5+ieXYPF3AVPoVZpbJD1ahxK0/MpOJGr9+ctstCF+MMa/vvv8HH4OHl+y
   HBKd3LxLawgrFKyrr8w898YtZH411n6vCmUC05qfNnYoja+HCr9wuuPog
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="260932532"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="260932532"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 20:31:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="570316166"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2022 20:31:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 20:31:18 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 20:31:18 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Tue, 5 Apr 2022 20:31:18 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA page
Thread-Topic: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA page
Thread-Index: AQHYRdQwyyvkN2qPdUShSuzF7pbIG6zeby0AgAPRwSA=
Date:   Wed, 6 Apr 2022 03:31:18 +0000
Message-ID: <62c5636814144fcdb61bb87f341232a0@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-4-cathy.zhang@intel.com> <YklyFJpzsC+7zC5L@kernel.org>
In-Reply-To: <YklyFJpzsC+7zC5L@kernel.org>
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
> Sent: Sunday, April 3, 2022 6:08 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>
> Subject: Re: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA pa=
ge
>=20
> On Fri, Apr 01, 2022 at 10:24:02PM +0800, Cathy Zhang wrote:
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
> > Save the enclave pointer for each VA page to support locating its
> > owning enclave.
> >
> > Note: to track 2T EPC memory, this scheme of tracking will use
> > additional 8M memory.
> >
> > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.h  | 1 +
> > arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.h
> > b/arch/x86/kernel/cpu/sgx/encl.h index 0c8571fc30cf..59fbd4ed5c64
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
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/ioctl.c index f0ce96bd462a..da82abbb81b4
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -30,6 +30,7 @@ static struct sgx_va_page *sgx_encl_grow(struct
> sgx_encl *encl)
> >  		if (!va_page)
> >  			return ERR_PTR(-ENOMEM);
> >
> > +		va_page->encl =3D encl;
> >  		va_page->epc_page =3D sgx_alloc_va_page(va_page);
> >  		if (IS_ERR(va_page->epc_page)) {
> >  			err =3D ERR_CAST(va_page->epc_page);
> > --
> > 2.17.1
> >
>=20
> Squash this with the previous patch. Then the code will provide
> answer to one of the questions that I mentioned in 2/10 review.
>=20
> BR, Jarkko

Squashed. How about re-write the commit log as follows:

x86/sgx: Save enclave pointer for VA page

Tearing down all enclaves is required by SGX SVN update, which
involves running the ENCLS[EREMOVE] instruction on every EPC
page. This (tearing down all enclaves) should be coordinated
with any enclaves that may be in the process of existing and thus
already be running ENCLS[EREMOVE] as part of enclave release.

In support of this coordination, it is required to know which enclave
owns each in-use EPC page. It is already possible to locate the
owning enclave of SECS and regular pages but not for VA pages.

Make the following changes for VA page's location:
1) Make epc->owner type-agnostic by change its type to 'void *'. So,
   besides "struct sgx_encl_page", it can have other types, like
   "struct sgx_va_page".
2) Save the enclave pointer for each VA page to support locating its
   owning enclave.

Note: to track 2T EPC memory, this scheme of tracking will use
additional 8M memory.
