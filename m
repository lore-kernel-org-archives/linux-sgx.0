Return-Path: <SRS0=W5EA=EK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94989C2D0A3
	for <linux-sgx@archiver.kernel.org>; Wed,  4 Nov 2020 18:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED7E20732
	for <linux-sgx@archiver.kernel.org>; Wed,  4 Nov 2020 18:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="kgRCcN5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgKDSVn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:21:43 -0500
Received: from mail.skyhub.de ([5.9.137.197]:37342 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729488AbgKDSVn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 4 Nov 2020 13:21:43 -0500
Received: from zn.tnic (p200300ec2f0ef400317dde2deb3fed11.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:f400:317d:de2d:eb3f:ed11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1F1851EC0324;
        Wed,  4 Nov 2020 19:21:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604514101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GpmWgyEf2ElSP4jnHUhAmP7K3AwEb5iwpZy9KQW/2fw=;
        b=kgRCcN5iQL3yrVMpe6J1MvxgIOk9zsQZFQiqVmReeUAGRwwAnG4vqDRlGiEqCMeo1lJipj
        dixIQSc9mXOEaflMExAQZXZNDYV2TjGgpOTFYYnK8UNUD3j10wl0C1gdAfaiO69Ml3exMJ
        Dm7jhq/kwNbSTKXohglMkmVI3UVS48A=
Date:   Wed, 4 Nov 2020 19:21:29 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 03/24] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20201104182129.GD23298@zn.tnic>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104145430.300542-4-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 04, 2020 at 04:54:09PM +0200, Jarkko Sakkinen wrote:
> +static void __init sgx_init(void)
> +{
> +	int i;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX))

Guys, you need to build-test *every* *single* patch - otherwise we break
bisectability and that is a no-no:

arch/x86/kernel/cpu/sgx/main.c: In function ‘sgx_init’:
arch/x86/kernel/cpu/sgx/main.c:172:20: error: ‘X86_FEATURE_SGX’ undeclared (first use in this function); did you mean ‘X86_FEATURE_SMX’?
  172 |  if (!boot_cpu_has(X86_FEATURE_SGX))
      |                    ^~~~~~~~~~~~~~~
./arch/x86/include/asm/cpufeature.h:118:24: note: in definition of macro ‘cpu_has’
  118 |  (__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : \
      |                        ^~~
arch/x86/kernel/cpu/sgx/main.c:172:7: note: in expansion of macro ‘boot_cpu_has’
  172 |  if (!boot_cpu_has(X86_FEATURE_SGX))
      |       ^~~~~~~~~~~~
arch/x86/kernel/cpu/sgx/main.c:172:20: note: each undeclared identifier is reported only once for each function it appears in
  172 |  if (!boot_cpu_has(X86_FEATURE_SGX))
      |                    ^~~~~~~~~~~~~~~
./arch/x86/include/asm/cpufeature.h:118:24: note: in definition of macro ‘cpu_has’
  118 |  (__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : \
      |                        ^~~
arch/x86/kernel/cpu/sgx/main.c:172:7: note: in expansion of macro ‘boot_cpu_has’
  172 |  if (!boot_cpu_has(X86_FEATURE_SGX))
      |       ^~~~~~~~~~~~
make[4]: *** [scripts/Makefile.build:283: arch/x86/kernel/cpu/sgx/main.o] Error 1
make[3]: *** [scripts/Makefile.build:500: arch/x86/kernel/cpu/sgx] Error 2
make[2]: *** [scripts/Makefile.build:500: arch/x86/kernel/cpu] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:500: arch/x86/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1799: arch/x86] Error 2
make: *** Waiting for unfinished jobs....

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
