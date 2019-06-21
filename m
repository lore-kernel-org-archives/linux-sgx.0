Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ADBC4646C
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 17:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0390208C3
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 17:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFURS6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Jun 2019 13:18:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:47936 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfFURS6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Jun 2019 13:18:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 10:18:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="161023650"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jun 2019 10:18:56 -0700
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 10:18:56 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.149]) with mapi id 14.03.0439.000;
 Fri, 21 Jun 2019 10:18:55 -0700
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
Subject: RE: [RFC PATCH v4 12/12] LSM: x86/sgx: Show line of sight to LSM
 support SGX2's EAUG
Thread-Topic: [RFC PATCH v4 12/12] LSM: x86/sgx: Show line of sight to LSM
 support SGX2's EAUG
Thread-Index: AQHVJu2/NiTIJyW+BECgY2Jq3MAUUaamWrbw
Date:   Fri, 21 Jun 2019 17:18:55 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F655184EC@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-13-sean.j.christopherson@intel.com>
In-Reply-To: <20190619222401.14942-13-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWU5MzhmOTYtYTkxMS00OWUyLTliMWEtZTQwZDU4YTZjZWRkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSnErVUVaQ2E3V2FsOW0rc2VKXC9XcDhhQjQ2cU9UWVlZSjZxc254MEhGNGZUNFU5V1wvUmxvc2J1WTJQWUt0MEJHIn0=
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
> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index 4379a2fb1f82..b478c0f45279 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -99,7 +99,8 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
>   * page is considered to have no RWX permissions, i.e. is inaccessible.
>   */
>  static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
> -				     struct vm_area_struct *vma)
> +				     struct vm_area_struct *vma,
> +				     bool *eaug)
>  {
>  	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
>  	unsigned long idx, idx_start, idx_end; @@ -123,6 +124,8 @@ static unsigned long
> sgx_allowed_rwx(struct sgx_encl *encl,
>  			allowed_rwx = 0;
>  		else
>  			allowed_rwx &= page->vm_prot_bits;
> +		if (page->vm_prot_bits & SGX_VM_EAUG)
> +			*eaug = true;
>  		if (!allowed_rwx)
>  			break;
>  	}
> @@ -134,16 +137,17 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> {
>  	struct sgx_encl *encl = file->private_data;
>  	unsigned long allowed_rwx, prot;
> +	bool eaug = false;
>  	int ret;
> 
> -	allowed_rwx = sgx_allowed_rwx(encl, vma);
> +	allowed_rwx = sgx_allowed_rwx(encl, vma, &eaug);
>  	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
>  		return -EACCES;

IIUC, "eaug range" has to be mapped PROT_NONE, then vm_ops->fault() won't be invoked. Am I correct? Then how to EAUG on #PF?

> 
>  	prot = _calc_vm_trans(vma->vm_flags, VM_READ, PROT_READ) |
>  	       _calc_vm_trans(vma->vm_flags, VM_WRITE, PROT_WRITE) |
>  	       _calc_vm_trans(vma->vm_flags, VM_EXEC, PROT_EXEC);
> -	ret = security_enclave_map(prot);
> +	ret = security_enclave_map(prot, eaug);
>  	if (ret)
>  		return ret;
> 
