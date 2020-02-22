Return-Path: <SRS0=JhNk=4K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BA6C35672
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Feb 2020 04:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B59208C4
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Feb 2020 04:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JmklBm8z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgBVEcC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Feb 2020 23:32:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35466 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgBVEcC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 21 Feb 2020 23:32:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=weu/KcDRpOpBuiPQX3TPgAeSa5/F/jELKk7bJm5RqRs=; b=JmklBm8zv9rsGeiWi5aA5cP3Bl
        ClO6fGtR3iN9cLrDa1aml8g8dza+LaKnps9EwS6IFD461M/WFUBi/OqQRbsKImoA7MjkpLmP9MqiV
        GYgPWjss6Hso6VtPchx04O39ddiOEJ6GS6F266tnHyk0Nfe64mgv+wdyjJmyEJeLGEp1t3hClKlcH
        USHGGse3sGg3Etxvy7IZdl0zgwMFDYk3NI+/wvB7igSS+ZzfFZKwDdcPmz5hiyXUUonZfwKWd66VD
        TlbOkeqGMnA0qtLD9i3caCTik8DISK8wVFDJKWD9z1rXezrXqRxnAbr4zuihr6CU0GvS9MqwOmqRx
        6rHykkWA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5MA3-0006Dh-Qw; Sat, 22 Feb 2020 04:13:03 +0000
Subject: Re: [PATCH v26 22/22] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-doc@vger.kernel.org
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-23-jarkko.sakkinen@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <01067247-f6ff-21f6-774f-cbb6e72bc99e@infradead.org>
Date:   Fri, 21 Feb 2020 20:13:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200209212609.7928-23-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

One minor fix below:


On 2/9/20 1:26 PM, Jarkko Sakkinen wrote:
> Document Intel SGX micro architecture and kernel internals. The motivation
> is to make the core ideas approachable by keeping a fairly high abstraction
> level. Fine-grained micro architecture details can be looked up from Intel
> SDM Volume 3D.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  Documentation/x86/index.rst |   1 +
>  Documentation/x86/sgx.rst   | 182 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 183 insertions(+)
>  create mode 100644 Documentation/x86/sgx.rst
> 
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> new file mode 100644
> index 000000000000..ccffb45b4f4d
> --- /dev/null
> +++ b/Documentation/x86/sgx.rst
> @@ -0,0 +1,182 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Architecture
> +============
> +
> +Introduction
> +============
> +
> +*Software Guard eXtensions (SGX)* is a set of instructions that enable ring-3
> +applications to set aside private regions of code and data. These regions are
> +called enclaves. An enclave can be entered to a fixed set of entry points. Only
> +a CPU running inside the enclave can access its code and data.
> +
> +SGX support can be determined by
> +
> +	``grep /proc/cpuinfo``

	grep sgx /proc/cpuinfo

> +
> +Enclave Page Cache
> +==================

...

and
Acked-by: Randy Dunlap <rdunlap@infradead.org>
-- 
~Randy

