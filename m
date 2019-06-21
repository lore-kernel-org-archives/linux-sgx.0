Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEA8C48BE0
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 16:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25B920665
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 16:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfFUQm6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Jun 2019 12:42:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:58996 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUQm5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Jun 2019 12:42:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 09:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,401,1557212400"; 
   d="scan'208";a="154506727"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga008.jf.intel.com with ESMTP; 21 Jun 2019 09:42:56 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 21 Jun 2019 09:42:56 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.97]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.250]) with mapi id 14.03.0439.000;
 Fri, 21 Jun 2019 09:42:56 -0700
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
Subject: RE: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Topic: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Index: AQHVJu27XnLeOL4jVkKHLIzqsJHQ+6amSqtg
Date:   Fri, 21 Jun 2019 16:42:54 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65518451@ORSMSX116.amr.corp.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-5-sean.j.christopherson@intel.com>
In-Reply-To: <20190619222401.14942-5-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTc2NDJhNDgtNDI3OS00ZTg2LTg3MjctODZjMWI4NmY1ZWU0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidWtrMVE3c0U2MlpiQXV2XC9DdHUwcUhpK3cyTWI2OTh3SzBKU29PM1VBYzQ1MlpLSUJaUUxydTlKcEpVaWtLdG0ifQ==
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
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h index
> 6dba9f282232..67a3babbb24d 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -35,15 +35,17 @@ struct sgx_enclave_create  {
>   * @src:	address for the page data
>   * @secinfo:	address for the SECINFO data
>   * @mrmask:	bitmask for the measured 256 byte chunks
> + * @prot:	maximal PROT_{READ,WRITE,EXEC} protections for the page
>   */
>  struct sgx_enclave_add_page {
>  	__u64	addr;
>  	__u64	src;
>  	__u64	secinfo;
> -	__u64	mrmask;
> +	__u16	mrmask;
> +	__u8	prot;
> +	__u8	pad;
>  };

Given EPCM permissions cannot change in SGX1, these maximal PROT_* flags can be the same as EPCM permissions, so don't have to be specified by user code until SGX2. Given we don't have a clear picture on how SGX2 will work yet, I think we shall take "prot" off until it is proven necessary. 

> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index 29384cdd0842..dabfe2a7245a 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -93,15 +93,64 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,  }
> #endif
> 
> +/*
> + * Returns the AND of VM_{READ,WRITE,EXEC} permissions across all pages
> + * covered by the specific VMA.  A non-existent (or yet to be added)
> +enclave
> + * page is considered to have no RWX permissions, i.e. is inaccessible.
> + */
> +static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
> +				     struct vm_area_struct *vma)
> +{
> +	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
> +	unsigned long idx, idx_start, idx_end;
> +	struct sgx_encl_page *page;
> +
> +	idx_start = PFN_DOWN(vma->vm_start);
> +	idx_end = PFN_DOWN(vma->vm_end - 1);
> +
> +	for (idx = idx_start; idx <= idx_end; ++idx) {
> +		/*
> +		 * No need to take encl->lock, vm_prot_bits is set prior to
> +		 * insertion and never changes, and racing with adding pages is
> +		 * a userspace bug.
> +		 */
> +		rcu_read_lock();
> +		page = radix_tree_lookup(&encl->page_tree, idx);
> +		rcu_read_unlock();

This loop iterates through every page in the range, which could be very slow if the range is large.

> +
> +		/* Do not allow R|W|X to a non-existent page. */
> +		if (!page)
> +			allowed_rwx = 0;
> +		else
> +			allowed_rwx &= page->vm_prot_bits;
> +		if (!allowed_rwx)
> +			break;
> +	}
> +
> +	return allowed_rwx;
> +}
> +
>  static int sgx_mmap(struct file *file, struct vm_area_struct *vma)  {
>  	struct sgx_encl *encl = file->private_data;
> +	unsigned long allowed_rwx;
>  	int ret;
> 
> +	allowed_rwx = sgx_allowed_rwx(encl, vma);
> +	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
> +		return -EACCES;
> +
>  	ret = sgx_encl_mm_add(encl, vma->vm_mm);
>  	if (ret)
>  		return ret;
> 
> +	if (!(allowed_rwx & VM_READ))
> +		vma->vm_flags &= ~VM_MAYREAD;
> +	if (!(allowed_rwx & VM_WRITE))
> +		vma->vm_flags &= ~VM_MAYWRITE;
> +	if (!(allowed_rwx & VM_EXEC))
> +		vma->vm_flags &= ~VM_MAYEXEC;
> +

Say a range comprised of a RW sub-range and a RX sub-range is being mmap()'ed as R here. It'd succeed but mprotect(<RW sub-range>, RW) afterwards will fail because VM_MAYWRITE is cleared here. However, if those two sub-ranges are mapped by separate mmap() calls then the same mprotect() would succeed. The inconsistence here is unexpected and unprecedented.

>  	vma->vm_ops = &sgx_vm_ops;
>  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
>  	vma->vm_private_data = encl;

