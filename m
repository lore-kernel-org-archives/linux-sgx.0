Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D63C28CC6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 15:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E29427B57
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 15:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="PrG21Q7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfFCPCO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 11:02:14 -0400
Received: from ucol19pa09.eemsg.mail.mil ([214.24.24.82]:45781 "EHLO
        ucol19pa09.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbfFCPCN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Jun 2019 11:02:13 -0400
X-EEMSG-check-017: 859349162|UCOL19PA09_EEMSG_MP7.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="859349162"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by ucol19pa09.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 03 Jun 2019 15:01:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559574099; x=1591110099;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qWcatyDP/HU5QWBmezGjw/wKg6kAR4dxaj1FfpOZZKs=;
  b=PrG21Q7lEXYousESxTIbkmTq8W3WgRzE7kB0vyyKtO63KUx2g0hYexei
   qV4ByOXX5dRVSoiWSvbezhD2btj/wvuW//UC5Lbg5NDcl/eS9y0feppPu
   qljIm9wsZYoXxIAxRI3jtmQ3oEAgV6TBkyedCqxBdg/1apYEoKdEZA+ta
   SYnZHbBPsztG0k+1YQwMAVKwcXyPad9N/012NK/MLpTEsMb+U17vm7bQ8
   DhOLn/uOF/R1tssITNX5cwuM7FfwdT3SFgTxS55YBxLmeVc/90R9T1tGm
   g0r1jDLCQxcWArLPdKSnG+LQBRmgpxm6UNkeCmSbuPM+5OYdzKEZb1J8Q
   w==;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="24331432"
IronPort-PHdr: =?us-ascii?q?9a23=3ApTZYpxZXkUiEp0CX3Wzt52//LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZpcqzYR7h7PlgxGXEQZ/co6odzbaP6ua5AjNLvsjJmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQi6oR/MusQYg4ZuJaQ8xx?=
 =?us-ascii?q?rUqXZUZupawn9lK0iOlBjm/Mew+5Bj8yVUu/0/8sNLTLv3caclQ7FGFToqK2?=
 =?us-ascii?q?866tHluhnFVguP+2ATUn4KnRpSAgjK9w/1U5HsuSbnrOV92S2aPcrrTbAoXD?=
 =?us-ascii?q?mp8qlmRAP0hCoBKjU063/chNBug61HoRKhvx1/zJDSYIGJL/p1Y6fRccoHSW?=
 =?us-ascii?q?ZdQspdUipMDY2mb4sLEuEPI+BWoYfgrFcKtBezCw2hCObpxzRVhHH5wLc63v?=
 =?us-ascii?q?w8Hw/Y0gwuH9EAvnrao9r6NqgdTe+7wbLUzTjBdf5axSvx5YbKfx0nvPqCXa?=
 =?us-ascii?q?hwcc3UyUQ3Cg3FkkufqZTlPzyL0OQGrnWV7+96WuKrj24otQFwqSWoy8c3l4?=
 =?us-ascii?q?bJnZkYykzE9CplwIY1Ise0SEhgYdG+CpdQuCaaN5VvT84kXmpmuz46x6UbtZ?=
 =?us-ascii?q?O0cyUG0pQqywPFZ/CZfIWE/AjvWPuXLDxlnnxqYqi/iAy38UW4z+38UdS730?=
 =?us-ascii?q?hSoypel9nMqmgN1xvO6sibUvd9/lmu2TKI1w3L9uFLO1o0lavGK5462LIwip?=
 =?us-ascii?q?oSvljDHi/xgkn2irOZdl449eSy7uTnY7HmqoedN49ylA7+LrwjltGwDOk3KA?=
 =?us-ascii?q?QDX3WX9f6i2LDs40H1WqhGguUzkqbDsZDaIcobprS+Aw9Qyosj8AuwDyy93d?=
 =?us-ascii?q?QEnXgIMFJFeBWdg4jvIFHBOur0Dfi4g1SyiDtr3ezJPqX9ApXRKXjOiKzhcq?=
 =?us-ascii?q?hn5E5a0gYzz8pT6I5UCrEbIfLzQVPxtNvADh85LQO02f3nCNJ71o4FWGKPBL?=
 =?us-ascii?q?OZP73WsVOS+u0vJOyMbpcPuDnhM/gl++LujXghlF8fZ6apx5gXaHO/Hvh8OE?=
 =?us-ascii?q?WWe3nsgtQAEWcMoAU+SvfniFmDUT5VenazULgw5jA9CIK6E4jDQpqhj6CG3C?=
 =?us-ascii?q?e+BpdWfHxJCkiQEXf0cIWJQ/MMaD+OIs9miTEEVqauS5Un1R6wsA/20b1nLv?=
 =?us-ascii?q?Db+icAr5LsyMB15/HPlRE17TF7E9qS3HyXT2F1gmwEXTA33KF5oUxy0VqD0K?=
 =?us-ascii?q?54g+BGGtxX/f9GTgA6NZvExexgF9/yQh7BfsuOSFu+QNWmBDYxTsgrw98PeE?=
 =?us-ascii?q?ZwANOigQrG3yW0Ar8ZjbuLBIY78qjExXj+O959y2ra1Kkml1QmWdVANXephq?=
 =?us-ascii?q?Fh7AXTB5TGk0Gdl6eqc6QQxjLC9GCGzWCWpkFXTBZwUbnZXXAYfkbWqdX55k?=
 =?us-ascii?q?XfT76hELgnKRVOxtKfKqtQa93pkVVHSO7mONTZfm2xhmOwCgiTy7OSY4rlZX?=
 =?us-ascii?q?8d0D/eCEcaiQAT+2iJNQwkCiemuWLeAyRkFUjzbEP07el+tHS7Q1cszw6Qck?=
 =?us-ascii?q?1h06G4+gYPivyBT/Mfx7cEuCAmqzVuAlmxxc7ZC92FpwB5ZqVTfcs94Etb1W?=
 =?us-ascii?q?LerwFyIISgILp4hl4faAR6pFvu2A9tCoVBisgqtHcqwxBuJq2Gyl9BcCmY3Z?=
 =?us-ascii?q?/oML3NNmby5Ayva7LR2lzGy9aZ5KMP6PU+q1X+swCkDVQi83p53NlPyXec5Y?=
 =?us-ascii?q?vFDBAUUZ3vVkY77R96p6vVYiMl/YPbyWVsMbWosj/Fw98pBvUqygqgf9dFN6?=
 =?us-ascii?q?OJDwHyE8oAB8iyMuMqnVmpbx0eMO9O8640Otusd+Ga166zIOZggDWmgHxa74?=
 =?us-ascii?q?9nzEKD6TBwSu7S0JYD2PGXwA2HWiz9jFenrsD4h4REaSsOEWq4zCjuHJRRab?=
 =?us-ascii?q?FqfYYXFWeuJNW6xslxh57pVH9V71qjB1IA2M+0ZRqSdVv93QtR1UUYu3CohD?=
 =?us-ascii?q?W3xSRukz41tqqfwDDOw+P6eRobPW5LXndigk3oIYeplNAXR0yobwkvlBu46k?=
 =?us-ascii?q?f23qZbpKNiL2nVXEhHZTT2L2BlUqu2rLaCZNRP6JwwuyVNTOu8eUyaSqL6ox?=
 =?us-ascii?q?YC1yPjHm1exC00dj2zuZX2gQZ6iGSDI3Z3t3fZZ85wygnF5NDGRv5ewCAGRC?=
 =?us-ascii?q?9mhjnTHFS8OMOp/dqMnZfZru++T36hVoFUcSTzwoKNtyq26HZpARKhhfCznM?=
 =?us-ascii?q?PoEQwg3S/8zdlqWj3CrAzgbYnzy6S6LeVnc1FsBF/97cp6B45/npIrhJEf1n?=
 =?us-ascii?q?kXnYuV/XUZnmfpK9lb2rzxbGALRTEVx97Z+g/l2FdsLniR3YL2Sm2dwtd9Z9?=
 =?us-ascii?q?m9em4ZwCE979hPCKqP6LxEnC11oke3rA7Ib/h9mSodyf0z53EAn+EJuQ0tzi?=
 =?us-ascii?q?OHDrAVB0lYMjTmlw6U4NCmsKVXeGGvfKC21Ep+mtChFrSCrRtaWHviYJctAz?=
 =?us-ascii?q?J/7sVlP1LQynH89obkeNzIZ9IJqhKUiwvAj/RSKJ8pkPoKnS9nNn7hsnI/z+?=
 =?us-ascii?q?47iQFu3ZShsYidNWpi4aK5DQRENjHve8wT/TTth75EnsmKx4CvAolhGjITUZ?=
 =?us-ascii?q?vzU/2oCj0Suur9OwmUEDw8rWqbGbzEEA+e7kdms2zAE5SxO36LI3kZyM1oRA?=
 =?us-ascii?q?OBK0xHnAAUQDI6k4YiFgCq3sPgcF115jML6V7kqxpA0+NpOAP6UmfevgelcT?=
 =?us-ascii?q?Y0SJ6DLBVI6gFO/VvaMcub7uhrBSFX4oWhrBCRKmycfwlIDXsGWk2YB1/5Ob?=
 =?us-ascii?q?mi/9nA8/WCCeq4IPvDerSOqepCV/iWwZKjyJdp/zGJNs+XJHltE+U72lZfXX?=
 =?us-ascii?q?B+A8nWgTMPRDENlyLMb8+Xvgy8+i1pocCh7PvrWBzg5Y2MC7tVKthv/xG2ga?=
 =?us-ascii?q?GeN++fnip5KDBY1o8Syn/M0rQQwFkSiyR2fTm3DbsArTLNTL7XmqJPDB4UcS?=
 =?us-ascii?q?JzONFT76IixAZNOcjbh8j01r5+kv46FVNFWUb9lcGuYMwAO3u9O0/fBEaXKL?=
 =?us-ascii?q?SGIiXGzNrvYa6nU7JQiORUuAO2uTuYCUPsIyqMnSHzVx+zKeFMkD2bPBtGtY?=
 =?us-ascii?q?G/dRZtEmjjQcnkah28K993jSE2wac1hnPSMW4TLyR8c19Xor2X9yNYje11G3?=
 =?us-ascii?q?Zd4Xp9MemEhyGZ4vHbKpkMsPtnGCR0l/9A73Q8xLtY9yBERPppmCTMqt5iuU?=
 =?us-ascii?q?2pku6KyjB/ShpBti5LhJ6XvUVlIajZ7JhAVmjC/BIR72WfFQ8KqsBqCt3ovK?=
 =?us-ascii?q?BQxdzPm7zpJDhe9NLU+NMWB9LIJ8KfLHohLR3pFSbaDQsEST6rMWDfiFZYkP?=
 =?us-ascii?q?2I6nKZtII6qp/3l5UQUL9bSEc1G+gbCkRjANwNPpN3Uik4nr6cic4C/WC+ow?=
 =?us-ascii?q?XJRMVGopDHUeqfAe3vKDaYiblEZgMIzanjIogJKo37wU1iZUVmk4vQAEfQXN?=
 =?us-ascii?q?ZNojF/YQ8wuklC7H9+Tmhgk37iPzig6XlbPv6unwUqjRN+bP428zGkt0w6L1?=
 =?us-ascii?q?yMpm07kFMwgsnimTCcaiX2Ko+xW51bD2z/sE1ndtvZShx2bgr6pkVnNzbCSr?=
 =?us-ascii?q?QZ27lpb2Noj0nHsJhMGPhRS4VAYRkN1beWYekl1RJXrSDxlmFd4u6QModvjA?=
 =?us-ascii?q?snd9aXqntE3w9yJIouKbf4OLtCzl8WgLmH+CCvyLZik0clO08R/TbKK2Yzs0?=
 =?us-ascii?q?sSO+xjfnH58w=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2ArAADANPVc/wHyM5BmHAEBAQQBAQcEAQGBUQcBAQsBg?=
 =?us-ascii?q?WYqgTsBMiiEFIgcimpSBoEQJYlQjw2BewkBAQEBAQEBAQE0AQIBAYRAAoMSI?=
 =?us-ascii?q?zQJDgEDAQEBBAEBAQEDAQFsKII6KQGCZwEFIwQRQRALGAICJgICVwYBDAYCA?=
 =?us-ascii?q?QGCXz+BdxSpdn4zhUeDHYFGgQwoAYtZF3iBB4ERJwyCXz6HToJYBI1pSoU/l?=
 =?us-ascii?q?B1qCYIPghiRFAYbgiKKc4lZLYxTmBU4gVgrCAIYCCEPgyeCGxeOPCMDMAGBB?=
 =?us-ascii?q?QEBkE0BAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 03 Jun 2019 15:01:36 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x53F1WW3017363;
        Mon, 3 Jun 2019 11:01:33 -0400
Subject: Re: [RFC PATCH 9/9] security/selinux: Add enclave_load()
 implementation
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
 <20190531233159.30992-10-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <b75cd16f-41a5-0933-3847-02aaa5b2c7d0@tycho.nsa.gov>
Date:   Mon, 3 Jun 2019 11:01:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531233159.30992-10-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/31/19 7:31 PM, Sean Christopherson wrote:
> The goal of selinux_enclave_load() is to provide a facsimile of the
> existing selinux_file_mprotect() and file_map_prot_check() policies,
> but tailored to the unique properties of SGX.
> 
> For example, an enclave page is technically backed by a MAP_SHARED file,
> but the "file" is essentially shared memory that is never persisted
> anywhere and also requires execute permissions (for some pages).
> 
> The basic concept is to require appropriate execute permissions on the
> source of the enclave for pages that are requesting PROT_EXEC, e.g. if
> an enclave page is being loaded from a regular file, require
> FILE__EXECUTE and/or FILE__EXECMOND, and if it's coming from an
> anonymous/private mapping, require PROCESS__EXECMEM since the process
> is essentially executing from the mapping, albeit in a roundabout way.
> 
> Note, FILE__READ and FILE__WRITE are intentionally not required even if
> the source page is backed by a regular file.  Writes to the enclave page
> are contained to the EPC, i.e. never hit the original file, and read
> permissions have already been vetted (or the VMA doesn't have PROT_READ,
> in which case loading the page into the enclave will fail).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   security/selinux/hooks.c | 85 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 85 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702cf46ca..f436a055dda7 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6726,6 +6726,87 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>   }
>   #endif
>   
> +#ifdef CONFIG_INTEL_SGX
> +int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> +			 unsigned long *allowed_prot)
> +{
> +	const struct cred *cred = current_cred();
> +	u32 sid = cred_sid(cred);
> +	int rc;
> +
> +	/* SGX is supported only in 64-bit kernels. */
> +	WARN_ON_ONCE(!default_noexec);
> +
> +	/*
> +	 * SGX is responsible for checking @prot vs @allowed_prot, and SELinux
> +	 * only cares about execute related permissions for enclaves.
> +	 */
> +	if (!(*allowed_prot & PROT_EXEC))
> +		return 0;
> +
> +	/*
> +	 * Loading an executable enclave page from a VMA that is not executable
> +	 * itself requires EXECUTE permissions on the source file, or if there
> +	 * is no regular source file, EXECMEM since the page is being loaded
> +	 * from a non-executable anonymous mapping.
> +	 */
> +	if (!(vma->vm_flags & VM_EXEC)) {
> +		if (vma->vm_file && !IS_PRIVATE(file_inode(vma->vm_file)))
> +			rc = file_has_perm(cred, vma->vm_file, FILE__EXECUTE);

We might need an EXECMOD check here as well if (vma->vm_file && 
vma->anon_vma).  The scenario would be that the host application mapped 
the file with PROT_WRITE, modified it, but haven't mapped it PROT_EXEC. 
Now the enclave loader requests PROT_EXEC without PROT_WRITE or allows 
it.  FILE__EXECUTE is insufficient for this case.

> +		else
> +			rc = avc_has_perm(&selinux_state,
> +					  sid, sid, SECCLASS_PROCESS,
> +					  PROCESS__EXECMEM, NULL);

These calls will audit FILE__EXECUTE or PROCESS__EXECMEM denials even 
when userspace never asked for PROT_EXEC. Possibly we should use 
avc_has_perm_noaudit() and only call avc_audit() if (prot & PROT_EXEC)? 
And similarly introduce file_has_perm_noaudit() -> 
inode_has_perm_noaudit() -> avc_has_perm_noaudit() or inline here and 
switch to avc_has_perm_noaudit() throughout?

> +
> +		/*
> +		 * Reject the load if the enclave *needs* the page to be
> +		 * executable, otherwise prevent it from becoming executable.
> +		 */
> +		if (rc) {
> +			if (prot & PROT_EXEC)
> +				return rc;
> +
> +			*allowed_prot &= ~PROT_EXEC;
> +		}
> +	}
> +
> +	/*
> +	 * An enclave page that may do RW->RX or W+X requires EXECMOD (backed
> +	 * by a regular file) or EXECMEM (loaded from an anonymous mapping).

At present EXECMEM is also triggered for W+X private file mappings, to 
allow denying W+X while permitting exceptions for W->X for text relocations.

> +	 * Note, this hybrid EXECMOD and EXECMEM behavior is intentional and
> +	 * reflects the nature of enclaves and the EPC, e.g. EPC is effectively
> +	 * a non-persistent shared file, but each enclave is a private domain
> +	 * within that shared file, so delegate to the source of the enclave.
> +	 */
> +	if ((*allowed_prot & PROT_EXEC) && (*allowed_prot & PROT_WRITE)) {
> +		if (vma->vm_file && !IS_PRIVATE(file_inode(vma->vm_file)))
> +			rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
> +		else
> +			rc = avc_has_perm(&selinux_state,
> +					  sid, sid, SECCLASS_PROCESS,
> +					  PROCESS__EXECMEM, NULL);

Same issue wrt auditing here.  Could also potentially skip the EXECMEM 
check this time if we performed it above (if so, then we must have 
passed it because *allowed_prot still had PROT_EXEC set).

> +		/*
> +		 * Clear ALLOW_EXEC instead of ALLOWED_WRITE if permissions are
> +		 * lacking and @prot has neither PROT_WRITE or PROT_EXEC.  If
> +		 * userspace wanted RX they would have requested RX, and due to
> +		 * lack of permissions they can never get RW->RX, i.e. the only
> +		 * useful transition is R->RW.
> +		 */
> +		if (rc) {
> +			if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> +				return rc;
> +
> +			if (prot & PROT_EXEC)
> +				*allowed_prot &= ~PROT_WRITE;
> +			else
> +				*allowed_prot &= ~PROT_EXEC;
> +		}
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
>   struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
>   	.lbs_cred = sizeof(struct task_security_struct),
>   	.lbs_file = sizeof(struct file_security_struct),
> @@ -6968,6 +7049,10 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
>   	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
>   	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
>   #endif
> +
> +#ifdef CONFIG_INTEL_SGX
> +	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
> +#endif
>   };
>   
>   static __init int selinux_init(void)
> 

