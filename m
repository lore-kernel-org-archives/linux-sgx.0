Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8104C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 13:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiDFOBW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 10:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiDFOBM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 10:01:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9742BF94A
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 20:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649215866; x=1680751866;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vzIavrpz1QTTqa8c+6oyTlAxFEOrbpcYsQp0iirvG4s=;
  b=HAUerawhBgZusVfH3nOJxXCfayk0GYjL6AL+/PGhSkgt4NNeB93Sc1FL
   /vY5Gi2W4Y/PpdrliXqarNWvHhjZ+YkdEcb2qg/nBvFRqz0lSfbtD7Xfw
   jwIjkBGsO2uztqA+A6SphZ6GqHLQpThbfhsCsuiQeTnRlvBypuQpA5nqc
   E7JWC9MoQ5+9B5bqx/8qsj0k0vMeKap6K8XqM5SNEdSKWn9GQYkHGbhnZ
   01v30NQuwwUprVRpfKmd4AB8RPLO5lXhANNsN3DaURLXiWR/jNFr59WxZ
   fiLvtyGGoJEcvcNoK/PHJUMrZy4SxCLhW65241xyo6rp/iVeTfiTutnsU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="324110676"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="324110676"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 20:31:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="524283886"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 05 Apr 2022 20:31:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 20:31:05 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 20:31:05 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Tue, 5 Apr 2022 20:31:05 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 01/10] x86/sgx: Introduce mechanism to prevent new
 initializations of EPC pages
Thread-Topic: [RFC PATCH v3 01/10] x86/sgx: Introduce mechanism to prevent new
 initializations of EPC pages
Thread-Index: AQHYRdQtwoC1J/OgH0eYX1UvG9FfjqzeTyWAgAPx+LA=
Date:   Wed, 6 Apr 2022 03:31:05 +0000
Message-ID: <9afc7a1b87cf42d9ac381c90f8ea7465@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-2-cathy.zhang@intel.com> <YklXNQfcaOcZE7GI@kernel.org>
In-Reply-To: <YklXNQfcaOcZE7GI@kernel.org>
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

Hi Jarkko,

> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Sunday, April 3, 2022 4:14 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>
> Subject: Re: [RFC PATCH v3 01/10] x86/sgx: Introduce mechanism to prevent
> new initializations of EPC pages
>=20
> On Fri, Apr 01, 2022 at 10:24:00PM +0800, Cathy Zhang wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/ioctl.c index b3c2e8d58142..00668e50848d
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -147,6 +147,7 @@ static int sgx_encl_create(struct sgx_encl *encl,
> > struct sgx_secs *secs)  static long sgx_ioc_enclave_create(struct
> > sgx_encl *encl, void __user *arg)  {
> >  	struct sgx_enclave_create create_arg;
> > +	int srcu_idx;
> >  	void *secs;
> >  	int ret;
> >
> > @@ -162,9 +163,20 @@ static long sgx_ioc_enclave_create(struct
> > sgx_encl *encl, void __user *arg)
> >
> >  	if (copy_from_user(secs, (void __user *)create_arg.src, PAGE_SIZE))
> >  		ret =3D -EFAULT;
> > -	else
> > +	else {
> > +		srcu_idx =3D srcu_read_lock(&sgx_lock_epc_srcu);
> > +		if (sgx_epc_is_locked()) {
> > +			srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
> > +			ret =3D -EBUSY;
> > +			goto out;
> > +		}
> > +
> >  		ret =3D sgx_encl_create(encl, secs);
> >
> > +		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
> > +	}
> > +
> > +out:
>=20
> Nit: I'd rename this as 'err:'.

Renamed as 'err'.

>=20
> >  	kfree(secs);
> >  	return ret;
> >  }
>=20
> Please, take advantage of the label you created anyway:
>=20
>   	if (copy_from_user(secs, (void __user *)create_arg.src, PAGE_SIZE {
>   		ret =3D -EFAULT;
>                 goto out;
>         }
>=20
> Then fail cases have the exact same rollback procedure, and the code is
> easier to read because it is less nested.

Update is done. The error branches in this function will all "goto err".

>=20
> BR, Jarkko
>=20
