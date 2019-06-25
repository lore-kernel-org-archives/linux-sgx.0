Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B28CC48BD7
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 20:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5572208CA
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 20:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="hxdoUt7Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFYUgy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 16:36:54 -0400
Received: from usfb19pa16.eemsg.mail.mil ([214.24.26.87]:3939 "EHLO
        usfb19pa16.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYUgx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 16:36:53 -0400
X-EEMSG-check-017: 210661010|USFB19PA16_EEMSG_MP12.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by usfb19pa16.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 20:34:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561494887; x=1593030887;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zLLmH2ssTiiJvAfz8t+SAuAi/SMtxFWoOr+76U/1dXg=;
  b=hxdoUt7QUs8v2/6tqwkc7C5+tGbjh01LEdw0Y/TgEXMnPxXZI2zlEMHA
   BtqsJXeP61O9Y7MJsZUBTJY2UiOzPTa9yBnqL0+onP+bCnXnYQCh6rVb0
   hjVxKi1bROxcWxS978e1Aamag71ocdO1koOnXEPZOLFLjGIsP4wDdv5kH
   XTPqsAXMgI4YDniURZq7SoSqKS7Oz+HoWyGkY2IEb8V0mJeLqttsbaWOS
   YBL/j9XtNtUkWQ9RAmeDp162zPCCOd+wGCxAPwEkmOhePJ1BxBT8xrppR
   GSujrU+3pcON09LTNOtuDwyURZwzXGycIBivs5MhC4nFQAeQpYqwxb62g
   A==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="25112503"
IronPort-PHdr: =?us-ascii?q?9a23=3A79H9hx8+NxiECP9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+1OkXIJqq85mqBkHD//Il1AaPAdyBrasYwLOM4+igATVGvc/Y9ihaMdRlbF?=
 =?us-ascii?q?wssY0uhQsuAcqIWwXQDcXBSGgEJvlET0Jv5HqhMEJYS47UblzWpWCuv3ZJQk?=
 =?us-ascii?q?2sfQV6Kf7oFYHMks+5y/69+4HJYwVPmTGxfa5+IA+5oAnMqMUam5ZuJ6k+xh?=
 =?us-ascii?q?fUvHdFePldyWd0KV6OhRrx6dq88IN5/yhMp/4t8tNLXLnncag/UbFWFiktPX?=
 =?us-ascii?q?ov5M3suxnDTA+P6WUZX24LjBdGABXL4Q/jUJvpvST0quRy2C+BPc3rVr80Qi?=
 =?us-ascii?q?it771qSBDzligKMSMy/XzNhcxxiKJbpw+hpwB6zoXJboyZKOZyc6XAdt4BW2?=
 =?us-ascii?q?FPQtheWDBAAoOkbosAEewBPfpDr4Lgo1cCtAayCRWwCO/qzDJHiGX23akn2O?=
 =?us-ascii?q?o/Fw/I0hErE9YXvHnaqNj5MaEfWv23wqbV1zXOd+5Y1ynz6IbIcR4vr/+DUr?=
 =?us-ascii?q?1yfsXNxkciDB/Fg1eKpID5Iz+Y2OYAvm6G5ORgT+KvjGsnphlsrDiz2Mgsko?=
 =?us-ascii?q?nJiZwTylvZ6Ct5xZw6Jdm8SEFlYd+vDZxdtzqHOIttWc4iX2Fptzo6yr0Bo5?=
 =?us-ascii?q?K7ejMKx449yx7QbPyHbZGF7xT+X+iSOTd1nG9pdb2wihqo8UWs1/fwWte73V?=
 =?us-ascii?q?pUtCZJj9/BvW0X2RPJ8MiIUP5981+k2TaIyg/c9PlJIVsxlarHM54hxaMwlo?=
 =?us-ascii?q?YLvUTDACD2nEL2gbeKdko+4Oio6vnnYq78qp+AN457lgH+MqM0lsy5Hes4KR?=
 =?us-ascii?q?QBU3Ke+eS90L3v5Uz5QLNUgf0qiqTVrZ/XKMsBqqO5HgNZyJgv5hmhAzu8zd?=
 =?us-ascii?q?gUhXwHI0hEeBKDgYjpIVbOIPXgAPeknlusiyxmx+zGP7L9ApXNKWLPkLH6fb?=
 =?us-ascii?q?ln8UJcxw0zzc5H65JOFr4BOO7zWlP2tNHAFR82LRa7w+D9BNV/zI8RRWKPAr?=
 =?us-ascii?q?WYMKPJrV+I4fovI+mSa48Pozb9LP4l6uXvjX8/hV8SY62p0YELZ3C/G/RsO1?=
 =?us-ascii?q?+Zbmb0gtcdDWcKuRIzTO7wh12YUj5TZHGyU7gn5j4hC4KmDobDRoazj7yHxy?=
 =?us-ascii?q?q7GpxWZmZbClGDC3vodoOEW+sSZyKWOMNujjsEVb25QY87yR6urBP6y6ZgLu?=
 =?us-ascii?q?fM/i0YtJTj1MV65uHKjhEy+jN1At+D02GCUW50hHkERzwo06Blp0xy1FOD3b?=
 =?us-ascii?q?J/g/xCGtxZ/+lJXRsiNZ7A0+x6DMj/WgbAftePVVanTcyqASovQd0t3t8OeU?=
 =?us-ascii?q?d9G8mijxza2iqqBKIal6GPBJMq6a/cwXfxKNhny3rc16kukUMmQs1ROm2inK?=
 =?us-ascii?q?J/8BLTB4HRmUWDi6mqbbgc3DLK9Gqb1mqBokVYUA92UaXYUnESfVXWrdvn6U?=
 =?us-ascii?q?PYVbOuCqooMhFHycGcLqtGcNrpjU9JRP37ItTRf3qxm3usBRaP3r6NYovqe2?=
 =?us-ascii?q?EZ3CXcEkcElhof8mqcOQgkASeuuHzRDCZyFVL0eE7s8O9+qG+lQU8w1Q2Fc0?=
 =?us-ascii?q?ph17+t8B4PmfOcU+8T3q4DuCo5tzp7Bk290MzWCtaavApuYKVcbskg4FdJ0W?=
 =?us-ascii?q?LWqRZ9M4ehL6Bkml4RbQB3s1ny2BVwD4VKidIqo28yzApuNaKY10tMdzGd3Z?=
 =?us-ascii?q?D3IL3XMGjy/Au0Zq7QwF7e1ciZ+qYV5PQ/sVXjsxmjFlA+/HV/z9lVz3yc64?=
 =?us-ascii?q?3XAwUIT5L+TFw79xhgqLHceSky+YXU2GZtMamyrj/NxdYpCPE5xRanetdVKL?=
 =?us-ascii?q?mEGxPqE80GG8iuL/QnlES3YR0ZJuBS9bI7M9mpdvuH3q6rM/1tnDOgjWRb/o?=
 =?us-ascii?q?991liA+DZ7Su7Nx5wF2e2X3hObVzfgi1esqsT3mZ1YZTEVBWe/yjbrBJRXZq?=
 =?us-ascii?q?JseYYHE2CuI9e4xt9mnZ7iR2ZY9EK/B1MBwMKpewSdb0D93Q1K0kQaunKnmS?=
 =?us-ascii?q?yizzxoiT4pqKuf3SPUz+v+cxoHP3ZBRHN+glf0PYi0k9caUVCnbwgzihSl6l?=
 =?us-ascii?q?33yLZdpKR9MWbTRUNIfynqIG14TqSwsb+CadZV6Jw0qSVXTPi8YVeCR77luR?=
 =?us-ascii?q?QazifjEnBGxD8hajGqvoz1nxl9iGKaNnZ8smDVdt13xRfat5TgQqtq0zMADA?=
 =?us-ascii?q?J4kzjMGl+kP9Sz5tKS38PYv+m4EWDnXZ1JcDL3ypuAuTGg4mtCABujkvT1kd?=
 =?us-ascii?q?riR0xy8ybh1NptHR7BrxX9ZITtn/C4OPhkfU4uH1b/6Mt8F4dWloo2mYFW2H?=
 =?us-ascii?q?4Gi5HT9n0CxzTdK9JejJniYWINSDhD+Nvc5AzoyQU3NX6S757oXXWahM16bp?=
 =?us-ascii?q?+1ZX1AiXF11NxDFKrBtO8MpiByuFft6FuKMPU=3D?=
X-IPAS-Result: =?us-ascii?q?A2BMAAAPhRJd/wHyM5BlHAEBAQQBAQcEAQGBVQUBAQsBg?=
 =?us-ascii?q?WwqgTwyKIQWk0YBAQEBAQEGgQkIJYlTjxOBewkBAQEBAQEBAQE0AQIBAYRAA?=
 =?us-ascii?q?oJ1IzYHDgEDAQEBBAEBAQEEAQFsikOCOikBgmcBBSMEEUEQCxgCAiYCAlcGA?=
 =?us-ascii?q?QwGAgEBgl8/gXcUpXJ+M4VHgymBRoEMKAGLXRd4gQeBEScMgl8+h06CWASOI?=
 =?us-ascii?q?YYmlGJrCYIXgh6RRwYCGYIpixmKDC2Me5kNCSiBWCsIAhgIIQ+DJ4JNF448I?=
 =?us-ascii?q?wMwAYEFAQGPaQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 25 Jun 2019 20:34:44 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PKYfGk014706;
        Tue, 25 Jun 2019 16:34:43 -0400
Subject: Re: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Paul Moore <paul@paul-moore.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <92082311-78a2-44dd-5907-ba31e195a5c4@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 16:34:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190619222401.14942-11-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/19/19 6:23 PM, Sean Christopherson wrote:
> The goal of selinux_enclave_load() is to provide a facsimile of the
> existing selinux_file_mprotect() and file_map_prot_check() policies,
> but tailored to the unique properties of SGX.
> 
> For example, an enclave page is technically backed by a MAP_SHARED file,
> but the "file" is essentially shared memory that is never persisted
> anywhere and also requires execute permissions (for some pages).
> 
> Enclaves are also less priveleged than normal user code, e.g. SYSCALL
> instructions #UD if attempted in an enclave.  For this reason, add SGX
> specific permissions instead of reusing existing permissions such as
> FILE__EXECUTE so that policies can allow running code in an enclave, or
> allow dynamically loading code in an enclave without having to grant the
> same capability to normal user code outside of the enclave.
> 
> Intended use of each permission:
> 
>    - SGX_EXECDIRTY: dynamically load code within the enclave itself
>    - SGX_EXECUNMR: load unmeasured code into the enclave, e.g. Graphene
>    - SGX_EXECANON: load code from anonymous memory (likely Graphene)
>    - SGX_EXECUTE: load an enclave from a file, i.e. normal behavior
> 
> Note, equivalents to FILE__READ and FILE__WRITE are intentionally never
> required.  Writes to the enclave page are contained to the EPC, i.e.
> never hit the original file, and read permissions have already been
> vetted (or the VMA doesn't have PROT_READ, in which case loading the
> page into the enclave will fail).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   security/selinux/hooks.c            | 55 +++++++++++++++++++++++++++--
>   security/selinux/include/classmap.h |  5 +--
>   2 files changed, 55 insertions(+), 5 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index fc239e541b62..8a431168e454 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6727,6 +6727,12 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>   #endif
>   
>   #ifdef CONFIG_INTEL_SGX
> +static inline int sgx_has_perm(u32 sid, u32 requested)
> +{
> +	return avc_has_perm(&selinux_state, sid, sid,
> +			    SECCLASS_PROCESS2, requested, NULL);
> +}
> +
>   static int selinux_enclave_map(unsigned long prot)
>   {
>   	const struct cred *cred = current_cred();
> @@ -6736,11 +6742,53 @@ static int selinux_enclave_map(unsigned long prot)
>   	WARN_ON_ONCE(!default_noexec);
>   
>   	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> -		return avc_has_perm(&selinux_state, sid, sid,
> -				    SECCLASS_PROCESS2, PROCESS2__SGX_MAPWX,
> -				    NULL);
> +		return sgx_has_perm(sid, PROCESS2__SGX_MAPWX);
> +
>   	return 0;
>   }
> +
> +static int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> +				bool measured)
> +{
> +	const struct cred *cred = current_cred();
> +	u32 sid = cred_sid(cred);
> +	int ret;
> +
> +	/* SGX is supported only in 64-bit kernels. */
> +	WARN_ON_ONCE(!default_noexec);
> +
> +	/* Only executable enclave pages are restricted in any way. */
> +	if (!(prot & PROT_EXEC))
> +		return 0;
> +
> +	/*
> +	 * WX at load time only requires EXECDIRTY, e.g. to allow W->X.  Actual
> +	 * WX mappings require MAPWX (see selinux_enclave_map()).
> +	 */
> +	if (prot & PROT_WRITE) {
> +		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECDIRTY);
> +		if (ret)
> +			goto out;
> +	}
> +	if (!measured) {
> +		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECUNMR);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	if (!vma->vm_file || IS_PRIVATE(file_inode(vma->vm_file)) ||
> +	    vma->anon_vma)
> +		/*
> +		 * Loading enclave code from an anonymous mapping or from a
> +		 * modified private file mapping.
> +		 */
> +		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECANON);
> +	else
> +		/* Loading from a shared or unmodified private file mapping. */
> +		ret = file_has_perm(cred, vma->vm_file, FILE__SGX_EXECUTE);
> +out:
> +	return ret;
> +}

Same comment on this patch: we might want to generalize the permission 
names in hopes of being able to reuse them in the future for similar 
constructs on other architectures.  SGX -> ENCLAVE throughout?


>   #endif
>   
>   struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
> @@ -6988,6 +7036,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>   
>   #ifdef CONFIG_INTEL_SGX
>   	LSM_HOOK_INIT(enclave_map, selinux_enclave_map),
> +	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
>   #endif
>   };
>   
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index cfd91e879bdf..baa1757be46a 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -7,7 +7,7 @@
>   
>   #define COMMON_FILE_PERMS COMMON_FILE_SOCK_PERMS, "unlink", "link", \
>       "rename", "execute", "quotaon", "mounton", "audit_access", \
> -    "open", "execmod"
> +    "open", "execmod", "sgx_execute"
>   
>   #define COMMON_SOCK_PERMS COMMON_FILE_SOCK_PERMS, "bind", "connect", \
>       "listen", "accept", "getopt", "setopt", "shutdown", "recvfrom",  \
> @@ -52,7 +52,8 @@ struct security_class_mapping secclass_map[] = {
>   	    "setsockcreate", "getrlimit", NULL } },
>   	{ "process2",
>   	  { "nnp_transition", "nosuid_transition",
> -	    "sgx_mapwx", NULL } },
> +	    "sgx_mapwx", "sgx_execdirty", "sgx_execanon", "sgx_execunmr",
> +	    NULL } },
>   	{ "system",
>   	  { "ipc_info", "syslog_read", "syslog_mod",
>   	    "syslog_console", "module_request", "module_load", NULL } },
> 

