Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9061EC48BD5
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 20:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A0A020663
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 20:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="GOf4QGjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfFYUUA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 16:20:00 -0400
Received: from upbd19pa07.eemsg.mail.mil ([214.24.27.82]:46151 "EHLO
        upbd19pa07.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfFYUT7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 25 Jun 2019 16:19:59 -0400
X-EEMSG-check-017: 235371943|UPBD19PA07_EEMSG_MP7.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by upbd19pa07.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 25 Jun 2019 20:19:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561493995; x=1593029995;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=IQ4zXMxg/l8rhYGpgSv2L3MnSgWy1xEw68zCsEYkWyw=;
  b=GOf4QGjxJ3j9586zhO/N5v6khwajEXfXoGJYn58XUbdzwtLMp9NxEN4G
   JN9BbLuqZqr4CUktw4eRFd+Dmpgdf6s0AN+T8V3MFPgS+NFi+axhqDsrs
   0A8Vp0CEKLp5ksQ+6YKVnbNoUZ9pxsLig0mmoIKQf/2fmUjmiwSMd2laD
   hSZfSNItTbxO9n9o1LKFSowqfQuyfcW4PukmnOhkoByGyEslEkCM5cmun
   v91nGWINOJRMcMDIAZWigZ6dynKG414iJzHwCYDLRCYhYMnbPna58J/d4
   RNwFNsFXsPLWL5a71KXFJQsUuGBRZvm0FCbGhFuvGciQ0Yc5NeJdETL/c
   w==;
X-IronPort-AV: E=Sophos;i="5.63,417,1557187200"; 
   d="scan'208";a="25111999"
IronPort-PHdr: =?us-ascii?q?9a23=3AoLX56BfYeFcvZQTS3tAip3t4lGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc28YxON2/xhgRfzUJnB7Loc0qyK6vqmADBLuMzR+DBaKdoQDk?=
 =?us-ascii?q?ZD0Z1X1yUbQ+e9QXXhK/DrayFoVO9jb3RCu0+BDE5OBczlbEfTqHDhpRQbGx?=
 =?us-ascii?q?H4KBYnbr+tQt2agMu4zf299IPOaAtUmjW9falyLBKrpgnNq8Uam4RvJrsvxh?=
 =?us-ascii?q?fTv3dFdOtayX52KV+Qgh3w4tu88IN5/ylfpv4t6tRMXbnmc6g9ULdVECkoP2?=
 =?us-ascii?q?cp6cPxqBLNVxGP5nwSUmUXlhpHHQ3I5wzkU5nyryX3qPNz1DGVMsPqQ780Xy?=
 =?us-ascii?q?+i77pwRx/zlCgHLT85/3rJhcF2kalWvQiupx17w47TfYGVKP9zdb7TcN8GWW?=
 =?us-ascii?q?ZMWNtaWjdfCY2gcYQAE+sBPf5Zr4bjoVsOsQC+DhSoCO/21zNEmmP60ag83u?=
 =?us-ascii?q?svCwHG2BErEcwIvnrasd75ML4eXO6xwaXNyzjIcvFY1irn6IXQbx4vv/+MU7?=
 =?us-ascii?q?Jzf8Tfx0YgGAHKgUmfp4H+IzOY1P4Av3SH4+duV++ijXMspQFrojiow8chkp?=
 =?us-ascii?q?THhp4LxVDc9SV23oA1LsClRk5+e9GkFJ9QuD+aNoBrRc4iWHxnuD0hx70auZ?=
 =?us-ascii?q?+0YCgKyJM9yx7ZcPyIaZKE4h3kVOaPODp1gm9udrGnhxuq7EStxeLxWtO03V?=
 =?us-ascii?q?pXtCZJjNbBum4X2xDO7MWMV+Fz8V272TmV0gDe8uREIUcpmqXFM5Mh2bswlo?=
 =?us-ascii?q?YLsUTEAy/2hF36jK+IeUUg/eil8/jnba/8pp+dKo90kRvyMrgum8OjAeQ4NR?=
 =?us-ascii?q?ICX26H9uSnyLLv50j5QLROjvEuk6nZto7VJdgDq6KkDAJY3Zwv5haiAzu8zt?=
 =?us-ascii?q?gVkmcLIEhYdB6fiojmIVDOIPT2DfelhFSslS9mx+vbMb36GZjNMnjCn6vhfb?=
 =?us-ascii?q?Z68UJczhEzwspF65JbDbEBPur/WlXtu9zAEh85Lwu0zv78CNpjzIweX3iDAq?=
 =?us-ascii?q?2DPKzOsV+I/OMvI/KQZI8SoDb9K+Yq5+T1jX8+n18QZqip3Z0LaH+mGvRqOV?=
 =?us-ascii?q?mWYX3pgt0ZC2cFohI+TPD2iF2FSTNTZWy9X7g/5jE4D4KqF5zDSZqugLyC3S?=
 =?us-ascii?q?e7GINZZmZdB1CIEHfocZiEWvgWZCKTJM9hjiILVby7R4A90hGusRfwy6B7Ie?=
 =?us-ascii?q?rM5i0YqZXj2cBx5+3SkxEy6DN1A92G02GCQGB5hX0IRzAo06Blu0B9yUmM0b?=
 =?us-ascii?q?J+g/NGEdxf/fRJUh01NZTE1ex1F8jyWh7dfteOUFumRtSmATcsTtM+2tMOeF?=
 =?us-ascii?q?hyFMm/jhDZ3iqqH78Um6WOBJwz763cwnzxKNhmxnbY26kukUMmTtFMNWK4nK?=
 =?us-ascii?q?5/8RbcB4rTn0WejaaqerwW3DTR+2eb0WqOoEZYXRZrUarbWXAfZ03Wrcn250?=
 =?us-ascii?q?7ZUb+uBqooMhFbxc6BNKRKcNvpgktCRPv5P9TeeW2xkX+qBRmU3rOMcJbqe2?=
 =?us-ascii?q?IF0STTCUgElwQT/XecOgg7HCuuv3jSDCZpFV30fUzs6/V+qGigQ081yQGKc1?=
 =?us-ascii?q?Nu176v9hEJgvycTusZ3qgYtyc5tzV0AFG90srKBNWavApuYqVdbckm4Fhb1W?=
 =?us-ascii?q?LWrRF9PpKkL698nF4TaAV3v0Xy1xppDoVMi9QlrHQvzABqM6KXzEtBdy+E3Z?=
 =?us-ascii?q?D3IrDXKGzy/Be1a67M21Hey82b+qEV5/Q9tVrjvRulFk0483Voy9NVyWeT5o?=
 =?us-ascii?q?3WDAoOVpL8Sls4+AJkp77EeCU955nb1Xt3MaaqtD/PwNMpBO05yhm+e9dTKr?=
 =?us-ascii?q?+LFAj3E8cCHcihNPQqm0S1bhIDJO1d6LA7MN68d/uHxKGnJulhnDOgjWRI+4?=
 =?us-ascii?q?1900SM9zZiRe7MxZoK3/aY3g6fXTfmkFihqtz3mZxDZTwKGmq/1DTkBIlKa6?=
 =?us-ascii?q?1xY4kLE2GuLNOzxtlkgJ7tQXFY/ka5B1wawM+pZQaSb1vl0A1Sy0sXvXynmT?=
 =?us-ascii?q?G/zzFvnTEpqbCf3DDUzOTkdRoGNXRHS3VljVfpOYK0lcwVXFC0bwg1kxuo/U?=
 =?us-ascii?q?n6x7JFq6RwNGTcX0FIfyroIGFmVquwt6aNb9RT55MvtCUEGNi7NGuXQ7i1iB?=
 =?us-ascii?q?sA0jj/GHNeySogcDfi7o70lho8iiSWLGxyt2beYcF93wzY4vTdQ+Jc2nwNQy?=
 =?us-ascii?q?wuzXH1D0K/PN7hxtyXlJbFv+b2A2CoTJ5Qdm/wxICDtS2240VuABuij7aynM?=
 =?us-ascii?q?HqFU4x1iqthPdwUiCdlwrxeonm0eyBNOtjekR5TAvn59FSBpB1kox2gooZn3?=
 =?us-ascii?q?cdmMPGrjI8jW7vPIADiurFZ30XSGtOmoWE7Q=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2CTAgB0gRJd/wHyM5BlHAEBAQQBAQcEAQGBZ4FoBSqBP?=
 =?us-ascii?q?DIohBaTRgEBAQEBAQaBCS2JU5EOCQEBAQEBAQEBATQBAgEBhEACgnUjOBMBA?=
 =?us-ascii?q?wEBAQQBAQEBBAEBbIpDgjopAYJnAQUjFUEQCxIGAgImAgJJDgYBDAYCAQGCX?=
 =?us-ascii?q?z+BdxSlb4ExhUeDJ4FGgQwoi14XeIEHgREngms+hA0hgyCCWASOIYVLW5VNC?=
 =?us-ascii?q?YIXgh6RRwYbl04tjHuZHSGBWCsIAhgIIQ+DJ4JNFxSOKCMDMAGBBQEBjReCU?=
 =?us-ascii?q?gEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 25 Jun 2019 20:19:37 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5PKJZ6R012191;
        Tue, 25 Jun 2019 16:19:36 -0400
Subject: Re: [RFC PATCH v4 08/12] security/selinux: Require SGX_MAPWX to map
 enclave page WX
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
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-9-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <119f6de8-e7b6-6ebd-be12-862303806ea7@tycho.nsa.gov>
Date:   Tue, 25 Jun 2019 16:19:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190619222401.14942-9-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/19/19 6:23 PM, Sean Christopherson wrote:
> Hook enclave_map() to require a new per-process capability, SGX_MAPWX,
> when mapping an enclave as simultaneously writable and executable.
> Note, @prot contains the actual protection bits that will be set by the
> kernel, not the maximal protection bits specified by userspace when the
> page was first loaded into the enclave.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   security/selinux/hooks.c            | 21 +++++++++++++++++++++
>   security/selinux/include/classmap.h |  3 ++-
>   2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702cf46ca..fc239e541b62 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6726,6 +6726,23 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>   }
>   #endif
>   
> +#ifdef CONFIG_INTEL_SGX
> +static int selinux_enclave_map(unsigned long prot)
> +{
> +	const struct cred *cred = current_cred();
> +	u32 sid = cred_sid(cred);
> +
> +	/* SGX is supported only in 64-bit kernels. */
> +	WARN_ON_ONCE(!default_noexec);
> +
> +	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> +		return avc_has_perm(&selinux_state, sid, sid,
> +				    SECCLASS_PROCESS2, PROCESS2__SGX_MAPWX,
> +				    NULL);

Possibly we should use a slightly more general name for the permission 
to allow reusing it in the future if/when another architecture 
introduces a similar construct under a different branding?  ENCLAVE_* 
seems slightly more generic than SGX_*.

I was interested in testing this code but sadly the driver reports the 
following on my development workstation:

[    1.644191] sgx: The launch control MSRs are not writable
[    1.695477] sgx: EPC section 0x70200000-0x75f7ffff
[    1.771760] sgx: The public key MSRs are not writable

I guess I'm out of luck until/unless I get a NUC or server class 
hardware that supports flexible launch control?  Seems developer unfriendly.

> +	return 0;
> +}
> +#endif
> +
>   struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
>   	.lbs_cred = sizeof(struct task_security_struct),
>   	.lbs_file = sizeof(struct file_security_struct),
> @@ -6968,6 +6985,10 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>   	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
>   	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
>   #endif
> +
> +#ifdef CONFIG_INTEL_SGX
> +	LSM_HOOK_INIT(enclave_map, selinux_enclave_map),
> +#endif
>   };
>   
>   static __init int selinux_init(void)
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 201f7e588a29..cfd91e879bdf 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -51,7 +51,8 @@ struct security_class_mapping secclass_map[] = {
>   	    "execmem", "execstack", "execheap", "setkeycreate",
>   	    "setsockcreate", "getrlimit", NULL } },
>   	{ "process2",
> -	  { "nnp_transition", "nosuid_transition", NULL } },
> +	  { "nnp_transition", "nosuid_transition",
> +	    "sgx_mapwx", NULL } },
>   	{ "system",
>   	  { "ipc_info", "syslog_read", "syslog_mod",
>   	    "syslog_console", "module_request", "module_load", NULL } },
> 

