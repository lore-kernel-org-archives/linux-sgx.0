Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E7728506F;
	Wed, 22 Jul 2026 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734440; cv=none; b=XPLCELlCJniVEvVjaF7qpnlFr1/z+VNGZsse4b6BB0IlC6rc0NDTeTYwipDfmBG6b5H5Uco9P1xmMdgrzRiLKs6i4FF0saMvBgj6cGOKWvsIkQElCujsEp4bB4iEjOeRKkmBkeQaYduEtCV6EWCzJ4t3zo0Y6qx9M9gTkoEvXKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734440; c=relaxed/simple;
	bh=nla4lZOkz0K8docKS3gwf8y4KNGw6LgqCo+mig39snM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TArwB/LEs2h9ux7+ZT8IOcKna8r4LwwZK9PTITv8MwrRMqW3oxQs+v9T9AK+68f6jvvP5FrDTxaOCxCFzu3PMPfH8tRwHKp6uFpBN/oWZb5SWaqi8DDe8Kae/R0f60paUEr1RJ4VTOwG501nYqxvypEWsjOaDBBh4M3XyqGv444=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpR/YhcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpR/YhcH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EF8F41F000E9;
	Wed, 22 Jul 2026 15:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784734438;
	bh=ni/BtuFNyNg+zphtNkAfxoao4TTaub7J8gmU6BFLLu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JpR/YhcHn5RbJ1mfUKVKhlJJhrPPJH1CUkMsp1qwj7Yw/K4J4NC5Bf9fFmNUTpLBd
	 /O7Be9/1M/BduXAlP2ybwFix8sF+ASCyuq46R7UD6jEczIAZ7shH7IcN3MthK9yBCx
	 DF0x6S2Eu458/ez3GQTm9IG4XOGi/hSAEvZA+e3Ex8EvQQW4bEpnv7hnNCitCPbLAK
	 8DBFLWnQx+FOR9y2YpYRhibeIWg5ksFGaxK113dxXO9uyNSCL/DIVPeIpUKs90XwNP
	 EYyfci/gndc7yyCn32N7y0jc9y4ApuiAoOxGXTEFYoJa4dXw3/abu4dbCdXmONS8/t
	 E6714T3F3r4TA==
Date: Wed, 22 Jul 2026 18:33:55 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: dave.hansen@linux.intel.com, shuah@kernel.org,
	linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/sgx: use MAP_FAILED for mmap error check
Message-ID: <amDi4-eN3zGXExOy@kernel.org>
References: <20260720025443.506-1-yanlonglong@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720025443.506-1-yanlonglong@kylinos.cn>

On Mon, Jul 20, 2026 at 10:54:43AM +0800, longlong yan wrote:
> Replace the direct comparison with (void *)-1 with the standard
> MAP_FAILED macro when checking mmap()
> 
> Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
> ---
>  tools/testing/selftests/sgx/load.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
> index c9f658e44de6..6204ab0bae19 100644
> --- a/tools/testing/selftests/sgx/load.c
> +++ b/tools/testing/selftests/sgx/load.c
> @@ -202,7 +202,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
>  	}
>  
>  	ptr = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, fd, 0);
> -	if (ptr == (void *)-1) {
> +	if (ptr == MAP_FAILED) {
>  		perror("mmap for read");
>  		goto err;
>  	}
> @@ -215,7 +215,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
>  " If so, remount it executable: mount -o remount,exec /dev\n\n"
>  
>  	ptr = mmap(NULL, PAGE_SIZE, PROT_EXEC, MAP_SHARED, fd, 0);
> -	if (ptr == (void *)-1) {
> +	if (ptr == MAP_FAILED) {
>  		fprintf(stderr, ERR_MSG);
>  		goto err;
>  	}
> -- 
> 2.43.0
> 

Yeah, why not:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

It does document test cases better.

BR, Jarkko
