Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7414AC433DB
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 12:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F33D23A52
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 12:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbhANMNR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 Jan 2021 07:13:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52680 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbhANMNR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 14 Jan 2021 07:13:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10ECAAQp153199;
        Thu, 14 Jan 2021 12:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=w9+dNPCu+MdawUc3ua+vPpypVjNaP2LE91fqALsojHU=;
 b=v8l5N5tsQ8hxgO+7sQn0E+GP24QKWejwxI8DBKu4LnM+vDnsasBL8UOa+yGUUH8TRrzr
 l9rL6hhklVo+X+UN4zuoAoOblPbH3C7U5mB8Ldserk4gdTPBbtpbfdhVvn47TSc5sO+L
 1PUwN/F57ZZfTRZEezJpHa4rgy0F9dhnlHgNGwVx7krJcvHJ8zSSnZTj9Z59nlSQmBBa
 PAMRHI3vzrVPyTdl8Re1k20caNIxP0P6Qojdc0z436eVpjNE+uhkN/yoPQlVJWdmoYVE
 dXjDYUds6zb1aB9gCXxjX8ZTXift0E9Je5/oKDtKde6CC6Ir2OMG3y3kl0Yy+AXkeohQ ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg1yyv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 12:12:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EC6DQX078979;
        Thu, 14 Jan 2021 12:12:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 360kf24maa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 12:12:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10ECCEuM013458;
        Thu, 14 Jan 2021 12:12:15 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Jan 2021 04:12:14 -0800
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id A3F982DC3650; Thu, 14 Jan 2021 12:12:12 +0000 (GMT)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Sami Tolvanen <samitolvanen@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Kees Cook <keescook@chromium.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] x86/sgx: fix the return type of sgx_init
In-Reply-To: <20210113232311.277302-1-samitolvanen@google.com>
References: <20210113232311.277302-1-samitolvanen@google.com>
Date:   Thu, 14 Jan 2021 12:12:12 +0000
Message-ID: <m2zh1bvhsz.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9863 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140072
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wednesday, 2021-01-13 at 15:23:11 -08, Sami Tolvanen wrote:
> device_initcall() expects a function of type initcall_t, which returns
> an integer. Change the signature of sgx_init() to match.
>
> Fixes: e7e0545299d8c ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Makes sense.

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c519fc5f6948..8df81a3ed945 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -700,25 +700,27 @@ static bool __init sgx_page_cache_init(void)
>  	return true;
>  }
>  
> -static void __init sgx_init(void)
> +static int __init sgx_init(void)
>  {
>  	int ret;
>  	int i;
>  
>  	if (!cpu_feature_enabled(X86_FEATURE_SGX))
> -		return;
> +		return -ENODEV;
>  
>  	if (!sgx_page_cache_init())
> -		return;
> +		return -ENOMEM;
>  
> -	if (!sgx_page_reclaimer_init())
> +	if (!sgx_page_reclaimer_init()) {
> +		ret = -ENOMEM;
>  		goto err_page_cache;
> +	}
>  
>  	ret = sgx_drv_init();
>  	if (ret)
>  		goto err_kthread;
>  
> -	return;
> +	return 0;
>  
>  err_kthread:
>  	kthread_stop(ksgxd_tsk);
> @@ -728,6 +730,8 @@ static void __init sgx_init(void)
>  		vfree(sgx_epc_sections[i].pages);
>  		memunmap(sgx_epc_sections[i].virt_addr);
>  	}
> +
> +	return ret;
>  }
>  
>  device_initcall(sgx_init);
>
> base-commit: 65f0d2414b7079556fbbcc070b3d1c9f9587606d
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
