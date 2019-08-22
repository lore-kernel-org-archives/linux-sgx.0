Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F14C3A59D
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 10:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050E8205ED
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 10:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbfHVKjV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 06:39:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:26488 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbfHVKjV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 06:39:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 03:39:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="196218356"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga001.fm.intel.com with ESMTP; 22 Aug 2019 03:39:20 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 22 Aug 2019 03:39:20 -0700
Received: from HASMSX109.ger.corp.intel.com (10.184.198.21) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 22 Aug 2019 03:39:20 -0700
Received: from hasmsx108.ger.corp.intel.com ([169.254.9.203]) by
 hasmsx109.ger.corp.intel.com ([169.254.3.38]) with mapi id 14.03.0439.000;
 Thu, 22 Aug 2019 13:39:17 +0300
From:   "Ayoun, Serge" <serge.ayoun@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     Sean Christopherson <sean.j.christpherson@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>
Subject: RE: [PATCH 3/5] x86/sgx: Make sgx_validate_secinfo() more readable
Thread-Topic: [PATCH 3/5] x86/sgx: Make sgx_validate_secinfo() more readable
Thread-Index: AQHVVqJrRDWN4xlrz0iNUe8HsD09iacG/e5A
Date:   Thu, 22 Aug 2019 10:39:17 +0000
Message-ID: <88B7642769729B409B4A93D7C5E0C5E7C661E682@hasmsx108.ger.corp.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-4-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190819152544.7296-4-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODE1NzgxZmYtZDdiMy00NGE5LWI1MWQtYWUzMGY1MmRlMzQ1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTkF6aFdRdlYyY3BmT1lBejMwRkswbWVYOGhPMVowdVpJZGNpeUJ1S2lTazZaMUsrRG1VUXNUMFNHMENEVHl3QiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Sent: Monday, August 19, 2019 18:26
> To: linux-sgx@vger.kernel.org
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>; Sean Christopherson
> <sean.j.christpherson@intel.com>; Katz-zamir, Shay <shay.katz-
> zamir@intel.com>; Ayoun, Serge <serge.ayoun@intel.com>
> Subject: [PATCH 3/5] x86/sgx: Make sgx_validate_secinfo() more readable
> 
> Split the huge conditional statement to three separate ones in order to make
> it easier to understand what is going on in the validation code.
> 
> Cc: Sean Christopherson <sean.j.christpherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index d5f326411df0..99b1b9776c3a 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -415,10 +415,15 @@ static int sgx_validate_secinfo(struct sgx_secinfo
> *secinfo)
>  	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
>  	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
> 
> -	if ((secinfo->flags & SGX_SECINFO_RESERVED_MASK) ||
> -	    ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R)) ||
> -	    (page_type != SGX_SECINFO_TCS && page_type !=
> SGX_SECINFO_TRIM &&
> -	     page_type != SGX_SECINFO_REG))
> +	if ((page_type != SGX_SECINFO_REG &&
> +	     page_type != SGX_SECINFO_TCS &&
> +	     page_type != SGX_SECINFO_TRIM))
> +		return -EINVAL;

sgx_validate_secinfo() is called via eadd ioctl. Eadd will fail with
TRIM page type, so you probably need to remove it from the if
sgx2.0 does not change this behavior

> +
> +	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
> +		return -EINVAL;
> +
> +	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
>  		return -EINVAL;
> 
>  	if (memchr_inv(secinfo->reserved, 0,
> SGX_SECINFO_RESERVED_SIZE))
> --
> 2.20.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

