Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7069AC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 23 May 2022 06:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiEWGMj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 23 May 2022 02:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiEWGMI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 23 May 2022 02:12:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5007F21B8
        for <linux-sgx@vger.kernel.org>; Sun, 22 May 2022 23:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653286326; x=1684822326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GGpX0oqzsJ/4nCDOtpsaQMR79WXzyJF+1bWqKXkqJY4=;
  b=EXrDl2Dt+feTI5v3dxAlKdm5l4KbtK1w2wNA//yZzHI00TZXVLRy54zz
   zq79924V2MYDUp61BpnHwas2wXjNUYs1KuLUV3xiR2imRYgDFrnHB6hhA
   64Hxk+eAqr2n/Y6NvsRxgpms/Hxo81eMwEa6GspIyJ8XL+rCPOD0ZV1qA
   2hlxXLXKGWnuwQGmowaasCl2M/QH1QxF/u7EAbqoiA993NO5Xatk/mdo8
   iZEOTQbUL23d8kfAGGRLNWvVXZ1svfsHz7vTN1dqc6d6bOlUSSQBpQ2Rc
   qvTLcITiyxhax0M8Z2wIMOaRRFRSlTXPVazXE9IwmLzUlm7y48cwRS1In
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="255179718"
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="255179718"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 23:09:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,245,1647327600"; 
   d="scan'208";a="525760726"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 22 May 2022 23:09:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 22 May 2022 23:09:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 22 May 2022 23:09:56 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2308.027;
 Sun, 22 May 2022 23:09:55 -0700
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
Thread-Index: AQHYbDYc7DP0xy83NEGDq57ZvnPRxa0ol6cAgAL9yqCAAGe+wA==
Date:   Mon, 23 May 2022 06:09:55 +0000
Message-ID: <eb95b32ecf3d44a695610cf7f2816785@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
 <20220520103904.1216-4-cathy.zhang@intel.com> <Yofnzg76OyCiHZwk@iki.fi>
 <aef784a1162e40e4a2f395ab3c52a55c@intel.com>
In-Reply-To: <aef784a1162e40e4a2f395ab3c52a55c@intel.com>
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
> From: Zhang, Cathy
> Sent: Monday, May 23, 2022 8:07 AM
> To: 'Jarkko Sakkinen' <jarkko@kernel.org>; Li, Zhiquan1
> <zhiquan1.li@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>; chao.p.peng@linux.intel.com; Zhong, Yang
> <yang.zhong@intel.com>
> Subject: RE: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest pag=
e
> type
>=20
> Hi Jarkko,
>=20
> > -----Original Message-----
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > Sent: Saturday, May 21, 2022 3:11 AM
> > To: Zhang, Cathy <cathy.zhang@intel.com>; Li, Zhiquan1
> > <zhiquan1.li@intel.com>
> > Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>;
> > Raj, Ashok <ashok.raj@intel.com>; chao.p.peng@linux.intel.com; Zhong,
> > Yang <yang.zhong@intel.com>
> > Subject: Re: [PATCH v5 3/9] x86/sgx: Keep record for SGX VA and Guest
> > page type
> >
> > On Fri, May 20, 2022 at 06:38:58PM +0800, Cathy Zhang wrote:
> > > Regular enclave EPC pages have sgx_encl_page as their owner, but SGX
> > > VA page and KVM guest EPC page are maintained by different owner
> > > structures.
> > >
> > > SGX CPUSVN update requires to know the EPC page owner's status and
> > > then decide how to handle the page.
> > >
> > > Keep a record of page type for SGX VA and KVM guest page while the
> > > other EPC pages already have their type tracked, so that CPUSVN
> > > update can get EPC page's owner by type and handle it then.
> > >
> > > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > >
> > > ---
> > > Changes since v3:
> > >  - Rename SGX_EPC_PAGE_GUEST as SGX_EPC_PAGE_KVM_GUEST.
> > (Suggested by
> > >    Jarkko, Sakkinen)
> > > ---
> > >  arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
> > > arch/x86/kernel/cpu/sgx/encl.c | 2 ++
> > > arch/x86/kernel/cpu/sgx/virt.c
> > > | 2 ++
> > >  3 files changed, 8 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
> > > b/arch/x86/kernel/cpu/sgx/sgx.h index f8ed9deac18b..4ad0e5396eef
> > > 100644
> > > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > > @@ -28,6 +28,10 @@
> > >
> > >  /* Pages on free list */
> > >  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
> > > +/* VA page */
> > > +#define SGX_EPC_PAGE_VA			BIT(2)
> > > +/* Pages allocated for KVM guest */
> > > +#define SGX_EPC_PAGE_KVM_GUEST		BIT(3)
> > >
> > >  struct sgx_epc_page {
> > >  	unsigned int section;
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> > > b/arch/x86/kernel/cpu/sgx/encl.c index 08f39fa03a39..383abd538ac9
> > > 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > > @@ -912,6 +912,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct
> > sgx_va_page *va_page)
> > >  		return ERR_PTR(-EFAULT);
> > >  	}
> > >
> > > +	epc_page->flags |=3D SGX_EPC_PAGE_VA;
> > > +
> > >  	return epc_page;
> > >  }
> > >
> > > diff --git a/arch/x86/kernel/cpu/sgx/virt.c
> > > b/arch/x86/kernel/cpu/sgx/virt.c index e953816d7c8b..104487b72fb8
> > > 100644
> > > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > > @@ -50,6 +50,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> > >  	if (IS_ERR(epc_page))
> > >  		return PTR_ERR(epc_page);
> > >
> > > +	epc_page->flags |=3D SGX_EPC_PAGE_KVM_GUEST;
> >
> > This would need to be synced up with SGX_EPC_IS_VEPC:
> >
> > https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-
> > e52b4a61e1ec@intel.com/T/#t
> >
> > Otherwise, we have a chaos.
> >
> > Can you sync up with Zhiquan Li and find some common approach. IMHO,
> > it might even sense to merge these patch sets into one. Then it would
> > be easier to review them as a whole.
>=20
> Thanks for showing the above related patches, Jarkko! I just take a quick=
 look
> at that series, AFAIK, __sgx_vepc_fault() will only be called during VM b=
oot
> up to allocate physical EPC pages.
> Then, host does not know how VM works with those pages. VM SGX driver
> will handle any errors itself.
> So with the approach in that series, what it actually tracks is the vaddr=
 in
> QEMU address space for all EPC pages allocated to the VM. Does host need
> to track such information? QEMU side should provide it easily I think. @L=
i,
> Zhiquan1.
>=20

I've synced with Zhiquan Li and got the whole picture of his patch logic. I=
 suggest
to follow the way how we handle the same change between EDMM and Seamless,
that is Zhiquan Li will apply patch 3 from Seamless and then add his left p=
atches.
Please let's know if you have other suggestion. Thanks!

> >
> > BR, Jarkko
