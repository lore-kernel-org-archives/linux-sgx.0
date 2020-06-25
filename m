Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23BEC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84C120773
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="oceytPbQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404464AbgFYRXW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 13:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404378AbgFYRXW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Jun 2020 13:23:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB0DC08C5C1;
        Thu, 25 Jun 2020 10:23:21 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ed10035c3b797f40e07e6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:35c3:b797:f40e:7e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 505511EC0105;
        Thu, 25 Jun 2020 19:23:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593105800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RsPV80ovuBQyjV3JETbCO3+U21IlLqQzHxfyrPrXILg=;
        b=oceytPbQR4/9ftJEGtyr+12eppSB7joaYfaVUsxYW4O8P3EbqcTyeXqusCXjRGRflpxYba
        uCphPRqdPgSmUryxhr1A3bfIUv6NcVpsxyDcybOLYwnEoMxHzDWC74Q98UPGQAQmw+W4Z1
        /NCQ1jPAHd9OWvBo64+sNYKGU2soWNk=
Date:   Thu, 25 Jun 2020 19:23:19 +0200
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
Message-ID: <20200625172319.GJ20319@zn.tnic>
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
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the SGX hosted software entity is disallowed to
> access the memory inside the enclave enforced by the CPU. We call these
> entities as enclaves.
> 
> This commit implements a driver that provides an ioctl API to construct
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
> EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> the EPC and EINIT check a given signed measurement and moves the enclave
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
> permissions that can be set for mmap() and mprotect(). This will
> effectively allow to build different security schemes between producers and
> consumers of enclaves. Later on we can increase granularity with LSM hooks
> for page addition (i.e. for producers) and mapping of the enclave (i.e. for
> consumers)
> 
> Cc: linux-security-module@vger.kernel.org
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> Tested-by: Seth Moore <sethmo@google.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  arch/x86/include/uapi/asm/sgx.h               |  66 ++
>  arch/x86/kernel/cpu/sgx/Makefile              |   3 +
>  arch/x86/kernel/cpu/sgx/driver.c              | 194 +++++
>  arch/x86/kernel/cpu/sgx/driver.h              |  30 +
>  arch/x86/kernel/cpu/sgx/encl.c                | 335 +++++++++
>  arch/x86/kernel/cpu/sgx/encl.h                |  87 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c               | 706 ++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/main.c                |  11 +
>  9 files changed, 1433 insertions(+)
>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 59472cd6a11d..35f713e3a267 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..5edb08ab8fd0
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,66 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

Checkpatch complains here:

WARNING: 'SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */' is not supported in LICENSES/...
#114: FILE: arch/x86/include/uapi/asm/sgx.h:1:
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

Also, you had all patches until now split nice and logically doing one
thing only.

But this one is huge. Why?

Why can't you split out the facilities which the driver uses: encl.[ch]
into a patch, then ioctl.c into a separate one and then the driver into
a third one? Or do they all belong together inseparably?

I guess I'll find out eventually but it would've been nice if they were
split out...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
