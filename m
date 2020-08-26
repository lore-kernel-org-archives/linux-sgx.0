Return-Path: <SRS0=/5Ao=CE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E8CC433E3
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 14:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A58B122B47
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Aug 2020 14:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="C9cifg0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgHZOws (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:52:48 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43130 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgHZOwp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Aug 2020 10:52:45 -0400
Received: from zn.tnic (p200300ec2f0cee00b9d687b85fd363f9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:ee00:b9d6:87b8:5fd3:63f9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 75F681EC0347;
        Wed, 26 Aug 2020 16:52:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598453562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jnsI/iKNmqsnOjPIZNdv4vnNfxJjeQ2wcvfdfUU1q0Y=;
        b=C9cifg0tLhB4V2DukbiUnvLsZKGU3rGL+iqq1vZ5Xb4ptofIdUpqe1J4oHKWyTq+S/ybrZ
        mxOSh8gF/AQsmCKeaBbyQY8uy8wgt9hWES9YJc91bh7fqaFwwrgGbjyh1dKgIb5+Ixy1P6
        /nxSYaBvAQ0N9NP68DG2coKAFVN63ac=
Date:   Wed, 26 Aug 2020 16:52:39 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
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
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200826145239.GC22390@zn.tnic>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 16, 2020 at 04:52:51PM +0300, Jarkko Sakkinen wrote:
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 59472cd6a11d..35f713e3a267 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)

Again, maybe add <mailto:linux-sgx@vger.kernel.org> ?

This is from a previous review - please be more careful when addressing
review comments - either do them or object to them but silently ignoring
them is not cool.

>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..3787d278e84b
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

checkpatch is not happy about something:

WARNING: 'SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */' is not supported in LICENSES/...
#79: FILE: arch/x86/include/uapi/asm/sgx.h:1:
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */

...

> +/**
> + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> + * @filep:	open file to /dev/sgx

Also from a previous review:

"That's

@encl: enclave pointer

or so."

> + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> + *
> + * Allocate kernel data structures for a new enclave and execute ECREATE after
> + * verifying the correctness of the provided SECS.
> + *
> + * Note, enforcement of restricted and disallowed attributes is deferred until
> + * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
> + * checked by sgx_ioc_enclave_create().

From that same review:

"Well, I don't see that checking. Where is it?"

Ok, I'm going to stop here. Please go over v33's review and either
address *all* feedback or incorporate it into your patches if you agree
with it but do not silently ignore it. One of the things I very strongly
detest is ignored review comments.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
