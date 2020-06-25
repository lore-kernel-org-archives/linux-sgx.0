Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D5C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B86BA20789
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="DPhYaS7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405897AbgFYSxh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:53:37 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36834 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405853AbgFYSxh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 14:53:37 -0400
Received: from zn.tnic (p200300ec2f0ed100359123de3d1ebdc6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:3591:23de:3d1e:bdc6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 821C21EC03E4;
        Thu, 25 Jun 2020 20:53:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593111215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cq3LKrRKJepHltbyBKhbhBaUgzsdqiaXd/tjkJyN1n0=;
        b=DPhYaS7IuP6FQrvef2Yeoymx/XJnTO2nXLvxzCWexN3YYNoNlu/FKFUW8eH2BHK4WGjTNS
        6PRYRcQ3dZdfQuH/Xnw5oLl4jo+eFabEJg39tyzGuKM6857nX2zp/pF4W47Ug19ifoFXk3
        7OUJTwAE66U9gqY4Kzv3U/3Mb6LtYr0=
Date:   Thu, 25 Jun 2020 20:53:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200625185334.GN20319@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:

> Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
					 ^
					 Add

> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the SGX hosted software entity is disallowed to
> access the memory inside the enclave enforced by the CPU. We call these
> entities as enclaves.

s/as //

> This commit implements a driver that provides an ioctl API to construct

s/This commit implements/Implement/

> and run enclaves. Enclaves are constructed from pages residing in
> reserved physical memory areas. The contents of these pages can only be
> accessed when they are mapped as part of an enclave, by a hardware
> thread running inside the enclave.
> 
> The starting state of an enclave consists of a fixed measured set of
> pages that are copied to the EPC during the construction process by
> using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> that defines the enclave properties.
> 
> Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and

Enclaves

> EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> the EPC and EINIT check a given signed measurement and moves the enclave

		   checks

> into a state ready for execution.
> 
> An initialized enclave can only be accessed through special Thread Control
> Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
> function converts a thread into enclave mode and continues the execution in
> the offset defined by the TCS provided to EENTER. An enclave is exited
> through syscall, exception, interrupts or by explicitly calling another
> ENCLU leaf EEXIT.
> 
> The permissions, which enclave page is added will set the limit for maximum
> permissions that can be set for mmap() and mprotect().

I can't parse that sentence.

> This will
> effectively allow to build different security schemes between producers and
> consumers of enclaves. Later on we can increase granularity with LSM hooks
> for page addition (i.e. for producers) and mapping of the enclave (i.e. for
> consumers)

Other than that, nice explanation. I like that in a commit message.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
