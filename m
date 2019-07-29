Return-Path: <SRS0=RmO4=V2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F76AC7618B
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jul 2019 11:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB722070D
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jul 2019 11:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbfG2LSD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jul 2019 07:18:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:4364 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387450AbfG2LSC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 29 Jul 2019 07:18:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 04:18:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="322822548"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 29 Jul 2019 04:18:01 -0700
Received: from fmsmsx162.amr.corp.intel.com (10.18.125.71) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 04:18:01 -0700
Received: from lcsmsx156.ger.corp.intel.com (10.186.165.234) by
 fmsmsx162.amr.corp.intel.com (10.18.125.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 04:18:01 -0700
Received: from hasmsx108.ger.corp.intel.com ([169.254.9.15]) by
 LCSMSX156.ger.corp.intel.com ([169.254.15.216]) with mapi id 14.03.0439.000;
 Mon, 29 Jul 2019 14:17:57 +0300
From:   "Ayoun, Serge" <serge.ayoun@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>
Subject: RE: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Topic: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver
Thread-Index: AQHVOZ3+IqhRtai+a0a1LmZyqDw5MabhhIqA
Date:   Mon, 29 Jul 2019 11:17:57 +0000
Message-ID: <88B7642769729B409B4A93D7C5E0C5E7C65ABB8D@hasmsx108.ger.corp.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDNlMjQ5OWItMjAzYS00MzBkLWJjYTItZmZmNTA0MmQ2ZjBjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoieDQ4Q1ZBN2dWK1F1TEl3dFFNVTJaWHFvaWVHWGkrbERcL1h4VlRRR1dKXC9neDUxckFpOFkzVGFmR3U2UlhxUUxXIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Sent: Saturday, July 13, 2019 20:08
> Subject: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver

> +static long sgx_ioc_enclave_add_page(struct file *filep, void __user
> +*arg) {
> +	struct sgx_encl *encl = filep->private_data;
> +	struct sgx_enclave_add_page addp;
> +	struct sgx_secinfo secinfo;
> +	struct page *data_page;
> +	unsigned long prot;
> +	void *data;
> +	int ret;
> +
> +	if (copy_from_user(&addp, arg, sizeof(addp)))
> +		return -EFAULT;
> +
> +	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
> +			   sizeof(secinfo)))
> +		return -EFAULT;
> +
> +	data_page = alloc_page(GFP_HIGHUSER);
> +	if (!data_page)
> +		return -ENOMEM;
> +
> +	data = kmap(data_page);
> +
> +	prot = _calc_vm_trans(secinfo.flags, SGX_SECINFO_R, PROT_READ)
> |
> +	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_W, PROT_WRITE) |
> +	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_X, PROT_EXEC);
> +
> +	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
> +	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) ==
> SGX_SECINFO_TCS)
> +		prot |= PROT_READ | PROT_WRITE;

For TCS pages you add both RD and WR maximum protection bits.
For the enclave to be able to run, user mode will have to change the "vma->vm_flags" from PROT_NONE to PROT_READ | PROT_WRITE (otherwise eenter fails). 
This is exactly what your selftest  does.
But when mmap (or mprotect) is called with PROT_READ bit, it automatically adds the PROT_EXEC bit unless the host application has been compiled with '-z noexecstack' option; pasting below the mmap() code which does it:

	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
		if (!(file && path_noexec(&file->f_path)))
			prot |= PROT_EXEC;

The problem is that if PROT_EXEC bit is added then sgx_mmap callback will fail since PROT_EXEC will get blocked by your code and not allowed for TCS pages.
This restriction is not necessary at all, i.e. I wouldn't block PROT_EXEC on tcs area because anyway, the hardware will never let those areas to execute: the SGX protection flags are fixed by the cpu and can not be changed by any mean.
So in order to facilitate user's interface I would let prot |= PROT_READ | PROT_WRITE | PROT_EXEC; we do not give up to any security criteria and make user interaction easier.

> +
> +	ret = sgx_encl_page_import_user(data, addp.src, prot);
> +	if (ret)
> +		goto out;
> +
> +	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo,
> addp.mrmask,
> +				prot);
> +	if (ret)
> +		goto out;
> +
> +out:
> +	kunmap(data_page);
> +	__free_page(data_page);
> +	return ret;
> +}
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

