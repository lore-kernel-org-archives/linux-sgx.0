Return-Path: <SRS0=1rnR=CD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758B3C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 16:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55FF920706
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 16:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="n3XzR9wj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgHYQoX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Aug 2020 12:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHYQoX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Aug 2020 12:44:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209CFC061574;
        Tue, 25 Aug 2020 09:44:23 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c5a009557515e5e730b1a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:5a00:9557:515e:5e73:b1a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0475A1EC02F2;
        Tue, 25 Aug 2020 18:44:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598373856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UbGRBBMOM4Q+XbRJRW9yoJJWM1PqXnrPAdAFhJ8j8HI=;
        b=n3XzR9wjuhdBeQAChl71tjSERzGHM/7ChjhMLTpdK0tjwwXSW7ZSaBUPzhMRAF+t37OVsZ
        pbqX76gRFEZlONdkGnDHJVQfVFuGc1kZk8gG7HHsXP6hHxdTwG1ycidTBcirjy3HJJ4zkB
        FDspO26JvSPEAuNQvaEZcICBzHoID2c=
Date:   Tue, 25 Aug 2020 18:44:12 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20200825164412.GF12107@zn.tnic>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-12-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200716135303.276442-12-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 16, 2020 at 04:52:50PM +0300, Jarkko Sakkinen wrote:

Just minor things below - I'm not even going to pretend I fully
understand what's going on but FWICT, it looks non-threateningly ok to
me.

> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> new file mode 100644
> index 000000000000..b52520407f5b
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -0,0 +1,177 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#include <linux/acpi.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mman.h>
> +#include <linux/security.h>
> +#include <linux/suspend.h>
> +#include <asm/traps.h>
> +#include "driver.h"
> +#include "encl.h"
> +
> +MODULE_DESCRIPTION("Intel SGX Enclave Driver");
> +MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
> +MODULE_LICENSE("Dual BSD/GPL");

That boilerplate stuff usually goes to the end of the file.

...

> +static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
> +						unsigned long addr)
> +{
> +	struct sgx_encl_page *entry;
> +	unsigned int flags;
> +
> +	/* If process was forked, VMA is still there but vm_private_data is set
> +	 * to NULL.
> +	 */
> +	if (!encl)
> +		return ERR_PTR(-EFAULT);
> +
> +	flags = atomic_read(&encl->flags);
> +

^ Superfluous newline.

> +	if ((flags & SGX_ENCL_DEAD) || !(flags & SGX_ENCL_INITIALIZED))
> +		return ERR_PTR(-EFAULT);
> +
> +	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
> +	if (!entry)
> +		return ERR_PTR(-EFAULT);
> +
> +	/* Page is already resident in the EPC. */
> +	if (entry->epc_page)
> +		return entry;
> +
> +	return ERR_PTR(-EFAULT);
> +}
> +
> +static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
> +				     struct mm_struct *mm)
> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(mn, struct sgx_encl_mm, mmu_notifier);

Just let it stick out.

> +	struct sgx_encl_mm *tmp = NULL;
> +
> +	/*
> +	 * The enclave itself can remove encl_mm.  Note, objects can't be moved
> +	 * off an RCU protected list, but deletion is ok.
> +	 */
> +	spin_lock(&encl_mm->encl->mm_lock);
> +	list_for_each_entry(tmp, &encl_mm->encl->mm_list, list) {
> +		if (tmp == encl_mm) {
> +			list_del_rcu(&encl_mm->list);
> +			break;
> +		}
> +	}
> +	spin_unlock(&encl_mm->encl->mm_lock);
> +
> +	if (tmp == encl_mm) {
> +		synchronize_srcu(&encl_mm->encl->srcu);
> +		mmu_notifier_put(mn);
> +	}
> +}
> +
> +static void sgx_mmu_notifier_free(struct mmu_notifier *mn)
> +{
> +	struct sgx_encl_mm *encl_mm =
> +		container_of(mn, struct sgx_encl_mm, mmu_notifier);

Ditto.

...

> +/**
> + * sgx_encl_may_map() - Check if a requested VMA mapping is allowed
> + * @encl:		an enclave
> + * @start:		lower bound of the address range, inclusive
> + * @end:		upper bound of the address range, exclusive
> + * @vm_prot_bits:	requested protections of the address range
> + *
> + * Iterate through the enclave pages contained within [@start, @end) to verify
> + * the permissions requested by @vm_prot_bits do not exceed that of any enclave
> + * page to be mapped.
> + *
> + * Return:
> + *   0 on success,
> + *   -EACCES if VMA permissions exceed enclave page permissions
> + */
> +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> +		     unsigned long end, unsigned long vm_flags)
> +{
> +	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
> +	unsigned long idx_start = PFN_DOWN(start);
> +	unsigned long idx_end = PFN_DOWN(end - 1);
> +	struct sgx_encl_page *page;
> +	XA_STATE(xas, &encl->page_array, idx_start);
> +
> +	/*
> +	 * Disallow RIE tasks as their VMA permissions might conflict with the

"RIE", hmm what is that?

/me looks at the test

Aaah, READ_IMPLIES_EXEC. Is "RIE" some widely accepted acronym I'm not
aware of?

> +	 * enclave page permissions.
> +	 */
> +	if (!!(current->personality & READ_IMPLIES_EXEC))

The "!!" is not really needed - you're in boolean context.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
