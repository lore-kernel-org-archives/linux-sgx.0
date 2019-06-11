Return-Path: <SRS0=yZGw=UK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EB1C4321B
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 13:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D60D208E3
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Jun 2019 13:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="kgWDSqhg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404162AbfFKNk6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:40:58 -0400
Received: from usfb19pa13.eemsg.mail.mil ([214.24.26.84]:7919 "EHLO
        USFB19PA13.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403885AbfFKNk4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Jun 2019 09:40:56 -0400
X-EEMSG-check-017: 272173685|USFB19PA13_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA13.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jun 2019 13:40:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560260437; x=1591796437;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bSz8f4DNj4fHEaizM+6YJQYWfMFfEWy2eq/4g84WPd0=;
  b=kgWDSqhgOs7qgIkDFXFTG5g+3Gjri/32g3syzwMy9oMaao7zTa5BvgOk
   zVqx3vgkNGcLnHcvT6cx+Uz69g242w1vzPrc7ZwNX/5IvqMjlMkEkiIar
   oBTDKrXB5PsG2HVkhgXRjaVUcdhnLBrGZw6+bx2P5taKekaagewsBmCJv
   XyOFeApRclYFZXuJR0V75zNZz7+Ad9PCQ+Un3iBOKrh+SN3d5dL7LitqG
   gvWlX0fOehnZ0KybPwByhyxB3NYoPWHwOXTRn03tPhoQL1Y/xOEwQalX4
   gEWArLuJ6n6NFo2AJK1mC1wdk/y2wSrzZn0mmZ0zUkZRkgNz7T5jf2WEa
   g==;
X-IronPort-AV: E=Sophos;i="5.63,579,1557187200"; 
   d="scan'208";a="28808938"
IronPort-PHdr: =?us-ascii?q?9a23=3AHsZq1RyixPVvCcrXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd0ewUKfad9pjvdHbS+e9qxAeQG9mCsrQd1red7/CocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmSexbalvIBi2rQjducYbjIh/Iast1x?=
 =?us-ascii?q?XFpWdFdf5Lzm1yP1KTmBj85sa0/JF99ilbpuws+c1dX6jkZqo0VbNXAigoPG?=
 =?us-ascii?q?Az/83rqALMTRCT6XsGU2UZiQRHDg7Y5xznRJjxsy/6tu1g2CmGOMD9UL45VS?=
 =?us-ascii?q?i+46ptVRTlkzkMOSIn/27Li8xwlKNbrwynpxxj2I7ffYWZOONjcq/BYd8WQG?=
 =?us-ascii?q?xMUchLVyxFH4iycY0BAeQcNupctoXwqV8DoR64CAKxBu3g1yVIi2fr06Mk3e?=
 =?us-ascii?q?QvEQLI0gIuEN0BsnvbsNr7ObwOUe231qTE0SnPYv1U1Dr79YPGcgohofaJXb?=
 =?us-ascii?q?9obMTR1VcgFxvFjlqOr4zuIi6b1uEXvGif6+pvS+KugHMgpgFqvzev3dwhip?=
 =?us-ascii?q?XJh40JylDE8j91wIAuJdKiUkJ7btmkEIVJuiycKoB4QdsiTnl1tCs1xbAKo5?=
 =?us-ascii?q?62cDUQxJg5yBPTdeaLf5WO7xn+TuieOy14i2hgeL+nghay9lWvxfPkW8mv1V?=
 =?us-ascii?q?ZKsjJFkt7RtnARzxDT6taISv96/kq5xTaAzRrT6uBZIUAvj6bbN54gzaIwlp?=
 =?us-ascii?q?oUq0jDGDP5mF7qg6OMc0Uk++yo5/zmYrXguJCcK5d5hhzxP6khgMCyAfk0Ph?=
 =?us-ascii?q?IQU2WU5+iwzqDv8VX8QLpQj/02lqfZsIrdJcQevqO5GBJa0p045hajDzapzN?=
 =?us-ascii?q?QYnX4dIFJDYxKIlZLlO17JIPDmFfu/mUijkC93x/DaOb3sGonCIWben7f7fL?=
 =?us-ascii?q?Zy91RQyQUyzdBZ6JJZEbABIPTvWkDvsNzUFAM2Mwuxw+z/EtVyypseWX6TAq?=
 =?us-ascii?q?+eKK7StV6I5uQyI+iDfYMVoyjyJOQ45/70jH85hV8ccbCs3ZsQdX+4A/BmLF?=
 =?us-ascii?q?uCbHryjdcOD30KshA9TOP0kl2CVyBcZ3KoU6I7/DE7B5qsDZ3fSYC1nLyBwC?=
 =?us-ascii?q?C7E4VNZm9YDlCMEHHod5iLWvoXdiKSLdFukiYeWbiiVYAhzxeuuxH+y7Z9Ke?=
 =?us-ascii?q?rU4CIYv4r51Ndp/+3TiQ0y9TtsAsSZ0mGNSXx0n2wRSz81wq9/u0p9xUmH0a?=
 =?us-ascii?q?VjnfxYGsJc5+lTXgc5K5Hc1ep6BM72Wg7bedeJUlmmSM28AT4tVtIx38MOY0?=
 =?us-ascii?q?FlFtWmjxDD2TeqArAMm7yQC5w1/bnR32b+J8lj0XbKzqohgEc8QstJK2Kmgr?=
 =?us-ascii?q?Rz9w/JB47Gi0+ZjbqldbwA3C7R82eO1WiOs1tCUA5zUqXFWmoTZlDMotT65U?=
 =?us-ascii?q?PCTrmuBqohMgZazc6CK61KasDmjFlcRffjPsjebHy1m2uqGRmIwbaMZpLwe2?=
 =?us-ascii?q?oBxCXdFFQEkwcL8HaCKAg+GiChrnndDDNwD1LvZV3j8e1kpHO8VE80wBmAb1?=
 =?us-ascii?q?d92Lqt5h4VmfucRusR3rIBvychsS90HFem39/NDdqPvQ9hc7tdYd8n51dHz2?=
 =?us-ascii?q?3ZvRRnPpO8N6BimkIecwNvskP1yRp3EIpAntYxoXMq1gVyLaaY0VNHdz+CwZ?=
 =?us-ascii?q?/wPbjXIHHo/B+zc67Wxk3e0NGO96cX8vs4tlHjsRqxFkU47nVn18BZ036b5p?=
 =?us-ascii?q?XNFgodT4j9XVow9xh/v7vaeDUy55vI1X1wNqm5qiHN28ozC+s/yxagZMxSML?=
 =?us-ascii?q?ueGw/oEs0aHNCuKOgwlFe1cB0IJudS9LQ7P8m+bfuJxLarPPp8nDKhlWlH4p?=
 =?us-ascii?q?5y0l6M9ypmTe7FxJgFw/aC3gubTTj8ilahs8/tlY9YYjESG3K1yTL4C45Jeq?=
 =?us-ascii?q?1yYYELBH+zLMKt2NVxmYThW35C+16lHFMJxsmpdAGTb1z7wQ1fy0AXrWa7li?=
 =?us-ascii?q?u/yjx+iyspobaH3CzS3+TicwIKOnJERGlmglbhOoy0j9EcXEi1cwgpjhyl5U?=
 =?us-ascii?q?D7x6lUvqhwMnfcS19SfyfqN2FiTrewtr2abs5T75MoqztXX/64YV+HUb7wuB?=
 =?us-ascii?q?8a0yLlH2tDyzE3bj+qupLknxx8lW2SNmpzrHveecF23xvf48bcRfFJ1DocWC?=
 =?us-ascii?q?Z4kSXXBkS7P9Sx59qUlI/DsuWlWmKlV51TdzTrzIyZuCu14m1qHBu/kO2pld?=
 =?us-ascii?q?37EAg61in728NtVSXSoxb2epPr2LiiMeJ7YkloA0fx68x6GoF5iIswgYsf2X?=
 =?us-ascii?q?4Bi5WP43UIjGfzPs9H2a7kcHUNQjsLycbP4Af5wE1jMm6Jx4XhW3WFx8tue8?=
 =?us-ascii?q?W1bXkS2iI58sBKDbyZ7KZakiRoolq3tx7RbeJhkTcazPsk8GQajP0RuAox0i?=
 =?us-ascii?q?WdBagfHVJGMiz2mBSH8cqyo79XZWaobLiw0lFzndGnDLGevA5cXGz1dYslHS?=
 =?us-ascii?q?919s9/Kk7D0GXv6oH4f9nddckTth2OnBbAleRVK4g+luYLhCZ+OGPyp3gly+?=
 =?us-ascii?q?8hjRF13JG6upSHJHtp/K6jHhFYMTj1bdsJ+j7xlaZegtqW34e3E5VhADoLXY?=
 =?us-ascii?q?foQuivED4ItfTnKhyBEDszqnqAGLrfGxOf51lir37VD5+rMHSXLmEDzdp+XB?=
 =?us-ascii?q?mdOFBfgAcMUTogmJ42CxqqxM3hcUtj/TAR5kD3qgVQxeJoKRb/VGTfpACzZz?=
 =?us-ascii?q?cwSZifKgdW7w5Y60fUN8ye8vx8HyVC8pK9qwyNL3SRZx5UAmERRkyEG1fjM6?=
 =?us-ascii?q?Gt5dba8uiUHPG+L+XUbrWOr+xTTPaIxZSz0oR4+zaALNmAPn5nD/cjwEpMQW?=
 =?us-ascii?q?h5G9jFmzUIUyEYjDrNYtWBqxe4+y14sMa//ffxVA3y+4SFE6FSPsl3+xCqna?=
 =?us-ascii?q?eDMPadhCR+KTZD1pMB3n3IyL8E3F4SlyFubTitEawEtSHTUKLQhrVbDxkBay?=
 =?us-ascii?q?N8LMFI9b4z3hFROc7HjdP4zr14geQ0C1tfVVzhh9umZcoFI2ymNVPHAlqLO6?=
 =?us-ascii?q?qCJTHR3873Zqa8Q6VKjOpIrx2wpSqbE0j7MzSZljnmSRavMf1OjC6FJxxTo4?=
 =?us-ascii?q?69chFqCWjsSNLpdAe3P8NwjT0z2bc0nG/FNXYAMThgdENAtrOR7SJcgvV7Gm?=
 =?us-ascii?q?xO9H9lIfOYlCqD9enYLY0ZvuVxAiRojOJX+3U6y71J7C5aQPx5gjfdrtlro1?=
 =?us-ascii?q?u+iOmA1iJnUAZSqjZMnI+LpUViOaTd9plBQXbI5gkC4X+MCxQQpttqFsHgtL?=
 =?us-ascii?q?pLx9jOkqLzNClN89bO8cQAAMjULZHPDH10GhflAj/fRDsESzHjYWrSi1Zcm7?=
 =?us-ascii?q?eC93uahpk8tpXo3pEJT+kfHFg0EO4KT19oF8EYIYtmGzYjnaOfgeYW6nek6h?=
 =?us-ascii?q?rcXsNXutbATP3WSe7iLDefkKlseRQF2/X7IJ4VO4m93FZtLhF+nYLXCw/TUM?=
 =?us-ascii?q?pLrylJcAA5ugNO/WJ4Q2l13FjqLkup4XkOBbuvkQ4elARze6Iu+S3q7lNxIU?=
 =?us-ascii?q?DF9wUql0xkosnomTCcdnbKKa60WYxHQ37vu1MZLoLwQwEzaxa720NjKmGXFP?=
 =?us-ascii?q?pqk7J8eDUz20fnspxVFKsZFPYVbQ=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2CmAQDurf9c/wHyM5BlHgEGBwaBVAYLAYFmKoE3BAEyK?=
 =?us-ascii?q?IQVknNMAQEBAQEBBoE1fohTjySBZwkBAQEBAQEBAQE0AQIBAYRAAoJ+IzcGD?=
 =?us-ascii?q?gEDAQEBBAEBAQEDAQFsKII6KQGCZwEFIwQRQRALGAICJgICVwYBDAYCAQGCX?=
 =?us-ascii?q?z+BdxSpCH4zhUeDK4FGgQwoi10XeIEHgREngjY1PoQJBCODHoJYBIs4IYd3P?=
 =?us-ascii?q?pUiCYISghuRJAYbgiWCH4ReigmDdY0Wk06EfSKBWCsIAhgIIQ87gmyCGxeOP?=
 =?us-ascii?q?CMDMIEGAQGMNgElgiwBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 11 Jun 2019 13:40:34 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5BDePD3025826;
        Tue, 11 Jun 2019 09:40:25 -0400
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
To:     Cedric Xing <cedric.xing@intel.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        eparis@parisplace.org, jethro@fortanix.com, dave.hansen@intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nhorman@redhat.com,
        pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
Date:   Tue, 11 Jun 2019 09:40:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/10/19 3:03 AM, Cedric Xing wrote:
> In this patch, SELinux maintains two bits per enclave page, namely SGX__EXECUTE
> and SGX__EXECMOD.
> 
> SGX__EXECUTE is set initially (by selinux_enclave_load) for every enclave page
> that was loaded from a potentially executable source page. SGX__EXECMOD is set
> for every page that was loaded from a file that has FILE__EXECMOD.
> 
> At runtime, on every protection change (resulted in a call to
> selinux_file_mprotect), SGX__EXECUTE is cleared for a page if VM_WRITE is
> requested, unless SGX__EXECMOD is set.
> 
> To track enclave page protection changes, SELinux has been changed in four
> different places.
> 
> Firstly, storage is required for storing per page SGX__EXECUTE and SGX__EXECMOD
> bits. Given every enclave instance is uniquely tied to an open file (i.e.
> struct file), the storage is allocated by extending `file_security_struct`.
> More precisely, a new field `esec` has been added, initially zero, to point to
> the data structure for tracking per page protection. `esec` will be
> allocated/initialized at the first invocation of selinux_enclave_load().
> 
> Then, selinux_enclave_load() initializes those 2 bits for every new enclave as
> described above. One more detail worth noting, is that selinux_enclave_load()
> sets SGX__EXECUTE/SGX__EXECMOD for EAUG'ed pages (for upcoming SGX2) only if
> the calling process has FILE__EXECMOD on the sigstruct file.
> 
> Afterwards, every change on protection will go through selinux_file_mprotect()
> so will be noted. Please note that user space could munmap() then mmap() to
> work around mprotect(), but that "leak" could be "plugged" by SGX subsystem
> calling security_file_mprotect() explicitly whenever new mappings are created.
> 
> Finally, the storage for page protection tracking must be freed when the
> associated file is closed. Hence a new selinux_file_free_security() has been
> added.
> 
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>   security/selinux/Makefile            |   2 +
>   security/selinux/hooks.c             |  77 ++++++-
>   security/selinux/include/intel_sgx.h |  18 ++
>   security/selinux/include/objsec.h    |   3 +
>   security/selinux/intel_sgx.c         | 292 +++++++++++++++++++++++++++
>   5 files changed, 391 insertions(+), 1 deletion(-)
>   create mode 100644 security/selinux/include/intel_sgx.h
>   create mode 100644 security/selinux/intel_sgx.c
> 
> diff --git a/security/selinux/Makefile b/security/selinux/Makefile
> index ccf950409384..58a05a9639e0 100644
> --- a/security/selinux/Makefile
> +++ b/security/selinux/Makefile
> @@ -14,6 +14,8 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
>   
>   selinux-$(CONFIG_NETLABEL) += netlabel.o
>   
> +selinux-$(CONFIG_INTEL_SGX) += intel_sgx.o
> +
>   ccflags-y := -I$(srctree)/security/selinux -I$(srctree)/security/selinux/include
>   
>   $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702cf46ca..17f855871a41 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -103,6 +103,7 @@
>   #include "netlabel.h"
>   #include "audit.h"
>   #include "avc_ss.h"
> +#include "intel_sgx.h"
>   
>   struct selinux_state selinux_state;
>   
> @@ -3485,6 +3486,11 @@ static int selinux_file_alloc_security(struct file *file)
>   	return file_alloc_security(file);
>   }
>   
> +static void selinux_file_free_security(struct file *file)
> +{
> +	sgxsec_enclave_free(file);
> +}
> +
>   /*
>    * Check whether a task has the ioctl permission and cmd
>    * operation to an inode.
> @@ -3656,6 +3662,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
>   				 unsigned long reqprot,
>   				 unsigned long prot)
>   {
> +	int rc;
>   	const struct cred *cred = current_cred();
>   	u32 sid = cred_sid(cred);
>   
> @@ -3664,7 +3671,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
>   
>   	if (default_noexec &&
>   	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
> -		int rc = 0;
> +		rc = 0;
>   		if (vma->vm_start >= vma->vm_mm->start_brk &&
>   		    vma->vm_end <= vma->vm_mm->brk) {
>   			rc = avc_has_perm(&selinux_state,
> @@ -3691,6 +3698,12 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
>   			return rc;
>   	}
>   
> +#ifdef CONFIG_INTEL_SGX
> +	rc = sgxsec_mprotect(vma, prot);
> +	if (rc <= 0)
> +		return rc;

Why are you skipping the file_map_prot_check() call when rc == 0?
What would SELinux check if you didn't do so - 
FILE__READ|FILE__WRITE|FILE__EXECUTE to /dev/sgx/enclave?  Is it a 
problem to let SELinux proceed with that check?

> +#endif
> +
>   	return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
>   }
>   
> @@ -6726,6 +6739,62 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>   }
>   #endif
>   
> +#ifdef CONFIG_INTEL_SGX
> +
> +static int selinux_enclave_load(struct file *encl, unsigned long addr,
> +				unsigned long size, unsigned long prot,
> +				struct vm_area_struct *source)
> +{
> +	if (source) {
> +		/**
> +		 * Adding page from source => EADD request
> +		 */
> +		int rc = selinux_file_mprotect(source, prot, prot);
> +		if (rc)
> +			return rc;
> +
> +		if (!(prot & VM_EXEC) &&
> +		    selinux_file_mprotect(source, VM_EXEC, VM_EXEC))

I wouldn't conflate VM_EXEC with PROT_EXEC even if they happen to be 
defined with the same values currently.  Elsewhere the kernel appears to 
explicitly translate them ala calc_vm_prot_bits().

Also, this will mean that we will always perform an execute check on all 
sources, thereby triggering audit denial messages for any EADD sources 
that are only intended to be data.  Depending on the source, this could 
trigger PROCESS__EXECMEM or FILE__EXECMOD or FILE__EXECUTE.  In a world 
where users often just run any denials they see through audit2allow, 
they'll end up always allowing them all.  How can they tell whether it 
was needed? It would be preferable if we could only trigger execute 
checks when there is some probability that execute will be requested in 
the future.  Alternatives would be to silence the audit of these 
permission checks always via use of _noaudit() interfaces or to silence 
audit of these permissions via dontaudit rules in policy, but the latter 
would hide all denials of the permission by the process, not just those 
triggered from security_enclave_load().  And if we silence them, then we 
won't see them even if they were needed.

> +			prot = 0;
> +		else {
> +			prot = SGX__EXECUTE;
> +			if (source->vm_file &&
> +			    !file_has_perm(current_cred(), source->vm_file,
> +					   FILE__EXECMOD))
> +				prot |= SGX__EXECMOD;

Similarly, this means that we will always perform a FILE__EXECMOD check 
on all executable sources, triggering audit denial messages for any EADD 
source that is executable but to which EXECMOD is not allowed, and again 
the most common pattern will be that users will add EXECMOD to all 
executable sources to avoid this.

> +		}
> +		return sgxsec_eadd(encl, addr, size, prot);
> +	} else {
> +		/**
> +		  * Adding page from NULL => EAUG request
> +		  */
> +		return sgxsec_eaug(encl, addr, size, prot);
> +	}
> +}
> +
> +static int selinux_enclave_init(struct file *encl,
> +				const struct sgx_sigstruct *sigstruct,
> +				struct vm_area_struct *vma)
> +{
> +	int rc = 0;
> +
> +	if (!vma)
> +		rc = -EINVAL;

Is it ever valid to call this hook with a NULL vma?  If not, this should 
be handled/prevented by the caller.  If so, I'd just return -EINVAL 
immediately here.

> +
> +	if (!rc && !(vma->vm_flags & VM_EXEC))
> +		rc = selinux_file_mprotect(vma, VM_EXEC, VM_EXEC);

I had thought we were trying to avoid overloading FILE__EXECUTE (or 
whatever gets checked here, e.g. could be PROCESS__EXECMEM or 
FILE__EXECMOD) on the sigstruct file, since the caller isn't truly 
executing code from it.

I'd define new ENCLAVE__* permissions, including an up-front 
ENCLAVE__INIT permission that governs whether the sigstruct file can be 
used at all irrespective of memory protections.

Then you can also have ENCLAVE__EXECUTE, ENCLAVE__EXECMEM, 
ENCLAVE__EXECMOD for the execute-related checks.  Or you can use the 
/dev/sgx/enclave inode as the target for the execute checks and just 
reuse the file permissions there.

> +
> +	if (!rc) {
> +		if (vma->vm_file)
> +			rc = file_has_perm(current_cred(), vma->vm_file,
> +					   FILE__EXECMOD);

Similar issue here with always triggering EXECMOD audit denials even if 
never required.

> +		rc = sgxsec_einit(encl, sigstruct, !rc);
> +	}
> +	return rc;
> +}
> +
> +#endif
> +
>   struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
>   	.lbs_cred = sizeof(struct task_security_struct),
>   	.lbs_file = sizeof(struct file_security_struct),
> @@ -6808,6 +6877,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>   
>   	LSM_HOOK_INIT(file_permission, selinux_file_permission),
>   	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
> +	LSM_HOOK_INIT(file_free_security, selinux_file_free_security),
>   	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
>   	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
>   	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
> @@ -6968,6 +7038,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>   	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
>   	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
>   #endif
> +
> +#ifdef CONFIG_INTEL_SGX
> +	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
> +	LSM_HOOK_INIT(enclave_init, selinux_enclave_init),
> +#endif
>   };
>   
>   static __init int selinux_init(void)
> diff --git a/security/selinux/include/intel_sgx.h b/security/selinux/include/intel_sgx.h
> new file mode 100644
> index 000000000000..8f9c6c734921
> --- /dev/null
> +++ b/security/selinux/include/intel_sgx.h
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#ifndef _SELINUX_SGXSEC_H_
> +#define _SELINUX_SGXSEC_H_
> +
> +#include <linux/lsm_hooks.h>
> +
> +#define SGX__EXECUTE	1
> +#define SGX__EXECMOD	2
> +
> +void sgxsec_enclave_free(struct file *);
> +int sgxsec_mprotect(struct vm_area_struct *, size_t);
> +int sgxsec_eadd(struct file *, size_t, size_t, size_t);
> +int sgxsec_eaug(struct file *, size_t, size_t, size_t);
> +int sgxsec_einit(struct file *, const struct sgx_sigstruct *, int);
> +
> +#endif
> diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
> index 231262d8eac9..0fb4da7e3a8a 100644
> --- a/security/selinux/include/objsec.h
> +++ b/security/selinux/include/objsec.h
> @@ -71,6 +71,9 @@ struct file_security_struct {
>   	u32 fown_sid;		/* SID of file owner (for SIGIO) */
>   	u32 isid;		/* SID of inode at the time of file open */
>   	u32 pseqno;		/* Policy seqno at the time of file open */
> +#ifdef CONFIG_INTEL_SGX
> +	atomic_long_t esec;
> +#endif
>   };
>   
>   struct superblock_security_struct {
> diff --git a/security/selinux/intel_sgx.c b/security/selinux/intel_sgx.c
> new file mode 100644
> index 000000000000..37dacf5c295f
> --- /dev/null
> +++ b/security/selinux/intel_sgx.c
> @@ -0,0 +1,292 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#include "objsec.h"
> +#include "intel_sgx.h"
> +
> +struct region {
> +	struct list_head	link;
> +	size_t			start;
> +	size_t			end;
> +	size_t			data;
> +};
> +
> +static inline struct region *region_new(void)
> +{
> +	struct region *n = kzalloc(sizeof(struct region), GFP_KERNEL);
> +	if (n)
> +		INIT_LIST_HEAD(&n->link);
> +	return n;
> +}
> +
> +static inline void region_free(struct region *r)
> +{
> +	list_del(&r->link);
> +	kfree(r);
> +}
> +
> +static struct list_head *
> +region_apply_to_range(struct list_head *rgs,
> +		      size_t start, size_t end,
> +		      struct list_head *(*cb)(struct region *,
> +					      size_t, size_t, size_t),
> +		      size_t arg)
> +{
> +	struct region *r, *n;
> +
> +	list_for_each_entry(r, rgs, link)
> +		if (start < r-> end)
> +			break;
> +
> +	if (&r->link == rgs || end <= r->start)
> +		return rgs;
> +
> +	do {
> +		struct list_head *ret;
> +		n = list_next_entry(r, link);
> +		ret = (*cb)(r, start, end, arg);
> +		if (ret)
> +			return ret;
> +		r = n;
> +	} while (&r->link != rgs && r->start < end);
> +	return &r->link;
> +}
> +
> +static struct list_head *
> +region_clear_cb(struct region *r, size_t start, size_t end, size_t arg)
> +{
> +	if (end < r->end) {
> +		if (start > r->start) {
> +			struct region *n = region_new();
> +			if (unlikely(!n))
> +				return ERR_PTR(-ENOMEM);
> +
> +			n->start = r->start;
> +			n->end = start;
> +			n->data = r->data;
> +			list_add_tail(&n->link, &r->link);
> +		}
> +		r->start = end;
> +		return &r->link;
> +	}
> +
> +	if (start > r->start)
> +		r->end = start;
> +	else
> +		region_free(r);
> +	return NULL;
> +}
> +
> +static inline struct list_head *
> +region_clear_range(struct list_head *rgs, size_t start, size_t end)
> +{
> +	return region_apply_to_range(rgs, start, end, region_clear_cb, 0);
> +}
> +
> +static struct list_head *
> +region_add_range(struct list_head *rgs, size_t start, size_t end, size_t data)
> +{
> +	struct region *r, *n;
> +
> +	n = list_entry(region_clear_range(rgs, start, end), typeof(*n), link);
> +	if (unlikely(IS_ERR_VALUE(&n->link)))
> +		return &n->link;
> +
> +	if (&n->link != rgs && end == n->start && data == n->data) {
> +		n->start = start;
> +		r = n;
> +	} else {
> +		r = region_new();
> +		if (unlikely(!r))
> +			return ERR_PTR(-ENOMEM);
> +
> +		r->start = start;
> +		r->end = end;
> +		r->data = data;
> +		list_add_tail(&r->link, &n->link);
> +	}
> +
> +	n = list_prev_entry(r, link);
> +	if (&n->link != rgs && start == n->end && data == n->data) {
> +		r->start = n->start;
> +		region_free(n);
> +	}
> +
> +	return &r->link;
> +}
> +
> +static inline int
> +enclave_add_pages(struct list_head *rgs, size_t start, size_t end, size_t flags)
> +{
> +	void *p = region_add_range(rgs, start, end, flags);
> +	return PTR_ERR_OR_ZERO(p);
> +}
> +
> +static inline int enclave_prot_allowed(size_t prot, size_t flags)
> +{
> +	return !(prot & VM_EXEC) || (flags & SGX__EXECUTE);
> +}
> +
> +static struct list_head *
> +enclave_prot_check_cb(struct region *r, size_t start, size_t end, size_t prot)
> +{
> +	if (!enclave_prot_allowed(prot, r->data))
> +		return ERR_PTR(-EACCES);
> +	return NULL;
> +}
> +
> +static struct list_head *
> +enclave_prot_set_cb(struct region *r, size_t start, size_t end, size_t prot)
> +{
> +	BUG_ON(!enclave_prot_allowed(prot, r->data));
> +
> +	if (!(prot & VM_WRITE) ||
> +	    (r->data & SGX__EXECMOD) ||
> +	    !(r->data & SGX__EXECUTE))
> +		return NULL;
> +
> +	if (end < r->end) {
> +		struct region *n = region_new();
> +		if (unlikely(!n))
> +			return ERR_PTR(-ENOMEM);
> +
> +		n->start = end;
> +		n->end = r->end;
> +		n->data = r->data;
> +		r->end = end;
> +		list_add(&n->link, &r->link);
> +	}
> +
> +	if (start > r->start) {
> +		struct region *n = region_new();
> +		if (unlikely(!n))
> +			return ERR_PTR(-ENOMEM);
> +
> +		n->start = r->start;
> +		n->end = start;
> +		n->data = r->data;
> +		r->start = start;
> +		list_add_tail(&n->link, &r->link);
> +	}
> +
> +	r->data &= ~SGX__EXECUTE;
> +	return NULL;
> +}
> +
> +static inline int
> +enclave_mprotect(struct list_head *rgs, size_t start, size_t end, size_t prot)
> +{
> +	void *ret;
> +
> +	ret = region_apply_to_range(rgs, start, end,
> +				    enclave_prot_check_cb, prot);
> +	if (!IS_ERR_VALUE(ret) && (prot & VM_WRITE))
> +		ret = region_apply_to_range(rgs, start, end,
> +					    enclave_prot_set_cb, prot);
> +	return PTR_ERR_OR_ZERO(ret);
> +}
> +
> +struct enclave_sec {
> +	struct rw_semaphore	sem;
> +	struct list_head	regions;
> +	size_t			eaug_perm;
> +};
> +
> +static inline struct enclave_sec *__esec(struct file_security_struct *fsec)
> +{
> +	return (struct enclave_sec *)atomic_long_read(&fsec->esec);
> +}
> +
> +static struct enclave_sec *encl_esec(struct file *encl)
> +{
> +	struct file_security_struct *fsec = selinux_file(encl);
> +	struct enclave_sec *esec = __esec(fsec);
> +
> +	if (unlikely(!esec)) {
> +		long n;
> +
> +		esec = kzalloc(sizeof(*esec), GFP_KERNEL);
> +		if (!esec)
> +			return NULL;
> +
> +		init_rwsem(&esec->sem);
> +		INIT_LIST_HEAD(&esec->regions);
> +
> +		n = atomic_long_cmpxchg(&fsec->esec, 0, (long)esec);
> +		if (n) {
> +			kfree(esec);
> +			esec = (typeof(esec))n;
> +		}
> +	}
> +
> +	return esec;
> +}
> +
> +void sgxsec_enclave_free(struct file *encl)
> +{
> +	struct enclave_sec *esec = __esec(selinux_file(encl));
> +
> +	if (esec) {
> +		struct region *r, *n;
> +
> +		BUG_ON(rwsem_is_locked(&esec->sem));
> +
> +		list_for_each_entry_safe(r, n, &esec->regions, link)
> +			region_free(r);
> +
> +		kfree(esec);
> +	}
> +}
> +
> +int sgxsec_mprotect(struct vm_area_struct *vma, size_t prot)
> +{
> +	struct enclave_sec *esec;
> +	int rc;
> +
> +	if (!vma->vm_file || !(esec = __esec(selinux_file(vma->vm_file)))) {
> +		/* Positive return value indicates non-enclave VMA */
> +		return 1;
> +	}
> +
> +	down_read(&esec->sem);
> +	rc = enclave_mprotect(&esec->regions, vma->vm_start, vma->vm_end, prot);

Why is it safe for this to only use down_read()? enclave_mprotect() can 
call enclave_prot_set_cb() which modifies the list?

> +	up_read(&esec->sem);
> +	return rc;
> +}
> +
> +int sgxsec_eadd(struct file *encl, size_t start, size_t size, size_t perm)
> +{
> +	struct enclave_sec *esec = encl_esec(encl);
> +	int rc;
> +
> +	if (down_write_killable(&esec->sem))
> +		return -EINTR;
> +	rc = enclave_add_pages(&esec->regions, start, start + size, perm);
> +	up_write(&esec->sem);
> +	return rc;
> +}
> +
> +int sgxsec_eaug(struct file *encl, size_t start, size_t size, size_t prot)
> +{
> +	struct enclave_sec *esec = encl_esec(encl);
> +	int rc = -EPERM;
> +
> +	if (down_write_killable(&esec->sem))
> +		return -EINTR;
> +	if (enclave_prot_allowed(prot, esec->eaug_perm))
> +		rc = enclave_add_pages(&esec->regions, start, start + size,
> +				       esec->eaug_perm);
> +	up_write(&esec->sem);
> +	return rc;
> +}
> +
> +int sgxsec_einit(struct file *encl, const struct sgx_sigstruct *sigstruct, int execmod)
> +{
> +	struct enclave_sec *esec = encl_esec(encl);
> +
> +	if (down_write_killable(&esec->sem))
> +		return -EINTR;
> +	esec->eaug_perm = execmod ? SGX__EXECUTE | SGX__EXECMOD : 0;
> +	up_write(&esec->sem);
> +	return 0;
> +}

I haven't looked at this code closely, but it feels like a lot of 
SGX-specific logic embedded into SELinux that will have to be repeated 
or reused for every security module.  Does SGX not track this state itself?
