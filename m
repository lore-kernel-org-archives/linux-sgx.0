Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3ABC04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 14:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7221B2784B
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 14:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="EZWAM9xv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfFCOTx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 10:19:53 -0400
Received: from ucol19pa12.eemsg.mail.mil ([214.24.24.85]:14992 "EHLO
        UCOL19PA12.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfFCOTx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Jun 2019 10:19:53 -0400
X-EEMSG-check-017: 24834249|UCOL19PA12_EEMSG_MP10.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="24834249"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA12.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 03 Jun 2019 14:19:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559571564; x=1591107564;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=t1ahy3/qQCREjC8J7NW0L+m1VfIso8RwXsC8bRQoZqk=;
  b=EZWAM9xvxQnospR88SoHeQ8AWD6f/G7thTeR6wRB/Pn1atJjdZBoQf+c
   YwEsvF8AG79J2Sjfb0gQ5JW+oI2lbnInlWDOy/M1aXDMmmpDMOkHaH5Cg
   xRqEVnucRJLeL0Mgwvy5/ppWvUQz/luXcrxK7ayA1SAlpZeaCO7TW68yg
   D/fc9nM9viXt3SuFkfNjgAS/dEaLJoA+wHAVnPMX4ebmxnuguJteOunMF
   +sWl7AHQS7lSEyB+hMNucKQZJg1FIAMBoMBl6tYqCudcYVpJUZlAYeup/
   IM82hi+OTxCJgb6xWrpJxlhnYtjR/HJDpQkqNPYNlqngd30QNKD33YoZU
   g==;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="24328298"
IronPort-PHdr: =?us-ascii?q?9a23=3AVKWXQxVvHCKqj8j9YiGa9wVNMO/V8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZhOEvqdThVPEFb/W9+hDw7KP9fy5ACpZusnK7iBKWacPfi?=
 =?us-ascii?q?dNsd8RkQ0kDZzNImzAB9muURYHGt9fXkRu5XCxPBsdMs//Y1rPvi/6tmZKSV?=
 =?us-ascii?q?3wOgVvO+v6BJPZgdip2OCu4Z3TZBhDiCagbb9oIxi6sBjdutMLjYZsKKs9xR?=
 =?us-ascii?q?rEr3hVcOlK2G1kIk6ekQzh7cmq5p5j9CpQu/Ml98FeVKjxYro1Q79FAjk4Km?=
 =?us-ascii?q?45/MLkuwXNQguJ/XscT34ZkgFUDAjf7RH1RYn+vy3nvedgwiaaPMn2TbcpWT?=
 =?us-ascii?q?S+6qpgVRHlhDsbOzM/7WrakdJ7gr5Frx29phx/24/Ub5+TNPpiZaPWYNcWSX?=
 =?us-ascii?q?NcUspNSyBNB4WxYIUVD+oFIO1WsY/zqVUTphe6HAWgGufixjpOi3Tr36M1zv?=
 =?us-ascii?q?4hHBnb0gI+EdIAsHfaotv7O6gdU++60KbGwC7fb/5Uwzrx9JTEfx4jrPyKQL?=
 =?us-ascii?q?l+cdDRyU4qFw7dk1uQtZLqPyuV1usTtWiQ8vduVee1hG4jrwF+vDiuzdorh4?=
 =?us-ascii?q?nSm40V0UvJ9Tl5wYkpJd24T1R3Ydi/EJRKrS2aOIx2Qt07TmxupS00xLoGuZ?=
 =?us-ascii?q?uhcygLzpQq3x3fZOKdc4iO/B3jUPydITBihHJqfr+0mhW88VC4x+HhWcS530?=
 =?us-ascii?q?xGoypYntXWqHwA2ALf5tKaRvZ740yvwyyA1xrJ5eFBOU00kK3bJIM/zbMojZ?=
 =?us-ascii?q?oTtFjDHjfxmEXrkK+abkUk9fas6+TgerjmuoWTN5V1igHjKaQigNC/AOQkPQ?=
 =?us-ascii?q?gOWGiX4+K826H4/ULlWrlKi/w2kq3BvJDbI8QUuLK5DhdI3oss5BuzFTer3M?=
 =?us-ascii?q?kCkXUZI19JZgiLg5XxN1HLOv/4DPO/g1q2kDdswvDLJqbhDYjWLnXYjLfgfa?=
 =?us-ascii?q?py605byAYpy9Bf/IhbBqsOIPL0RE/9rMbYAQMhMwyo3+bnD81w1pgAVm2VBK?=
 =?us-ascii?q?+VKqHSvUWU6eIvOemMZZQVuCr6K/g95/7hk2U5mUQafamvxpYXaXa4Huh4LE?=
 =?us-ascii?q?Wde3bjntABEWIStAokUOPqkEGCUSJUZ3uqXaIz/Cs7CIGlDYfEXIytm6aO3C?=
 =?us-ascii?q?S4Hp1XYGBJFFaMHGzsd4WFXfcMdS2TLtVgkjwCSbiuVYsh2Quyuw/9zrptNv?=
 =?us-ascii?q?DU9TEAtZL/yNh14PXelRUv9TxoCMSQyGKNQH9unmMOWTA22LpzoUtnyleMya?=
 =?us-ascii?q?J4meBXFcRP5/NVVQc3LYLTwPJnBNDoWwLOYs2FSVmnQtWgDjE8VdMxw9kSY0?=
 =?us-ascii?q?ljH9WulAzM3y2vA7UNjbyEGIQ08r7A33j2P8t9yXPG1K47j1k8Q8tPLnarhq?=
 =?us-ascii?q?hl+AjWGYHJkl+Vl6GwdaQTxCTN7nuMzXKSvEFEVw59Sb7FUm4FZkvZs9v0/U?=
 =?us-ascii?q?PCQKWqCbQjMgpBz9SOJbdNat3slV9GXuvsOMzCY2KtnGe9HRKIxrKKbIr3dG?=
 =?us-ascii?q?QRxT7dB1YYnAAO53aGNBQ+Bye4r2LbCzxhCE/vY0fy/uRltnO7QVE7zxuQY0?=
 =?us-ascii?q?1iybW14BgViuKYS/8J2bIEoighoS1uHFmhx9LWF8aApw15caVEe9w9/VNH2H?=
 =?us-ascii?q?nBtwNnI5ygK7luhlsZcwRwpUPhyQ97BZlHkcgvtHkq1hZ9KbqE0FNdcDOVxY?=
 =?us-ascii?q?7/OqXNJWno/RCvcLXb2knE39aM+6cP8+w4q1H5sw61CEUu6XJn08Na03GE/J?=
 =?us-ascii?q?XFEBISUY7tUkYw7xV6vK/VYi0854PSyH1tPrK5siHN2903Husp0BWgcMlFMK?=
 =?us-ascii?q?OCCgDyF9cWB8+0KOwlg1KpdA4LPPhO9K4oOMOrb/mG17C3POZghjKmin9K4I?=
 =?us-ascii?q?560kKW6ypzUOjI35cKwv2CwgSHUDL8hk+7ss/rgYBEeS0SHm2nxCf5HoFReL?=
 =?us-ascii?q?N9cZwLCWi0Jc233ctxh5j2Vn5Z8l6jG00J2MuzdRWOaFz92BVa1V4Lrny/hS?=
 =?us-ascii?q?u40zt0nik1rqqQ2CzPzP/vdB4GOm5NWWlikU3sIY+yj9AbU0mkdRUmmwW970?=
 =?us-ascii?q?bg26dbvLh/L3XUQUpQYyj2KHtiUrWqubqGfsFP84glsSFWUOS6fFCbRafxox?=
 =?us-ascii?q?Ud0yP+GWtR2So0dy2rupX+mRx2kmWdLGx8rHDBY8F/2Q/f5MDARf5WxjcGQC?=
 =?us-ascii?q?h4iT/KBlmzJtWp/subl43Fsu+gU2KsTYNTcSb1woOarie75nNlAQe5n/+tnt?=
 =?us-ascii?q?3rCw860TX019NyTyXHsA78YpX316S9Ke9mcUplCV7n5sp5BI5+iI0wi48U2X?=
 =?us-ascii?q?QAgZWV53UHm3/pMdpHwaL+cGYNRTkTzt7R4Qjl3lBjL32Qy4LiWXWczdBsZ8?=
 =?us-ascii?q?e1YmwIwCIx9cNKB7mO7LxCgyR1pkC0rQXLYfhyhj0d0+ch6GYGg+EVvwog1j?=
 =?us-ascii?q?+SArMKHUldJiHskxWI79ajrKRYfWqvf7+w1Fd4nd+8Fr6CvgBcWHH/eps4Gi?=
 =?us-ascii?q?9w9Mp/OkrW0HLv8oHkZMXQbdULux2SkxfAiPJVKJcrmfoMnidnI3zysmAly+?=
 =?us-ascii?q?EhkRxix421vI+CK2915qK2HgZYNiHpZ8MU4jzti75ensOK0I+zBJphHjELXI?=
 =?us-ascii?q?btTf+zCjIdq+noNwaUHz0gsHuUBb3fHQqH4kd8s33PC4yrN22QJHQB1tVtWg?=
 =?us-ascii?q?OdJENBjwwORjo7npk5Fh2sxMH6cUd54CwR6UD8qhdW1u1oMBz/WH/FpAi0cj?=
 =?us-ascii?q?c0VISfLB1O4wFZ50faK8yf4vhwHy5C4p2grRWBK22BaARNDGEJQFeJB1HlPr?=
 =?us-ascii?q?my+9bA9/KUCfa5L/vLeb+Os/BRV++UxZKz1Ytr5zaMOd+OPnl+FfI73VBPXX?=
 =?us-ascii?q?BkG8vDnTUPRDcalyPLb86Huhi8/jd7ody48PTuQAjv/5eAC6NOMdVz/BC7mb?=
 =?us-ascii?q?2MN+iNiyZjKDZZ1okAxWTIyLcBwl4dlyFueCerEbQDsi7AV6bQmq5RDx4GZC?=
 =?us-ascii?q?J/LspI76Qg3gZTPc7XkM/61rl9jvQtEVdKSUThmt21ZcwNO2y9N0nIBEeROL?=
 =?us-ascii?q?SdOz3E2cH3YaWnRL1RiuVUqwO/uTKBH0D/OTSDkiHjVwqzPuFUkCGbIBtetZ?=
 =?us-ascii?q?mmfRZ1EmXsVtbmahylP99xjjA626A7iW3SP24GLTd8a19NrqGX7S5AgPV/HH?=
 =?us-ascii?q?dB7np+IOmGnCaZ9OnYKooMsftqGiR0k/xV4Ggmy7dP6yFEXvN1kjPIrtFyu1?=
 =?us-ascii?q?GmjvWPyj1/XRpNsDlLhZiHvUV/OarD8JlAVm3J/BML7WWMFRsKo8FpBcHou6?=
 =?us-ascii?q?BV0tLPjr78KC9e89LI+ssRH9LUKMOZP3onLRrpGiDbDBAeQD6kMmHfgENdkP?=
 =?us-ascii?q?WM+XGPspc6rZ3skoIUSrBHTFw1Cu8aCkN9Ed0MIZd3Wjckkb+Bg84N/3axsA?=
 =?us-ascii?q?PdRN9dvp/cSP2SG+nvKC2CgLlFYRsI3a33LYAJOoLn3Exib0FwnJ7WFErIQd?=
 =?us-ascii?q?BNviphYxcsoEVN8Xh+Smwz21r/Zgy2+nMTCeS0nh8qhQRie+sg7zbs41ErJl?=
 =?us-ascii?q?XUoCs8ilU+mdLggWPZTDmkF6q5W8l9CzD1rFQ2KpP2WR1ya0XmhkFtMnHGAb?=
 =?us-ascii?q?lRlbp7aWdziALGopxJMf9aUaBAJhQXwKfTL9chy1dfrW2czExE5O3ID9M2lg?=
 =?us-ascii?q?Iwcp2r6WlJ2AFiatMzDajRIrdZiFlWmq+K+CSv07Zi7hUZIhM27G6KeCMO8H?=
 =?us-ascii?q?cNP70iKjvgqvdg8iSeijBDfy4KTPNsrfV0oBBuc9+cxj7thuYQYnu6MPaSeu?=
 =?us-ascii?q?bA4TnN?=
X-IPAS-Result: =?us-ascii?q?A2BYAwDUKvVc/wHyM5BcChwBAQEEAQEHBAEBgWWBZypqU?=
 =?us-ascii?q?QEyKIQUkwZSBoE1iVCRCAkBAQEBAQEBAQEtBwECAQGEQAKDEiM4EwEDAQEBB?=
 =?us-ascii?q?AEBAQEDAQFsHAyCOikBgmYBAQEBAgEjBBFBBQsLGAICJgICVwYBDAYCAQGCU?=
 =?us-ascii?q?ww/AYF2BQ8PqVB+M4VHgx2BQAaBDCiLWhd4gQeBOIFtSTU+gmEEgTQLAQGDK?=
 =?us-ascii?q?IJYBIspgkCGCZQdagmCD4IYhCeMbQYbgiKKc4lZLYxTgSmFYpEhIYFYKwgCG?=
 =?us-ascii?q?AghD4MnghsXiGGFWyMDMAEBgQQBAY17DxcDgikBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 03 Jun 2019 14:19:23 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x53EJISv004333;
        Mon, 3 Jun 2019 10:19:19 -0400
Subject: Re: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook for
 Intel SGX
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-9-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <d9ef6314-de91-ddcb-3d18-8155cd37e7be@tycho.nsa.gov>
Date:   Mon, 3 Jun 2019 10:19:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531233159.30992-9-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/31/19 7:31 PM, Sean Christopherson wrote:
> enclave_load() is roughly analogous to the existing file_mprotect().
> 
> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> VMAs.  As a result, file_mprotect() does not provide any meaningful
> security for enclaves since an LSM can only deny/grant access to the
> EPC as a whole.
> 
> security_enclave_load() is called when SGX is first loading an enclave
> page, i.e. copying a page from normal memory into the EPC.  The notable
> difference from file_mprotect() is the allowed_prot parameter, which
> is essentially an SGX-specific version of a VMA's MAY_{READ,WRITE,EXEC}
> flags.  The purpose of allowed_prot is to enable checks such as
> SELinux's FILE__EXECMOD permission without having to track and update
> VMAs across multiple mm structs, i.e. SGX can ensure userspace doesn't
> overstep its bounds simply by restricting an enclave VMA's protections
> by vetting what is maximally allowed during build time.
> 
> An alternative to the allowed_prot approach would be to use an enclave's
> SIGSTRUCT (a smallish structure that can uniquely identify an enclave)
> as a proxy for the enclave.  For example, SGX could take and hold a
> reference to the file containing the SIGSTRUCT (if it's in a file) and
> call security_enclave_load() during mprotect().  While the SIGSTRUCT
> approach would provide better precision, the actual value added was
> deemed to be negligible.  On the other hand, pinning a file for the
> lifetime of the enclave is ugly, and essentially caching LSM policies
> in each page's allowed_prot avoids having to make an extra LSM upcall
> during mprotect().
> 
> Note, extensive discussion yielded no sane alternative to some form of
> SGX specific LSM hook[1].
> 
> [1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 +++++++++-----
>   include/linux/lsm_hooks.h              | 16 ++++++++++++++++
>   include/linux/security.h               |  2 ++
>   security/security.c                    |  8 ++++++++
>   4 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 5f71be7cbb01..260417ecbcff 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -8,6 +8,7 @@
>   #include <linux/highmem.h>
>   #include <linux/ratelimit.h>
>   #include <linux/sched/signal.h>
> +#include <linux/security.h>
>   #include <linux/shmem_fs.h>
>   #include <linux/slab.h>
>   #include <linux/suspend.h>
> @@ -580,21 +581,24 @@ static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
>   				 unsigned long *allowed_prot)
>   {
>   	struct vm_area_struct *vma;
> +	int ret = 0;
>   
> -	if (!(*allowed_prot & VM_EXEC))
> +	if (!(*allowed_prot & VM_EXEC) && !IS_ENABLED(CONFIG_SECURITY))
>   		goto do_check;
>   
>   	down_read(&current->mm->mmap_sem);
>   	vma = find_vma(current->mm, src);
>   	if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
>   		*allowed_prot &= ~VM_EXEC;
> +#ifdef CONFIG_SECURITY
> +	ret = security_enclave_load(vma, prot, allowed_prot);
> +#endif

Normally you'd define a static inline stub for the hook in the #else 
clause for CONFIG_SECURITY in include/linux/security.h and avoid any 
ifdef here.

What ensures that the mapping referenced by src can't be changed to an 
entirely different one (with a different vm_file) between the time of 
check (here) and the time of use?

>   	up_read(&current->mm->mmap_sem);
>   
>   do_check:
> -	if (prot & ~*allowed_prot)
> -		return -EACCES;
> -
> -	return 0;
> +	if (!ret && (prot & ~*allowed_prot))
> +		ret = -EACCES;
> +	return ret;
>   }
>   
>   static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 47f58cfb6a19..0562775424a0 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1446,6 +1446,14 @@
>    * @bpf_prog_free_security:
>    *	Clean up the security information stored inside bpf prog.
>    *
> + * Security hooks for Intel SGX enclaves.
> + *
> + * @enclave_load:
> + *	On success, returns 0 and optionally adjusts @allowed_prot
> + *	@vma: the source memory region of the enclave page being loaded.
> + *	@prot: the initial protection of the enclave page.
> + *	@allowed_prot: the maximum protections of the enclave page.
> + *	Return 0 if permission is granted.
>    */
>   union security_list_options {
>   	int (*binder_set_context_mgr)(struct task_struct *mgr);
> @@ -1807,6 +1815,11 @@ union security_list_options {
>   	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
>   	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
>   #endif /* CONFIG_BPF_SYSCALL */
> +
> +#ifdef CONFIG_INTEL_SGX
> +	int (*enclave_load)(struct vm_area_struct *vma, unsigned long prot,
> +			    unsigned long *allowed_prot);
> +#endif /* CONFIG_INTEL_SGX */
>   };
>   
>   struct security_hook_heads {
> @@ -2046,6 +2059,9 @@ struct security_hook_heads {
>   	struct hlist_head bpf_prog_alloc_security;
>   	struct hlist_head bpf_prog_free_security;
>   #endif /* CONFIG_BPF_SYSCALL */
> +#ifdef CONFIG_INTEL_SGX
> +	struct hlist_head enclave_load;
> +#endif /* CONFIG_INTEL_SGX */
>   } __randomize_layout;
>   
>   /*
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 659071c2e57c..2f7925eeef7e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -392,6 +392,8 @@ void security_inode_invalidate_secctx(struct inode *inode);
>   int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
>   int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
>   int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> +			  unsigned long *allowed_prot);
>   #else /* CONFIG_SECURITY */
>   
>   static inline int call_lsm_notifier(enum lsm_event event, void *data)
> diff --git a/security/security.c b/security/security.c
> index 613a5c00e602..07ed6763571e 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2359,3 +2359,11 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
>   	call_void_hook(bpf_prog_free_security, aux);
>   }
>   #endif /* CONFIG_BPF_SYSCALL */
> +
> +#ifdef CONFIG_INTEL_SGX
> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> +			  unsigned long *allowed_prot)
> +{
> +	return call_int_hook(enclave_load, 0, vma, prot, allowed_prot);
> +}
> +#endif /* CONFIG_INTEL_SGX */
> 

