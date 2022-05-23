Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D63C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 23 May 2022 00:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiEWAGp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 22 May 2022 20:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiEWAGo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 22 May 2022 20:06:44 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A54E37A91
        for <linux-sgx@vger.kernel.org>; Sun, 22 May 2022 17:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653264403; x=1684800403;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6WtT4fd09KEdPjgMJva14LDw5Zj2Ga5PLFt2fGVlVp4=;
  b=O10CE+7VQhD2URHkXydwa0Z5GI5gQQ7BdTOEFmkt6zq3ZH0nNRQlrxwB
   DVkpu02h/9Cvte+vtkObfFxNN/sUUWfc6K622jR3iV30DDKbr74E5N/u4
   m5ajaM+ZNiEizyA7BmhGg1Fxg5OJUyNEqxhhd4l4cXLNNAvCVdGkbZDK9
   RF/xm9KxgOb8obBCRom2pKXpXD0F5Xn57P7grlLLrwfBgAoKaFL+9Svdk
   ZPDm8iV7Rcbzv1hlSx3QSlVa7ZZ9VKI1DrpkxDdzhAknwxIhkChA16NI9
   c0TIhlB9QSq9ZNX3OCNtxr/JFWHSW2BtRqaiIFIIfi7Uvn5Flpt8yAjk3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="270629843"
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="270629843"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 17:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="900280539"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2022 17:06:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 22 May 2022 17:06:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 22 May 2022 17:06:40 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2308.027;
 Sun, 22 May 2022 17:06:40 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest page
 type
Thread-Topic: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest page
 type
Thread-Index: AQHYbDYc7DP0xy83NEGDq57ZvnPRxa0ol6cAgAL9yqA=
Date:   Mon, 23 May 2022 00:06:40 +0000
Message-ID: <aef784a1162e40e4a2f395ab3c52a55c@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
 <20220520103904.1216-4-cathy.zhang@intel.com> <Yofnzg76OyCiHZwk@iki.fi>
In-Reply-To: <Yofnzg76OyCiHZwk@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: zhiquan1.li@intel.com
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
> Sent: Saturday, May 21, 2022 3:11 AM
> To: Zhang, Cathy <cathy.zhang@intel.com>; Li, Zhiquan1
> <zhiquan1.li@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>; chao.p.peng@linux.intel.com; Zhong, Yang
> <yang.zhong@intel.com>
> Subject: Re: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest pag=
e
> type
>=20
> On Fri, May 20, 2022 at 06:38:58PM +0800, Cathy Zhang wrote:
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
> >
> > ---
> > Changes since v3:
> >  - Rename SGX_EPC_PAGE_GUEST as SGX_EPC_PAGE_KVM_GUEST.
> (Suggested by
> >    Jarkko, Sakkinen)
> > ---
> >  arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
> > arch/x86/kernel/cpu/sgx/encl.c | 2 ++  arch/x86/kernel/cpu/sgx/virt.c
> > | 2 ++
> >  3 files changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
> > b/arch/x86/kernel/cpu/sgx/sgx.h index f8ed9deac18b..4ad0e5396eef
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
> > +#define SGX_EPC_PAGE_KVM_GUEST		BIT(3)
> >
> >  struct sgx_epc_page {
> >  	unsigned int section;
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > b/arch/x86/kernel/cpu/sgx/encl.c index 08f39fa03a39..383abd538ac9
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -912,6 +912,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct
> sgx_va_page *va_page)
> >  		return ERR_PTR(-EFAULT);
> >  	}
> >
> > +	epc_page->flags |=3D SGX_EPC_PAGE_VA;
> > +
> >  	return epc_page;
> >  }
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c
> > b/arch/x86/kernel/cpu/sgx/virt.c index e953816d7c8b..104487b72fb8
> > 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -50,6 +50,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> >  	if (IS_ERR(epc_page))
> >  		return PTR_ERR(epc_page);
> >
> > +	epc_page->flags |=3D SGX_EPC_PAGE_KVM_GUEST;
>=20
> This would need to be synced up with SGX_EPC_IS_VEPC:
>=20
> https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-
> e52b4a61e1ec@intel.com/T/#t
>=20
> Otherwise, we have a chaos.
>=20
> Can you sync up with Zhiquan Li and find some common approach. IMHO, it
> might even sense to merge these patch sets into one. Then it would be eas=
ier
> to review them as a whole.

Thanks for showing the above related patches, Jarkko! I just take a quick l=
ook at that series,
AFAIK, __sgx_vepc_fault() will only be called during VM boot up to allocate=
 physical EPC pages.
Then, host does not know how VM works with those pages. VM SGX driver will =
handle any errors itself.
So with the approach in that series, what it actually tracks is the vaddr i=
n QEMU address space
for all EPC pages allocated to the VM. Does host need to track such informa=
tion? QEMU side
should provide it easily I think. @Li, Zhiquan1.

>=20
> BR, Jarkko
