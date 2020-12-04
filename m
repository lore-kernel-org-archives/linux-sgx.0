Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1458CC4361A
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Dec 2020 05:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF74A222B6
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Dec 2020 05:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgLDFUd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Dec 2020 00:20:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLDFUd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Dec 2020 00:20:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B45AE9h063448;
        Fri, 4 Dec 2020 05:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D3SVi5YfXLIU4troA0CDGC8dn3+fd5w4lAX5Yqvaf1o=;
 b=GMs1dMZJduuWlpw/xgAxV7ZiEIHlh/vDv1iVQhMFYDhsEhUoV2lD/XBflmYDSKgQktDC
 JExPkghD0rwj/OH0+xo/WEdpY3S0s1Krehp5r+enTj8POOJdLnIXWpy7zq9kIGslPYCH
 ftDrB23X4MYJ6SKC2HotYeKIMj09nh3Ag6TMQymI4TpChT17hOVf20wwNc9KCxEkCkjF
 vkzbs0OHb8nWH17VUeZrazmdD5w0dyxHPd1sLoUSZDTT2E7yKAalPv8BFiWK3XxInK4U
 S92wneqNfnNLydTJisolCBtr9wyVQIYsXrWXqoOMwxp91aEZj5CDSm286za03cKQLYiy ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2b9h30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 05:19:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B45AESf078935;
        Fri, 4 Dec 2020 05:19:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540f2ufdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 05:19:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B45JgxH005798;
        Fri, 4 Dec 2020 05:19:43 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 21:19:42 -0800
Date:   Fri, 4 Dec 2020 08:19:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86/sgx: Return -EINVAL on a zero length buffer in
 sgx_ioc_enclave_add_pages()
Message-ID: <20201204051934.GR2789@kadam>
References: <20201203183527.139317-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203183527.139317-1-jarkko@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040029
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 03, 2020 at 08:35:27PM +0200, Jarkko Sakkinen wrote:
> The length documented as
> 
>  * @length:     length of the data (multiple of the page size)
> 
> Fail with -EINVAL, when user gives a zero length buffer. Right now
> 'ret' is returned as uninitialized.
> 
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Link: https://lore.kernel.org/linux-sgx/X8ehQssnslm194ld@mwanda/ 
> Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

