Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC319C3A59F
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 14:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2FF2173E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 14:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfHZOb6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 10:31:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:4449 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfHZOb6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 10:31:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 07:31:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="174225119"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2019 07:31:57 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 26 Aug 2019 07:31:57 -0700
Received: from hasmsx113.ger.corp.intel.com (10.184.198.64) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 26 Aug 2019 07:31:56 -0700
Received: from hasmsx108.ger.corp.intel.com ([169.254.9.203]) by
 HASMSX113.ger.corp.intel.com ([169.254.13.63]) with mapi id 14.03.0439.000;
 Mon, 26 Aug 2019 17:31:54 +0300
From:   "Ayoun, Serge" <serge.ayoun@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>
Subject: RE: [PATCH 1/4] x86/sgx: Replace @is_secs_child with @pt in
 sgx_encl_ewb()
Thread-Topic: [PATCH 1/4] x86/sgx: Replace @is_secs_child with @pt in
 sgx_encl_ewb()
Thread-Index: AQHVWc4l5ib1B1U5K0CKkTPqzjqcBKcNf+fg
Date:   Mon, 26 Aug 2019 14:31:54 +0000
Message-ID: <88B7642769729B409B4A93D7C5E0C5E7C6624865@hasmsx108.ger.corp.intel.com>
References: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
 <20190823161616.27644-2-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190823161616.27644-2-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2UzNzY3MTAtODQyNy00Yzc4LWJiN2UtZDEyYTBhZTA2MzE5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiU29cL2tqUk5SdnA2Z0JTaFBOWWFsdWRCQ2plYmpqdEoxOU9EdTZzRVN6UFc1WENLb01TRFRFdDU3bzFsMFgxNkEifQ==
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

> On Behalf Of Jarkko Sakkinen
> Sent: Friday, August 23, 2019 19:16
> To: linux-sgx@vger.kernel.org
> Cc: Christopherson, Sean J <sean.j.christopherson@intel.com>; Ayoun,
> Serge <serge.ayoun@intel.com>; Katz-zamir, Shay <shay.katz-
> zamir@intel.com>; Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Subject: [PATCH 1/4] x86/sgx: Replace @is_secs_child with @pt in
> sgx_encl_ewb()
> 
> Sean complained about boolean parameters so I though that maybe it would
> be good to rework the EWB flow in a way that it operates by a page type and
> here is the result. The contract is and will be that as long as you give the
> correct page type, you will get what you want. That is why I set REG and TCS
> appropriately even though they are treated the same way at this point of
> time.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/reclaim.c | 43 +++++++++++++++++++------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c
> b/arch/x86/kernel/cpu/sgx/reclaim.c
> index 00f596c64a2d..3f10a8ff00b7 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -221,7 +221,7 @@ static void sgx_reclaimer_block(struct sgx_epc_page
> *epc_page)
> 
>  static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page
> *epc_page,
>  			  struct sgx_va_page *va_page, unsigned int
> va_offset,
> -			  bool is_secs_child)
> +			  unsigned int pt)
>  {
>  	struct sgx_encl_page *encl_page = epc_page->owner;
>  	struct sgx_pageinfo pginfo;
> @@ -232,10 +232,14 @@ static int __sgx_encl_ewb(struct sgx_encl *encl,
> struct sgx_epc_page *epc_page,
>  	struct page *pcmd;
>  	int ret;
> 
> -	if (is_secs_child)
> -		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
> -	else
> +	if (pt != SGX_SECINFO_SECS && pt != SGX_SECINFO_TCS &&
> +	    pt != SGX_SECINFO_REG)
> +		return -EINVAL;

Not sure about this one since this 'if' should never happen, unless there is a bug
Not clear if the caller (sgx_encl_ewb) will handle -EINVAL properly.
Maybe would be better to issue some warning message or BUG_ON

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

