Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37746261B9E;
	Thu,  9 Jul 2026 13:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603489; cv=none; b=rz/LCD0ldAKOlUuN0bCR8wHo73jmXghkw+Osp8qHgog3MKwDlfxCrRneLhyVANdTql9j0b3deNDOTkM/AdGicm20kRfS8nildFmwHLa0Ix2G4drSJSPkmqp8XEmINnLSScdmpIQQA65S37USFrDJCgyMQPV6e4gXgHYPDe6TGMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603489; c=relaxed/simple;
	bh=+MKtcdlxUjCsv2R9lIDu/AkyvEYePrf2BMu9hUF8fYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIsxM2r3KASsJCu4lOBmcyaaHzTP5kZzf0k3uerjGz+KvO9R4ODoGDj3P8uHvpC2qCQRiCZDN4oaZbKMg9kmlTIyExufQOFybMEJ5M52xUPg7kp/8tN1J1oUDegicvJoecus9jdTBy7KR9YjHzxAqe4yjqCDkRhSejwV43lPTBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvlT84je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvlT84je"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2BAB91F000E9;
	Thu,  9 Jul 2026 13:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783603487;
	bh=78R/a0gCqkCIHWXwOcMQqoPe5dtjd2xnuQOvZvNAoVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kvlT84jeP67oQrt8rl7M/Cxrxo1DVa0Tz13iTNGViaTvGAecfpdjFkyYr4ehEpSTb
	 c8w6+f6KEetidUzdTqjES74THD+wwFzE++s6fTJXNtNfPI4miYn+uWQy9M99cC8dab
	 FxWXyoUhkld4KUt9jpsYafji1enI/s97+go09NyZjTaCcYW/4pmxJXZPtsJuMwtcBN
	 joZac977TshizY4a9lsYRuigfWPMex5URTW2rYEHCjTUiKTcWtwpXDfh7tvY+0wJb1
	 7AOSfXZAWEkTzXV8nHXzag/YPxfFoLhVdNdKpKXSrVbGB0NJ1gw9fur0tWqNpbSQZJ
	 WLw7mSAPG6mrw==
Date: Thu, 9 Jul 2026 16:24:43 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jun Miao <jun.miao@intel.com>
Cc: dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, kai.huang@intel.com,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, fan.du@intel.com, x86@kernel.org
Subject: Re: [PATCH v5] x86/sgx: Report RCU-Tasks quiescent state in EPC
 sanitization loop
Message-ID: <ak-hG4mo57WiP616@kernel.org>
References: <20260703084810.145567-1-jun.miao@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703084810.145567-1-jun.miao@intel.com>

On Fri, Jul 03, 2026 at 04:48:10PM +0800, Jun Miao wrote:
> When the kernel boots from kexec, the EPC pages may have a stale state.
> The kernel sanitizes all EPC pages to reset them to a clean state before
> their first use in any enclave.  The EPC size could be several GBs and
> resetting them could take a significant amount of time.  Because of that,
> the kernel performs the reset in a loop through a kernel thread ksgxd() at
> early boot, and there's a cond_resched() after resetting each EPC page.
> 
> This is fine in most cases, but becomes a problem when there's other kernel
> code waiting for an RCU-Tasks grace period but the cond_resched() in
> ksgxd() never triggers rescheduling.  Because cond_resched() doesn't report
> a quiescent state when it doesn't trigger rescheduling, the thread that is
> waiting for an RCU-Tasks grace period will wait until all EPC pages are
> reset.

You should probably also say why cond_resched() does not trigger
rescheduling. E.g., put that and delete the first sentence as
it tells nothing and is confusing.

> 
> For instance, BPF LSM subsystem can invoke synchronize_rcu_tasks() at
> kernel boot time.  A VM with a large EPC assigned and BPF LSM enabled can
> take a long time to boot, with a call trace triggered:
> 
>     rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is
> 	130631 jiffies old.
>     INFO: task systemd:1 blocked for more than 122 seconds.
>     ...
>     task:systemd  state:D stack:0  pid:1  tpid:1  ppid:0  flags:0x00000002
>     Call Trace:
>     ...
>     schedule_timeout+0x157/0x170
>     wait_for_completion+0x88/0x150
>     __wait_rcu_gp+0x17e/0x190
>     synchronize_rcu_tasks_generic+0x64/0x60
>     ...
>     synchronize_rcu_tasks+0x15/0x20
>     register_ftrace_direct+0x31f/0x350
>     ...
>     bpf_trampoline_link_prog+0x33/0x60
>     bpf_tracing_prog_attach+0x3c5/0x5f0
> 
> Replace cond_resched() with cond_resched_tasks_rcu_qs() which explicitly
> reports quiescent state regardless of whether actual rescheduling is
> triggered.  Resetting all EPC pages in ksgxd() isn't performance critical
> so the extra cost of cond_resched_tasks_rcu_qs() isn't a problem.
> 
> Tests showed this reduced the VM kernel boot time from ~50s to ~700ms.
> 
> Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Fan Du <fan.du@intel.com>
> Signed-off-by: Fan Du <fan.du@intel.com>
> Signed-off-by: Jun Miao <jun.miao@intel.com>
> Tested-by: Challvy Tee <challvy.tee@gmail.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Link: https://github.com/systemd/systemd/issues/40423
> 
> ---
> v1 -> v2:
>  - Clarify the RCU Tasks stall root cause.
>  - Use cond_resched_rcu_qs() following the Kai`s suggestion.
> 
> v2 -> v3:
>  - cee439398933 ("rcu: Rename cond_resched_rcu_qs() to cond_resched_tasks_rcu_qs()")
> 
> v3 -> v4:
>  - Trim down/rewrite changelog following Kai`s suggestion.
> 
> v4 -> v5:
>  - Change the title, not state the problem directly
>  - Corrected spelling and grammatical errors by Kai
>  - Add "Reviewed-by: Kai Huang"
> 
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 4505f808af5e..7d2f57663177 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -106,7 +106,7 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  			left_dirty++;
>  		}
> 


		/* 
		 * Pretend to be in the quiescent state given the possiblity of
		 * an ongoing grace period:
		 */
> -		cond_resched();
> +		cond_resched_tasks_rcu_qs();
>  	}
> 
>  	list_splice(&dirty, dirty_page_list);
> --
> 2.32.0
> 


BR, Jarkko
