Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26DFC433E6
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 22:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9357664F4C
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 22:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhBBWop (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 17:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235648AbhBBWoi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Feb 2021 17:44:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29E0564F4C;
        Tue,  2 Feb 2021 22:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612305837;
        bh=qyiIFBOuIC3f3nUMesj1fMzai7hKaPmzlzsaCTyXV+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pu9kSDVSy+xBHVBEA6OYdndUTict2LLHnUGJqpf8cfs4L6XuhaBaRMsc99hTZ7z8C
         MqZdlcADSirul1fukYmhahdOJ7FPO/lA8FDgufvxaKsw0PS1uEbntxp5ERDWSB3N0I
         yiUO5kXiibl8Z2ov9lFw3TPxw8faHI2AG4mUp4NcCOpOlDvrsEoV+npTn3a49Z59qF
         SmrKBSrCyaeNYlUTZzc9BftzEB3g/k1SMQABfytzoRdLs2BdXrAt/V8bv3l6QaR78i
         Vf4eSZN6A9Q30ZtMgH5czdKOeR5KG/9qZZawsv1K4KCBebzhLy3Q/vyEETFoJiJpnl
         P568lh/1zKDFw==
Date:   Wed, 3 Feb 2021 00:43:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     ira.weiny@intel.com, Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86: Remove unnecessary kmap() from
 sgx_ioc_enclave_init()
Message-ID: <YBnVprvgr1GMa3CJ@kernel.org>
References: <20210202013725.3514671-1-ira.weiny@intel.com>
 <ba4adad5-754f-65b5-5dae-69dee6803a23@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba4adad5-754f-65b5-5dae-69dee6803a23@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 02, 2021 at 10:55:36AM -0800, Dave Hansen wrote:
> On 2/1/21 5:37 PM, ira.weiny@intel.com wrote:
> > kmap is inefficient and we are trying to reduce the usage in the kernel.
> > There is no readily apparent reason why the initp_page page needs to be
> > allocated and kmap'ed() but sigstruct needs to be page aligned and token
> > 512 byte aligned.
> 
> Hi Ira,
> 
> It's a *relatively* recent guaranteed, but:
> 
> https://www.kernel.org/doc/Documentation/core-api/memory-allocation.rst
> 
> says:
> 
> > The address of a chunk allocated with `kmalloc` is aligned to at least
> > ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
> > alignment is also guaranteed to be at least the respective size.
> 
> So, if you allocate a page with kmalloc(), you get an aligned page.  Yay!

And this what we do sgx_ioc_enclave_create() anyway, as I stated in my
earlier response. Better to use the same pattern everywhere consitently
when it makes sense.

/Jarkko
