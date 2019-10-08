Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71021C4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 17:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 491722070B
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 17:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="LPED49Ot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfJHRaq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 13:30:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48212 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfJHRap (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 13:30:45 -0400
Received: from zn.tnic (p200300EC2F0B5100CCB0138313431791.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5100:ccb0:1383:1343:1791])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4439B1EC0A85;
        Tue,  8 Oct 2019 19:30:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570555844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xLl94N6X5/w3kf61EpDTaFZMT5oqXzqZ//0quPnC7XY=;
        b=LPED49Ot4PkU3NbyHwnrLI1COliqk1j7HNylcAIIPbW1syD9sRyCWQiShuEMpwOmT68XQY
        yUy04CvTH67ytUjV9DRQTcq7dm1lMKZIBtAwEo4QRLBKj92H9Q9Ivls1PhkULVHkkzy6tO
        O18pBpPD6QXDOK8FddhR2Q7yaNBfL5M=
Date:   Tue, 8 Oct 2019 19:30:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 10/24] x86/sgx: Add sgx_einit() for wrapping
 ENCLS[EINIT]
Message-ID: <20191008173035.GK14765@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-11-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190903142655.21943-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 03, 2019 at 05:26:41PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Enclaves are SGX hosted measured and signed software entities. ENCLS[EINIT]

		SGX-hosted, measured, and ...

> leaf function checks that the enclave has a legit signed measurement and
> transforms the enclave to the state ready for execution. The signed
> measurement is provided by the caller in the form of SIGSTRUCT data
> structure [1].
> 
> Wrap ENCLS[EINIT] into sgx_einit(). Set MSR_IA32_SGXLEPUBKEYHASH* MSRs to
> match the public key contained in the SIGSTRUCT [2]. This sets Linux to
> enforce a policy where the provided public key is as long as the signed
> measurement matches the enclave contents in memory.

That subclause needs to be separated, maybe:

  ... the provided public key is - as long as the signed measurement
  matches the the enclave contents - in memory.

Provided you mean that, of course.

> Add a per-cpu cache to avoid unnecessary reads and write to the MSRs

reads and writes?

> as they are expensive operations.
> 
> [1] Intel SDM: 37.1.3 ENCLAVE SIGNATURE STRUCTURE (SIGSTRUCT)
> [2] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 51 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 6b4727df72ca..d3ed742e90fe 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -17,6 +17,9 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
>  
>  int sgx_nr_epc_sections;
>  
> +/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
> +static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
> +
>  static struct sgx_epc_page *sgx_section_get_page(
>  	struct sgx_epc_section *section)
>  {
> @@ -106,6 +109,54 @@ void sgx_free_page(struct sgx_epc_page *page)
>  }
>  EXPORT_SYMBOL_GPL(sgx_free_page);
>  
> +static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
> +{
> +	u64 *cache;
> +	int i;
> +
> +	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
> +	for (i = 0; i < 4; i++) {
> +		if (enforce || (lepubkeyhash[i] != cache[i])) {
> +			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> +			cache[i] = lepubkeyhash[i];
> +		}
> +	}
> +}
> +
> +/**
> + * sgx_einit - initialize an enclave
> + * @sigstruct:		a pointer a SIGSTRUCT
> + * @token:		a pointer an EINITTOKEN (optional)
> + * @secs:		a pointer a SECS

That's a strange formulation "a pointer a/an" ? "to" missing?

> + * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx MSRs
> + *
> + * Execute ENCLS[EINIT], writing the IA32_SGXLEPUBKEYHASHx MSRs according
> + * to @lepubkeyhash (if possible and necessary).
> + *
> + * Return:
> + *   0 on success,
> + *   -errno or SGX error on failure
> + */
> +int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
> +	      struct sgx_epc_page *secs, u64 *lepubkeyhash)
> +{
> +	int ret;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX_LC))
> +		return __einit(sigstruct, token, sgx_epc_addr(secs));
> +
> +	preempt_disable();
> +	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
> +	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
> +	if (ret == SGX_INVALID_EINITTOKEN) {
> +		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
> +		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
> +	}
> +	preempt_enable();
> +	return ret;
> +}
> +EXPORT_SYMBOL(sgx_einit);

I was about to ask why isn't this export _GPL() but it goes away in a
later patch.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
