Return-Path: <SRS0=iPl9=4W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF675C3F2D2
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 19:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A59C420801
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 19:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgCETEc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Mar 2020 14:04:32 -0500
Received: from mga14.intel.com ([192.55.52.115]:31615 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgCETEb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Mar 2020 14:04:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 11:04:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="287749694"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Mar 2020 11:04:30 -0800
Date:   Thu, 5 Mar 2020 11:04:30 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>
Subject: Re: [PATCH v28 11/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200305190430.GL11500@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-12-jarkko.sakkinen@linux.intel.com>
 <20200305174015.GJ11500@linux.intel.com>
 <e445c2f8-fddd-5740-0e26-a03e023918bf@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e445c2f8-fddd-5740-0e26-a03e023918bf@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 05, 2020 at 07:24:11PM +0100, Jethro Beekman wrote:
> On 2020-03-05 18:40, Sean Christopherson wrote:
> > On Wed, Mar 04, 2020 at 01:35:58AM +0200, Jarkko Sakkinen wrote:
> >> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> >> new file mode 100644
> >> index 000000000000..5edb08ab8fd0
> >> --- /dev/null
> >> +++ b/arch/x86/include/uapi/asm/sgx.h
> >> @@ -0,0 +1,66 @@
> >> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> >> +/*
> >> + * Copyright(c) 2016-19 Intel Corporation.
> >> + */
> >> +#ifndef _UAPI_ASM_X86_SGX_H
> >> +#define _UAPI_ASM_X86_SGX_H
> >> +
> >> +#include <linux/types.h>
> >> +#include <linux/ioctl.h>
> >> +
> >> +/**
> >> + * enum sgx_epage_flags - page control flags
> >> + * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
> >> + *			ENCLS[EEXTEND] operations.
> >> + */
> >> +enum sgx_page_flags {
> >> +	SGX_PAGE_MEASURE	= 0x01,
> >> +};
> >> +
> >> +#define SGX_MAGIC 0xA4
> >> +
> >> +#define SGX_IOC_ENCLAVE_CREATE \
> >> +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> >> +#define SGX_IOC_ENCLAVE_ADD_PAGES \
> >> +	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
> >> +#define SGX_IOC_ENCLAVE_INIT \
> >> +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> >> +
> >> +/**
> >> + * struct sgx_enclave_create - parameter structure for the
> >> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> >> + * @src:	address for the SECS page data
> >> + */
> >> +struct sgx_enclave_create  {
> >> +	__u64	src;
> > 
> > Would it make sense to add reserved fields to the structs so that new
> > features can be added in a backwards compatible way?  E.g. if we want to
> > allow userspace to control the backing store by passing in a file
> > descriptor ENCLAVE_CREATE.
> 
> Reserving space for future fields is not necessary because the size of the
> struct is encoded in the ioctl number. The kernel can use this to
> differentiate between different call versions from userspace.

Ah, perfect!  Thanks!
