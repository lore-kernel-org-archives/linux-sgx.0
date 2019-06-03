Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBE1C04AB6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E17F327BEB
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFCG0L convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:26:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:41645 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfFCG0L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 02:26:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jun 2019 23:26:10 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga005.jf.intel.com with ESMTP; 02 Jun 2019 23:26:10 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 2 Jun 2019 23:26:10 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.35]) with mapi id 14.03.0415.000;
 Sun, 2 Jun 2019 23:26:10 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
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
Subject: RE: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Topic: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages
 in single ioctl()
Thread-Index: AQHVGAki7TYpY4ZsUk+m4jTej+khLaaJYAJQ
Date:   Mon, 3 Jun 2019 06:26:09 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ECBBD@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-4-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-4-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTFhYjE5MTAtN2M1Ny00NzQ1LWI4MWYtYTYyOTljMTBlOWY1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUUo4ZUN3aGVZbGxhQ3RnK21xZWRVZTVxWVBtS1VnYVVcL25DMmVCOGoyTnlTbDQ5aFYxa09ySVwvQ2VOZjNNcU1oIn0=
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
> +/**
> + * sgx_ioc_enclave_add_pages - handler for %SGX_IOC_ENCLAVE_ADD_PAGES
> + *
> + * @filep:	open file to /dev/sgx
> + * @cmd:	the command value
> + * @arg:	pointer to an &sgx_enclave_add_page instance
> + *
> + * Add a range of pages to an uninitialized enclave (EADD), and
> +optionally
> + * extend the enclave's measurement with the contents of the page (EEXTEND).
> + * The range of pages must be virtually contiguous.  The SECINFO and
> + * measurement maskare applied to all pages, i.e. pages with different
> + * properties must be added in separate calls.
> + *
> + * EADD and EEXTEND are done asynchronously via worker threads.  A
> +successful
> + * sgx_ioc_enclave_add_page() only indicates the pages have been added
> +to the
> + * work queue, it does not guarantee adding the pages to the enclave
> +will
> + * succeed.
> + *
> + * Return:
> + *   0 on success,
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_add_pages(struct file *filep, unsigned int cmd,
> +				      unsigned long arg)
> +{
> +	struct sgx_enclave_add_pages *addp = (void *)arg;
> +	struct sgx_encl *encl = filep->private_data;
> +	struct sgx_secinfo secinfo;
> +	unsigned int i;
> +	int ret;
> +
> +	if (copy_from_user(&secinfo, (void __user *)addp->secinfo,
> +			   sizeof(secinfo)))
> +		return -EFAULT;
> +
> +	for (i = 0, ret = 0; i < addp->nr_pages && !ret; i++) {
> +		if (signal_pending(current))
> +			return -ERESTARTSYS;

If interrupted, how would user mode code know how many pages have been EADD'ed?

> +
> +		if (need_resched())
> +			cond_resched();
> +
> +		ret = sgx_encl_add_page(encl, addp->addr + i*PAGE_SIZE,
> +					addp->src + i*PAGE_SIZE,
> +					&secinfo, addp->mrmask);
> +	}
>  	return ret;
>  }
> 
> @@ -823,8 +845,8 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  	case SGX_IOC_ENCLAVE_CREATE:
>  		handler = sgx_ioc_enclave_create;
>  		break;
> -	case SGX_IOC_ENCLAVE_ADD_PAGE:
> -		handler = sgx_ioc_enclave_add_page;
> +	case SGX_IOC_ENCLAVE_ADD_PAGES:
> +		handler = sgx_ioc_enclave_add_pages;
>  		break;
>  	case SGX_IOC_ENCLAVE_INIT:
>  		handler = sgx_ioc_enclave_init;
> --
> 2.21.0

