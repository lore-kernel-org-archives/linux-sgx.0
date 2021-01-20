Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ABDC4332D
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 17:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B7223358
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 17:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387753AbhATOsL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 09:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388235AbhATOTa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Jan 2021 09:19:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F01A523371;
        Wed, 20 Jan 2021 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611152326;
        bh=tVBGlqo5MZ7suDj3LfH0/aVvSirTh2eeutKAI+aTcGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YIZ7bxDIRFGDXhuLY1WUO4xiWH/GlhJykKNqesbuURCsbLpKVZfkjyY9IJkP1nmkq
         RhgaJb7+ZkSLmnNiPNz1hm5k6Xb/u6BZ6lUkfO6DzhzELg8i4DKNGqKhODGajuMTTw
         8iRNt/+1j3lndx3oVZ2xVUCng5Gybdic3tzEhvv4UXTWdntmG0fcZfyMGkkOwJNf3f
         0SycNFARsQryqILXw6eT2o4SFp7PE/fsP/2sveyWDhyQvWEhkkLNB905mKmW/0l8Tt
         RVrfxMXAewtZkPk7JxH0K7Mlxx1XyZY9whtTnOzYMoBgS8wi6iTkguTCtL9rPTbIoZ
         jJTUvNdrzDgVw==
Date:   Wed, 20 Jan 2021 16:18:39 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v2 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YAg7vzevfw5iL9kN@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:26PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> bits 15:0, and single-bit modifiers in bits 31:16.
> 
> Historically, KVM has only had to worry about handling the "failed
> VM-Entry" modifier, which could only be set in very specific flows and
> required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> bit was a somewhat viable approach.  But even with only a single bit to
> worry about, KVM has had several bugs related to comparing a basic exit
> reason against the full exit reason store in vcpu_vmx.
> 
> Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> be set on more or less any VM-Exit, as opposed to the significantly more
> restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> flows isn't scalable.  Tracking exit reason in a union forces code to
> explicitly choose between consuming the full exit reason and the basic
> exit, and is a convenient way to document and access the modifiers.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
>  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
>  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
>  3 files changed, 86 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0fbb46990dfc..f112c2482887 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>  	enum vm_entry_failure_code entry_failure_code;
>  	bool evaluate_pending_interrupts;
> -	u32 exit_reason, failed_index;
> +	u32 failed_index;
> +	union vmx_exit_reason exit_reason = {
> +		.basic = -1,
> +		.failed_vmentry = 1,
> +	};

Instead, put this declaration to the correct place, following the
reverse christmas tree ordering:

        union vmx_exit_reason exit_reason = {};

And after declarations:

        exit_reason.basic = -1;
        exit_reason.failed_vmentry = 1;

More pleasing for the eye.

/Jarkko
