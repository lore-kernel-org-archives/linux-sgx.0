Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A524390CB2;
	Fri, 24 Jul 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784876854; cv=none; b=Lu4mGxMFyCC9VIaU6KO7C0gWKF9/TNc+9AxP3Gd4CA/GOo3KrpqCtMc1FZhOHzHkZ7klLoP1uVjjaSBYXIUSTTOAMN+rP/tpqADgOmuq1AZ7IeKBPoB17oSxFxDPPzZih694sMbwZirULaNCMxBQrFu+XWKrJ6zwYCgRxX27y4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784876854; c=relaxed/simple;
	bh=I5iLiM4yT5rfYLYiS+1z1bArugcENDUBO7RAwypMtu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqICA0HLdR8jHrFdmb1Acor+L4Zp2V2QVVo9MEaiWZWMAOsLL/0I4Ugha35X8wOTSk2ZmGOHPlXDMicElUBqtijL8yvigtU7xX6oqHjELRU6H5hhSGQiPYcafNzryhw1lBLe/uia1AH8vl0oE1aruvsWcgQ0VGK3JstVVQZByQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCw3gAeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCw3gAeT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DF8E11F000E9;
	Fri, 24 Jul 2026 07:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784876852;
	bh=UaxH1UUddJAijiudyP+ko611oyKEG0cvbsLe2rXZA0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kCw3gAeTp5bvLgk48k8K+DDkYY87g69m3V/gFiFjZqAy+SK9rK8YWSEC954qC479w
	 RYHskV172g59wuYs7oFXw9mDglB/QOAfLwYr5SW73R/Wi0kxaHZeLxo3kXv15eUsCJ
	 h6JbX005Xv+gr5v9iveHTjgYdZbDeOJkV3wQExq4wslIgq9uFEN/woj5OnsdZaqGiJ
	 Mo/odlIt7Ez9vQU2FYQQtYivyMackHzvVqLn2j2pfbUgh/ES080Q3X0XtRbt3GEhcP
	 umK2Ps+dSIwA+pd0KnuklevId41iaYI/AMp1bHwVeC0WQSrLaHqhEiLZ7liIR/eYtZ
	 5XLQxasKfhxDw==
Date: Fri, 24 Jul 2026 10:07:28 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jun Miao <jun.miao@intel.com>
Cc: dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, kai.huang@intel.com,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, fan.du@intel.com, challvy.tee@gmail.com
Subject: Re: [PATCH v6] x86/sgx: Report RCU-Tasks quiescent state in EPC
 sanitization loop
Message-ID: <amMPMLAzE0nUiH9C@kernel.org>
References: <20260724025514.525117-1-jun.miao@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724025514.525117-1-jun.miao@intel.com>

On Fri, Jul 24, 2026 at 10:55:14AM +0800, Jun Miao wrote:
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
> v5 -> v6:
>  - Add the exactly kind of reminder that why cond_resched() does 
>    not trigger rescheduling.
> 
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 4505f808af5e..207e680732a4 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -106,7 +106,13 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  			left_dirty++;
>  		}
> 
> -		cond_resched();
> +		/*
> +		 * cond_resched() only schedules when TIF_NEED_RESCHED is set.
> +		 * During this boot-time loop that condition may not happen for a
> +		 * long time, so report an RCU-Tasks quiescent state explicitly.
> +		 * Therefore, change cond_resched() to cond_resched_tasks_rcu_qs().
> +		 */
> +		cond_resched_tasks_rcu_qs();
>  	}
> 
>  	list_splice(&dirty, dirty_page_list);
> -- 
> 2.43.0
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
