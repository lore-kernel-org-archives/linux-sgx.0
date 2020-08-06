Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42FEC433E0
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 16:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1517D2311A
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 16:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w1o2nrIr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgHFQ4A (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:56:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbgHFQkn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 12:40:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076DIxiX008274;
        Thu, 6 Aug 2020 13:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=0cdeMqErhFa6q6fDiKHnaLTgfp6odn/HO4EcR6i6//E=;
 b=w1o2nrIrqNlbM23C0O6v/5acfayxFWey7Y+Bp761Ts9gBlfht3qWdAh3EXRJ+OIPrpk8
 DGa3R0ld6pZZdENBYAsvr7GBDkYyDJTAMB8+hyn/LmLbAiGckHRxQ8kXorIJSi2NBSU7
 bB5COLo3N+Ie826mHSMKeIJr5Y1ATm9z1Jd24eCGNCZl2E3+/5ts/ndhy4KLDmanarFQ
 zrHrXc/FLxK/7jc+1SKE91zJduX9qHd+nIrwOKHIZX+yozUEGr3KtbeCwm31hxVu2gug
 5gN1OJmDePWYurP9s2oNDj4jbiwxiJSe7hzZoW2B6B2F2IxDkdPtltebsWlWi3wWay7U eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32r6ep2wuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:29:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076DJMxR031400;
        Thu, 6 Aug 2020 13:29:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32qy8nch5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:29:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076DTetC007041;
        Thu, 6 Aug 2020 13:29:40 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:29:40 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id 85D17F04EE7; Thu,  6 Aug 2020 14:29:34 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 09/24] x86/sgx: Add __sgx_alloc_epc_page() and
 sgx_free_epc_page()
In-Reply-To: <20200716135303.276442-10-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-10-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:29:34 +0100
Message-ID: <m2pn83rjgh.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 bulkscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060095
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:48 +03, Jarkko Sakkinen wrote:
> Add __sgx_alloc_epc_page(), which iterates through EPC sections and borrows
> a page structure that is not used by anyone else. When a page is no longer
> needed it must be released with sgx_free_epc_page(). This function
> implicitly calls ENCLS[EREMOVE], which will return the page to the
> uninitialized state (i.e. not required from caller part).
>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  arch/x86/kernel/cpu/sgx/main.c | 62 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
>  2 files changed, 65 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c5831e3db14a..97c6895fb6c9 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -83,6 +83,68 @@ static bool __init sgx_page_reclaimer_init(void)
>  	return true;
>  }
>  
> +static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page;
> +
> +	if (list_empty(&section->page_list))
> +		return NULL;
> +
> +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> +	list_del_init(&page->list);
> +
> +	return page;
> +}
> +
> +/**
> + * __sgx_alloc_epc_page() - Allocate an EPC page
> + *
> + * Iterate through EPC sections and borrow a free EPC page to the caller. When a
> + * page is no longer needed it must be released with sgx_free_epc_page().
> + *
> + * Return:
> + *   an EPC page,
> + *   -errno on error
> + */
> +struct sgx_epc_page *__sgx_alloc_epc_page(void)
> +{
> +	struct sgx_epc_section *section;
> +	struct sgx_epc_page *page;
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_sections; i++) {
> +		section = &sgx_epc_sections[i];
> +		spin_lock(&section->lock);
> +		page = __sgx_alloc_epc_page_from_section(section);
> +		spin_unlock(&section->lock);
> +
> +		if (page)
> +			return page;
> +	}
> +
> +	return ERR_PTR(-ENOMEM);
> +}
> +
> +/**
> + * sgx_free_epc_page() - Free an EPC page
> + * @page:	an EPC page
> + *
> + * Call EREMOVE for an EPC page and insert it back to the list of free pages.
> + */
> +void sgx_free_epc_page(struct sgx_epc_page *page)
> +{
> +	struct sgx_epc_section *section = sgx_get_epc_section(page);
> +	int ret;
> +
> +	ret = __eremove(sgx_get_epc_addr(page));
> +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> +		return;
> +
> +	spin_lock(&section->lock);
> +	list_add_tail(&page->list, &section->page_list);
> +	spin_unlock(&section->lock);
> +}
> +
>  static void __init sgx_free_epc_section(struct sgx_epc_section *section)
>  {
>  	struct sgx_epc_page *page;
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index dff4f5f16d09..fce756c3434b 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -49,4 +49,7 @@ static inline void *sgx_get_epc_addr(struct sgx_epc_page *page)
>  	return section->va + (page->desc & PAGE_MASK) - section->pa;
>  }
>  
> +struct sgx_epc_page *__sgx_alloc_epc_page(void);
> +void sgx_free_epc_page(struct sgx_epc_page *page);
> +
>  #endif /* _X86_SGX_H */
> -- 
> 2.25.1
