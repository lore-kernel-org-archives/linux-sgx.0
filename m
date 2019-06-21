Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F161C43613
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 17:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183A62089E
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 17:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfFURF1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Jun 2019 13:05:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:38388 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFURF1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Jun 2019 13:05:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 10:05:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="154512204"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga008.jf.intel.com with ESMTP; 21 Jun 2019 10:05:26 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 10:05:25 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.252]) with mapi id 14.03.0439.000;
 Fri, 21 Jun 2019 10:05:25 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>
Subject: RE: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
Thread-Topic: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load()
 hook for Intel SGX
Thread-Index: AQHVJu2/Ps4u3cZ3TEKYDYciObKMyqamVmOw
Date:   Fri, 21 Jun 2019 17:05:25 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F655184A2@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-10-sean.j.christopherson@intel.com>
In-Reply-To: <20190619222401.14942-10-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMGEyYTVkZjctYTg5NS00ZDAxLWE4ZTktMmE1MTc5MDM0NGM0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQ25sQWVRTytDZTU0NzBzNXJBR0NETmFXUzdheVdRR0dVdDZCWW42OXpWaEUxRU5MMTdaM2FuQlwvV083RlR4Y0gifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Wednesday, June 19, 2019 3:24 PM
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 6a1f54ba6794..572ddfc53039 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1832,11 +1832,18 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
>  #ifdef CONFIG_INTEL_SGX
>  #ifdef CONFIG_SECURITY
>  int security_enclave_map(unsigned long prot);
> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> +			  bool measured);
>  #else
>  static inline int security_enclave_map(unsigned long prot)
>  {
>  	return 0;
>  }
> +static inline int security_enclave_load(struct vm_area_struct *vma,
> +					unsigned long prot, bool measured)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_INTEL_SGX */

Parameters to security_enclave_load() are specific on what's being loading only, but unspecific on which enclave to be loaded into. That kills the possibility of an LSM module making enclave dependent decisions.

Btw, if enclave (in the form of struct file) is also passed in as a parameter, it'd let LSM know that file is an enclave, hence would be able to make the same decision in security_mmap_file() as in security_enclave_map(). In other words, you wouldn't need security_enclave_map().

