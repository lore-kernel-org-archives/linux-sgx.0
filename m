Return-Path: <SRS0=ZwJT=UG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB8CC2BCA1
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jun 2019 19:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CA47212F5
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jun 2019 19:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="kBWM5c5Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfFGT6w (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Jun 2019 15:58:52 -0400
Received: from ucol19pa10.eemsg.mail.mil ([214.24.24.83]:26184 "EHLO
        UCOL19PA10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbfFGT6v (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Jun 2019 15:58:51 -0400
X-EEMSG-check-017: 684338919|UCOL19PA10_EEMSG_MP8.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.63,564,1557187200"; 
   d="scan'208";a="684338919"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UCOL19PA10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 07 Jun 2019 19:58:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559937523; x=1591473523;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=3Hy7BXugypGIjXG/8fx9rHYhLj2l1BzUfmgLAqUYzcs=;
  b=kBWM5c5YhbHGutYIapoMpIXspCbybNZv9TMTpjCkc2Y3vJrGCe9+picv
   2mXNWxKgRSOmf72427ypEObn3kai9tSCGdmYR8aD3D4G8Uh76YxmYTgwK
   rhH5IoSKQ6+rvdi+2Jvi2LECvrKjNNId2fndaZfwJHSEY2YD9xHig/xGx
   C0EX5bhisS04IYNyq5NdqQj9QEubzcjRGnpuu2tyBX26j6HoLw5YZqycp
   XP9NK80BibS25vYqVSRlvA53oVIHDU1pph3VL0/biKh0EHKmbcK8u339/
   UsU3AotZPVCT2tShMHpr9xikqAj34R+ZXxTsU03RYeww59A7wbxLrUm2B
   A==;
X-IronPort-AV: E=Sophos;i="5.63,564,1557187200"; 
   d="scan'208";a="28715090"
IronPort-PHdr: =?us-ascii?q?9a23=3A5+Q1WRGNmq12mCof/307bJ1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ75oM+8bnLW6fgltlLVR4KTs6sC17OP9fm8BydZvczJmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQi6oR/MusQZgIZuJbs9xx?=
 =?us-ascii?q?TXrnBVZ+lY2GRkKE6JkR3h/Mmw5plj8ypRu/Il6cFNVLjxcro7Q7JFEjkoKn?=
 =?us-ascii?q?g568L3uxbNSwuP/WYcXX4NkhVUGQjF7Qr1UYn3vyDnq+dywiiaPcnxTbApRT?=
 =?us-ascii?q?Sv6rpgRRH0hCsbMTMy7XragdJsgq1FvB2hpgR/w4/Kb4GTKPp+Zb7WcdcDSW?=
 =?us-ascii?q?ZcQspdSylND4WyYIsVC+oKIPhWoY/zqVATqReyHBegCefqxjJOm3T437A10/?=
 =?us-ascii?q?45HA/bwgIgEdIAvnfaotr7O6gdU/y6wqbTwDXfbf5bwyvx5JTGfx0jp/yHQL?=
 =?us-ascii?q?J+cdDWyUkqDw7Lk0mQppL9PzOVyOsNtXWQ4fdlVe21j24nrx9+oziyzcorkY?=
 =?us-ascii?q?nGm5kVx0vY9SR53Ik1Jdq4RFR9Yd6/CpRcrS6aN4xoQs47RWxjpSg0yroDuZ?=
 =?us-ascii?q?GhfSgKzowqxx3BZPyddYiH/BbjWPyWITdii3Jofq+0iRWq8UW41+HxWca53E?=
 =?us-ascii?q?xKoyZYiNXAqH8A2wLJ5sSaTPZ2412v1iyV1w/J7+FJOUU0la3GJJE/2rMwjZ?=
 =?us-ascii?q?8TsVjbHi/xhUX2kLeadkU69eis7OTqeqnmqYWGN491lwH+Kb4imtC/AOskMg?=
 =?us-ascii?q?gOWHKX+eKg27344UL1WrBKjvwykqXBsZDaI9oUprKhDgNI3Ysu5AyzAje73N?=
 =?us-ascii?q?gCg3UKI0xJdAiag4TxPlHBOvH4DfOxg1S2lzdrwujLPqb8DZXWNXXDjLfgcq?=
 =?us-ascii?q?p9605b0gYzy8tf6IhOBrEOJ/LzRFf9tMbEAR8hLwy03+HnBc1m1owAQ22PBL?=
 =?us-ascii?q?WVMKHIvVCU5uIvOeiMZJQJuDb6M/gl5+DhjWUimV8ae6mkxpoXaHakHvt4J0?=
 =?us-ascii?q?WVe2bjgtAEEW0SpAoxUPTqiEGeUT5Uf3uyXbgz5is4CIKlCofPXJutj6aC3C?=
 =?us-ascii?q?e4H51WYH5JClaXHHfsdoWEXeoMaS2ILs9glDwESaauS4s72R6ysw/6zqJtLv?=
 =?us-ascii?q?DI9S0AqZLjyN916vXXlREv6Tx0CN+Q02KTQGFumGMHWTs20Lp4oUxnxVeJyb?=
 =?us-ascii?q?J4jOBAFdxP+/NJVR83OoLCwONnEdDyWx7Ocs2GSVanRNWmDio8TtM3w98SfU?=
 =?us-ascii?q?l9H8+ugQzE3yqvG7UVjaCEBIQo8qLA2Hj8P8R9y3PB1Kk7lVkmQ9BPOHaghq?=
 =?us-ascii?q?Fl8gjcGY/Jn1+el6aweqQWxDTN+3ubzWqSoEFYVxZ9Ub7bUnAFaUvZs8/05k?=
 =?us-ascii?q?PYQL+qDbQmMg1BxdSeJatNb93jlU9GS+v7ONTCf2KxnH+9BRKJxrOKcYrrdH?=
 =?us-ascii?q?wR3D7DB0cYjgAT53eGNRQ+Byu4pmLeCyFhFU/rY0zy6uR+tny7QVEuzw2QbE?=
 =?us-ascii?q?1uyaC1+hgLivyYUf8T2agEuCg5oTVuAFm9x87WC8aHpwd5ZKVTe8494FNc2G?=
 =?us-ascii?q?LBrQN9I5igI7lnhl4ZdAR3pV3h2w9rBYVHlMggtGkqwxZqKaKEzFNBcCuV0o?=
 =?us-ascii?q?7oOrLNMGny/QuvZrXO2l7EytaW+7wP6Ow8q1r5oA6mCFAu83J909lay3Gc/I?=
 =?us-ascii?q?nFDBIOUZLtVUY67wN6qK/eYik84YPUyHJtPLKqsj/Nxd0pHvEpyhW+cNdFNq?=
 =?us-ascii?q?OLCgvyH9cdB8i0J+wgg0KpYQ4cPOBO6K40ONurd/mY1663POZghjWmgH9J4I?=
 =?us-ascii?q?B6yEKM6zBzSujJ35cK2f2XwgyHVzLkhle7rs/3gZxEZS0VHmen1CfrHpBRab?=
 =?us-ascii?q?NocYYLE2iuJda3yct4h5P2Wn5Y8kKjCE0C2MOzZRWSaFn91xVK1UsLuXynhT?=
 =?us-ascii?q?e4zztsnjE1oaqf2CPPzv/mdBoGPG5LWXVijU3rIYiyjtAbU1KkYBU3mxG9/0?=
 =?us-ascii?q?b127BbpLhjL2nUWUpIYy/2L3t8UqSqsrqNftVP5YgssSVWVuS8fF+bRqfzox?=
 =?us-ascii?q?sdziPjGXZRyyondzGrvZX5mQZ2iGWHLHZ8tHDZY91/xQ/D5NzAQv5cxj4GRC?=
 =?us-ascii?q?h+iTnKCVmwJtqp8suOl5fFrO++U3msVoNccSb114OMrii76nNwAR25gf+zns?=
 =?us-ascii?q?frEQ8g0S/0z9NqTznHrA7gYon30KS3Ke1mc0ppCVLn6Mp1BJt+ko0ui5EUw3?=
 =?us-ascii?q?QagY+V/XUfm2fpLdpbwb7+bGYKRTMTx97V4Q7l2FBsL36Q3IL5WXqcz9B/Z9?=
 =?us-ascii?q?m1fGwWwDgx78NUB6eO6rxLgy91rkC/rQLLbvh3hi0dxuc26H4Gn+EJvxIgwT?=
 =?us-ascii?q?+eArAKGElVJijslxWO79Cjo6RbfWivcb+t1Ep4gN+uFq2CogBbWHb/YJsiGj?=
 =?us-ascii?q?Vw7spnOlLWzHLz8p3keMXXbd8LsB2UkxDAj/JQKJ0rkPoHnjBnNnzgsn0l0e?=
 =?us-ascii?q?E7kQZi0o29vIiCM29t5r62AgZENj3pYMMe4jftjb5bnsmKw4+gBJFhGjEWXJ?=
 =?us-ascii?q?vtVv+oCiwduunnNwmUDD0wsGuUGb3aHQWH8kdps2rPE4y3N3GQPHQZ1sttRA?=
 =?us-ascii?q?OSJENBmgwbRjU7npkkFgCs38HhcUF55iwP6V78sBdD1uVoNxznWGfFuAioci?=
 =?us-ascii?q?s0SISYLBdO9QFC513aMMyE4uJwBS5Y4pygoBWMK2OBYgRIDHsJV1eFB1DlIr?=
 =?us-ascii?q?mh+93A//KECeq5KvvEea+OpvBGV/eU2ZKv1ZNr/zaWOcWOInltFfo71lBDXX?=
 =?us-ascii?q?BkAcvZnToPRjcWlyLLc86UuhO89jdrocC49fThQBjv6peXC7tOLdVv/Ai7jr?=
 =?us-ascii?q?2FN+GNniZ5KDZZ2okXxX/I1rcfwkIdiyFweDmrErQAsjXATKbRmq9REh4aZD?=
 =?us-ascii?q?l/NMpO76IgwAZNPdTXhc/y1r59lvQ1EUtKVUT9msG1YswHO2K9O0nGBEqRL7?=
 =?us-ascii?q?SGOyfEw8HxYa6nSL1QivlUuAO0uTqBD0DjOTGDnSHzVx+zKeFMkD2bPBtGtY?=
 =?us-ascii?q?6mahZgEnLsTNbnahKlNt96jic6zqAqiXnSL24TLSB8c19Rrr2X9S5YgPJ/G3?=
 =?us-ascii?q?dB7nd+L+mEnD2Z7+nEKpYMsPtrGiB0mPxG4HQm0bdV6ztERPNtkivIstFuu0?=
 =?us-ascii?q?2mkvWIyjd/UxpBsDdLiJiLvUV/I6rZ8JZAVG3F/BIL8WWfFRAKq8F5Bd3ovq?=
 =?us-ascii?q?Ba0sLPm77rKDde79LU+tMRB9LVKM2ZNnohLRjpFyDPDAYeQj6rMmbfh0NZkP?=
 =?us-ascii?q?6M7HGasp86qp30kpoUVrBbTEA1Fu8dCkl9Et0CIZN3XjclkbGBic4E/2axoA?=
 =?us-ascii?q?PLRMVdpZ/ISOiSAen0KDuCjLlEYQcIzq38LYgJKoL73EliYEFgnIvWA0rQQc?=
 =?us-ascii?q?xNoip5Yw8soEVN8Xx+Tmwr207/cQyh+mMTFeS1nhEqlgRxe/8g9Dbq41crOF?=
 =?us-ascii?q?XKoDE8n1U2mdXg0nitd2vKIa62FapWESvvq08pMp7hWAFzJVmpkEVicjWCTL?=
 =?us-ascii?q?JLjqB8cnhrhRXHvp1nGPhAQKkCaxgVk7XfRfwy0ldb4h6uxkxG4+bDQc9gnR?=
 =?us-ascii?q?EpcpnqtHtD2ANlYdgdIa3WOboPz15Mi6bItSitgLMf2ggbcn0R/XuSdShAg0?=
 =?us-ascii?q?kBMr0rNmL85eB3wRCTkDtEPm4XXrwlpew8pRB1APiJ0y+1i+0LEUu2LeHKav?=
 =?us-ascii?q?rD6mU=3D?=
X-IPAS-Result: =?us-ascii?q?A2BXAAD0wPpc/wHyM5BmGwEBAQEDAQEBBwMBAQGBVAMBA?=
 =?us-ascii?q?QELAYFmKmpSMiiEFZNBAQEBAQEBBoEICCWJUZEJCQEBAQEBAQEBAS0HAQIBA?=
 =?us-ascii?q?YRAAoJqIzcGDgEDAQEBBAEBAQEDAQFsHAyCOikBgmcBBSMEEUEQCxgCAiYCA?=
 =?us-ascii?q?lcGAQwGAgEBgl8/AYF2FA+oFn4zhUeDKIFABoEMKAGLWhd4gQeBOAyCXz6CY?=
 =?us-ascii?q?QSBPwEBgyiCWASLM4JBhhGVHwmCEIIbhCiMeAYbgiSKfIlxLYxihxORMCKBW?=
 =?us-ascii?q?CsIAhgIIQ+DJ4IbFxSITYVbIwMwAQGBBAEBjFsPFwOCKQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 07 Jun 2019 19:58:41 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x57JwYRU014431;
        Fri, 7 Jun 2019 15:58:34 -0400
Subject: Re: [RFC PATCH v2 4/5] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
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
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-5-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <5706a7ec-5497-c560-92fa-91c9751b9096@tycho.nsa.gov>
Date:   Fri, 7 Jun 2019 15:58:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606021145.12604-5-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/5/19 10:11 PM, Sean Christopherson wrote:
> enclave_load() is roughly analogous to the existing file_mprotect().
> 
> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> VMAs.  As a result, the existing/standard call to file_mprotect() does
> not provide any meaningful security for enclaves since an LSM can only
> deny/grant access to the EPC as a whole.
> 
> security_enclave_load() is called when SGX is first loading an enclave
> page, i.e. copying a page from normal memory into the EPC.  Although
> the prototype for enclave_load() is similar to file_mprotect(), e.g.
> SGX could theoretically use file_mprotect() and set reqprot=prot, a
> separate hook is desirable as the semantics of an enclave's protection
> bits are different than those of vmas, e.g. an enclave page tracks the
> maximal set of protections, whereas file_mprotect() operates on the
> actual protections being provided.  In other words, LSMs will likely
> want to implement different policies for enclave page protections.
> 
> Note, extensive discussion yielded no sane alternative to some form of
> SGX specific LSM hook[1].
> 
> [1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kernel/cpu/sgx/driver/ioctl.c | 12 ++++++------
>   include/linux/lsm_hooks.h              | 13 +++++++++++++
>   include/linux/security.h               | 12 ++++++++++++
>   security/security.c                    |  7 +++++++
>   4 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 44b2d73de7c3..29c0df672250 100644
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
> @@ -582,9 +583,6 @@ static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
>   	struct vm_area_struct *vma;
>   	int ret;
>   
> -	if (!(prot & VM_EXEC))
> -		return 0;
> -

Is there a real use case where LSM will want to be called if !(prot & 
VM_EXEC)? Also, you seem to be mixing prot and PROT_EXEC with vm_flags 
and VM_EXEC; other code does not appear to assume they are identical and 
explicitly converts, e.g. calc_vm_prot_bits().

>   	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
>   	down_read(&current->mm->mmap_sem);
>   
> @@ -599,15 +597,17 @@ static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
>   	 * but with some future proofing against other cases that may deny
>   	 * execute permissions.
>   	 */
> -	if (!(vma->vm_flags & VM_MAYEXEC)) {
> +	if ((prot & VM_EXEC) && !(vma->vm_flags & VM_MAYEXEC)) {
>   		ret = -EACCES;
>   		goto out;
>   	}
>   
> +	ret = security_enclave_load(vma, prot);
> +	if (ret)
> +		goto out;
> +
>   	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
>   		ret = -EFAULT;
> -	else
> -		ret = 0;
>   
>   out:
>   	up_read(&current->mm->mmap_sem);
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 47f58cfb6a19..c6f47a7eef70 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1446,6 +1446,12 @@
>    * @bpf_prog_free_security:
>    *	Clean up the security information stored inside bpf prog.
>    *
> + * Security hooks for Intel SGX enclaves.
> + *
> + * @enclave_load:
> + *	@vma: the source memory region of the enclave page being loaded.
> + *	@prot: the (maximal) protections of the enclave page.
> + *	Return 0 if permission is granted.
>    */
>   union security_list_options {
>   	int (*binder_set_context_mgr)(struct task_struct *mgr);
> @@ -1807,6 +1813,10 @@ union security_list_options {
>   	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
>   	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
>   #endif /* CONFIG_BPF_SYSCALL */
> +
> +#ifdef CONFIG_INTEL_SGX
> +	int (*enclave_load)(struct vm_area_struct *vma, unsigned long prot);
> +#endif /* CONFIG_INTEL_SGX */
>   };
>   
>   struct security_hook_heads {
> @@ -2046,6 +2056,9 @@ struct security_hook_heads {
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
> index 659071c2e57c..0b6d1eb7368b 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1829,5 +1829,17 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
>   #endif /* CONFIG_SECURITY */
>   #endif /* CONFIG_BPF_SYSCALL */
>   
> +#ifdef CONFIG_INTEL_SGX
> +#ifdef CONFIG_SECURITY
> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot);
> +#else
> +static inline int security_enclave_load(struct vm_area_struct *vma,
> +					unsigned long prot)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_SECURITY */
> +#endif /* CONFIG_INTEL_SGX */
> +
>   #endif /* ! __LINUX_SECURITY_H */
>   
> diff --git a/security/security.c b/security/security.c
> index 613a5c00e602..c6f7f26969b2 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2359,3 +2359,10 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
>   	call_void_hook(bpf_prog_free_security, aux);
>   }
>   #endif /* CONFIG_BPF_SYSCALL */
> +
> +#ifdef CONFIG_INTEL_SGX
> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot)
> +{
> +	return call_int_hook(enclave_load, 0, vma, prot);
> +}
> +#endif /* CONFIG_INTEL_SGX */
> 

