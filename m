Return-Path: <SRS0=PKbn=UR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AE0C31E5E
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 14:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEB820B1F
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 14:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="IpixEavk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbfFROuR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:50:17 -0400
Received: from ucol19pa10.eemsg.mail.mil ([214.24.24.83]:47569 "EHLO
        UCOL19PA10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729758AbfFROuQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Jun 2019 10:50:16 -0400
X-EEMSG-check-017: 687595701|UCOL19PA10_EEMSG_MP8.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.63,389,1557187200"; 
   d="scan'208";a="687595701"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 18 Jun 2019 14:50:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560869409; x=1592405409;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=GgLjOtox1fA2/dg1RNh5RluXDHi+7u55VmV/atFqVzA=;
  b=IpixEavkwcv+eI+53kn8r4DoCTRiPfNADVU2E8MKAeliEPP0ioF9Z1/Y
   o8JnRb7nva1DRAfgLBBlTii6dEVnkSMZa6ER4Jl1ZGqnvpz2UsqxPX569
   sWUKyzCYd4VlphMY14+JKcLD3qoaY6scBm/A3k9w3vsFj2CSXitTHcrPV
   nzTDcuRMnMEd9mHwhb8aw4E5klPaQe5FUw9c8rdoohwF2f9RLWM5Zl7MZ
   F28MSr+177aVBlghA6t9upoH1vvOUetM66z6u4V3XfyzX5ZpMtrPVMz9+
   lPk0bh1bsXX4Kk0GxmNVdE5H2V2gVG1o7cvVXK4kJt5s5LuxWzzzSM3Yr
   A==;
X-IronPort-AV: E=Sophos;i="5.63,389,1557187200"; 
   d="scan'208";a="24854880"
IronPort-PHdr: =?us-ascii?q?9a23=3ASE06jRQfhlqisEjiqw6x0AaLn9psv+yvbD5Q0Y?=
 =?us-ascii?q?Iujvd0So/mwa67ZxeBt8tkgFKBZ4jH8fUM07OQ7/m6HzRYqsrQ+DBaKdoQDk?=
 =?us-ascii?q?ZD0Z1X1yUbQ+e9QXXhK/DrayFoVO9jb3RCu0+BDE5OBczlbEfTqHDhpRQbGx?=
 =?us-ascii?q?H4KBYnbr+tQt2agMu4zf299IPOaAtUmjW9falyLBKrpgnNq8Uam4RvJrsvxh?=
 =?us-ascii?q?fTvndEZ+tayGxsKFmOmxrw+tq88IRs/ihNpv4t7dJMXbn/c68lUbFWETMqPn?=
 =?us-ascii?q?wv6sb2rxfDVwyP5nUdUmUSjBVFBhXO4Q/5UJnsrCb0r/Jx1yaGM8L4S7A0Qi?=
 =?us-ascii?q?mi4LxwSBD0kicHNiU2/3/Rh8dtka9UuhOhpxh4w47JfIGYMed1c63Bcd8GQ2?=
 =?us-ascii?q?dKQ91cXDJdDIyic4QPDvIBPedGoIn7u1sOtga1CQ21CO/y1jNEmnr60Ks03O?=
 =?us-ascii?q?Q7FQHNwRIuEdQAvn/JqNn5LakfXOSwwKTO0D7Nbe5Z2S3l5YbVbB4hr/GCU7?=
 =?us-ascii?q?F+f8XfxkYgFR/KgFqLpIz5PT6YzPgBv3SV4udiU++klm4pqxt2ojiq3soil5?=
 =?us-ascii?q?XJiZwNylDE6yp5xps+K8C9SEFhZd6kFIVftiGHPIZxWcMtXnpotT0myrwGpZ?=
 =?us-ascii?q?G7fC8KxI4hxx7EcfOLaYeI4hX9VOuIJzpzmXFreKqnihqv/kWtxffwW8mp3F?=
 =?us-ascii?q?pQsCZIncfAumoQ2xHV98OJUOFy/l271jaKzw3T7+ZELl0qmqfDMJ4hx6Iwlo?=
 =?us-ascii?q?IUsUTeAi/6gEX2g7GSdkUj4uWo9/7oYq/npp+BLI94kB3+M6Qylcy/BuQ0KA?=
 =?us-ascii?q?4OUHSA+eugzrHj+Ez5QLFSgv03lKnWrozaKNwGqqO2DAJZyIYu5wulAzu439?=
 =?us-ascii?q?kUg2MLIE9ddBKClYfpOlXOIP7iDfe4hlShiCxryO3dPrD6HpXMLmTMkLfmfb?=
 =?us-ascii?q?pn7U5c0xA8wcpQ55JTFLENOOjzVVPptNzEEh85NBS5w/35B9pn0IMSQ2CPDr?=
 =?us-ascii?q?WFP6PSq1+I5/kvI/WLZI8NuDbyNeIl5+XpjX8/glIdfK+p3YcJZ3C8BPhpP0?=
 =?us-ascii?q?KZYX/0iNcbDWgKphY+TPDtiFCaUz5cfWyyX6E/5jE8Eo6mFp3MRoOugLyA2i?=
 =?us-ascii?q?e0AJtWa3tCClCNF3foaoqFV+0NaCKUPs9ujDgEWaK9RI8m0BGkrBX6xKZ/Lu?=
 =?us-ascii?q?rI5i0Ysoru1Nx05+3ViBEz+iV4D9+S02CCVGx0gGwISCEs3Kxlokxy1E2D0a?=
 =?us-ascii?q?5mjPxcD9BT4OlJUggiP57G0+N6E8zyWh7GftqRVVmpWMumDi8rQtIx2dAOZV?=
 =?us-ascii?q?19FMukjh3Y3iqqBaMVmKKPBJAu7q3c2H3xLd5ny3nazKkhk0UmQsxXOGK6mK?=
 =?us-ascii?q?Fw6hLTB4/VnEmDmKeqdKIc3CHW+WeCy2qOoF9XUApqXarZWnAfY1Pcrc7l6U?=
 =?us-ascii?q?PaU7+uFbMnPxNFyc6fNqtKbcbkjVZYS/f5PtTRfWaxl323BRaSybOGdJDqdH?=
 =?us-ascii?q?kF3CXBFEgElBge/XSYOggiBiehuWXeASdgFVLoeUPs7fNxqHW6Tk471Q2Fc0?=
 =?us-ascii?q?ph17+t8B4PmfOcU+8T3q4DuCo5pDV0Bkiy393NBtWeoQphfrtTYdc54FdGyW?=
 =?us-ascii?q?3VrRByPpulL/MqullLSAl+uQvF1w92EZlHicgntmgtykImMq+R1hVDMTiYx5?=
 =?us-ascii?q?HrJrrPKmTo5xepQ6/Qxlzalt2R//FLoNYxsVbgu0mSH0kh8nNq1ZEB0XKG5Z?=
 =?us-ascii?q?bNShEbUpHwVEsx3xx7oazKJCg7+47Qk3ZrNP/nnCXF3ocSGOY9yhumN+xaOa?=
 =?us-ascii?q?eAGR66R9YWHOCyOecqnB6vdRtCM+dMov1nd/i6fueLjfb4dN1rmyir2CEeu9?=
 =?us-ascii?q?Fw?=
X-IPAS-Result: =?us-ascii?q?A2DZAACW+Qhd/wHyM5BmGwEBAQEDAQEBBwMBAQGBZYFiB?=
 =?us-ascii?q?SqBOwEyKIQWk0cBAQEGgTWJU5EMCQEBAQEBAQEBATQBAgEBhEACglEjOBMBA?=
 =?us-ascii?q?wEBAQQBAQEBAwEBbCiCOikBgmcBBSMEEUEQCxgCAiYCAlcGAQwGAgEBgl8/g?=
 =?us-ascii?q?XcUqWd+M4VHgyCBRoEMKIteF3iBB4ERJ4JrPodOglgEjg1MhHlXlE1qCYISg?=
 =?us-ascii?q?huRMgYbgieLEIl9LYxwmHYhgVgrCAIYCCEPgyeCGxeOPCMDMAGBBQEBjm8BA?=
 =?us-ascii?q?Q?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 18 Jun 2019 14:49:58 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5IEntKG005970;
        Tue, 18 Jun 2019 10:49:56 -0400
Subject: Re: [RFC PATCH v3 10/12] security/selinux: Add enclave_load()
 implementation
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-11-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <267cb58d-aea2-b33c-e711-84cb5fb0ad8e@tycho.nsa.gov>
Date:   Tue, 18 Jun 2019 10:49:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190617222438.2080-11-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/17/19 6:24 PM, Sean Christopherson wrote:
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
>    - SGX_EXECMOD: dynamically load code within the enclave itself
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
> index 22e0f4a71333..ea452a416fe1 100644
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
> -				    SECCLASS_PROCESS2, PROCESS2__SGX_EXECMEM,
> -				    NULL);
> +		return sgx_has_perm(sid, PROCESS2__SGX_EXECMEM);
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
> +	 * WX at load time only requires EXECMOD, e.g. to allow W->X.  Actual
> +	 * WX mappings require EXECMEM (see selinux_enclave_map()).
> +	 */
> +	if (prot & PROT_WRITE) {
> +		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECMOD);

So, security_enclave_load() can be called with PROT_WRITE|PROT_EXEC, but 
the subsequent calls to security_enclave_map() won't have both set 
unless a mapping is actually simultaneously WX?  Is that correct? 
Trying to make sure that every PROCESS2__SGX_EXECMOD check here won't be 
followed immediately by a PROCESS2__SGX_EXECMEM check from 
security_enclave_map(), thereby rendering any distinction between them moot.

> +		if (ret)
> +			goto out;
> +	}
> +	if (!measured) {
> +		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECUNMR);

I'm unclear on the concept of loading unmeasured code into an enclave; I 
thought that wasn't supposed to happen apart from SGX2.  How does that 
occur?

> +		if (ret)
> +			goto out;
> +	}
> +
> +	if (!vma->vm_file || !IS_PRIVATE(file_inode(vma->vm_file)) ||

I think this should be IS_PRIVATE(), not !IS_PRIVATE()?

> +	    vma->anon_vma)
> +		/*
> +		 * Loading enclave code from an anonymous mapping or from a
> +		 * modified private file mapping.
> +		 */
> +		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECANON);

I might have expected this to be EXECMEM.  It is actually a blend of 
EXECMEM and EXECMOD, so I'm ok with the new name. However, I'm wondering 
if you should use an entirely different set of permission names than 
EXECMEM or EXECMOD for the other checks too since none of them quite 
align with the existing usage; your SGX__EXECMEM is effectively MAPWX 
and your SGX__EXECMOD is effectively MAPXAFTERW.  Or something like that.

> +	else
> +		/* Loading from a shared or unmodified private file mapping. */
> +		ret = file_has_perm(cred, vma->vm_file, FILE__SGX_EXECUTE);
> +out:
> +	return ret;
> +}
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
> index 0f525f5b926f..29a0a74268cd 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -52,7 +52,8 @@ struct security_class_mapping secclass_map[] = {
>   	    "setsockcreate", "getrlimit", NULL } },
>   	{ "process2",
>   	  { "nnp_transition", "nosuid_transition",
> -	    "sgx_execmem", NULL } },
> +	    "sgx_execmem", "sgx_execmod", "sgx_execanon", "sgx_execunmr",
> +	    NULL } },
>   	{ "system",
>   	  { "ipc_info", "syslog_read", "syslog_mod",
>   	    "syslog_console", "module_request", "module_load", NULL } },
> @@ -64,7 +65,7 @@ struct security_class_mapping secclass_map[] = {
>   	    "quotaget", NULL } },
>   	{ "file",
>   	  { COMMON_FILE_PERMS,
> -	    "execute_no_trans", "entrypoint", NULL } },
> +	    "execute_no_trans", "entrypoint", "sgx_execute", NULL } },

If there is any possibility of a mapping of a non-regular file reaching 
the point of the permission check, then the permission needs to either 
be added to COMMON_FILE_PERMS or be added to each of the *_file classes 
for which it can legitimately be checked.  That's why execmod is in 
COMMON_FILE_PERMS; it can show up on e.g. a modified private file 
mapping of a device file in addition to regular files.

>   	{ "dir",
>   	  { COMMON_FILE_PERMS, "add_name", "remove_name",
>   	    "reparent", "search", "rmdir", NULL } },
> 

