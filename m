Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD99C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 16:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16CC22086A
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 16:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16CC22086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbeKGCGC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:06:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:65089 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387685AbeKGCGC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 21:06:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 08:40:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,472,1534834800"; 
   d="scan'208";a="102000368"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by fmsmga002.fm.intel.com with ESMTP; 06 Nov 2018 08:40:00 -0800
Message-ID: <1541522400.7839.48.camel@intel.com>
Subject: Re: [PATCH v16 18/22] platform/x86: Intel SGX driver
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Date:   Tue, 06 Nov 2018 08:40:00 -0800
In-Reply-To: <20181106134758.10572-19-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
         <20181106134758.10572-19-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.18.5.2-0ubuntu3.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2018-11-06 at 15:45 +0200, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
> 
> SGX driver provides a ioctl API for loading and initializing enclaves.
> Address range for enclaves is reserved with mmap() and they are
> destroyed with munmap(). Enclave construction, measurement and
> initialization is done with the provided the ioctl API.

...

> +struct sgx_encl {
> +	unsigned int flags;
> +	uint64_t attributes;
> +	uint64_t xfrm;
> +	unsigned int page_cnt;
> +	unsigned int secs_child_cnt;
> +	struct mutex lock;
> +	struct mm_struct *mm;
> +	struct file *backing;

Is there any particular reason why the kernel manages the backing for
the enclave and the PCMDs?  Could we have userspace provide the backing
either through the ECREATE ioctl() or maybe a completely new ioctl(),
e.g. to give userspace the option to back the enclave with a NVDIMM
instead of RAM?  A separate ioctl() with control flags might give us
some flexibility in the future, e.g. maybe there are use cases where
userspace would prefer to kill enclaves rather than swap EPC.

> +	struct kref refcount;
> +	unsigned long base;
> +	unsigned long size;
> +	unsigned long ssaframesize;
> +	struct radix_tree_root page_tree;
> +	struct list_head add_page_reqs;
> +	struct work_struct add_page_work;
> +	struct sgx_encl_page secs;
> +	struct pid *tgid;
> +	struct mmu_notifier mmu_notifier;
> +	struct notifier_block pm_notifier;
> +};
