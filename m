Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FDCC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 12:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE852332B
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 12:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbhATMVq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbhATLxk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 06:53:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 228EA2332B;
        Wed, 20 Jan 2021 11:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611143497;
        bh=gIE/9Q5kcut4jo7HWwDqNs9MboUmlS9BMq0bazv7Y/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XgIh6Ifx+SvqtzZYkH13DBqTHhAx3mlS1R1L/fxAix2EW994dCsp7C2BRLv1+Iriy
         1290pqVNbiGQPeQP7tbRmCTOKLdIgjaDZX9PtcKWL2x9E5yRP5zPBgwMi7cpyO/dPo
         LsJNAb+tJbuPeA59q6ZU7yUGoSy5RabjxL/ox5dkBp2wnK+efAQLzXDdYU80W1Veco
         nkezyj8gKgKkZLoFuvKI9xELfWe6d2RPI91fNuC5+Flw6O3sU0Ns9j/PSHmZxcQxQk
         atnDkyTDclFZ0f8nGaatTdVf+pj+0uzYmmVy6h7ALk97GYr2uwqvCkUpavVege0pwt
         dVKUASWAUY/Zg==
Date:   Wed, 20 Jan 2021 13:51:30 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
Message-ID: <YAgZQtCVOynk0FOt@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <9638853bc880d5699e01bdf14b37814e2b08065f.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9638853bc880d5699e01bdf14b37814e2b08065f.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 18, 2021 at 04:26:52PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> SGX virtualization requires to allocate "raw" EPC and use it as "virtual
> EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> knowledge of which pages are SECS with non-zero child counts.
> 
> Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> failures are expected, but only due to SGX_CHILD_PRESENT.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v1->v2:
> 
>  - Change title to reflect hardware error code.
> 
> ---
>  arch/x86/kernel/cpu/sgx/arch.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
> index dd7602c44c72..56b0f8ae3f92 100644
> --- a/arch/x86/kernel/cpu/sgx/arch.h
> +++ b/arch/x86/kernel/cpu/sgx/arch.h
> @@ -26,12 +26,14 @@
>   * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
>   * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
>   *				been completed yet.
> + * %SGX_CHILD_PRESENT		Enclave has child pages present in the EPC.

s/Enclave/SECS/

>   * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
>   *				public key does not match IA32_SGXLEPUBKEYHASH.
>   * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
>   */
>  enum sgx_return_code {
>  	SGX_NOT_TRACKED			= 11,
> +	SGX_CHILD_PRESENT		= 13,
>  	SGX_INVALID_EINITTOKEN		= 16,
>  	SGX_UNMASKED_EVENT		= 128,
>  };
> -- 
> 2.29.2
> 
> 

/Jarkko
