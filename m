References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-12-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-12-jarkko.sakkinen@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 4 Sep 2018 20:59:58 +0300
Message-ID: <CAHp75VcqKunkHYNdd287_F7APHwYr7K9QD2PVCkqBqJWG2_E-g@mail.gmail.com>
Subject: Re: [PATCH v13 11/13] platform/x86: Intel SGX driver
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Darren Hart
	<dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, <ebiggers@google.com>, "Linux Kernel Mailing
 List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
>
> SGX driver provides a ioctl API for loading and initializing enclaves.
> Address range for enclaves is reserved with mmap() and they are
> destroyed with munmap(). Enclave construction, measurement and
> initialization is done with the provided the ioctl API.

> +/*
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
> + *
> + * Copyright(c) 2016-2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * Contact Information:
> + * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> + * Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
> + *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2016-2017 Intel Corporation.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *   * Redistributions of source code must retain the above copyright
> + *     notice, this list of conditions and the following disclaimer.
> + *   * Redistributions in binary form must reproduce the above copyright
> + *     notice, this list of conditions and the following disclaimer in
> + *     the documentation and/or other materials provided with the
> + *     distribution.
> + *   * Neither the name of Intel Corporation nor the names of its
> + *     contributors may be used to endorse or promote products derived
> + *     from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *

Can't we just put one line with SPDX identifier?

> + * Authors:

> + *

Redundant line.

> + * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> + * Suresh Siddha <suresh.b.siddha@intel.com>
> + */

> +/**

> + * struct sgx_enclave_add_page - parameter structure for the
> + *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl

I don't think multi-line would work nice for short description line.

> + * @addr:      address within the ELRANGE
> + * @src:       address for the page data
> + * @secinfo:   address for the SECINFO data
> + * @mrmask:    bitmask for the measured 256 byte chunks
> + */

> +config INTEL_SGX
> +       tristate "Intel(R) SGX Driver"

Spell SGX fully here.

> +       default n

Drop this.

> +++ b/drivers/platform/x86/intel_sgx/Makefile
> @@ -0,0 +1,13 @@
> +#
> +# Intel SGX
> +#

No SPDX?  (Same, btw, for Kconfig)

> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)

Should be /* */ in headers AFAIR.

Btw, shouldn't be this file rather under include/linux/platform_data/x86/ ?

> +#define sgx_pr_ratelimited(level, encl, fmt, ...)                      \
> +       pr_ ## level ## _ratelimited("[%d:0x%p] " fmt,                  \
> +                                    pid_nr((encl)->tgid),              \
> +                                    (void *)(encl)->base, ##__VA_ARGS__)
> +#define sgx_dbg(encl, fmt, ...) \
> +       sgx_pr_ratelimited(debug, encl, fmt, ##__VA_ARGS__)
> +#define sgx_info(encl, fmt, ...) \
> +       sgx_pr_ratelimited(info, encl, fmt, ##__VA_ARGS__)
> +#define sgx_warn(encl, fmt, ...) \
> +       sgx_pr_ratelimited(warn, encl, fmt, ##__VA_ARGS__)
> +#define sgx_err(encl, fmt, ...) \
> +       sgx_pr_ratelimited(err, encl, fmt, ##__VA_ARGS__)
> +#define sgx_crit(encl, fmt, ...) \
> +       sgx_pr_ratelimited(crit, encl, fmt, ##__VA_ARGS__)

Rate limited versions do not guarantee all info to be printed (as far
as I heard).
If you are going to use them everywhere it would be nice to see that
RL versions are in use.
So, please, add suffix _rl at least to your helper macros.

> +#define SGX_ENCL_PAGE_PCMD_OFFSET(encl_page, encl)             \
> +({                                                             \
> +       unsigned long ret;                                      \
> +       ret = SGX_ENCL_PAGE_BACKING_INDEX(encl_page, encl);     \

> +       ((ret & 31) * 128);                                     \

What these magic numbers are about?

> +})

> +#define SGX_INVD(ret, encl, fmt, ...)          \
> +do {                                           \
> +       if (WARN(ret, "sgx: " fmt, ##__VA_ARGS__))      \
> +               sgx_invalidate(encl, true);     \
> +} while (0)

Perhaps INVD -> INV as I can see as a pattern in kernel.

> +#include <asm/mman.h>

linux/* first

> +#include <linux/delay.h>
> +#include <linux/file.h>
> +#include <linux/hashtable.h>
> +#include <linux/highmem.h>
> +#include <linux/ratelimit.h>
> +#include <linux/sched/signal.h>
> +#include <linux/shmem_fs.h>
> +#include <linux/slab.h>
> +#include <linux/suspend.h>

> +                       if ((entry->desc & SGX_ENCL_PAGE_LOADED) &&
> +                           (entry->desc & SGX_ENCL_PAGE_TCS) &&
> +                           !sgx_encl_find(encl->mm, addr, &vma))

> +               if ((entry->desc & SGX_ENCL_PAGE_LOADED) &&
> +                   !(entry->desc & SGX_ENCL_PAGE_RECLAIMED)) {
> +                       if (!__sgx_free_page(entry->epc_page))
> +                               entry->desc &= ~SGX_ENCL_PAGE_LOADED;

> +static int sgx_measure(struct sgx_epc_page *secs_page,
> +                      struct sgx_epc_page *epc_page,
> +                      u16 mrmask)
> +{

> +       int ret = 0;

I would rather expect this to be closer to where it's used.

> +       void *secs;
> +       void *epc;
> +       int i;
> +       int j;
> +
> +       if (!mrmask)
> +               return ret;

return 0; ?

> +
> +       secs = sgx_epc_addr(secs_page);
> +       epc = sgx_epc_addr(epc_page);
> +

... ret = 0;

Actually, it's not needed, since you are always call __eextend() at
least once (see above check for !mrmask).

> +       for (i = 0, j = 1; i < 0x1000 && !ret; i += 0x100, j <<= 1) {
> +               if (!(j & mrmask))
> +                       continue;
> +
> +               ret = __eextend(secs, (void *)((unsigned long)epc + i));
> +       }

Can we rewrite this like

unsigned long tmp = mrmask;

for_each_set_bit(j, ...) {
 ret = ...(... + j * 0x100));
 if (ret)
  break;
}

?

> +       struct sgx_encl *encl;

> +       encl = container_of(work, struct sgx_encl, add_page_work);

Could this assignment be directly in definition block?

> +       } while (!kref_put(&encl->refcount, sgx_encl_release) && !is_empty);

isn't it the same as  !(... || ...) ?

> +}

> +static u32 sgx_calc_ssaframesize(u32 miscselect, u64 xfrm)
> +{
> +       u32 size_max = PAGE_SIZE;
> +       u32 size;
> +       int i;
> +

> +       for (i = 2; i < 64; i++) {
> +               if (!((1 << i) & xfrm))
> +                       continue;

DECLARE_BITMAP(tmp, 64);

tmp = bitmap_from_u64(tmp, xfrm & ~3);
for_each_set_bit(i, tmp) {
 ...
}

> +
> +               size = SGX_SSA_GPRS_SIZE + sgx_xsave_size_tbl[i];
> +               if (miscselect & SGX_MISC_EXINFO)
> +                       size += SGX_SSA_MISC_EXINFO_SIZE;

> +               if (size > size_max)
> +                       size_max = size;

size_max = max(size_max, size);

> +       }
> +

> +       return (size_max + PAGE_SIZE - 1) >> PAGE_SHIFT;

snd_sgbuf_aligned_pages() is the same. Perhaps time to create a helper
here and in the future it can be moved to some generic one?

Ooops, it's actually PFN_UP().

> +}
> +
> +static int sgx_validate_secs(const struct sgx_secs *secs,
> +                            unsigned long ssaframesize)
> +{
> +       int i;
> +
> +       if (secs->size < (2 * PAGE_SIZE) ||

> +           (secs->size & (secs->size - 1)) != 0)

is_power_of_2()

> +               return -EINVAL;
> +
> +       if (secs->base & (secs->size - 1))
> +               return -EINVAL;
> +
> +       if (secs->attributes & SGX_ATTR_RESERVED_MASK ||
> +           secs->miscselect & sgx_misc_reserved)
> +               return -EINVAL;

> +       if ((secs->xfrm & 0x3) != 0x3 || (secs->xfrm & ~sgx_xfrm_mask))
> +               return -EINVAL;

Some magic is here

> +
> +       /* Check that BNDREGS and BNDCSR are equal. */

> +       if (((secs->xfrm >> 3) & 1) != ((secs->xfrm >> 4) & 1))

Perhaps

(!!(... & BIT(3)) ^ !!(... & BIT(4))) ?

...and actually define those magic bits?

> +               return -EINVAL;
> +
> +       if (!secs->ssa_frame_size || ssaframesize > secs->ssa_frame_size)
> +               return -EINVAL;
> +

> +       for (i = 0; i < SGX_SECS_RESERVED1_SIZE; i++)
> +               if (secs->reserved1[i])
> +                       return -EINVAL;
> +
> +       for (i = 0; i < SGX_SECS_RESERVED2_SIZE; i++)
> +               if (secs->reserved2[i])
> +                       return -EINVAL;
> +
> +       for (i = 0; i < SGX_SECS_RESERVED3_SIZE; i++)
> +               if (secs->reserved3[i])
> +                       return -EINVAL;
> +
> +       for (i = 0; i < SGX_SECS_RESERVED4_SIZE; i++)
> +               if (secs->reserved4[i])
> +                       return -EINVAL;

Can you use memchr_inv() in all above cases?

> +       return 0;
> +}
> +

> +       struct sgx_encl *encl =
> +               container_of(mn, struct sgx_encl, mmu_notifier);

One line?

> +       backing = shmem_file_setup("[dev/sgx]", secs->size + PAGE_SIZE,
> +                                  VM_NORESERVE);
> +       if (IS_ERR(backing))

> +               return (void *)backing;

ERR_CAST() please.

> +       pcmd = shmem_file_setup("[dev/sgx]", (secs->size + PAGE_SIZE) >> 5,
> +                               VM_NORESERVE);
> +       if (IS_ERR(pcmd)) {
> +               fput(backing);

> +               return (void *)pcmd;

Ditto.

> +       }

> +int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> +{
> +       struct vm_area_struct *vma;
> +       struct sgx_pageinfo pginfo;
> +       struct sgx_secinfo secinfo;
> +       struct sgx_epc_page *secs_epc;
> +       long ret;
> +
> +       secs_epc = sgx_alloc_page(&encl->secs.impl, 0);
> +       if (IS_ERR(secs_epc)) {

> +               ret = PTR_ERR(secs_epc);
> +               return ret;

One line.

> +       }

> +       pginfo.addr = 0;
> +       pginfo.contents = (unsigned long)secs;
> +       pginfo.metadata = (unsigned long)&secinfo;
> +       pginfo.secs = 0;
> +       memset(&secinfo, 0, sizeof(secinfo));

+ blank line here.

> +       ret = __ecreate((void *)&pginfo, sgx_epc_addr(secs_epc));

> +

- blank line here.

> +       if (ret) {
> +               sgx_dbg(encl, "ECREATE returned %ld\n", ret);
> +               return ret;
> +       }

> +       down_read(&current->mm->mmap_sem);
> +       ret = sgx_encl_find(current->mm, secs->base, &vma);

> +       if (ret != -ENOENT) {

> +               if (!ret)
> +                       ret = -EINVAL;

> +               return ret;

return ret ? ret : -EINVAL;

> +       }

> +}

> +       for (i = 0; i < SGX_SECINFO_RESERVED_SIZE; i++)
> +               if (secinfo->reserved[i])
> +                       return -EINVAL;

memchr_inv() ?

> +       if (offset & (PAGE_SIZE - 1))
> +               return false;

~PAGE_MASK ?

> +       if ((tcs->fs_limit & 0xFFF) != 0xFFF)
> +               return -EINVAL;
> +
> +       if ((tcs->gs_limit & 0xFFF) != 0xFFF)
> +               return -EINVAL;

Are they ~PAGE_MASK as well? Please define properly.

> +       if (sgx_validate_secinfo(secinfo))
> +               return -EINVAL;

+ blank line

> +       if (page_type == SGX_SECINFO_TCS) {
> +               ret = sgx_validate_tcs(encl, data);
> +               if (ret)
> +                       return ret;
> +       }

+ blank line

> +       ret = sgx_encl_grow(encl);
> +       if (ret)
> +               return ret;

+ blank line

> +       mutex_lock(&encl->lock);
> +       if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
> +               mutex_unlock(&encl->lock);
> +               return -EINVAL;
> +       }

+ blank line

> +       encl_page = sgx_encl_alloc_page(encl, addr);
> +       if (IS_ERR(encl_page)) {
> +               mutex_unlock(&encl->lock);
> +               return PTR_ERR(encl_page);
> +       }

+ blank line

> +       ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
> +       if (ret)
> +               sgx_encl_free_page(encl_page);

+ blank line

> +       mutex_unlock(&encl->lock);

> +       u64 mrsigner[4];

Magic 4.

> +       for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> +               for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> +                       ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> +                                       mrsigner);

> +                       if (ret == SGX_UNMASKED_EVENT)
> +                               continue;

> +                       else
> +                               break;

Seems redundant

> +               }

> +       while (!list_empty(&encl->va_pages)) {
> +               va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> +                                          list);

list_for_each_entry_safe() ?

> +               list_del(&va_page->list);
> +               sgx_free_page(va_page->epc_page);
> +               kfree(va_page);
> +       }

--
With Best Regards,
Andy Shevchenko
