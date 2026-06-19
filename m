Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD5540D579;
	Fri, 19 Jun 2026 00:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781829707; cv=none; b=uPN8UAni/FV9OY8f1053/WKU+rroCsQWgQAIWNu73K+2ISbmcSbFVrkdxg8Pwy5OnL0Lmi3u6Y/QkB0VA/z4N+ULmIAdVOuRQBD2qAMvW0wD/5wCGJeumNlLSpm7U6aQhDAi2ZVT7F/QSzWOsypYD8C/1BLiFpdbs+LGyA/+/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781829707; c=relaxed/simple;
	bh=zrfTxmVXA2VwcRdj5EONtPyAhay6ysbBNblo588qkhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIhDHR27xY0SS3vcCEFCKUiUM4UnVtGy3p4vm+E0MxaWu49LAIk5YQW27+2n6FsnzFjT/giLKH5WokMJbjk30zwxVyoLXc1Y/zRtgt8kyt2BMJ3EZi1l/kIka5arLYL531FOGDn0t4QlS+5Rt+cjooydCmceAcPVkGWemcOz1DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgLd0/Ct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgLd0/Ct"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A485A1F000E9;
	Fri, 19 Jun 2026 00:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781829706;
	bh=QLDLeKXG9X3PVj3yGMKyOVjBhJgFW44+uPkbDBs/O/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NgLd0/CtAVGhak6paAalZ6cQN2e1YJx3Z9CtgX0vPJUtQHgTDYId+vc7OXASIFlAS
	 pWnmbgPmHG56OuheavhDMtKzSFN6CZHHXTJiOzU6ygBHHzSy6jYDIv4WhBBXvfCERU
	 gpc1HNSqQndEmVfDTx0eNA6e0dFijtNrVVmjHS54x3meGWKwYUHDijDIJJSwpRC/vQ
	 zShPd+n2W65a1JUqASTnZoVEvEOJ4Uv1igC4GbEnkxfYN/XkLLpEY5lpYX/pYFWFqf
	 bDM7oB3spzxq03xGV+elwKaUaE4bTjT1HLu7/EAhczw1KM/ojOBLWudh/1ooa7KVvC
	 4hUlx++NHXvKg==
Date: Fri, 19 Jun 2026 03:41:42 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jun Miao <jun.miao@intel.com>
Cc: dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, fan.du@intel.com,
	challvy.tee@gmail.com
Subject: Re: [PATCH] x86/sgx: Periodically yield in EPC sanitization to
 unblock rcu_tasks GP
Message-ID: <ajSQRmcf7wCJF7ni@kernel.org>
References: <20260618100432.2280834-1-jun.miao@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618100432.2280834-1-jun.miao@intel.com>

On Thu, Jun 18, 2026 at 06:04:32PM +0800, Jun Miao wrote:
> During early boot, ksgxd (Intel Software Guard Extensions Kernel Thread)
> iterates over all post-kexec dirty EPC pages in a tight loop calling
> cond_resched() after each page.  But, on isolated CPUs
> (a common configuration in cloud VMs), cond_resched() never triggers a
> real context switch because TIF_NEED_RESCHED is not set when no competing
> runnable task exists on that CPU.
> 
> synchronize_rcu_tasks(), invoked by BPF LSM during initialization, must
> wait for every task that was running at the start of the grace period to
> pass through a quiescent state (a voluntary sleep or preemption point).
> If ksgxd never leaves the CPU, the rcu_tasks grace period stalls, causing
> boot delays exceeding 60 seconds on machines with large EPC regions.
> 
> Fix this by introducing SGX_SANITIZE_RESCHED_INTERVAL (32768) and forcing
> ksgxd to sleep for one jiffy every that many pages, guaranteeing that an
> rcu_tasks quiescent state is reached in bounded time regardless of CPU
> isolation.  Keep cond_resched() for all other iterations.
> 
> Without this patch, instead, virtual machines (VMs) experience a long OS boot times:
> 
> [    4.110549] systemd[1]: Detected architecture x86-64.
> [    4.115279] systemd[1]: Hostname set to <i2bp1g0g0m0i8406er0g1zX2>.
> [    4.115554] systemd[1]: Installed transient /etc/machine-id file.
> [   14.262158] rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is 10087 jiffies old.
> [   14.374158] rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is 40199 jiffies old.
> [  134.806157] rcu_tasks_wait_gp: rcu_tasks grace period number 1 (since boot) is 130631 jiffies old.
> [  248.086158] INFO: task systemd:1 blocked for more than 122 seconds.
> [  248.086491] Not tainted 6.8.0-90-generic #91-Ubuntu
> [  248.086739] 'echo 0 > /proc/sys/kernel/hung_task_timeout_secs' disables this message.
> [  248.086993] task:systemd    state:D stack:0    pid:1    tpid:1    ppid:0    flags:0x00000002
> [  248.087274] Call Trace:
> [  248.087434] <TASK>
> [  248.087557] __schedule+0x27c/0x6b0
> [  248.087770] schedule+0x33/0x110
> [  248.087939] schedule_timeout+0x157/0x170
> [  248.088120] wait_for_completion+0x88/0x150
> [  248.088304] __wait_rcu_gp+0x17e/0x190
> [  248.088481] synchronize_rcu_tasks_generic+0x64/0x60
> [  248.088672] ? __pfx_call_rcu_tasks+0x10/0x10
> [  248.088858] ? __pfx_wakeme_after_rcu+0x10/0x10
> [  248.089047] synchronize_rcu_tasks+0x15/0x20
> [  248.089260] register_ftrace_direct+0x31f/0x350
> [  248.089445] ? __pfx_bpf_lsm_file_open+0x10/0x10
> [  248.089629] bpf_trampoline_update+0x469/0x650
> [  248.089814] ? 0xffffffffffffffff
> [  248.089988] ? 0xffffffffffffffff
> [  248.090153] __bpf_trampoline_link_prog+0x10d/0x330
> [  248.090339] bpf_trampoline_link_prog+0x33/0x60
> [  248.090518] bpf_tracing_prog_attach+0x3c5/0x5f0
> [  248.090699] link_create+0x1a5/0x280
> [  248.090886] ? security_bpf+0x3c/0x70
> [  248.091101] __sys_bpf+0x4ae/0x10
> [  248.091312] __x64_sys_bpf+0x1a/0x30
> [  248.091477] x64_sys_call+0x199/0x250
> [  248.091647] do_syscall_64+0x7f/0x180
> [  248.091818] ? arch_exit_to_user_mode_prepare.isa.0+0x1a/0x60
> [  248.092022] ? irqentry_exit_to_user_mode+0x38/0x1e0
> [  248.092246] ? irqentry_exit+0x43/0x50
> [  248.092401] entry_SYSCALL_64_after_hwframe+0x78/0x80
> [  248.092590] RIP: 0033:0x7b53e592728d
> [  248.092756] RSP: 002b:00007ffdaa9d696 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> [  248.092856] RAX: ffffffffffffffda RBX: 00007ffdaa9d696 RCX: 00007b53e592728d
> [  248.092956] RDX: 0000000000000000 RSI: 00007ffdaa9d696 RDI: 0000000000000001
> [  248.093056] RBP: 00007ffdaa9d696 R08: 00007b53e5a03a8 R09: 00007ffdaa9d696
> [  248.093156] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  248.093256] R13: 0000000000000000 R14: 00005d81ed2cfd0 R15: 00005d81ed2b7ec0
> [  248.093406] </TASK>
> 
> Reported-by: challvy <challvy.tee@gmail.com>
> Link: https://github.com/systemd/systemd/issues/40423
> Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> Co-developed-by: Fan Du <fan.du@intel.com>
> Signed-off-by: Fan Du <fan.du@intel.com>
> Signed-off-by: Jun Miao <jun.miao@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 4505f808af5e..4642d2d47186 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -52,6 +52,13 @@ static struct sgx_numa_node *sgx_numa_nodes;
>  
>  static LIST_HEAD(sgx_dirty_page_list);
>  
> +/*
> + * Force a voluntary context switch every SGX_SANITIZE_RESCHED_INTERVAL
> + * iterations to let synchronize_rcu_tasks() (e.g. called by BPF LSM at
> + * init) complete its grace period.
> + */
> +#define SGX_SANITIZE_RESCHED_INTERVAL	(1 << 15)

nit: maybe SGX_SANITIZE_PAGES_RECHED_INTERVAL

> +
>  /*
>   * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
>   * from the input list, and made available for the page allocator. SECS pages
> @@ -63,6 +70,7 @@ static LIST_HEAD(sgx_dirty_page_list);
>  static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  {
>  	unsigned long left_dirty = 0;
> +	unsigned long count = 0;
>  	struct sgx_epc_page *page;
>  	LIST_HEAD(dirty);
>  	int ret;

nit: reverse xmas tree order

> @@ -72,6 +80,18 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  		if (kthread_should_stop())
>  			return 0;
>  
> +		/*
> +		 * On isolated CPUs cond_resched() does not trigger a real
> +		 * context switch when no competing runnable task exists.
> +		 * Periodically force ksgxd to sleep so that synchronize_rcu_tasks()
> +		 * (e.g. BPF LSM) can complete the grace period in bounded time.
> +		 * Keep cond_resched() between forced sleeps for higher-priority tasks.
> +		 */
> +		if (!(++count & (SGX_SANITIZE_RESCHED_INTERVAL - 1)))
> +			schedule_timeout_interruptible(1);
> +		else
> +			cond_resched();
> +
>  		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
>  
>  		/*
> @@ -105,8 +125,6 @@ static unsigned long __sgx_sanitize_pages(struct list_head *dirty_page_list)
>  			list_move_tail(&page->list, &dirty);
>  			left_dirty++;
>  		}
> -
> -		cond_resched();
>  	}
>  
>  	list_splice(&dirty, dirty_page_list);
> -- 
> 2.43.0
> 
> 

BR, Jarkko
