Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE44BC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 14:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbiDFPAJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiDFO77 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 10:59:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BB62228DC
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 21:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649217633; x=1680753633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rNt2XA/wxasTgEVrMgnjZ654gjqewZXAUADEdigxKPs=;
  b=SgH+N09cbKzJ2ZE2I7gWLc3DXGPNjvKa9bLPOTcq5W/Xf/4t1vwH0XcN
   C5ioSePTHJ3RZI0XLVDDw14h0RAUXnvjQd3FbnO+LLwUfOy4e1a6T+yCD
   X1d9sjkG1s18Wa8BXbnbI8cH9yD76pwuGwxvDVTQLCx4DmytHkgeXEy40
   6N5WDO7ShfZJczfJf+wGTRn3wBs2U4SXQXXObnApcXt8gjalKF2m+hLGe
   bUR9tUDcx0rIwDQka++gwRC88mc6UiuJCeaacO8Jpx0tCcEdw7spScowO
   ZhKoP04h3KqT9WmCNmC1tdBrQo4910fnFmDi5/s/4QmC+tNynV0yNT2XN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="259776794"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="259776794"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:00:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="722344574"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 05 Apr 2022 21:00:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 21:00:30 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 21:00:30 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Tue, 5 Apr 2022 21:00:30 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC section
Thread-Topic: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC section
Thread-Index: AQHYRdQ0Cz1wZVtWA0SDJRhdLrV65qzecQUAgAPYLcA=
Date:   Wed, 6 Apr 2022 04:00:29 +0000
Message-ID: <77a9e893ffe54dca9685b97cdf79b078@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-6-cathy.zhang@intel.com> <YklzoObeCWk1AX5L@kernel.org>
In-Reply-To: <YklzoObeCWk1AX5L@kernel.org>
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
> Sent: Sunday, April 3, 2022 6:15 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>
> Subject: Re: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC sect=
ion
>=20
> On Fri, Apr 01, 2022 at 10:24:04PM +0800, Cathy Zhang wrote:
> > For SGX CPUSVN update process will check all EPC pages in each section
> > to ensure they will be marked as unused, it requires to know the size
> > of each EPC section to end the loop.
>=20
> Why is the size required to end the loop? It's missing.

How about re-write as follows:

SGX CPUSVN update process should check all EPC pages to ensure they
will be marked as unused. For EPC pages are stored in EPC sections,
it's required to save the size of each section, as the indicator for
the end of each section's traversing.

>=20
> > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/sgx.h  | 1 +
> >  arch/x86/kernel/cpu/sgx/main.c | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
> > b/arch/x86/kernel/cpu/sgx/sgx.h index 0b036f19cca1..45ba6fcabfda
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -63,6 +63,7 @@ struct sgx_epc_section {
> >  	void *virt_addr;
> >  	struct sgx_epc_page *pages;
> >  	struct sgx_numa_node *node;
> > +	u64 size;
> >  };
> >
> >  extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c
> > b/arch/x86/kernel/cpu/sgx/main.c index 10360f06c0df..031c1402cd7e
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -665,6 +665,7 @@ static bool __init sgx_setup_epc_section(u64
> phys_addr, u64 size,
> >  	}
> >
> >  	section->phys_addr =3D phys_addr;
> > +	section->size =3D size;
> >  	xa_store_range(&sgx_epc_address_space, section->phys_addr,
> >  		       phys_addr + size - 1, section, GFP_KERNEL);
> >
> > --
> > 2.17.1
> >
>=20
> BR, Jarkko
