Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A59C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jul 2022 23:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiGUX1I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Jul 2022 19:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiGUX1H (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Jul 2022 19:27:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E391CD3
        for <linux-sgx@vger.kernel.org>; Thu, 21 Jul 2022 16:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658446027; x=1689982027;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=++6XaqcEaGSb4AMUImkLmaZ6fhM3o9n2PgF3Q3z2DwI=;
  b=bLQMkY/f0Btt/uKeEbIr6KRIGZzLLueL1yvk7F+wP1Eg/unaNENMH8qU
   BwcMdVrgohC/pz8xx6MYYv6bEu9jQAF+kB/PBzqL54EckaNJY2ZPjc28v
   SBWnQUfnOf/YLFQQ/qY6IP80SSmRw93REobyBjSnUPaL/hrgFg6qZZ+re
   gN3R0ojSaSQ0DLzKSnXh3gIRiryInQBabaPZolEXzq8CSpJR74dbpbV+L
   giYgA2Qbr2XaxLtcaRA9u0YflUdnIFh8HnZ1eyzCJJA0+KHJOW7Nc+11C
   umZrmHffhpeQcU/Wzwso/TlBnd8YtHnNdF6X+K5gC15v96vvkk2sJ8VTf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="285955916"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="285955916"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 16:27:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="775051110"
Received: from refarabe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.165.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 16:27:04 -0700
Message-ID: <fa93057f417b1f630d8199381589c415a0ec710b.camel@intel.com>
Subject: Re: [PATCH v5 1/3] x86/sgx: Repurpose the owner field as the
 virtual address of virtual EPC page
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com
Date:   Fri, 22 Jul 2022 11:27:02 +1200
In-Reply-To: <111cc85d-0e49-ad45-84e9-1a71ce58a2ca@intel.com>
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
         <20220622093705.2891642-2-zhiquan1.li@intel.com>
         <111cc85d-0e49-ad45-84e9-1a71ce58a2ca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2022-07-21 at 09:42 -0700, Dave Hansen wrote:
> On 6/22/22 02:37, Zhiquan Li wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/v=
irt.c
> > index 6a77a14eee38..776ae5c1c032 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -46,10 +46,12 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
> >  	if (epc_page)
> >  		return 0;
> > =20
> > -	epc_page =3D sgx_alloc_epc_page(vepc, false);
> > +	epc_page =3D sgx_alloc_epc_page((void *)addr, false);
> >  	if (IS_ERR(epc_page))
> >  		return PTR_ERR(epc_page);
>=20
> Was the 'vepc' value simply unused before?

Yes for EPC page assigned to KVM guest it was unused before this series.

--=20
Thanks,
-Kai


