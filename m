Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C185EC25B06
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Aug 2022 19:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiHNTlo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Aug 2022 15:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiHNTln (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 14 Aug 2022 15:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4A81C93F
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 12:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FBF6B80B52
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 19:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1723C433D6;
        Sun, 14 Aug 2022 19:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660506100;
        bh=X3kSFUtT0JyEQKyKwKCrl/jQHO1hUrq85glB7sV7MXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LmRHthWNZDpP/kqUj23niEQ1UP4BBn1IDCzyEgcxK6QIAUQ6bsCGxiPGovNNwd/nT
         1sI45dxTath03RqaDChibI7p7shP3AwqStRjihWXlPWAns4YgnUnQU7uCwg9nw4EAk
         D5Pqmkk71AC/6QjBTflmXzsgjwBAOFp1vFG8ALfDumzoqpSKySGK7h6rdnwAncpOJ4
         +iUwJaKub+hRDIP7bwoUIBgSgkKpGBJRjX8PLlBQafUZhuL6HdfQttyWxdWI26cIdq
         MZTR0cQDWTREqLpDOtGVcCPQD8f1x/kMtfaylm/2kRw93Kl9MOtfhDMRNvQL+8us9R
         XPZFhK1Uwn/ig==
Date:   Sun, 14 Aug 2022 22:41:37 +0300
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on
 PF.
Message-ID: <YvlP8fOWWmGdZQGy@kernel.org>
References: <20220812191224.15561-1-haitao.huang@linux.intel.com>
 <DM8PR11MB559143ADF2DD1A8053641F5AF6679@DM8PR11MB5591.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB559143ADF2DD1A8053641F5AF6679@DM8PR11MB5591.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 12, 2022 at 10:41:30PM +0000, Dhanraj, Vijay wrote:
> Hi Haitao,
> 
> > -----Original Message-----
> > From: Haitao Huang <haitao.huang@linux.intel.com>
> > Sent: Friday, August 12, 2022 12:12 PM
> > To: linux-sgx@vger.kernel.org; jarkko@kernel.org; Chatre, Reinette
> > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Dhanraj, Vijay
> > <vijay.dhanraj@intel.com>
> > Subject: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on PF.
> > 
> > Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.
> > 
> > link: https://lore.kernel.org/all/20220804201456.33418-1-
> > vijay.dhanraj@intel.com/
> > 
> > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > 
> >  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 24c1bb8eb196..1f88f80c4477 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct
> > vm_area_struct *vma,
> >  	}
> > 
> >  	va_page = sgx_encl_grow(encl, false);
> > -	if (IS_ERR(va_page))
> > -		goto err_out_epc;
> > +	if (IS_ERR(va_page)) {
> > +        if (PTR_ERR(va_page) == -EBUSY)
> > +            vmret =  VM_FAULT_NOPAGE;
> > +        goto err_out_epc;
> > +    }
> > 
> >  	if (va_page)
> >  		list_add(&va_page->list, &encl->va_pages);
> > --
> > 2.25.1
> 
> After applying this patch, I don't see the allocation failure issue with `augment_via_eaccept_long` test case. Ran the test for about ~60 times and all the time it passes.
> Tested-by: Vijay Dhanraj <vijay.dhanraj@intel.com>

Good to hear. Thank you.

BR, Jarkko
