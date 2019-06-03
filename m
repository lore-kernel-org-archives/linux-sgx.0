Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC26C04AB6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A79427BF1
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfFCG3P convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:29:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:41230 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfFCG3P (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 02:29:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jun 2019 23:29:14 -0700
X-ExtLoop1: 1
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga004.jf.intel.com with ESMTP; 02 Jun 2019 23:29:14 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX101.amr.corp.intel.com ([169.254.8.107]) with mapi id 14.03.0415.000;
 Sun, 2 Jun 2019 23:29:14 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        "LSM List" <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
Thread-Topic: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
Thread-Index: AQHVGAkjwUGhfvPW2Uy0jc3S+IXJ16aJZ4lQ
Date:   Mon, 3 Jun 2019 06:29:14 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ECC53@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-8-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-8-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOWIwM2ExZDEtNTA3Ny00OWUwLWI0MWItZTYwNTAzOWI0N2MzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTlwvRnhjRGpkN3AzU1ptdmxYZVQ3Y1dcL3pWc0RQNndNeUgyRlNHMEh2OURkb1hlYWhRK2o3clUraWl2d040U1JQIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Friday, May 31, 2019 4:32 PM
> 
> Do not allow an enclave page to be mapped with PROT_EXEC if the source page is backed by a
> file on a noexec file system.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index c30acd3fbbdd..5f71be7cbb01 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -576,6 +576,27 @@ static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long
> addr,
>  	return ret;
>  }
> 
> +static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
> +				 unsigned long *allowed_prot)
> +{
> +	struct vm_area_struct *vma;
> +
> +	if (!(*allowed_prot & VM_EXEC))
> +		goto do_check;
> +
> +	down_read(&current->mm->mmap_sem);
> +	vma = find_vma(current->mm, src);
> +	if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
> +		*allowed_prot &= ~VM_EXEC;

Testing (vma->vm_flags & VM_MAYEXEC) == 0 should be a better approach.

Moreover, it looks like the check is done per page, so say 100 pages would cause this test to run 100 times even if they are within the same VMA. Wouldn't that be a bit inefficient? 
 
> +	up_read(&current->mm->mmap_sem);
> +
> +do_check:
> +	if (prot & ~*allowed_prot)
> +		return -EACCES;
> +
> +	return 0;
> +}
