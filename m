Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09B8C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 13:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiDFNdJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiDFNdB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 09:33:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAC220825D
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 20:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649216290; x=1680752290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sWgrM6TXcr1RCac9hLxXhbjxq3r/5GmzbINZCyUK5Bo=;
  b=lwd3gRhHYvhaksHmWfZJNHtER9de++4zbbRzdhq2RS/fF4h/An9Yfn8o
   fH36L/UnGstqW2mvpirya/8rR+SHKGL9HaYz6tTcV9sJUtq7vlx37TYQY
   bydd1g6TDBedajEqLsWNeq7cUD5t/BQntN8xqrPP216/wHIgPYlccjjqI
   rxvEP9uitX4PqpGRr+NXTWKi9Ldjjxk57E9EtevapddFzcNizBfa78cxW
   UqhP3IUDOcVwDiZwlvuxf6meSiwuWtHuOaO4b9TGQS0N0PgvnMWVuyHkc
   RuAog9Dwx+d+7r0rtMOd3IaEbcQ+/+stQ/3GrVABv2YJrOOu/l1C1po1j
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243080551"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="243080551"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 20:38:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="570318372"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2022 20:38:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 20:38:09 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 20:38:09 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Tue, 5 Apr 2022 20:38:09 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 04/10] x86/sgx: Keep record for SGX VA and Guest
 page type
Thread-Topic: [RFC PATCH v3 04/10] x86/sgx: Keep record for SGX VA and Guest
 page type
Thread-Index: AQHYRdQyLsUF9/QMuUG6Zjq+bLXe+qzeb/6AgAPTq1A=
Date:   Wed, 6 Apr 2022 03:38:08 +0000
Message-ID: <df92395ade424401ac3c6322de568720@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-5-cathy.zhang@intel.com> <Yklywz249ykoWL5U@kernel.org>
In-Reply-To: <Yklywz249ykoWL5U@kernel.org>
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
> Sent: Sunday, April 3, 2022 6:11 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>
> Subject: Re: [RFC PATCH v3 04/10] x86/sgx: Keep record for SGX VA and
> Guest page type
>=20
> On Fri, Apr 01, 2022 at 10:24:03PM +0800, Cathy Zhang wrote:
> > Regular enclave EPC pages have sgx_encl_page as their owner, but SGX
> > VA page and KVM guest EPC page are maintained by different owner
> > structures.
> >
> > SGX CPUSVN update requires to know the EPC page owner's status and
> > then decide how to handle the page.
> >
> > Keep a record of page type for SGX VA and KVM guest page while the
> > other EPC pages already have their type tracked, so that CPUSVN update
> > can get EPC page's owner by type and handle it then.
> >
> > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
> > arch/x86/kernel/cpu/sgx/encl.c | 2 ++  arch/x86/kernel/cpu/sgx/virt.c
> > | 2 ++
> >  3 files changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
> > b/arch/x86/kernel/cpu/sgx/sgx.h index f8ed9deac18b..0b036f19cca1
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -28,6 +28,10 @@
> >
> >  /* Pages on free list */
> >  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> > +/* VA page */
> > +#define SGX_EPC_PAGE_VA			BIT(2)
> > +/* Pages allocated for KVM guest */
> > +#define SGX_EPC_PAGE_GUEST		BIT(3)
>=20
> Please rename this as either SGX_EPC_PAGE_KVM_GUEST or
> SGX_EPC_PAGE_KVM.
> Then it is hard to not remember what it is.

Renamed as SGX_EPC_PAGE_KVM_GUEST.

>=20
> BR, Jarkko
