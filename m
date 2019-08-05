Return-Path: <SRS0=oZh+=WB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23970C433FF
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Aug 2019 16:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F352B208C3
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Aug 2019 16:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfHEQQq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Aug 2019 12:16:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:32039 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbfHEQQq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Aug 2019 12:16:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 09:16:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373754202"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 09:16:45 -0700
Date:   Mon, 5 Aug 2019 09:16:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190805161644.GD29275@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jul 13, 2019 at 08:07:52PM +0300, Jarkko Sakkinen wrote:
> +static unsigned long sgx_get_unmapped_area(struct file *file,
> +					   unsigned long addr,
> +					   unsigned long len,
> +					   unsigned long pgoff,
> +					   unsigned long flags)
> +{
> +	if (flags & MAP_PRIVATE)
> +		return -EINVAL;
> +
> +	if (flags & MAP_FIXED)
> +		return addr;
> +
> +	if (len < 2 * PAGE_SIZE || len & (len - 1))
> +		return -EINVAL;
> +
> +	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
> +					      flags);
> +	if (IS_ERR_VALUE(addr))
> +		return addr;
> +
> +	addr = (addr + (len - 1)) & ~(len - 1);
> +
> +	return addr;
> +}

Thinking about this more, I don't think the driver should verify or adjust
@addr and @len during non-fixed mmap().  There is no requirement that
userspace must map the full ELRANGE, or that an enclave's ELRANGE can
*never* be mapped to non-EPC.  The architectural requirement is that an
access that hits ELRANGE must map to the EPC *if* the CPU is executing the
associated enclave.

This means that a process can have random mappings that overlap an
enclave's ELRANGE while the enclave is active, it just can't access that
memory from within the enclave.

A good example is a large enclave, e.g. 3gb of actual code/data, that
userspace wants to locate below 4gb for some reason, e.g. running an
unmodified non-enclave binary under graphene.  Requiring @addr+@len to be
naturally sized and aligned will force @addr to 0x0, which is often
disallowed by the kernel.
