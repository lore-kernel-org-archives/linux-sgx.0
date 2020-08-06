Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B28CC433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 16:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49632311A
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 16:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zVMa+o90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgHFQhK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:37:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53380 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgHFQgI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 12:36:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076DcHBf063097;
        Thu, 6 Aug 2020 13:40:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ieWOgI6ySdEYzx1kCy7LgrSuPa0O7ecWMZIAZnekG+0=;
 b=zVMa+o90tPJUCb7TozNXtUqu/jh/K9ctLffSDQGLuKbSWqTF5wkdCRq2cVrGSDoYF3f0
 jbE2uqqNO2x18E/K+wlSXcrKX/R3z+TsnPklVnVQ1ukWBWf6qi51IfvyOPiBvEHueDdv
 SnzZLSTiKhZP80mA6NuRhDmVCBuomEXLnES2CigTB5UHlo6pASgtmSDqfhYFPmEM4C6f
 YSNiMFejuYL8gtTknc1ZFrFPdQ6R99VQ7i5BuXnhf/DtMzxsFk+7C84mvgPcdgi4+pqm
 Grhf/HTgkrHo2KvGygYGSPPOOfjdrQzWHB0PpaLHyOBvdr0aOJePrMGUCUplB6u8Wp24 dQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32r6fxjydv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:40:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076DdEY3167174;
        Thu, 6 Aug 2020 13:40:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32p5gvecxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:40:38 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076DeZRq002339;
        Thu, 6 Aug 2020 13:40:35 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:40:35 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id F0C22F05212; Thu,  6 Aug 2020 14:35:17 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 10/24] mm: Add vm_ops->mprotect()
In-Reply-To: <20200716135303.276442-11-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-11-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:35:17 +0100
Message-ID: <m2mu37rj6y.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=1 spamscore=0 clxscore=1011 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060096
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:49 +03, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add vm_ops()->mprotect() for additional constraints for a VMA.
>
> Intel Software Guard eXtensions (SGX) will use this callback to add two
> constraints:
>
> 1. Verify that the address range does not have holes: each page address
>    must be filled with an enclave page.
> 2. Verify that VMA permissions won't surpass the permissions of any enclave
>    page within the address range. Enclave cryptographically sealed
>    permissions for each page address that set the upper limit for possible
>    VMA permissions. Not respecting this can cause #GP's to be emitted.
>
> Cc: linux-mm@kvack.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  include/linux/mm.h | 3 +++
>  mm/mprotect.c      | 5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dc7b87310c10..458e8cb99aaf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -542,6 +542,9 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	int (*mprotect)(struct vm_area_struct *vma,
> +			struct vm_area_struct **pprev, unsigned long start,
> +			unsigned long end, unsigned long newflags);
>  	vm_fault_t (*fault)(struct vm_fault *vmf);
>  	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>  			enum page_entry_size pe_size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ce8b8a5eacbb..f170f3da8a4f 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -610,7 +610,10 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> -		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> +		if (vma->vm_ops && vma->vm_ops->mprotect)
> +			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp, newflags);
> +		else
> +			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
>  		if (error)
>  			goto out;
>  		nstart = tmp;
> -- 
> 2.25.1
