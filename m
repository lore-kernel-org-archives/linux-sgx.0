Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B591C84C0;
	Mon, 19 May 2025 18:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747679548; cv=none; b=jKlv0GiH0Fl7QB9xxfVpxgNbgbMplw3lX0d1cSLWxCyYTPtvSJ1xL5X3O8GF4XDI64AVJU8RjkWIX7oRKOeyui/SACStQNjG9F6aX+Y2XEErkUxUx0LYQLyP82/MrOCKCh2PxR8XWzcG53x4AhXalgd1+b353aLiYp7boS+YmuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747679548; c=relaxed/simple;
	bh=H1AP0trpR498y+A4st74/UHQvp6akcwoeEWb0O18RGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxqAcYFXx1CNUmhx3F2FXuqnnBYeREZbjln1NX2VLjoS5UKCC73P4NXUhqinVp5t/3qCx3p19fH8l61dFD2q+z6dh359CUqi+zEFrSL6XgnFd96AdP/H2LNP4CRjb4lgli+wAdgtHy6lH2V0SbtenfTmXHj8vz18aUf44Vm4sA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYeGoFaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYeGoFaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2869EC4CEE4;
	Mon, 19 May 2025 18:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747679547;
	bh=H1AP0trpR498y+A4st74/UHQvp6akcwoeEWb0O18RGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mYeGoFaC0aX6zfFbwh8/n0ekDh2z2mQRABLYp4+J3mMdpe19jBTBbcvuOjqhDgJhP
	 TWXgW9x2UA1n9dgn5zFEWMdnRoRXJDf8OHJLXiVfhRmTnIY4Z/iKzEcS0iFBpuHiq3
	 B+mjb5HGRmVSWKEvtl6nEkIQ2gvCbIMe9G3m0aFEyQdA6kjxJrBUjCPsmVUJFjJbZ0
	 6CSZjd7VjfIqXyW1GxjLYh/bz70yfGnMCJo2UzxWcovHxI2/xa9Ca248R5Lz2w/MXG
	 Ox4nyQq0pq+n+Oq4CtYy3DGKMYmA7nGn1yIKmYMLvfeT1S1VYSSsFRZwCr+hCXcgp3
	 r6FjiDcJXNBDw==
Date: Mon, 19 May 2025 21:32:23 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com, chongc@google.com,
	erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Message-ID: <aCt5Nx06rItmWcYR@kernel.org>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250519072603.328429-6-elena.reshetova@intel.com>

On Mon, May 19, 2025 at 10:24:31AM +0300, Elena Reshetova wrote:
> SGX enclaves have an attestation mechanism.  An enclave might,
> for instance, need to attest to its state before it is given
> a special decryption key.  Since SGX must trust the CPU microcode,
> attestation incorporates the microcode versions of all processors
> on the system and is affected by microcode updates. This enables
> deployment decisions based on the microcode version.
> For example, an enclave might be denied a decryption key if it
> runs on a system that has old microcode without a specific mitigation.
> 
> Unfortunately, this attestation metric (called CPUSVN) is only a snapshot.
> When the kernel first uses SGX (successfully executes any ENCLS instruction),
> SGX inspects all CPUs in the system and incorporates a record of their
> microcode versions into CPUSVN. CPUSVN is only automatically updated at reboot.
> This means that, although the microcode has been updated, enclaves can never
> attest to this fact. Enclaves are stuck attesting to the old version until
> a reboot.
> 
> The SGX architecture has an alternative to these reboots: the ENCLS[EUPDATESVN]
> instruction [1]. It allows another snapshot to be taken to update CPUSVN
> after a runtime microcode update without a reboot.
> 
> Whenever a microcode update affects SGX, the SGX attestation architecture
> assumes that all running enclaves and cryptographic assets (like internal
> SGX encryption keys) have been compromised. To mitigate the impact of this
> presumed compromise, EUPDATESVN success requires that all SGX memory to be
> marked as “unused” and its contents destroyed. This requirement ensures
> that no compromised enclave can survive the EUPDATESVN procedure and provides
> an opportunity to generate new cryptographic assets.
> 
> Attempt to execute EUPDATESVN on the first open of sgx_(vepc)open().
> If EUPDATESVN fails with any other error code than SGX_INSUFFICIENT_ENTROPY,
> this is considered unexpected and the open() returns an error. This
> should not happen in practice. On contrary SGX_INSUFFICIENT_ENTROPY might
> happen due to a pressure on the system DRNG (RDSEED) and therefore
> the open() is not blocked to allow normal enclave operation.
> 
> [1] Runtime Microcode Updates with Intel Software Guard Extensions,
> https://cdrdv2.intel.com/v1/dl/getContent/648682

I'd hope, despite having the wealth of information in it, this commit
message would a go round or few of editing, and nail the gist of this
commit better. Then it would be easier in future review the choices
made.

BR, Jarkko
