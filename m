Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FC25392D;
	Sat,  9 Aug 2025 10:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754735349; cv=none; b=CGh2r1LSwLqVP+iVoV52564K0qTCdwtqLJmdKssmsG72BKjRA57XSHZUa3HhXzs9zCVovko2t6ovn+30au+kJKYENZx+GFRAO2OCRnD2No1AnzwW6VQ+/URHeDAK2PUrLfEy7ODqShhI8toDyUo9lrM65WS0AJM8qbnCrrcVJd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754735349; c=relaxed/simple;
	bh=ay55KwcH9stnDws+b6Vbr3kYE7hZUQ1Z+DxrqR1R+q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Myd7dyhvw0Fm8wBBnMF+kGJRFhsckMIdisetXkahR9WUlth6/f9G2z1cwt9FRdWfANGCF3RX8/YJKAKumdLrBu0xnlaoVG42g76rEbYPSRK3/C0N56U6/oRbySfvtvki97jrETy1giN8xYAz1Y74foB7q9MderII0NGtWnG6980=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8JOM4dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8JOM4dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE09C4CEE7;
	Sat,  9 Aug 2025 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754735349;
	bh=ay55KwcH9stnDws+b6Vbr3kYE7hZUQ1Z+DxrqR1R+q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y8JOM4dkr+BQ0S8cRfJDMrLrfnBCKwiotuvISvhDBUP3y+XQGhsuD5ClnwVAoLoRS
	 rLvGIe98fJHEB90dH7r21BsTA7kwG6PoWC4jVog571Od28wzMPv10GkdTSADDgFpmT
	 3Kfyb5YoQgmaXidEmxrTgJodAdo7ImR2qlblcl50i/7s1oOBamtVW7L/k1REt+guhY
	 OD9lYLExDDOiHqnrnbdN+yAGfuhIEriUCVgYEldaqSoijQVZS7QsBfDX3zeY4ZUX5H
	 YLn9Ls744hiMmYhuJyo4SkYzGx7KZAur9XRsPcQqbNgZ8pEasUfR7lk8ZAacnzDUUd
	 2YXtcQnMg7meA==
Date: Sat, 9 Aug 2025 13:29:05 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v11 0/5] Enable automatic SVN updates for SGX enclaves
Message-ID: <aJci8Zt9iSb3LurZ@kernel.org>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806081344.404004-1-elena.reshetova@intel.com>

On Wed, Aug 06, 2025 at 11:11:51AM +0300, Elena Reshetova wrote:
> Changes since v10 following reviews by Dave:
> 
>  - merge patch 1 and 2
>  - patch 1: clarify the comment about the function prototype
>  - patch 3: clarify the description of SGX_NO_UPDATE
>   error code, move the definition of EUPDATESVN enum leaf
>   to patch 4
>  - patch 4: clarify commit, adjust sgx_update_svn() function
>   according to feedback
> 
> Changes since v9 following reviews by Kai:
> 
>  - postpone the definition of sgx_inc_usage_count
>    until patch 6
>  - clarify the commit message in patch 6
>  - minor fixes
> 
> Note: I didn't merge patch 1 and 2 since it goes against
> previous suggestion made by Jarkko.
> 
> Changes since v8 following reviews by Dave and Jarkko:
> 
>  - fix the sgx_inc/dec_usage_count() to not do any
>  actual counting until the later patch when adequate
>  mutex is introduced as suggested by Dave
>  - add an additional patch (patch 1) to redefine
>  existing sgx_(vepc_)open into wrappers to allow
>  the follow up patch to introduce the sgx_inc/dec_usage_count()
>  functions into sgx_(vepc_)open cleanly as suggested
>  by Jarkko. 
> 
> Changes since v7 following reviews by Dave:
> 
>  - change sgx_usage_count to be a normal int type
>  and greatly simplify the sgx_inc_usage_count func.
>  This results in requiring a mutex for each sgx_(vepc_)open
>  but given that the mutex is held a short amount of
>  time it should be ok perf-wise.
> 
> Changes since v6 following reviews by Kai,Jarkko
> and Dave:
> 
>  - fix sgx_update_svn function description
>  - add maybe_unused for sgx_update_svn in patch 4
>  to silence the warning, remove it in patch 5
>  - add note to patch 1 explaining why the prototype
>  sgx_inc_usage_count returns int and not void
>  - fix the order of return code checks in 
>  sgx_update_svn
>  - cosmetic fixes
>  
> Note: I didn't change the sgx_inc/dec_usage_count
> to statics because they are called from a number of
> different code locations and also rely on a static
> sgx_usage_count, which lives naturally in main.c.  
>  
> Changes since v5 following reviews by Ingo, Kai,
> Jarkko and Dave:
> 
>  - rebase on x86 tip
>  - patch 1 is fixed to do correct unwinding in
>  case of errors
>  - patch 2: add feature flag to cpuid-deps.c
>  - patch 3: remove unused SGX_EPC_NOT_READY error code
>  - patch 4: fix x86 feature check, return -EAGAIN
>  on SGX_INSUFFICIENT_ENTROPY and -EIO on other non-
>  expected errors. Comments/style are also fixed.
>  - patch 5: rewrite commit message, add comments inline
> 
> Changes since v4 following reviews by Dave and Jarkko:
> 
>  - breakdown the single patch into 4 patches as
>  suggested by Dave
>  - fix error unwinding in sgx_(vepc_)open as 
>  suggested by Jarkko
>  - numerous code improvements suggested by Dave
>  - numerous additional code comments and commit
>  message improvements as suggested by Dave
>  - switch to usage of atomic64_t for sgx_usage_count
>  to ensure overflows cannot happen as suggested by Dave
>  - do not return a error case when failing with
>  SGX_INSUFFICIENT_ENTROPY, fail silently as suggested
>  by Dave
> 
> Changes since v3 following reviews by Kai and Sean:
> 
>  - Change the overall approach to the one suggested
>   by Sean and do the EUPDATESVN execution during
>   sgx_open() and sgx_vepc_open().
>   Note, I do not try to do EUPDATESVN during the release()
>   flows since it doesnt save any noticable amount
>   of time during next open flow per underlying EUPDATESVN
>   microcode logic.
>  - In sgx_update_svn() remove the check that we are
>   running under VMM and expect the VMM to instead
>   expose correct CPUID
>  - Move the actual CPUID leaf check out of
>   sgx_update_svn() into sgx_init()
>  - Use existing RDRAND_RETRY_LOOPS define instead of 10
>  - Change the sgx_update_svn() to return 0 only in
>  success cases (or if unsupported)
>  - Various smaller cosmetic fixes
> 
> The still to be discussed question is what sgx_update_svn()
> should return in case of various failures. The current version
> follows suggestion by Kai and would return an error (and block
> sgx_(vepc_)open() in all cases, including running out of entropy.
> I think this might be the correct approach for SGX_INSUFFICIENT_ENTROPY
> since in such cases userspace can retry the open() and also
> will get an info about what is actually blocking the EUPDATEVSN
> (and can act on this). However, this is a change in existing API
> and therefore debatable and I would like to hear people's feedback.
> 
> Changes since v2 following review by Jarkko:
> 
>  - formatting of comments is fixed
>  - change from pr_error to ENCLS_WARN to communicate errors from
>  EUPDATESVN
>  - In case an unknown error is detected (must not happen per spec),
>  make page allocation from EPC fail in order to prevent EPC usage
> 
> Changes since v1 following review by Jarkko:
> 
>  - first and second patch are squashed together and a better
>    explanation of the change is added into the commit message
>  - third and fourth patch are also combined for better understanding
>    of error code purposes used in 4th patch
>  - implementation of sgx_updatesvn adjusted following Jarkko's 
>    suggestions
>  - minor fixes in both commit messages and code from the review
>  - dropping co-developed-by tag since the code now differs enough
>    from the original submission. However, the reference where the
>    original code came from and credits to original author is kept
> 
> Background
> ----------
> 
> In case an SGX vulnerability is discovered and TCB recovery
> for SGX is triggered, Intel specifies a process that must be
> followed for a given vulnerability. Steps to mitigate can vary
> based on vulnerability type, affected components, etc.
> In some cases, a vulnerability can be mitigated via a runtime
> recovery flow by shutting down all running SGX enclaves,
> clearing enclave page cache (EPC), applying a microcode patch
> that does not require a reboot (via late microcode loading) and
> restarting all SGX enclaves.
> 
> 
> Problem statement
> -------------------------
> Even when the above-described runtime recovery flow to mitigate the
> SGX vulnerability is followed, the SGX attestation evidence will
> still reflect the security SVN version being equal to the previous
> state of security SVN (containing vulnerability) that created
> and managed the enclave until the runtime recovery event. This
> limitation currently can be only overcome via a platform reboot,
> which negates all the benefits from the rebootless late microcode
> loading and not required in this case for functional or security
> purposes.
> 
> 
> Proposed solution
> -----------------
> 
> SGX architecture introduced  a new instruction called EUPDATESVN [1]
> to Ice Lake. It allows updating security SVN version, given that EPC
> is completely empty. The latter is required for security reasons
> in order to reason that enclave security posture is as secure as the
> security SVN version of the TCB that created it.
> 
> This series enables opportunistic execution of EUPDATESVN upon first
> EPC page allocation for a first enclave to be run on the platform.
> 
> This series is partly based on the previous work done by Cathy Zhang
> [2], which attempted to enable forceful destruction of all SGX
> enclaves and execution of EUPDATESVN upon successful application of
> any microcode patch. This approach is determined as being too
> intrusive for the running SGX enclaves, especially taking into account
> that it would be performed upon *every* microcode patch application
> regardless if it changes the security SVN version or not (change to the
> security SVN version is a rare event).
> 
> Testing
> -------
> 
> Tested on EMR machine using kernel-6.16.0_rc7 & sgx selftests.
> Also tested on a Kaby Lake machine without EUPDATESVN support.
> If Google folks in CC can test on their side, it would be greatly appreciated.
> 
> 
> References
> ----------
> 
> [1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
> [2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/
> 
> Elena Reshetova (5):
>   x86/sgx: Introduce functions to count the sgx_(vepc_)open()
>   x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
>   x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
>   x86/sgx: Implement ENCLS[EUPDATESVN]
>   x86/sgx: Enable automatic SVN updates for SGX enclaves
> 
>  arch/x86/include/asm/cpufeatures.h       |  1 +
>  arch/x86/include/asm/sgx.h               | 37 ++++++----
>  arch/x86/kernel/cpu/cpuid-deps.c         |  1 +
>  arch/x86/kernel/cpu/scattered.c          |  1 +
>  arch/x86/kernel/cpu/sgx/driver.c         | 19 ++++-
>  arch/x86/kernel/cpu/sgx/encl.c           |  1 +
>  arch/x86/kernel/cpu/sgx/encls.h          |  5 ++
>  arch/x86/kernel/cpu/sgx/main.c           | 91 ++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h            |  3 +
>  arch/x86/kernel/cpu/sgx/virt.c           | 20 +++++-
>  tools/arch/x86/include/asm/cpufeatures.h |  1 +
>  11 files changed, 163 insertions(+), 17 deletions(-)
> 
> -- 
> 2.45.2
> 
> 

LGTM

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
