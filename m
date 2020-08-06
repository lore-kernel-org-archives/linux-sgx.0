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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6CCC433E3
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4CB2311C
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lq3TcMtz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgHFRP2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:15:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbgHFRPZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 13:15:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076DILXb007671;
        Thu, 6 Aug 2020 13:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=AHSv3tsI28sIISVsPR048qSjA4rjmfzS6HgnYK0Bxvc=;
 b=Lq3TcMtz29DRvR8UISmpLfn9qAFdXxKeC3s8/FD7pj4ij7eSqrHztQ/RtQvyvZ8JLMh+
 MwklYDHZi52xRqeZVXaSKdTRK3tC4kClZrwLCCly/JBvozGdeiCj579ZG72vxJMByJuW
 6/Db/L5yHg7wD1per9OfP82QHaPwklcFWZhCx7E5ONrMUdz/LDQVAZkalNrzWoFN6wK7
 cqTMY4RBKeVl9s3slreVL1NOOGgPyBIGT+mqU4/IBUSyh1Bna3QscCHeLkBivSxGVYY2
 utcMj2qVhduUgZ/mN12WlBATYGDGYfYaYtfnxaq/8BvJrviSJOgLWjSN7zcRM+iPLaFN eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32r6ep2urb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:18:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076Cwxi9172955;
        Thu, 6 Aug 2020 13:18:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32pdnwc31r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:18:15 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076DIEuv021665;
        Thu, 6 Aug 2020 13:18:14 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:18:14 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id BC84EF04A3F; Thu,  6 Aug 2020 14:18:09 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 07/24] x86/cpu/intel: Add nosgx kernel parameter
In-Reply-To: <20200716135303.276442-8-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-8-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:18:09 +0100
Message-ID: <m2wo2brjzi.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060095
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:46 +03, Jarkko Sakkinen wrote:
> Add kernel parameter to disable Intel SGX kernel support.
>
> Tested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  Documentation/admin-guide/kernel-parameters.txt | 2 ++
>  arch/x86/kernel/cpu/feat_ctl.c                  | 9 +++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index fb95fad81c79..e747bd9ca911 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3314,6 +3314,8 @@
>  
>  	nosep		[BUGS=X86-32] Disables x86 SYSENTER/SYSEXIT support.
>  
> +	nosgx		[X86-64,SGX] Disables Intel SGX kernel support.
> +
>  	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel,
>  			and disable the IO APIC.  legacy for "maxcpus=0".
>  
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index c3afcd2e4342..1837df39527f 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -101,6 +101,15 @@ static void clear_sgx_caps(void)
>  	setup_clear_cpu_cap(X86_FEATURE_SGX2);
>  }
>  
> +static int __init nosgx(char *str)
> +{
> +	clear_sgx_caps();
> +
> +	return 0;
> +}
> +
> +early_param("nosgx", nosgx);
> +
>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  {
>  	bool tboot = tboot_enabled();
> -- 
> 2.25.1
