Return-Path: <SRS0=ZaoB=VG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0059C606B0
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 01:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1752166E
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Jul 2019 01:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfGIBDQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 21:03:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:37831 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGIBDP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 21:03:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 18:03:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,468,1557212400"; 
   d="scan'208";a="165614482"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jul 2019 18:03:15 -0700
Date:   Mon, 8 Jul 2019 18:03:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] x86/64: Call LSM hooks from SGX
 subsystem/module
Message-ID: <20190709010314.GA24799@linux.intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <a1a4f6a4f7be05ce1635b48a80cea86c27ee14cc.1562542383.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1a4f6a4f7be05ce1635b48a80cea86c27ee14cc.1562542383.git.cedric.xing@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jul 07, 2019 at 04:41:32PM -0700, Cedric Xing wrote:

...

> @@ -575,6 +576,46 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  	return ret;
>  }
>  
> +static int sgx_encl_prepare_page(struct file *filp, unsigned long dst,
> +				 unsigned long src, void *buf)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned long prot;
> +	int rc;
> +
> +	if (dst & ~PAGE_SIZE)
> +		return -EINVAL;
> +
> +	rc = down_read_killable(&current->mm->mmap_sem);
> +	if (rc)
> +		return rc;
> +
> +	vma = find_vma(current->mm, dst);
> +	if (vma && dst >= vma->vm_start)
> +		prot = _calc_vm_trans(vma->vm_flags, VM_READ, PROT_READ) |
> +		       _calc_vm_trans(vma->vm_flags, VM_WRITE, PROT_WRITE) |
> +		       _calc_vm_trans(vma->vm_flags, VM_EXEC, PROT_EXEC);
> +	else
> +		prot = 0;
> +
> +	vma = find_vma(current->mm, src);
> +	if (!vma || src < vma->vm_start || src + PAGE_SIZE > vma->vm_end)
> +		rc = -EFAULT;
> +
> +	if (!rc && !(vma->vm_flags & VM_MAYEXEC))
> +		rc = -EACCES;

Disallowing loading enclave *data* from a noexec file system is an arbitrary
and weird restriction.

> +
> +	if (!rc && copy_from_user(buf, (void __user *)src, PAGE_SIZE))
> +		rc = -EFAULT;
> +
> +	if (!rc)
> +		rc = security_enclave_load(filp, dst, PAGE_SIZE, prot, vma);
> +
> +	up_read(&current->mm->mmap_sem);
> +
> +	return rc;
> +}
