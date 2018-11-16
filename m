Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4ABCC04EBC
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 11:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A64E22086A
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 11:23:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A64E22086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389395AbeKPVfa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:35:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:29336 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbeKPVfa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 16:35:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Nov 2018 03:23:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,240,1539673200"; 
   d="scan'208";a="96809630"
Received: from unknown (HELO localhost) ([10.249.254.90])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Nov 2018 03:23:27 -0800
Date:   Fri, 16 Nov 2018 13:23:26 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181116112326.GA6445@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <6fe0687b-70c9-9e7d-6f05-8963f18f0636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fe0687b-70c9-9e7d-6f05-8963f18f0636@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 15, 2018 at 05:37:27PM -0800, Randy Dunlap wrote:
> On 11/15/18 5:01 PM, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> > 
> > SGX driver provides a ioctl API for loading and initializing enclaves.
> > Address range for enclaves is reserved with mmap() and they are
> > destroyed with munmap(). Enclave construction, measurement and
> > initialization is done with the provided the ioctl API.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> > Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> > Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> 
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > new file mode 100644
> > index 000000000000..aadf9c76e360
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -0,0 +1,59 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> > +/**
> > + * Copyright(c) 2016-18 Intel Corporation.
> > + */
> > +#ifndef _UAPI_ASM_X86_SGX_H
> > +#define _UAPI_ASM_X86_SGX_H
> > +
> > +#include <linux/types.h>
> > +#include <linux/ioctl.h>
> > +
> > +#define SGX_MAGIC 0xA4
> > +
> > +#define SGX_IOC_ENCLAVE_CREATE \
> > +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> > +#define SGX_IOC_ENCLAVE_ADD_PAGE \
> > +	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> > +#define SGX_IOC_ENCLAVE_INIT \
> > +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> > +
> > +/* IOCTL return values */
> > +#define SGX_POWER_LOST_ENCLAVE		0x40000000
> 
> 
> Hi,
> The ioctl magic number should be documented in
> Documentation/ioctl/ioctl-number.txt.
> 
> ta.
> -- 
> ~Randy

Thank you. Addressed now in https://github.com/jsakkine-intel/linux-sgx.git.

/Jarkko
