Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0DE1F8BC6
	for <linux-sgx@vger.kernel.org>; Tue,  4 Mar 2025 22:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741126053; cv=none; b=GbPajrcZJfUOFb6b1B1y6qhIgp28yIPr43EyW/fb7WiTqJI3Re4QQhX/R4sGOQKwD56WRNDQt/j66ZJZjQja3XCgVEKUfM3FeKzhp5G5fgBQlONZMgf5tag0LHeFJdEl2OSLVfIqNFQjh4Loek/q+N1zc1Vfwqvx5T5i3BqHFPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741126053; c=relaxed/simple;
	bh=YRMsJhn+O7vZoWLFZH9uHOoKEtptraxuPbXnTI/bCfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2Lv5NHKOH+K4GvfCvdHgg1Eu7em7RP60eRqT95LM5JQ8ScTozZOfeqXAlxOUNh/2iwZ5x+PFkEFc0aCBVMJUwkn7pEy3SGpy55i3TU92DIb50OUbUkHJTM2Ff4ok75GmyYj6cwfue1JSRn+/rrYjOqsaxjzllrK2dj1hKm4kTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAS9dXpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAS9dXpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCD9C4CEE5;
	Tue,  4 Mar 2025 22:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741126052;
	bh=YRMsJhn+O7vZoWLFZH9uHOoKEtptraxuPbXnTI/bCfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PAS9dXpxcx/ksQFD+jGzpxn3lW623xmPNl5d1qLPjgUSqMd3xxUhFRVsngc2KYcEf
	 6F7pNYlgcOezSjgNeZMVBqFyt7PLQH6ZUrzvuzCCttLqVzdcaV9Awa8tDnIAn4F6Ev
	 sMfg9y5OM/a8dkoYtTC/S0QTFC+M1rMHDGHMS9POWLb/oYZG3vGEk26rAR3d49rrR8
	 JhRGZt5oPZJsRJzI/gf5DCo9+yqu60A3cJhQ05J8zvs9119+yDAbdF1288I2mUTGAJ
	 QMxikdKl7vlzyM7pRAgaRPaR5mGwyb/EUmGpE4t77J2XFO18BxJVYn5hFNFC8tQ6Uv
	 jYMF1Es76HnxA==
Date: Wed, 5 Mar 2025 00:07:27 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-sgx@vger.kernel.org
Subject: Re: [bug report] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <Z8d5n9e4tBZo892q@kernel.org>
References: <c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain>

On Tue, Mar 04, 2025 at 04:05:45PM +0300, Dan Carpenter wrote:
> Hello Jarkko Sakkinen,

Hi Dan, thanks for the report, it is very well put together with all the
detail it has :-)

> 
> Commit 888d24911787 ("x86/sgx: Add SGX_IOC_ENCLAVE_CREATE") from Nov
> 13, 2020 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	arch/x86/kernel/cpu/sgx/ioctl.c:75 sgx_encl_create()
> 	warn: potential user controlled sizeof overflow 'secs->size + ((1) << 12)' '0-u64max + 4096'


What I tried:

1. Installed smatch package to Fedora.
2. Cloned git clone git://repo.or.cz/smatch.git

I get:

$ O=.clangd ~/work/staging/smatch/smatch_scripts/kchecker arch/x86/kernel/cpu/sgx/ioctl.c
make[1]: Entering directory '/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/.clangd'
  SYNC    include/config/auto.conf
  GEN     Makefile
  GEN     Makefile
  CHECK   ../scripts/mod/empty.c
  CALL    ../scripts/checksyscalls.sh
  DESCEND objtool
  INSTALL libsubcmd_headers
  CHECK   ../arch/x86/kernel/cpu/sgx/ioctl.c
make[7]: *** [../scripts/Makefile.build:208: arch/x86/kernel/cpu/sgx/ioctl.o] Error 139
make[6]: *** [../scripts/Makefile.build:465: arch/x86/kernel/cpu/sgx] Error 2
make[5]: *** [../scripts/Makefile.build:465: arch/x86/kernel/cpu] Error 2
make[4]: *** [../scripts/Makefile.build:465: arch/x86/kernel] Error 2
make[3]: *** [../scripts/Makefile.build:465: arch/x86] Error 2
make[2]: *** [/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/Makefile:1989: .] Error 2
make[1]: *** [/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/Makefile:251: __sub-make] Error 2
make[1]: Leaving directory '/home/jarkko/work/kernel.org/jarkko/linux-tpmdd/.clangd'
make: *** [Makefile:251: __sub-make] Error 2

Am I using smatch incorrectly? I'd just love to learn how to use it in
order to make sure that my fix will address the bug.

> 
> arch/x86/kernel/cpu/sgx/ioctl.c
>     57 static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>     58 {
>     59         struct sgx_epc_page *secs_epc;
>     60         struct sgx_va_page *va_page;
>     61         struct sgx_pageinfo pginfo;
>     62         struct sgx_secinfo secinfo;
>     63         unsigned long encl_size;
>     64         struct file *backing;
>     65         long ret;
>     66 
>     67         va_page = sgx_encl_grow(encl, true);
>     68         if (IS_ERR(va_page))
>     69                 return PTR_ERR(va_page);
>     70         else if (va_page)
>     71                 list_add(&va_page->list, &encl->va_pages);
>     72         /* else the tail page of the VA page list had free slots. */
>     73 
>     74         /* The extra page goes to SECS. */
> --> 75         encl_size = secs->size + PAGE_SIZE;
> 
> secs->size is a u64 that comes from the user in sgx_ioc_enclave_create().
> If we add PAGE_SIZE that could be an integer overflow.  Also encl_size is
> unsigned long so on 32 bits that's another integer overflow.

It's guaranteeed to be 64-bit given:

config X86_SGX
	bool "Software Guard eXtensions (SGX)"
	depends on X86_64 && CPU_SUP_INTEL && X86_X2APIC

That said, it would add clarity to explicitly declare encl_size as u64.

How it is now, is somewhat obfuscated, I give you that (but still not
incorrect).


> 
>     76 
>     77         backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
>                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Also this can integer overflow.


I drafted this quickly but I think we could probably fix this up by:

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b65ab214bdf5..551e65c94eb3 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -60,10 +60,20 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
        struct sgx_va_page *va_page;
        struct sgx_pageinfo pginfo;
        struct sgx_secinfo secinfo;
-       unsigned long encl_size;
+       u64 encl_size, pcmd_size;
        struct file *backing;
        long ret;

+       if ((u64)PAGE_SIZE > ~secs->size)
+               return -E2BIG;
+
+       /* The extra page is for SECS: */
+       encl_size = secs->size + PAGE_SIZE;
+       pcmd_size = encl_size >> 5;
+
+       if (pcmd_size > ~encl_size)
+               return -E2BIG;
+
        va_page = sgx_encl_grow(encl, true);
        if (IS_ERR(va_page))
                return PTR_ERR(va_page);
@@ -71,9 +81,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
                list_add(&va_page->list, &encl->va_pages);
        /* else the tail page of the VA page list had free slots. */

-       /* The extra page goes to SECS. */
-       encl_size = secs->size + PAGE_SIZE;
-
        backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
                                   VM_NORESERVE);
        if (IS_ERR(backing)) {

The gist here is that by inverting bits we check if the remaining space
in 64-bit number has enough space for the "extra fill"

BR, Jarkko
