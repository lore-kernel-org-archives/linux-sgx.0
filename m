Return-Path: <SRS0=ZwJT=UG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC81C2BCA1
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jun 2019 21:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6DFC208C3
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jun 2019 21:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="gzmGKoG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfFGV01 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Jun 2019 17:26:27 -0400
Received: from uhil19pa11.eemsg.mail.mil ([214.24.21.84]:24957 "EHLO
        uhil19pa11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbfFGV00 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Jun 2019 17:26:26 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2019 17:26:26 EDT
X-EEMSG-check-017: 418278634|UHIL19PA11_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by uhil19pa11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 07 Jun 2019 21:16:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559942169; x=1591478169;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=kFpV/NisBt/PsmwE3TuY6SYBr+rxeOWFn/X1BGEoND0=;
  b=gzmGKoG/fbOisngQYWO39e24CRPDi9H916FWmICz45J48s0IjnzvWIjo
   S4PqyGTUsf1vYxDl0vOUGJ5cZ8qET3BUp9UijnAXNPgf3QpQuDIteWBVJ
   tB+MPMALtle/2b4m7Ly8C0f9TmQoeFyp3ois+Kz8ePYc4TVpgHjfFZ9Ss
   C1zcbYQiLVE/KmJJhXv8yaUvj+dGNPwYGZXR1nMJE1Bpbin+UL9GFQXt1
   cIZr65buNSDNTBl89xT8UV0BWCGWwERzUYG4KaYNx3tbqK9rgYpmVCuNt
   6NQ9VT0qJ2zxfFXkwEjOmu1P74ZTkfPPQb/9rZlNh+dNm5MmMWtMQLznT
   w==;
X-IronPort-AV: E=Sophos;i="5.63,564,1557187200"; 
   d="scan'208";a="24530770"
IronPort-PHdr: =?us-ascii?q?9a23=3ALdEH8hH0dpfoGyAocx/zAZ1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ75ocWybnLW6fgltlLVR4KTs6sC17OP9fm8BydZvMnJmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MQi6oR/MusQZgIZuJbs9xx?=
 =?us-ascii?q?vLr3BVZ+lY2GRkKE6JkR3h/Mmw5plj8ypRu/Il6cFNVLjxcro7Q7JFEjkoKn?=
 =?us-ascii?q?g568L3uxbNSwuP/WYcXX4NkhVUGQjF7Qr1UYn3vyDnq+dywiiaPcnxTbApRT?=
 =?us-ascii?q?Sv6rpgRRH0hCsbMTMy7XragdJsgq1FvB2hpgR/w4/Kb4GTKPp+Zb7WcdcDSW?=
 =?us-ascii?q?ZcQspdSylND4WyYIsVC+oKIPhWoY/zqVATqReyHAehCefqxjJOm3T437A10/?=
 =?us-ascii?q?45HA/bwgIgEdIAvnfaotr7O6gdU/y6wqbTwDXfbf5bwyvx5JTGfx0jp/yHQL?=
 =?us-ascii?q?J+cdDWyUkqDw7Lk0mQppL9PzOVyOsNtXWQ4fdlVe21j24nrx9+oziyzcorkY?=
 =?us-ascii?q?nGm5kVx0vY9SR53Ik1Jdq4RFR9Yd6/CpRcrS6aN4xoQs47RWxjpSU0yqUetJ?=
 =?us-ascii?q?KmcyUHx44ryh7CZ/CdbYSF7QzvWPyMLTp+mXlrYqiwhwyo/kil0uD8U86030?=
 =?us-ascii?q?tUoSddidnMs2wN1wTU6siaVvtx5keh1iiL1wDU8uxEPVo7lbDaK5482b48jI?=
 =?us-ascii?q?YTsETfES/2n0X6lqmWeVk/+ue08ejnZ7TmppuEO491jAHxLLgul9SiDek3PQ?=
 =?us-ascii?q?UCRWiW9fmm2LH98kD1Xq9GguAunqncqp/aJMAbpqCjAw9S14Yu8w2/ACq90N?=
 =?us-ascii?q?kDgXkGLE5KeBKAj4TzPVHOO+r3Ae2wg1Srjjdn3+rGMaH5ApXRMnjDl6/sfa?=
 =?us-ascii?q?1j5EFGzgo/19Jf64hIBbEBOvLzW1TxtMDfDh8hMwy73fznCM561oMYQm+PA6?=
 =?us-ascii?q?mZML/Mvl+M/O4gP+6MZIoNsjbnN/cl/+LujWM+mVIFf6mmx4EXaHO7HvRhOU?=
 =?us-ascii?q?mZemDjgtQCEWcLuAoxUurqhUaGUT5SYXayQq096is6CIKgEYfMWIStjKad0y?=
 =?us-ascii?q?e8G51cfnpGBUyUEXf0a4WEXO8BaCaPIs99lTwJTruhRJE71RGoqgD6z6BrLu?=
 =?us-ascii?q?3O+i0XrZjjzsR65/XPlREu8jx5F9iS3H+QQGFun2MHWyU63a9+oUx7xVeOyq?=
 =?us-ascii?q?l4g/pEFdNN4/NFSBs1NZnZz+ZiEdD9RhrBfsuVSFahWtimAzQxTtUrw98UYk?=
 =?us-ascii?q?Z9AM6vjhbZ0CqvHbAVlqaHBJsu8qLTx3LxPdpyy27a1Kk9iFkrWtBPOnO8hq?=
 =?us-ascii?q?5w6QfeHI7JnF+dl6audaUc2jTB+3uEzWqLpEtYShJ/Ub3ZXXADYUvbtdD55k?=
 =?us-ascii?q?LET7+zBrUrKxBBxtCeJatXcN3pjElGRff6NNTbZGK+hnqwBRKWyb6XcorqdH?=
 =?us-ascii?q?sS3D/HBEgHjQ8T53CGOhY6Biu7pGLeFjNuH0r1Y0zw6el+tG+7TkgswgGSdU?=
 =?us-ascii?q?Jhyr619wUNhfOGVvMT2qsIuCImqzVzBlaywcjaBMaHpwpkZK9ce88y4E9b1W?=
 =?us-ascii?q?LFsAxwJoKvL7h4iV4EcgR3pFjj1w1tBYVakMgqt2sqzA5oJq2EzlxNbTSY3Y?=
 =?us-ascii?q?r/OrfPMGn94Aiva7LK2lHZyNuW4bkA6PA5q1XloQGoGVEv82to09ZLyXuQ/J?=
 =?us-ascii?q?bKAxQIUZL3TEk38wJ2p7bAYiky/4nUz2FjMbGosj/e3NIkHOklxQi8f9dfKq?=
 =?us-ascii?q?OEExT/E8MdB8i0NOwlgV6pbhMLPexI6KE0OMamfeOc2KG3JOZggC6mjWNf7Y?=
 =?us-ascii?q?9gyE2M6TRzRvTI35kfxfGYxRWIVzHngVegtMD3hZ5LZTUIEmWjzijkAZZbZr?=
 =?us-ascii?q?ducoYTFWeuP8q3y81ih57iX35Z+0WuB1cH2M+vZBqSc0b93QpW1UQWrn2rgz?=
 =?us-ascii?q?a3wCJsmTEzsqWfxDDOw/jldBcfJm5LQ3NijUn2Loiwkt8aR1OlbwwolBuj+E?=
 =?us-ascii?q?b7yLFXpKp4L2nOR0dHYjL5L31jUqu3sLqOeclP6IknsS9PSuSzfUiaSqLhox?=
 =?us-ascii?q?sdyy7jG2pexDYmdzClo5n5nAJ1iHibLHltqHrUYt9wxRjB69zGX/JR3SQJRD?=
 =?us-ascii?q?N+iTbJAliwJd6p/c+bl53bqOCxS3qhVoFPcSns1Y6Buyi26GxxDB28gf+zgN?=
 =?us-ascii?q?vnHhY+0SPh0NlqTyrIpg7mYob3z6S6Lf5nfk5wCV/46sp6HJx+k4QpiJEL1n?=
 =?us-ascii?q?gbiY6Y/WQIkWjtK9VXw6H+Y2QXRT4N3dHV5BLp2Ep5LnKG34j5TGmSwtN9Z9?=
 =?us-ascii?q?mmZWMbwjgy78NSCKeR97FEmSp1olylrQPeePR9kDAdyeYo6HEHme4JpAstzi?=
 =?us-ascii?q?KbArwIGklYJyPsnQyS79+itKVXeHqvcb+o2Up4ndChC6uCogRGV3b/YZoiBz?=
 =?us-ascii?q?F/4dh/MF3WzH3/8J3reN7VbdgLrB2bjw/Aj/RJKJI2jvcKgzJnOWfhsnI50e?=
 =?us-ascii?q?E7iRhu3Yy/vIWcMWVi4r+2Ah5COT3pfc8c5jbtjaNGlMaMw4+vBolhGikMXJ?=
 =?us-ascii?q?bwVvKnDigStfv5OAqUCjI9qnCbGafZHQKE6UdmqW7PHI6vN32NOHYZytBiTg?=
 =?us-ascii?q?GHJENDmAAUQCk6npkhGwCxxMzuakd46ioS5lHithtNy/tkNhjlXWfapQeocC?=
 =?us-ascii?q?w5SJmZLBpK8A5C413ZPtCZ7uJ2BytY5IGurBSRKmyHYARFFWEJVVaFB1D/JL?=
 =?us-ascii?q?au4sPM8+iFBuWkKfvObq6Dqe1YV/eU252v1pFq8CqLNsWKJnNiFeE02lJfXX?=
 =?us-ascii?q?BlHMTUgy8ASyoKmCLXbs6apA2w+jZ3rs+h7vTkRALv6pWJC7tRNtVi4BS2ga?=
 =?us-ascii?q?aFN+6Niyd1MzdY1pUQxXDWzLgTxkIdiyZrdzO1C7QPqTbNTL7Mmq9QFxMbaD?=
 =?us-ascii?q?l8NMpS46InwAlCI87bitXu2755iP41F0lKVVj7ls61YswKJnm3NEnbC0aTKL?=
 =?us-ascii?q?SGOTrLztnsbqOkUrBfluFUtxyutjadEELvJCmMmCfxXRC1Le5MlD2bPABZuI?=
 =?us-ascii?q?ylcBZtDnPjTNL9Zx25N993lj02waEuhnPLLW4cNSZzc19RrrGK6iNYmPp/EX?=
 =?us-ascii?q?Rb7nV5NemEhzqZ7+7AJ5YVq/RrAz54l+JH4HsgzbtV4zpJRP1zmCvOsNFup0?=
 =?us-ascii?q?uqnfWIyjpiSBBOsCpEhJqXvUV+PqXU7oNAWXfa8xIL8WWQCQoFp8B+B93gvK?=
 =?us-ascii?q?BQzdfPlKbtJztY793U+s4cDdDOKM2bKHohLQbpGDnMAQoLTD6rMWXfh01Hn/?=
 =?us-ascii?q?GX7HGasoI2qoLrmJUVVLBbTkA1FugBB0RkGtwCPIl4Xjc+nbGHi84I4GK0rA?=
 =?us-ascii?q?PNS8VCopDHSvWSDO33KDaZjLlEYxoIwaviIYsILIH7x1Zialhmk4vWAUXdRt?=
 =?us-ascii?q?FNoit9bgAqpEVB6mRxTmo22xGtVgT423IaE7afngQ3kRd5eeQg7izr5R9jPV?=
 =?us-ascii?q?fDom0y1kIxg9T+nTeJcDPrN6C2dYBQFyfw8UM2N8W/CyR8dw6xmgRfPTTHRr?=
 =?us-ascii?q?RcifM0d2lxiwzb/4BGGv1dS6BCSBsRw+yHIfQuzVlY7C6gwBkUy/HCDM5ZiA?=
 =?us-ascii?q?YycZOq50lF0gZnYc99cbfcP4JV31NQgeSIpSbu2ecvllxNb30R+X+fLXZb8H?=
 =?us-ascii?q?cDMaMrcm/xpb1h?=
X-IPAS-Result: =?us-ascii?q?A2BGAAAX0/pc/wHyM5BmHAEBAQQBAQcEAQGBUgYBAQsBg?=
 =?us-ascii?q?WYqgTsBMiiEFZJzTAEBAQEBAQaBNYlRjw6BewkBAQEBAQEBAQE0AQIBAYRAA?=
 =?us-ascii?q?oJqIzUIDgEDAQEBBAEBAQEDAQFsKII6KQGCZwEFIwQRQRALGAICJgICVwYBD?=
 =?us-ascii?q?AYCAQGCXz+BdxSoKH4zhUeDJoFGgQwoAYtaF3iBB4ERJ4JrPodOglgEjXSGE?=
 =?us-ascii?q?ZQ1agmCEIIbiH6IIgYbgiSKfIlxLYximC4BNoFYKwgCGAghD4MnghsXjjwjA?=
 =?us-ascii?q?zABgQUBAY8tAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 07 Jun 2019 21:16:08 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x57LG16m008171;
        Fri, 7 Jun 2019 17:16:04 -0400
Subject: Re: [RFC PATCH v2 5/5] security/selinux: Add enclave_load()
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
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-6-sean.j.christopherson@intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <ca77e597-69de-9db4-f88a-26881ab53680@tycho.nsa.gov>
Date:   Fri, 7 Jun 2019 17:16:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606021145.12604-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/5/19 10:11 PM, Sean Christopherson wrote:
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
>   security/selinux/hooks.c | 69 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 69 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702cf46ca..3c5418edf51c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6726,6 +6726,71 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
>   }
>   #endif
>   
> +#ifdef CONFIG_INTEL_SGX
> +int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot)
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

prot/PROT_EXEC or vmflags/VM_EXEC

> +
> +	/*
> +	 * The source page is exectuable, i.e. has already passed SELinux's

executable

> +	 * checks, and userspace is not requesting RW->RX capabilities.

Is it requesting W->X or WX?

> +	 */
> +	if ((vma->vm_flags & VM_EXEC) && !(prot & PROT_WRITE))
> +		return 0;
> +
> +	/*
> +	 * The source page is not executable, or userspace is requesting the
> +	 * ability to do a RW->RX conversion.  Permissions are required as
> +	 * follows, in order of increasing privelege:
> +	 *
> +	 * EXECUTE - Load an executable enclave page without RW->RX intent from
> +	 *           a non-executable vma that is backed by a shared mapping to
> +	 *           a regular file that has not undergone COW.

Shared mapping or unmodified private file mapping

> +	 *
> +	 * EXECMOD - Load an executable enclave page without RW->RX intent from
> +	 *           a non-executable vma that is backed by a shared mapping to
> +	 *           a regular file that *has* undergone COW.

modified private file mapping (write to shared mapping won't trigger 
COW; it would have been checked by FILE__WRITE earlier)

> +	 *
> +	 *         - Load an enclave page *with* RW->RX intent from a shared
> +	 *           mapping to a regular file.
> +	 *
> +	 * EXECMEM - Load an exectuable enclave page from an anonymous mapping.

executable

> +	 *
> +	 *         - Load an exectuable enclave page from a private file, e.g.

executable

> +	 *           from a shared mapping to a hugetlbfs file.
> +	 *
> +	 *         - Load an enclave page *with* RW->RX intent from a private

W->X or WX?

> +	 *           mapping to a regular file.
> +	 *
> +	 * Note, this hybrid EXECMOD and EXECMEM behavior is intentional and
> +	 * reflects the nature of enclaves and the EPC, e.g. EPC is effectively
> +	 * a non-persistent shared file, but each enclave is a private domain
> +	 * within that shared file, so delegate to the source of the enclave.
> +	 */
> +	if (vma->vm_file && !IS_PRIVATE(file_inode(vma->vm_file) &&
> +	    ((vma->vm_flags & VM_SHARED) || !(prot & PROT_WRITE)))) {
> +		if (!vma->anon_vma && !(prot & PROT_WRITE))
> +			ret = file_has_perm(cred, vma->vm_file, FILE__EXECUTE);
> +		else
> +			ret = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
> +	} else {
> +		ret = avc_has_perm(&selinux_state,
> +				   sid, sid, SECCLASS_PROCESS,
> +				   PROCESS__EXECMEM, NULL);
> +	}
> +	return ret;
> +}
> +#endif
> +
>   struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
>   	.lbs_cred = sizeof(struct task_security_struct),
>   	.lbs_file = sizeof(struct file_security_struct),
> @@ -6968,6 +7033,10 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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

