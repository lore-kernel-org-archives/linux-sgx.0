Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A92475CE;
	Thu, 11 Dec 2025 20:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765483436; cv=none; b=Y+EUwKf8TiQlJX0DBOFlMKs9lX9YTC4cofIA8WTQoTg5YcSwfsGQl6WAEnAYn3q/CcH6LhWZDKpIp+Y0dc7TbZA72CP2W+Pfgmh0eyw0V4dQHG2qPqXnSg+1PvDvOe6HYWN4KFgrx4ZoyNvt9yMNNuu2XQv16xIWYEkXEotXOo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765483436; c=relaxed/simple;
	bh=F20lA+rQScR1xrx4upX0C3a5HksJ1gJQ1wu3s2YT06I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEJOoEug6uZbdfLWrBQyU+gmHi3JS6FrMwAitifptpOjj+ebIUO6OYS35pnIInIvV3iEFmlBcJ86v9r8OTqdv6khWbXNi9EWlkFnG9FLTwTwtFr9sHzoEInjnb6DZrKHZtp7ICsEfErQoWOFIphbqB+RwI1VOVPc42ihq8YPsTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nR1g/M1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nR1g/M1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F93C4CEF7;
	Thu, 11 Dec 2025 20:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765483436;
	bh=F20lA+rQScR1xrx4upX0C3a5HksJ1gJQ1wu3s2YT06I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nR1g/M1NmretcQ5/Ay2/pfOnXs5LuA3aA33tu6E0CH801CfIqqgWtdYAxZqmZByWa
	 VdPvtDUvWZe9n66mstXzQQKQ1cyhLcbFV53Rqz144ffh4zsQcfAXVQAzENtnbasfHC
	 x2mWHJrVKKCJccGmW5TTjhsS0zD56PyAn0UFDQN0EFZm42uZd6kktHpAkotiHW+aA/
	 fhCzpBU7X14VACdd2p1Ggpb4XB7rjNIXQ0oY63+8/oVjxOVbpnvFGFlGGNqMdZHrl4
	 9Pf6VAsOh1k5PqIlVIfqchjlsWjysG22VSY8NRrLtaQYHAAOisGsZnixv5Vr2wgiIE
	 WwQV+xvjVtLyA==
Date: Thu, 11 Dec 2025 22:03:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use goto to remove redundant if check in
 sgx_encl_init
Message-ID: <aTsjqDtWoIO_p60j@kernel.org>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
 <aTmSq5Px4P6vEUCb@kernel.org>
 <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>

On Wed, Dec 10, 2025 at 04:48:08PM +0100, Thorsten Blum wrote:
> On 10. Dec 2025, at 16:32, Jarkko Sakkinen wrote:
> > On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
> >> Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
> >> instead of checking for the same condition again in the outer loop.
> >> 
> >> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> >> ---
> >> [...]
> > 
> > I don't think moving code around is very useful.
> 
> The patch doesn't actually move any code around, but it removes up to 50
> (SGX_EINIT_SLEEP_COUNT) duplicate and therefore unnecessary if checks in
> the outer for loop.

Temporary change for generating disassembly:

❯ git diff
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 66f1efa16fbb..da43613eb837 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -464,8 +464,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
        return ret;
 }

-static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
-                        void *token)
+int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
+                 void *token)
 {
        u64 mrsigner[4];
        int i, j;


Then I A/B by doing

gdb -q -batch -ex 'set pagination off' -ex 'disassemble sgx_ioctl' .clangd/vmlinux > sgx_ioctl_a.txt
gdb -q -batch -ex 'set pagination off' -ex 'disassemble sgx_ioctl' .clangd/vmlinux > sgx_ioctl_b.txt

❯ diff -u sgx_ioctl_a.txt  sgx_ioctl_b.txt
--- sgx_ioctl_a.txt     2025-12-11 21:59:59.660197371 +0200
+++ sgx_ioctl_b.txt     2025-12-11 22:00:50.713917112 +0200
@@ -12,31 +12,31 @@
 mov    %rdx,0x20(%rsp)
 lock btsq $0x1,0x10(%rbx)
 mov    $0xfffffffffffffff0,%rax
-jb     0xffffffff812275ac <sgx_ioctl+1402>
+jb     0xffffffff812275ad <sgx_ioctl+1402>
 cmp    $0xc018a407,%esi
-je     0xffffffff812273ce <sgx_ioctl+924>
-ja     0xffffffff81227098 <sgx_ioctl+102>
+je     0xffffffff812273cf <sgx_ioctl+924>
+ja     0xffffffff81227099 <sgx_ioctl+102>
 cmp    $0x4008a402,%esi
-je     0xffffffff81227174 <sgx_ioctl+322>
+je     0xffffffff81227175 <sgx_ioctl+322>
 cmp    $0x4008a403,%esi
-je     0xffffffff81227253 <sgx_ioctl+545>
+je     0xffffffff81227254 <sgx_ioctl+545>
 cmp    $0x4008a400,%esi
-je     0xffffffff812270c6 <sgx_ioctl+148>
-jmp    0xffffffff812270bc <sgx_ioctl+138>
+je     0xffffffff812270c7 <sgx_ioctl+148>
+jmp    0xffffffff812270bd <sgx_ioctl+138>
 cmp    $0xc028a406,%esi
-je     0xffffffff8122732f <sgx_ioctl+765>
+je     0xffffffff81227330 <sgx_ioctl+765>
 cmp    $0xc030a401,%esi
-je     0xffffffff81227162 <sgx_ioctl+304>
+je     0xffffffff81227163 <sgx_ioctl+304>
 cmp    $0xc028a405,%esi
-je     0xffffffff81227298 <sgx_ioctl+614>
+je     0xffffffff81227299 <sgx_ioctl+614>
 mov    $0xfffffdfd,%eax
-jmp    0xffffffff812275a5 <sgx_ioctl+1395>
+jmp    0xffffffff812275a6 <sgx_ioctl+1395>
 xor    %esi,%esi
 mov    $0xffffffffffffffea,%rax
 mov    %rsi,0x40(%rsp)
 mov    0x10(%rbx),%rdx
 and    $0x10,%dl
-jne    0xffffffff812275a5 <sgx_ioctl+1395>
+jne    0xffffffff812275a6 <sgx_ioctl+1395>
 mov    0x20(%rsp),%rsi
 mov    $0x8,%edx
 lea    0x40(%rsp),%rdi
@@ -44,39 +44,39 @@
 mov    %rax,%rdx
 mov    $0xfffffffffffffff2,%rax
 test   %rdx,%rdx
-jne    0xffffffff812275a5 <sgx_ioctl+1395>
-mov    0x437ed1(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
+jne    0xffffffff812275a6 <sgx_ioctl+1395>
+mov    0x437ed0(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
 mov    $0x1000,%edx
 mov    $0xcc0,%esi
 call   0xffffffff812cdde9 <__kmalloc_cache_noprof>
 mov    %rax,%r13
 mov    $0xfffffffffffffff4,%rax
 test   %r13,%r13
-je     0xffffffff812275a5 <sgx_ioctl+1395>
+je     0xffffffff812275a6 <sgx_ioctl+1395>
 mov    0x40(%rsp),%rsi
 mov    $0x1000,%edx
 mov    %r13,%rdi
 mov    $0xfffffff2,%r12d
 call   0xffffffff8133b725 <_copy_from_user>
 test   %rax,%rax
-jne    0xffffffff81227243 <sgx_ioctl+529>
+jne    0xffffffff81227244 <sgx_ioctl+529>
 mov    %r13,%rsi
 mov    %rbx,%rdi
 call   0xffffffff812267da <sgx_encl_create>
-jmp    0xffffffff81227240 <sgx_ioctl+526>
+jmp    0xffffffff81227241 <sgx_ioctl+526>
 mov    0x20(%rsp),%rsi
 mov    %rbx,%rdi
 call   0xffffffff812269b2 <sgx_ioc_enclave_add_pages>
-jmp    0xffffffff812275a5 <sgx_ioctl+1395>
+jmp    0xffffffff812275a6 <sgx_ioctl+1395>
 xor    %ecx,%ecx
 mov    $0xffffffffffffffea,%rax
 mov    %rcx,0x40(%rsp)
 mov    0x10(%rbx),%rdx
 and    $0x10,%dl
-je     0xffffffff812275a5 <sgx_ioctl+1395>
+je     0xffffffff812275a6 <sgx_ioctl+1395>
 mov    0x10(%rbx),%rdx
 bt     $0x8,%edx
-jb     0xffffffff812275a5 <sgx_ioctl+1395>
+jb     0xffffffff812275a6 <sgx_ioctl+1395>
 mov    0x20(%rsp),%rsi
 mov    $0x8,%edx
 lea    0x40(%rsp),%rdi
@@ -84,15 +84,15 @@
 mov    %rax,%rdx
 mov    $0xfffffffffffffff2,%rax
 test   %rdx,%rdx
-jne    0xffffffff812275a5 <sgx_ioctl+1395>
-mov    0x437e15(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
+jne    0xffffffff812275a6 <sgx_ioctl+1395>
+mov    0x437e14(%rip),%rdi        # 0xffffffff8165efe0 <kmalloc_caches+96>
 mov    $0x1000,%edx
 mov    $0xcc0,%esi
 call   0xffffffff812cdde9 <__kmalloc_cache_noprof>
 mov    %rax,%r13
 mov    $0xfffffffffffffff4,%rax
 test   %r13,%r13
-je     0xffffffff812275a5 <sgx_ioctl+1395>
+je     0xffffffff812275a6 <sgx_ioctl+1395>
 lea    0x800(%r13),%r14
 xor    %eax,%eax
 mov    $0x4c,%ecx
@@ -104,13 +104,13 @@
 mov    0x40(%rsp),%rsi
 call   0xffffffff8133b725 <_copy_from_user>
 test   %rax,%rax
-jne    0xffffffff81227243 <sgx_ioctl+529>
+jne    0xffffffff81227244 <sgx_ioctl+529>
 mov    0x10(%r13),%eax
 test   %eax,%eax
-je     0xffffffff81227232 <sgx_ioctl+512>
+je     0xffffffff81227233 <sgx_ioctl+512>
 mov    $0xffffffea,%r12d
 cmp    $0x8086,%eax
-jne    0xffffffff81227243 <sgx_ioctl+529>
+jne    0xffffffff81227244 <sgx_ioctl+529>
 mov    %r14,%rdx
 mov    %r13,%rsi
 mov    %rbx,%rdi
@@ -119,7 +119,7 @@
 mov    %r13,%rdi
 call   0xffffffff812ce269 <kfree>
 movslq %r12d,%rax
-jmp    0xffffffff812275a5 <sgx_ioctl+1395>
+jmp    0xffffffff812275a6 <sgx_ioctl+1395>
 xor    %edx,%edx
 mov    0x20(%rsp),%rsi
 lea    0x40(%rsp),%rdi
@@ -129,12 +129,12 @@
 mov    %rax,%rdx
 mov    $0xfffffffffffffff2,%rax
 test   %rdx,%rdx
-jne    0xffffffff812275a5 <sgx_ioctl+1395>
+jne    0xffffffff812275a6 <sgx_ioctl+1395>
 mov    0x40(%rsp),%esi
 lea    0x80(%rbx),%rdi
-call   0xffffffff81228220 <sgx_set_attribute>
+call   0xffffffff81228221 <sgx_set_attribute>
 cltq
-jmp    0xffffffff812275a5 <sgx_ioctl+1395>
+jmp    0xffffffff812275a6 <sgx_ioctl+1395>
 lea    0x40(%rsp),%r13
 xor    %eax,%eax
 mov    $0xa,%ecx
@@ -144,32 +144,32 @@
 call   0xffffffff81226369 <sgx_ioc_sgx2_ready>
 movslq %eax,%r12
 test   %r12,%r12
-jne    0xffffffff812273c6 <sgx_ioctl+916>
+jne    0xffffffff812273c7 <sgx_ioctl+916>
 mov    0x20(%rsp),%rsi
 mov    $0x28,%edx
 mov    %r13,%rdi
 call   0xffffffff8133b725 <_copy_from_user>
 test   %rax,%rax
-jne    0xffffffff81227367 <sgx_ioctl+821>
+jne    0xffffffff81227368 <sgx_ioctl+821>
 mov    0x48(%rsp),%rdx
 mov    0x40(%rsp),%rsi
 mov    %rbx,%rdi
 mov    $0xffffffffffffffea,%r12
 call   0xffffffff81226339 <sgx_validate_offset_length>
 test   %eax,%eax
-jne    0xffffffff812273c6 <sgx_ioctl+916>
+jne    0xffffffff812273c7 <sgx_ioctl+916>
 mov    0x50(%rsp),%rax
 cmp    $0x7,%rax
-ja     0xffffffff812273c6 <sgx_ioctl+916>
+ja     0xffffffff812273c7 <sgx_ioctl+916>
 and    $0x3,%eax
 cmp    $0x2,%rax
-je     0xffffffff812273c6 <sgx_ioctl+916>
+je     0xffffffff812273c7 <sgx_ioctl+916>
 mov    0x58(%rsp),%rax
 or     0x60(%rsp),%rax
-jne    0xffffffff812273c6 <sgx_ioctl+916>
+jne    0xffffffff812273c7 <sgx_ioctl+916>
 mov    %r13,%rsi
 call   0xffffffff81226611 <sgx_enclave_restrict_permissions>
-jmp    0xffffffff812273ac <sgx_ioctl+890>
+jmp    0xffffffff812273ad <sgx_ioctl+890>
 lea    0x40(%rsp),%r13
 xor    %eax,%eax
 mov    $0xa,%ecx
@@ -179,27 +179,27 @@
 call   0xffffffff81226369 <sgx_ioc_sgx2_ready>
 movslq %eax,%r12
 test   %r12,%r12
-jne    0xffffffff812273c6 <sgx_ioctl+916>
+jne    0xffffffff812273c7 <sgx_ioctl+916>
 mov    0x20(%rsp),%rsi
 mov    $0x28,%edx
 mov    %r13,%rdi
 call   0xffffffff8133b725 <_copy_from_user>
 test   %rax,%rax
-je     0xffffffff81227370 <sgx_ioctl+830>
+je     0xffffffff81227371 <sgx_ioctl+830>
 mov    $0xfffffffffffffff2,%r12
-jmp    0xffffffff812273c6 <sgx_ioctl+916>
+jmp    0xffffffff812273c7 <sgx_ioctl+916>
 mov    0x48(%rsp),%rdx
 mov    0x40(%rsp),%rsi
 mov    %rbx,%rdi
 mov    $0xffffffffffffffea,%r12
 call   0xffffffff81226339 <sgx_validate_offset_length>
 test   %eax,%eax
-jne    0xffffffff812273c6 <sgx_ioctl+916>
+jne    0xffffffff812273c7 <sgx_ioctl+916>
 cmpq   $0xff,0x50(%rsp)
-ja     0xffffffff812273c6 <sgx_ioctl+916>
+ja     0xffffffff812273c7 <sgx_ioctl+916>
 mov    0x58(%rsp),%rax
 or     0x60(%rsp),%rax
-jne    0xffffffff812273c6 <sgx_ioctl+916>
+jne    0xffffffff812273c7 <sgx_ioctl+916>
 mov    %r13,%rsi
 call   0xffffffff81226413 <sgx_enclave_modify_types>
 mov    0x20(%rsp),%rdi
@@ -208,9 +208,9 @@
 mov    %rax,%r12
 call   0xffffffff8133b81f <_copy_to_user>
 test   %rax,%rax
-jne    0xffffffff81227367 <sgx_ioctl+821>
+jne    0xffffffff81227368 <sgx_ioctl+821>
 mov    %r12d,%eax
-jmp    0xffffffff812275a5 <sgx_ioctl+1395>
+jmp    0xffffffff812275a6 <sgx_ioctl+1395>
 lea    0x28(%rsp),%r15
 xor    %eax,%eax
 mov    $0x6,%ecx
@@ -220,15 +220,15 @@
 call   0xffffffff81226369 <sgx_ioc_sgx2_ready>
 movslq %eax,%r14
 test   %r14,%r14
-jne    0xffffffff812275a2 <sgx_ioctl+1392>
+jne    0xffffffff812275a3 <sgx_ioctl+1392>
 mov    0x20(%rsp),%rsi
 mov    $0x18,%edx
 mov    %r15,%rdi
 call   0xffffffff8133b725 <_copy_from_user>
 test   %rax,%rax
-je     0xffffffff81227416 <sgx_ioctl+996>
+je     0xffffffff81227417 <sgx_ioctl+996>
 mov    $0xfffffffffffffff2,%r14
-jmp    0xffffffff812275a2 <sgx_ioctl+1392>
+jmp    0xffffffff812275a3 <sgx_ioctl+1392>
 mov    0x30(%rsp),%rdx
 mov    0x28(%rsp),%rsi
 mov    %rbx,%rdi
@@ -236,10 +236,10 @@
 call   0xffffffff81226339 <sgx_validate_offset_length>
 mov    %eax,%r12d
 test   %eax,%eax
-jne    0xffffffff812275a2 <sgx_ioctl+1392>
+jne    0xffffffff812275a3 <sgx_ioctl+1392>
 mov    0x38(%rsp),%r13
 test   %r13,%r13
-jne    0xffffffff812275a2 <sgx_ioctl+1392>
+jne    0xffffffff812275a3 <sgx_ioctl+1392>
 lea    0x48(%rsp),%rdx
 mov    $0xe,%ecx
 mov    %rdx,%rdi
@@ -248,12 +248,12 @@
 movq   $0x7,0x40(%rsp)
 mov    %rax,0x18(%rsp)
 cmp    0x30(%rsp),%r13
-jae    0xffffffff8122757f <sgx_ioctl+1357>
+jae    0xffffffff81227580 <sgx_ioctl+1357>
 mov    0x28(%rsp),%rax
 add    (%rbx),%rax
 add    %r13,%rax
 mov    %rax,0x10(%rsp)
-call   0xffffffff81227e7c <sgx_reclaim_direct>
+call   0xffffffff81227e7d <sgx_reclaim_direct>
 mov    0x18(%rsp),%rdi
 call   0xffffffff81427ce9 <mutex_lock>
 mov    0x10(%rsp),%rsi
@@ -261,32 +261,32 @@
 call   0xffffffff81225b7e <sgx_encl_load_page>
 mov    %rax,%r14
 cmp    $0xfffffffffffff000,%rax
-jbe    0xffffffff812274c0 <sgx_ioctl+1166>
+jbe    0xffffffff812274c1 <sgx_ioctl+1166>
 xor    %r12d,%r12d
 cmp    $0xfffffffffffffff0,%rax
 sete   %r12b
 lea    -0xe(%r12,%r12,2),%r12d
-jmp    0xffffffff81227575 <sgx_ioctl+1347>
+jmp    0xffffffff81227576 <sgx_ioctl+1347>
 mov    0x8(%rax),%eax
 and    $0xffff00,%eax
 cmp    $0x400,%eax
-je     0xffffffff812274d8 <sgx_ioctl+1190>
+je     0xffffffff812274d9 <sgx_ioctl+1190>
 or     $0xffffffff,%r12d
-jmp    0xffffffff81227575 <sgx_ioctl+1347>
+jmp    0xffffffff81227576 <sgx_ioctl+1347>
 mov    0x10(%r14),%rdi
 call   0xffffffff812262fc <sgx_get_epc_virt_addr>
 mov    %rax,%rsi
 lea    0x40(%rsp),%rdi
 call   0xffffffff81226328 <__emodpr>
 bt     $0x1e,%eax
-jae    0xffffffff812274cf <sgx_ioctl+1181>
+jae    0xffffffff812274d0 <sgx_ioctl+1181>
 and    $0xbfffffff,%eax
 cmp    $0xe,%eax
-jne    0xffffffff812274cf <sgx_ioctl+1181>
+jne    0xffffffff812274d0 <sgx_ioctl+1181>
 mov    0x10(%r14),%rdi
-call   0xffffffff812279e0 <sgx_unmark_page_reclaimable>
+call   0xffffffff812279e1 <sgx_unmark_page_reclaimable>
 test   %eax,%eax
-jne    0xffffffff8122756f <sgx_ioctl+1341>
+jne    0xffffffff81227570 <sgx_ioctl+1341>
 mov    0x18(%rsp),%rdi
 add    $0x1000,%r13
 call   0xffffffff81427360 <mutex_unlock>
@@ -309,7 +309,7 @@
 call   0xffffffff812ce269 <kfree>
 mov    0x18(%rsp),%rdi
 call   0xffffffff81427360 <mutex_unlock>
-jmp    0xffffffff81227469 <sgx_ioctl+1079>
+jmp    0xffffffff8122746a <sgx_ioctl+1079>
 mov    $0xfffffff0,%r12d
 mov    0x18(%rsp),%rdi
 call   0xffffffff81427360 <mutex_unlock>
@@ -320,7 +320,7 @@
 mov    %r13,0x38(%rsp)
 call   0xffffffff8133b81f <_copy_to_user>
 test   %rax,%rax
-jne    0xffffffff8122740a <sgx_ioctl+984>
+jne    0xffffffff8122740b <sgx_ioctl+984>
 mov    %r14d,%eax
 lock andb $0xfd,0x10(%rbx)
 cltq

How would you interpret this?

> 
> Thanks,
> Thorsten
> 

BR, Jarkko
