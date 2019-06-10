Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D45EC4321A
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 18:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53DC52082E
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 18:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfFJS3i convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 14:29:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:60999 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbfFJS3h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 14:29:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 11:29:37 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jun 2019 11:29:36 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 10 Jun 2019 11:29:35 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.166]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.94]) with mapi id 14.03.0415.000;
 Mon, 10 Jun 2019 11:29:34 -0700
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
Subject: RE: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
Thread-Topic: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define
 enclave pages' protection bits
Thread-Index: AQHVHA02SpPQp25T6UKJfs0Hq6ptA6aVOU0Q
Date:   Mon, 10 Jun 2019 18:29:34 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F65500E13@ORSMSX116.amr.corp.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com>
In-Reply-To: <20190606021145.12604-3-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjg3MTNkYjgtOWYzMS00NmI3LWI2NTQtMjA2YTVlOGI0NjI1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicHpLSUtJZmpyY0l6RWk4VGJhRE9cL2ZTYlE0cmVFdldiQStNZEJ4TXZcL2pteFYrSTNoQ1wvcmhqSmJrNEVNUjVWTyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
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
> Sent: Wednesday, June 05, 2019 7:12 PM
> 
> +/**
> + * sgx_map_allowed - check vma protections against the associated
> enclave page
> + * @encl:	an enclave
> + * @start:	start address of the mapping (inclusive)
> + * @end:	end address of the mapping (exclusive)
> + * @prot:	protection bits of the mapping
> + *
> + * Verify a userspace mapping to an enclave page would not violate the
> +security
> + * requirements of the *kernel*.  Note, this is in no way related to
> +the
> + * page protections enforced by hardware via the EPCM.  The EPCM
> +protections
> + * can be directly extended by the enclave, i.e. cannot be relied upon
> +by the
> + * kernel for security guarantees of any kind.
> + *
> + * Return:
> + *   0 on success,
> + *   -EACCES if the mapping is disallowed
> + */
> +int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
> +		    unsigned long end, unsigned long prot) {
> +	struct sgx_encl_page *page;
> +	unsigned long addr;
> +
> +	prot &= (VM_READ | VM_WRITE | VM_EXEC);
> +	if (!prot || !encl)
> +		return 0;
> +
> +	mutex_lock(&encl->lock);
> +
> +	for (addr = start; addr < end; addr += PAGE_SIZE) {
> +		page = radix_tree_lookup(&encl->page_tree, addr >>
> PAGE_SHIFT);
> +
> +		/*
> +		 * Do not allow R|W|X to a non-existent page, or protections
> +		 * beyond those of the existing enclave page.
> +		 */
> +		if (!page || (prot & ~page->prot))
> +			return -EACCES;

In SGX2, pages will be "mapped" before being populated.

Here's a brief summary for those who don't have enough background on how new EPC pages could be added to a running enclave in SGX2:
  - There are 2 new instructions - EACCEPT and EAUG.
  - EAUG is used by SGX module to add (augment) a new page to an existing enclave. The newly added page is *inaccessible* until the enclave *accepts* it.
  - EACCEPT is the instruction for an enclave to accept a new page.

And the s/w flow for an enclave to request new EPC pages is expected to be something like the following:
  - The enclave issues EACCEPT at the linear address that it would like a new page.
  - EACCEPT results in #PF, as there's no page at the linear address above.
  - SGX module is notified about the #PF, in form of its vma->vm_ops->fault() being called by kernel.
  - SGX module EAUGs a new EPC page at the fault address, and resumes the enclave.
  - EACCEPT is reattempted, and succeeds at this time.

But with the above check in sgx_map_allowed(), I'm not sure how this will work out with SGX2.

> +	}
> +
> +	mutex_unlock(&encl->lock);
> +
> +	return 0;
> +}
> +
