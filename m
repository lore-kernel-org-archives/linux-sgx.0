Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC70DC64E7B
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 14:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AF3C221EB
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 14:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgLBOPR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 09:15:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLBOPQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 2 Dec 2020 09:15:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2E5feC107885;
        Wed, 2 Dec 2020 14:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=goeAealbfR1Oo0ug61ERN0EJRJMVeeEamvq4Wv945cA=;
 b=jM2hXyHhK2aoVyzJbEUxqGzc+WcAsfpTXae5A/RRICZOBkmHWKwlIS/bKWQJHkCBlU79
 djmcEkscNd5+I01vessZGb1zZKKQ5qv67195P+Y6jWlaqlQ9O01ACBtSxom5JXmjUNC5
 XUxwtAQcjLF4iaXHsOHMqSQ8UT9T2pk656yrXI30djn7/hPD80av686xHOhMUDcl0yHo
 FmjC+bqI3w/NDY7U7R1NHpZS/VJTDtGJWKUPB0qJFYYEwEVhdB5+NRRBYelJ5TWexOwm
 lskMOYcEZn0gwnWdbcqrRRL2XOLm2jjFdKhEF9w/xuYDc8sXgM45hTnmPAUXTHcPDrFg EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkre5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 14:14:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2E5Pr5064462;
        Wed, 2 Dec 2020 14:14:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540fysuyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 14:14:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2EEWmX011010;
        Wed, 2 Dec 2020 14:14:32 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 06:14:31 -0800
Date:   Wed, 2 Dec 2020 17:14:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     jarkko@kernel.org
Cc:     linux-sgx@vger.kernel.org
Subject: [bug report] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <X8ehQssnslm194ld@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 phishscore=0 mlxlogscore=847 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=861 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020086
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hello Jarkko Sakkinen,

The patch c6d26d370767: "x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES" from
Nov 13, 2020, leads to the following static checker warning:

	arch/x86/kernel/cpu/sgx/ioctl.c:466 sgx_ioc_enclave_add_pages()
	error: uninitialized symbol 'ret'.

arch/x86/kernel/cpu/sgx/ioctl.c
   413  static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
   414  {
   415          struct sgx_enclave_add_pages add_arg;
   416          struct sgx_secinfo secinfo;
   417          unsigned long c;
   418          int ret;
   419  
   420          if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
   421              test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
   422                  return -EINVAL;
   423  
   424          if (copy_from_user(&add_arg, arg, sizeof(add_arg)))
   425                  return -EFAULT;
   426  
   427          if (!IS_ALIGNED(add_arg.offset, PAGE_SIZE) ||
   428              !IS_ALIGNED(add_arg.src, PAGE_SIZE))
   429                  return -EINVAL;
   430  
   431          if (add_arg.length & (PAGE_SIZE - 1))
   432                  return -EINVAL;
   433  
   434          if (add_arg.offset + add_arg.length - PAGE_SIZE >= encl->size)
   435                  return -EINVAL;
   436  
   437          if (copy_from_user(&secinfo, (void __user *)add_arg.secinfo,
   438                             sizeof(secinfo)))
   439                  return -EFAULT;
   440  
   441          if (sgx_validate_secinfo(&secinfo))
   442                  return -EINVAL;
   443  
   444          for (c = 0 ; c < add_arg.length; c += PAGE_SIZE) {

If the user passes in an "add_arg.length" value of zero then "ret" isn't
initialized.

   445                  if (signal_pending(current)) {
   446                          if (!c)
   447                                  ret = -ERESTARTSYS;
   448  
   449                          break;
   450                  }
   451  
   452                  if (need_resched())
   453                          cond_resched();
   454  
   455                  ret = sgx_encl_add_page(encl, add_arg.src + c, add_arg.offset + c,
   456                                          &secinfo, add_arg.flags);
   457                  if (ret)
   458                          break;
   459          }
   460  
   461          add_arg.count = c;
   462  
   463          if (copy_to_user(arg, &add_arg, sizeof(add_arg)))
   464                  return -EFAULT;
   465  
   466          return ret;
                ^^^^^^^^^^

   467  }

regards,
dan carpenter
