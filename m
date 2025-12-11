Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9AD224AE0;
	Thu, 11 Dec 2025 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765484134; cv=none; b=h8fV6vwCoZc7fg+PYa+nkaOkkXrvm9CyLMe/ex8t8je6jYTvtkRDYaY3zjL209sigoEQeriUQT6Gladbc/YvaVqEnAA1MfjwOoe/7xTkAIEOEXPIQ6nd6QnFJJXPVxprhT0f905mmwfbzbC4FDVJTin9dJNurwnemWY390SwLaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765484134; c=relaxed/simple;
	bh=WFF8+EQUupEPe9GngNp2KV5bMWgssEAmOk32SuTfN8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q5DYkAD5Pl2+pdevq6YQiTitebJ2U34nj4WZqIgyYNhfK33XKQ7qfwSDrHIsFfrieZnc0pxjwVSqfiaCA0yzA6lz5KuCGXCVr/udck1nYOQuLW+FgNxOH09Ce/UqxoD22zk+MPgqN3FaMfN+oP+BBgosalfvslJb3PQ+XX9PuEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iE3flmyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iE3flmyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2831C4CEF7;
	Thu, 11 Dec 2025 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765484134;
	bh=WFF8+EQUupEPe9GngNp2KV5bMWgssEAmOk32SuTfN8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iE3flmypWmhxHJQUeVbKs89TMdxrBQvVjPuniu7HrRF6DHYjGAJbDQ/LduBceDPPd
	 MWJDsu1X+gNt/QVztQg1hPEPLRUaQRABcjhCF/CL20nQBC6ZLhUihZnecX9QqCeVIH
	 BQKnnJ3NorwCnDizXubn6DDdayfLY5Z0b2rcIZBcvSLehCnSnx27Zd6Reih/c9tSnD
	 p7XV9+T+GRzyZdb5QbOvpnW9/qLkelV7HEKKrFybQ4kwk6ttrRIxrxUXl+UZvklLaA
	 sfNrJCCf0+xpkKB/jYAv9QBabvJnfAwpv93572FPfepywjExo7ncA4v1jbK6/qr4Xd
	 6o+9cy0TIMZ/g==
Date: Thu, 11 Dec 2025 22:15:30 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use goto to remove redundant if check in
 sgx_encl_init
Message-ID: <aTsmYkI3ThbsfpIH@kernel.org>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
 <aTmSq5Px4P6vEUCb@kernel.org>
 <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>
 <aTsjqDtWoIO_p60j@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aTsjqDtWoIO_p60j@kernel.org>

On Thu, Dec 11, 2025 at 10:03:56PM +0200, Jarkko Sakkinen wrote:
> On Wed, Dec 10, 2025 at 04:48:08PM +0100, Thorsten Blum wrote:
> > On 10. Dec 2025, at 16:32, Jarkko Sakkinen wrote:
> > > On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
> > >> Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
> > >> instead of checking for the same condition again in the outer loop.
> > >> 
> > >> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > >> ---
> > >> [...]
> > > 
> > > I don't think moving code around is very useful.
> > 
> > The patch doesn't actually move any code around, but it removes up to 50
> > (SGX_EINIT_SLEEP_COUNT) duplicate and therefore unnecessary if checks in
> > the outer for loop.
> 
> Temporary change for generating disassembly:
> 
> ❯ git diff
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 66f1efa16fbb..da43613eb837 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -464,8 +464,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>         return ret;
>  }
> 
> -static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> -                        void *token)
> +int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> +                 void *token)
>  {
>         u64 mrsigner[4];
>         int i, j;
> 
> 
> Then I A/B by doing
> 
> gdb -q -batch -ex 'set pagination off' -ex 'disassemble sgx_ioctl' .clangd/vmlinux > sgx_ioctl_a.txt
> gdb -q -batch -ex 'set pagination off' -ex 'disassemble sgx_ioctl' .clangd/vmlinux > sgx_ioctl_b.txt
> 
> ❯ diff -u sgx_ioctl_a.txt  sgx_ioctl_b.txt
> --- sgx_ioctl_a.txt     2025-12-11 21:59:59.660197371 +0200
> +++ sgx_ioctl_b.txt     2025-12-11 22:00:50.713917112 +0200
> @@ -12,31 +12,31 @@
>  mov    %rdx,0x20(%rsp)
>  lock btsq $0x1,0x10(%rbx)
>  mov    $0xfffffffffffffff0,%rax
> -jb     0xffffffff812275ac <sgx_ioctl+1402>
> +jb     0xffffffff812275ad <sgx_ioctl+1402>
>  cmp    $0xc018a407,%esi
> -je     0xffffffff812273ce <sgx_ioctl+924>
> -ja     0xffffffff81227098 <sgx_ioctl+102>
> +je     0xffffffff812273cf <sgx_ioctl+924>
> +ja     0xffffffff81227099 <sgx_ioctl+102>
>  cmp    $0x4008a402,%esi
> -je     0xffffffff81227174 <sgx_ioctl+322>
> +je     0xffffffff81227175 <sgx_ioctl+322>
>  cmp    $0x4008a403,%esi
> -je     0xffffffff81227253 <sgx_ioctl+545>
> +je     0xffffffff81227254 <sgx_ioctl+545>
>  cmp    $0x4008a400,%esi
> -je     0xffffffff812270c6 <sgx_ioctl+148>
> -jmp    0xffffffff812270bc <sgx_ioctl+138>
> +je     0xffffffff812270c7 <sgx_ioctl+148>
> +jmp    0xffffffff812270bd <sgx_ioctl+138>
>  cmp    $0xc028a406,%esi
> -je     0xffffffff8122732f <sgx_ioctl+765>
> +je     0xffffffff81227330 <sgx_ioctl+765>
>  cmp    $0xc030a401,%esi
> -je     0xffffffff81227162 <sgx_ioctl+304>
> +je     0xffffffff81227163 <sgx_ioctl+304>
>  cmp    $0xc028a405,%esi
> -je     0xffffffff81227298 <sgx_ioctl+614>
> +je     0xffffffff81227299 <sgx_ioctl+614>
>  mov    $0xfffffdfd,%eax
> -jmp    0xffffffff812275a5 <sgx_ioctl+1395>
> +jmp    0xffffffff812275a6 <sgx_ioctl+1395>
>  xor    %esi,%esi
>  mov    $0xffffffffffffffea,%rax
>  mov    %rsi,0x40(%rsp)
>  mov    0x10(%rbx),%rdx
>  and    $0x10,%dl
> -jne    0xffffffff812275a5 <sgx_ioctl+1395>
> +jne    0xffffffff812275a6 <sgx_ioctl+1395>
>  mov    0x20(%rsp),%rsi
>  mov    $0x8,%edx
>  lea    0x40(%rsp),%rdi
> @@ -44,39 +44,39 @@
>  mov    %rax,%rdx
>  mov    $0xfffffffffffffff2,%rax
>  test   %rdx,%rdx
> -jne    0xffffffff812275a5 <sgx_ioctl+1395>
> -mov    0x437ed1(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
> +jne    0xffffffff812275a6 <sgx_ioctl+1395>
> +mov    0x437ed0(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
>  mov    $0x1000,%edx
>  mov    $0xcc0,%esi
>  call   0xffffffff812cdde9 <__kmalloc_cache_noprof>
>  mov    %rax,%r13
>  mov    $0xfffffffffffffff4,%rax
>  test   %r13,%r13
> -je     0xffffffff812275a5 <sgx_ioctl+1395>
> +je     0xffffffff812275a6 <sgx_ioctl+1395>
>  mov    0x40(%rsp),%rsi
>  mov    $0x1000,%edx
>  mov    %r13,%rdi
>  mov    $0xfffffff2,%r12d
>  call   0xffffffff8133b725 <_copy_from_user>
>  test   %rax,%rax
> -jne    0xffffffff81227243 <sgx_ioctl+529>
> +jne    0xffffffff81227244 <sgx_ioctl+529>
>  mov    %r13,%rsi
>  mov    %rbx,%rdi
>  call   0xffffffff812267da <sgx_encl_create>
> -jmp    0xffffffff81227240 <sgx_ioctl+526>
> +jmp    0xffffffff81227241 <sgx_ioctl+526>
>  mov    0x20(%rsp),%rsi
>  mov    %rbx,%rdi
>  call   0xffffffff812269b2 <sgx_ioc_enclave_add_pages>
> -jmp    0xffffffff812275a5 <sgx_ioctl+1395>
> +jmp    0xffffffff812275a6 <sgx_ioctl+1395>
>  xor    %ecx,%ecx
>  mov    $0xffffffffffffffea,%rax
>  mov    %rcx,0x40(%rsp)
>  mov    0x10(%rbx),%rdx
>  and    $0x10,%dl
> -je     0xffffffff812275a5 <sgx_ioctl+1395>
> +je     0xffffffff812275a6 <sgx_ioctl+1395>
>  mov    0x10(%rbx),%rdx
>  bt     $0x8,%edx
> -jb     0xffffffff812275a5 <sgx_ioctl+1395>
> +jb     0xffffffff812275a6 <sgx_ioctl+1395>
>  mov    0x20(%rsp),%rsi
>  mov    $0x8,%edx
>  lea    0x40(%rsp),%rdi
> @@ -84,15 +84,15 @@
>  mov    %rax,%rdx
>  mov    $0xfffffffffffffff2,%rax
>  test   %rdx,%rdx
> -jne    0xffffffff812275a5 <sgx_ioctl+1395>
> -mov    0x437e15(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
> +jne    0xffffffff812275a6 <sgx_ioctl+1395>
> +mov    0x437e14(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
>  mov    $0x1000,%edx
>  mov    $0xcc0,%esi
>  call   0xffffffff812cdde9 <__kmalloc_cache_noprof>
>  mov    %rax,%r13
>  mov    $0xfffffffffffffff4,%rax
>  test   %r13,%r13
> -je     0xffffffff812275a5 <sgx_ioctl+1395>
> +je     0xffffffff812275a6 <sgx_ioctl+1395>
>  lea    0x800(%r13),%r14
>  xor    %eax,%eax
>  mov    $0x4c,%ecx
> @@ -104,13 +104,13 @@
>  mov    0x40(%rsp),%rsi
>  call   0xffffffff8133b725 <_copy_from_user>
>  test   %rax,%rax
> -jne    0xffffffff81227243 <sgx_ioctl+529>
> +jne    0xffffffff81227244 <sgx_ioctl+529>
>  mov    0x10(%r13),%eax
>  test   %eax,%eax
> -je     0xffffffff81227232 <sgx_ioctl+512>
> +je     0xffffffff81227233 <sgx_ioctl+512>
>  mov    $0xffffffea,%r12d
>  cmp    $0x8086,%eax
> -jne    0xffffffff81227243 <sgx_ioctl+529>
> +jne    0xffffffff81227244 <sgx_ioctl+529>
>  mov    %r14,%rdx
>  mov    %r13,%rsi
>  mov    %rbx,%rdi
> @@ -119,7 +119,7 @@
>  mov    %r13,%rdi
>  call   0xffffffff812ce269 <kfree>
>  movslq %r12d,%rax
> -jmp    0xffffffff812275a5 <sgx_ioctl+1395>
> +jmp    0xffffffff812275a6 <sgx_ioctl+1395>
>  xor    %edx,%edx
>  mov    0x20(%rsp),%rsi
>  lea    0x40(%rsp),%rdi
> @@ -129,12 +129,12 @@
>  mov    %rax,%rdx
>  mov    $0xfffffffffffffff2,%rax
>  test   %rdx,%rdx
> -jne    0xffffffff812275a5 <sgx_ioctl+1395>
> +jne    0xffffffff812275a6 <sgx_ioctl+1395>
>  mov    0x40(%rsp),%esi
>  lea    0x80(%rbx),%rdi
> -call   0xffffffff81228220 <sgx_set_attribute>
> +call   0xffffffff81228221 <sgx_set_attribute>
>  cltq
> -jmp    0xffffffff812275a5 <sgx_ioctl+1395>
> +jmp    0xffffffff812275a6 <sgx_ioctl+1395>
>  lea    0x40(%rsp),%r13
>  xor    %eax,%eax
>  mov    $0xa,%ecx
> @@ -144,32 +144,32 @@
>  call   0xffffffff81226369 <sgx_ioc_sgx2_ready>
>  movslq %eax,%r12
>  test   %r12,%r12
> -jne    0xffffffff812273c6 <sgx_ioctl+916>
> +jne    0xffffffff812273c7 <sgx_ioctl+916>
>  mov    0x20(%rsp),%rsi
>  mov    $0x28,%edx
>  mov    %r13,%rdi
>  call   0xffffffff8133b725 <_copy_from_user>
>  test   %rax,%rax
> -jne    0xffffffff81227367 <sgx_ioctl+821>
> +jne    0xffffffff81227368 <sgx_ioctl+821>
>  mov    0x48(%rsp),%rdx
>  mov    0x40(%rsp),%rsi
>  mov    %rbx,%rdi
>  mov    $0xffffffffffffffea,%r12
>  call   0xffffffff81226339 <sgx_validate_offset_length>
>  test   %eax,%eax
> -jne    0xffffffff812273c6 <sgx_ioctl+916>
> +jne    0xffffffff812273c7 <sgx_ioctl+916>
>  mov    0x50(%rsp),%rax
>  cmp    $0x7,%rax
> -ja     0xffffffff812273c6 <sgx_ioctl+916>
> +ja     0xffffffff812273c7 <sgx_ioctl+916>
>  and    $0x3,%eax
>  cmp    $0x2,%rax
> -je     0xffffffff812273c6 <sgx_ioctl+916>
> +je     0xffffffff812273c7 <sgx_ioctl+916>
>  mov    0x58(%rsp),%rax
>  or     0x60(%rsp),%rax
> -jne    0xffffffff812273c6 <sgx_ioctl+916>
> +jne    0xffffffff812273c7 <sgx_ioctl+916>
>  mov    %r13,%rsi
>  call   0xffffffff81226611 <sgx_enclave_restrict_permissions>
> -jmp    0xffffffff812273ac <sgx_ioctl+890>
> +jmp    0xffffffff812273ad <sgx_ioctl+890>
>  lea    0x40(%rsp),%r13
>  xor    %eax,%eax
>  mov    $0xa,%ecx
> @@ -179,27 +179,27 @@
>  call   0xffffffff81226369 <sgx_ioc_sgx2_ready>
>  movslq %eax,%r12
>  test   %r12,%r12
> -jne    0xffffffff812273c6 <sgx_ioctl+916>
> +jne    0xffffffff812273c7 <sgx_ioctl+916>
>  mov    0x20(%rsp),%rsi
>  mov    $0x28,%edx
>  mov    %r13,%rdi
>  call   0xffffffff8133b725 <_copy_from_user>
>  test   %rax,%rax
> -je     0xffffffff81227370 <sgx_ioctl+830>
> +je     0xffffffff81227371 <sgx_ioctl+830>
>  mov    $0xfffffffffffffff2,%r12
> -jmp    0xffffffff812273c6 <sgx_ioctl+916>
> +jmp    0xffffffff812273c7 <sgx_ioctl+916>
>  mov    0x48(%rsp),%rdx
>  mov    0x40(%rsp),%rsi
>  mov    %rbx,%rdi
>  mov    $0xffffffffffffffea,%r12
>  call   0xffffffff81226339 <sgx_validate_offset_length>
>  test   %eax,%eax
> -jne    0xffffffff812273c6 <sgx_ioctl+916>
> +jne    0xffffffff812273c7 <sgx_ioctl+916>
>  cmpq   $0xff,0x50(%rsp)
> -ja     0xffffffff812273c6 <sgx_ioctl+916>
> +ja     0xffffffff812273c7 <sgx_ioctl+916>
>  mov    0x58(%rsp),%rax
>  or     0x60(%rsp),%rax
> -jne    0xffffffff812273c6 <sgx_ioctl+916>
> +jne    0xffffffff812273c7 <sgx_ioctl+916>
>  mov    %r13,%rsi
>  call   0xffffffff81226413 <sgx_enclave_modify_types>
>  mov    0x20(%rsp),%rdi
> @@ -208,9 +208,9 @@
>  mov    %rax,%r12
>  call   0xffffffff8133b81f <_copy_to_user>
>  test   %rax,%rax
> -jne    0xffffffff81227367 <sgx_ioctl+821>
> +jne    0xffffffff81227368 <sgx_ioctl+821>
>  mov    %r12d,%eax
> -jmp    0xffffffff812275a5 <sgx_ioctl+1395>
> +jmp    0xffffffff812275a6 <sgx_ioctl+1395>
>  lea    0x28(%rsp),%r15
>  xor    %eax,%eax
>  mov    $0x6,%ecx
> @@ -220,15 +220,15 @@
>  call   0xffffffff81226369 <sgx_ioc_sgx2_ready>
>  movslq %eax,%r14
>  test   %r14,%r14
> -jne    0xffffffff812275a2 <sgx_ioctl+1392>
> +jne    0xffffffff812275a3 <sgx_ioctl+1392>
>  mov    0x20(%rsp),%rsi
>  mov    $0x18,%edx
>  mov    %r15,%rdi
>  call   0xffffffff8133b725 <_copy_from_user>
>  test   %rax,%rax
> -je     0xffffffff81227416 <sgx_ioctl+996>
> +je     0xffffffff81227417 <sgx_ioctl+996>
>  mov    $0xfffffffffffffff2,%r14
> -jmp    0xffffffff812275a2 <sgx_ioctl+1392>
> +jmp    0xffffffff812275a3 <sgx_ioctl+1392>
>  mov    0x30(%rsp),%rdx
>  mov    0x28(%rsp),%rsi
>  mov    %rbx,%rdi
> @@ -236,10 +236,10 @@
>  call   0xffffffff81226339 <sgx_validate_offset_length>
>  mov    %eax,%r12d
>  test   %eax,%eax
> -jne    0xffffffff812275a2 <sgx_ioctl+1392>
> +jne    0xffffffff812275a3 <sgx_ioctl+1392>
>  mov    0x38(%rsp),%r13
>  test   %r13,%r13
> -jne    0xffffffff812275a2 <sgx_ioctl+1392>
> +jne    0xffffffff812275a3 <sgx_ioctl+1392>
>  lea    0x48(%rsp),%rdx
>  mov    $0xe,%ecx
>  mov    %rdx,%rdi
> @@ -248,12 +248,12 @@
>  movq   $0x7,0x40(%rsp)
>  mov    %rax,0x18(%rsp)
>  cmp    0x30(%rsp),%r13
> -jae    0xffffffff8122757f <sgx_ioctl+1357>
> +jae    0xffffffff81227580 <sgx_ioctl+1357>
>  mov    0x28(%rsp),%rax
>  add    (%rbx),%rax
>  add    %r13,%rax
>  mov    %rax,0x10(%rsp)
> -call   0xffffffff81227e7c <sgx_reclaim_direct>
> +call   0xffffffff81227e7d <sgx_reclaim_direct>
>  mov    0x18(%rsp),%rdi
>  call   0xffffffff81427ce9 <mutex_lock>
>  mov    0x10(%rsp),%rsi
> @@ -261,32 +261,32 @@
>  call   0xffffffff81225b7e <sgx_encl_load_page>
>  mov    %rax,%r14
>  cmp    $0xfffffffffffff000,%rax
> -jbe    0xffffffff812274c0 <sgx_ioctl+1166>
> +jbe    0xffffffff812274c1 <sgx_ioctl+1166>
>  xor    %r12d,%r12d
>  cmp    $0xfffffffffffffff0,%rax
>  sete   %r12b
>  lea    -0xe(%r12,%r12,2),%r12d
> -jmp    0xffffffff81227575 <sgx_ioctl+1347>
> +jmp    0xffffffff81227576 <sgx_ioctl+1347>
>  mov    0x8(%rax),%eax
>  and    $0xffff00,%eax
>  cmp    $0x400,%eax
> -je     0xffffffff812274d8 <sgx_ioctl+1190>
> +je     0xffffffff812274d9 <sgx_ioctl+1190>
>  or     $0xffffffff,%r12d
> -jmp    0xffffffff81227575 <sgx_ioctl+1347>
> +jmp    0xffffffff81227576 <sgx_ioctl+1347>
>  mov    0x10(%r14),%rdi
>  call   0xffffffff812262fc <sgx_get_epc_virt_addr>
>  mov    %rax,%rsi
>  lea    0x40(%rsp),%rdi
>  call   0xffffffff81226328 <__emodpr>
>  bt     $0x1e,%eax
> -jae    0xffffffff812274cf <sgx_ioctl+1181>
> +jae    0xffffffff812274d0 <sgx_ioctl+1181>
>  and    $0xbfffffff,%eax
>  cmp    $0xe,%eax
> -jne    0xffffffff812274cf <sgx_ioctl+1181>
> +jne    0xffffffff812274d0 <sgx_ioctl+1181>
>  mov    0x10(%r14),%rdi
> -call   0xffffffff812279e0 <sgx_unmark_page_reclaimable>
> +call   0xffffffff812279e1 <sgx_unmark_page_reclaimable>
>  test   %eax,%eax
> -jne    0xffffffff8122756f <sgx_ioctl+1341>
> +jne    0xffffffff81227570 <sgx_ioctl+1341>
>  mov    0x18(%rsp),%rdi
>  add    $0x1000,%r13
>  call   0xffffffff81427360 <mutex_unlock>
> @@ -309,7 +309,7 @@
>  call   0xffffffff812ce269 <kfree>
>  mov    0x18(%rsp),%rdi
>  call   0xffffffff81427360 <mutex_unlock>
> -jmp    0xffffffff81227469 <sgx_ioctl+1079>
> +jmp    0xffffffff8122746a <sgx_ioctl+1079>
>  mov    $0xfffffff0,%r12d
>  mov    0x18(%rsp),%rdi
>  call   0xffffffff81427360 <mutex_unlock>
> @@ -320,7 +320,7 @@
>  mov    %r13,0x38(%rsp)
>  call   0xffffffff8133b81f <_copy_to_user>
>  test   %rax,%rax
> -jne    0xffffffff8122740a <sgx_ioctl+984>
> +jne    0xffffffff8122740b <sgx_ioctl+984>
>  mov    %r14d,%eax
>  lock andb $0xfd,0x10(%rbx)
>  cltq
> 
> How would you interpret this?
> 
> > 
> > Thanks,
> > Thorsten
> > 

Oops, sorry, here's against sgx_encl_init():

~/work/kernel.org/jarkko/linux-tpmdd queue*
❯ diff -u sgx_ioctl_a.txt  sgx_ioctl_b.txt
--- sgx_ioctl_a.txt     2025-12-11 22:11:57.444562168 +0200
+++ sgx_ioctl_b.txt     2025-12-11 22:12:08.308829402 +0200
@@ -4,81 +4,81 @@
 mov    $0x8,%ecx
 push   %r14
 push   %r13
+mov    %rdi,%r13
 push   %r12
 push   %rbp
-mov    %rdi,%rbp
+mov    $0xfffffff3,%ebp
 push   %rbx
 sub    $0x30,%rsp
-mov    %rdx,(%rsp)
-mov    0x80(%rbp),%rdx
 lea    0x10(%rsp),%rdi
+mov    %rdx,0x8(%rsp)
 rep stos %eax,%es:(%rdi)
-mov    $0xfffffff3,%eax
-not    %rdx
-and    0x78(%rbp),%rdx
-jne    0xffffffff81227023 <sgx_encl_init+335>
-mov    0x3a0(%rsi),%rdx
+mov    0x80(%r13),%rax
+not    %rax
+and    0x78(%r13),%rax
+jne    0xffffffff81227022 <sgx_encl_init+334>
+mov    0x3a0(%rsi),%rax
 mov    %rsi,%rbx
-and    0x3b0(%rsi),%rdx
-mov    $0xffffffea,%eax
-and    0x6ebb47(%rip),%rdx        # 0xffffffff81912a78 <sgx_attributes_reserved_mask>
-jne    0xffffffff81227023 <sgx_encl_init+335>
-mov    0x384(%rsi),%edx
-and    0x388(%rsi),%edx
-and    0x6ebb27(%rip),%edx        # 0xffffffff81912a70 <sgx_misc_reserved_mask>
-jne    0xffffffff81227023 <sgx_encl_init+335>
-mov    0x3a8(%rsi),%rdx
-and    0x3b8(%rsi),%rdx
-and    0x5f920c(%rip),%rdx        # 0xffffffff81820170 <sgx_xfrm_reserved_mask>
-jne    0xffffffff81227023 <sgx_encl_init+335>
-lea    0x10(%rsp),%rdx
-lea    0x20(%rbp),%r14
-mov    $0x32,%r12d
-mov    $0x2,%r15d
+and    0x3b0(%rsi),%rax
+mov    $0xffffffea,%ebp
+and    0x6ebb46(%rip),%rax        # 0xffffffff81912a78 <sgx_attributes_reserved_mask>
+jne    0xffffffff81227022 <sgx_encl_init+334>
+mov    0x384(%rsi),%eax
+and    0x388(%rsi),%eax
+and    0x6ebb26(%rip),%eax        # 0xffffffff81912a70 <sgx_misc_reserved_mask>
+jne    0xffffffff81227022 <sgx_encl_init+334>
+mov    0x3a8(%rsi),%rax
+and    0x3b8(%rsi),%rax
+and    0x5f920b(%rip),%rax        # 0xffffffff81820170 <sgx_xfrm_reserved_mask>
+jne    0xffffffff81227022 <sgx_encl_init+334>
 lea    0x80(%rsi),%rdi
+lea    0x10(%rsp),%rdx
 mov    $0x180,%esi
+mov    $0x32,%r12d
 call   0xffffffff81345271 <sha256>
-mov    %r14,%rdi
+lea    0x20(%r13),%rax
+mov    %rax,%rdi
+mov    %rax,(%rsp)
 call   0xffffffff81427ce9 <mutex_lock>
-mov    $0x14,%r13d
-mov    0x60(%rbp),%rdi
+mov    $0x14,%r15d
+mov    0x60(%r13),%rdi
 call   0xffffffff812262fc <sgx_get_epc_virt_addr>
-mov    %rax,0x8(%rsp)
+mov    %rax,%rbp
 lea    0x10(%rsp),%rdi
-call   0xffffffff812281fd <sgx_update_lepubkeyhash>
-mov    %r15d,%eax
-mov    (%rsp),%rdx
-mov    0x8(%rsp),%rcx
+call   0xffffffff812281fe <sgx_update_lepubkeyhash>
+mov    $0x2,%eax
+mov    0x8(%rsp),%rdx
+mov    %rbp,%rcx
 encls
+mov    %eax,%r14d
+mov    %eax,%ebp
 cmp    $0x80,%eax
-jne    0xffffffff81226ff3 <sgx_encl_init+287>
-dec    %r13d
-jne    0xffffffff81226f9e <sgx_encl_init+202>
+jne    0xffffffff81226ff4 <sgx_encl_init+288>
+dec    %r15d
+jne    0xffffffff81226f9d <sgx_encl_init+201>
 mov    $0x14,%edi
 call   0xffffffff8127e4b1 <msleep_interruptible>
-mov    %gs:0x6d9035(%rip),%rdi        # 0xffffffff81900018 <current_task>
+mov    %gs:0x6d9032(%rip),%rdi        # 0xffffffff81900018 <current_task>
 call   0xffffffff81226387 <signal_pending>
 test   %eax,%eax
-jne    0xffffffff81227009 <sgx_encl_init+309>
+jne    0xffffffff81227008 <sgx_encl_init+308>
 dec    %r12d
-jne    0xffffffff81226f98 <sgx_encl_init+196>
-jmp    0xffffffff81226ffd <sgx_encl_init+297>
-bt     $0x1e,%eax
-jb     0xffffffff81227010 <sgx_encl_init+316>
-test   %eax,%eax
-je     0xffffffff81227002 <sgx_encl_init+302>
-or     $0xffffffff,%eax
-jmp    0xffffffff81227015 <sgx_encl_init+321>
-lock orb $0x1,0x11(%rbp)
-jmp    0xffffffff81227015 <sgx_encl_init+321>
-mov    $0xfffffe00,%eax
-jmp    0xffffffff81227015 <sgx_encl_init+321>
-mov    $0xfffffffb,%eax
-mov    %r14,%rdi
-mov    %eax,(%rsp)
+jne    0xffffffff81226f97 <sgx_encl_init+195>
+bt     $0x1e,%r14d
+jb     0xffffffff8122700f <sgx_encl_init+315>
+test   %r14d,%r14d
+jne    0xffffffff81227016 <sgx_encl_init+322>
+lock orb $0x1,0x11(%r13)
+jmp    0xffffffff81227019 <sgx_encl_init+325>
+mov    $0xfffffe00,%ebp
+jmp    0xffffffff81227019 <sgx_encl_init+325>
+mov    $0xfffffffb,%ebp
+jmp    0xffffffff81227019 <sgx_encl_init+325>
+or     $0xffffffff,%ebp
+mov    (%rsp),%rdi
 call   0xffffffff81427360 <mutex_unlock>
-mov    (%rsp),%eax
 add    $0x30,%rsp
+mov    %ebp,%eax
 pop    %rbx
 pop    %rbp
 pop    %r12

It pretty much does what I said i.e., shuffles a new location for a code block.

BR, Jarkko
