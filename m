Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AC2C10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 17:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C13521835
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 17:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="nDSySf/u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfJHR7a (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 13:59:30 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52344 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfJHR73 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 13:59:29 -0400
Received: from zn.tnic (p200300EC2F0B51004985F04ADA683F0C.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5100:4985:f04a:da68:3f0c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0BDE51EC095C;
        Tue,  8 Oct 2019 19:59:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570557567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5C8Trcl0YLswcFrT8Bhf5kBQud4Vu+vDhH2kLkHcJuk=;
        b=nDSySf/uUwT+ndWu541wKERvD5OnJ+exQ/jyvN4JcOMybHJbbQ+X7rRSUBhsuI44eSItpQ
        n+izUaYjoyHhB2PUom5qUKuznPI8c6VdgbXmmgHNy7ImbBDU87Um2Di+DK5Sm5YQ2KN8Ip
        x85qZLV039SWANBrTEV5lBvNAxMxysU=
Date:   Tue, 8 Oct 2019 19:59:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v22 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191008175924.GN14765@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190903142655.21943-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> Subject: Re: [PATCH v22 12/24] x86/sgx: Linux Enclave Driver

Title needs a verb: "Add a Linux ... "

On Tue, Sep 03, 2019 at 05:26:43PM +0300, Jarkko Sakkinen wrote:
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
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  Documentation/ioctl/ioctl-number.rst  |   1 +
>  arch/x86/include/uapi/asm/sgx.h       |  55 +++
>  arch/x86/include/uapi/asm/sgx_errno.h |   2 +-
>  arch/x86/kernel/cpu/sgx/Makefile      |   6 +-
>  arch/x86/kernel/cpu/sgx/driver.c      | 251 +++++++++++
>  arch/x86/kernel/cpu/sgx/driver.h      |  37 ++
>  arch/x86/kernel/cpu/sgx/encl.c        | 365 +++++++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h        | 100 +++++
>  arch/x86/kernel/cpu/sgx/ioctl.c       | 612 ++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/main.c        |  25 +-
>  arch/x86/kernel/cpu/sgx/reclaim.c     |   2 +-
>  arch/x86/kernel/cpu/sgx/sgx.h         |   1 +
>  12 files changed, 1444 insertions(+), 13 deletions(-)

That's a fat one. :)

>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
> 
> diff --git a/Documentation/ioctl/ioctl-number.rst b/Documentation/ioctl/ioctl-number.rst
> index 7f8dcae7a230..83df9c17c127 100644
> --- a/Documentation/ioctl/ioctl-number.rst
> +++ b/Documentation/ioctl/ioctl-number.rst
> @@ -320,6 +320,7 @@ Code  Seq#    Include File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..c45eeed68144
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

checkpatch is bitching for some reason, I guess it doesn't like the
"WITH" thing or so:

WARNING: 'SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */' is not supported in LICENSES/...
#98: FILE: arch/x86/include/uapi/asm/sgx.h:1:
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

WARNING: 'SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause WITH Linux-syscall-note */' is not supported in LICENSES/...
#159: FILE: arch/x86/include/uapi/asm/sgx_errno.h:1:
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause WITH Linux-syscall-note */

And building this fails:

arch/x86/kernel/cpu/sgx/encl.c: In function ‘sgx_mmu_notifier_release’:
arch/x86/kernel/cpu/sgx/encl.c:77:3: error: implicit declaration of function ‘mmu_notifier_unregister_no_release’; did you mean ‘mmu_notifier_unregister’? [-Werror=implicit-function-declaration]
   mmu_notifier_unregister_no_release(mn, mm);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mmu_notifier_unregister
arch/x86/kernel/cpu/sgx/encl.c:78:3: error: implicit declaration of function ‘mmu_notifier_call_srcu’; did you mean ‘mmu_notifier_release’? [-Werror=implicit-function-declaration]
   mmu_notifier_call_srcu(&encl_mm->rcu,
   ^~~~~~~~~~~~~~~~~~~~~~
   mmu_notifier_release
cc1: some warnings being treated as errors
make[4]: *** [scripts/Makefile.build:265: arch/x86/kernel/cpu/sgx/encl.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [scripts/Makefile.build:509: arch/x86/kernel/cpu/sgx] Error 2
make[2]: *** [scripts/Makefile.build:509: arch/x86/kernel/cpu] Error 2
make[1]: *** [scripts/Makefile.build:509: arch/x86/kernel] Error 2
make: *** [Makefile:1670: arch/x86] Error 2
make: *** Waiting for unfinished jobs....

Got a fixed version which I can review instead?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
