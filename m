Return-Path: <SRS0=6APk=X5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A89C47404
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Oct 2019 09:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4865D21A4C
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Oct 2019 09:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="lsrK3yQq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbfJDJpU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Oct 2019 05:45:20 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58984 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388388AbfJDJpT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Oct 2019 05:45:19 -0400
Received: from zn.tnic (p200300EC2F0C7700A886458DB1699599.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:7700:a886:458d:b169:9599])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 512CC1EC0B59;
        Fri,  4 Oct 2019 11:45:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570182318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4fjavIWUE7bcCsSR2gUXUpZ+AhGZW8WM0D0bMXAAJTE=;
        b=lsrK3yQqWIovY51s2Gd51Ja0zlGWC+RfoXQeEt/1uBJMK3ZGB0QcCyHmzujej+2RlTkKVo
        DIYpoA7k8SxJxBw7tRQL1/OI5LBxjxu8FkJCHbi30HPzbZEube81+KrYTV47MMVzf4ils1
        GZbKhCPnWYI04ddZ7p7z3h8jGMMUeA0=
Date:   Fri, 4 Oct 2019 11:45:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 07/24] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20191004094513.GA3362@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-8-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190903142655.21943-8-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:38PM +0300, Jarkko Sakkinen wrote:
> ENCLS is a ring 0 instruction that contains a set of leaf functions for
> managing enclaves [1]. Enclaves SGX hosted measured and signed software
> entities, which are protected by asserting the outside memory accesses and
> memory encryption.
> 
> Add a two-layer macro system along with an encoding scheme to allow
> wrappers to return trap numbers along ENCLS-specific error codes. The
> bottom layer of the macro system splits between the leafs that return an
> error code and those that do not. The second layer generates the correct
> input/output annotations based on the number of operands for each leaf
> function.
> 
> [1] Intel SDM: 36.6 ENCLAVE INSTRUCTIONS AND INTEL®
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This SOB needs to come...

> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

<--- ... here.

> +/**
> + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> + *
> + * ENCLS has its own (positive value) error codes and also generates
> + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> + * with system error codes as everything percolates back up the stack.
> + * Unfortunately (for us), we need to precisely identify each unique
> + * error code, e.g. the action taken if EWB fails varies based on the
> + * type of fault and on the exact SGX error code, i.e. we can't simply
> + * convert all faults to -EFAULT.
> + *
> + * To make all three error types coexist, we set bit 30 to identify an
> + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> + * between positive (faults and SGX error codes) and negative (system
> + * error codes) values.
> + */
> +#define ENCLS_FAULT_FLAG 0x40000000

BIT(30)

> +
> +/**
> + * Retrieve the encoded trapnr from the specified return code.
> + */
> +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
> +
> +/* Issue a WARN() about an ENCLS leaf. */
> +#define ENCLS_WARN(r, name) {						\
> +	do {								\
> +		int _r = (r);						\
> +		WARN(_r, "sgx: %s returned %d (0x%x)\n", (name), _r,	\
> +		     _r);						\

Let that line stick out a bit:

		WARN(_r, "sgx: %s returned %d (0x%x)\n", (name), _r, _r); \

> +	} while (0);							\
> +}
> +
> +/**
> + * encls_faulted() - Check if ENCLS leaf function faulted
> + * @ret:	the return value of an ENCLS leaf function call
> + *
> + * Return: true if the fault flag is set
> + */
> +static inline bool encls_faulted(int ret)
> +{
> +	return (ret & ENCLS_FAULT_FLAG) != 0;

	return ret & ENCLS_FAULT_FLAG;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
