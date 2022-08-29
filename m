Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CB4ECAAD4
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Aug 2022 12:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiH2Mcg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Aug 2022 08:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiH2McG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Aug 2022 08:32:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A3A8C036;
        Mon, 29 Aug 2022 05:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F4961199;
        Mon, 29 Aug 2022 12:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB2C433D7;
        Mon, 29 Aug 2022 12:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661775338;
        bh=7Urql1E5XDxhVb8MTBNbpYyK+YMAUNovIVIRoaYnK5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ovf4b4rrY7jDp4P2Fo6D6lw72zZM8qV/FkZnvS3c+EPLkH6Upxl2k3Boaw1OGZafX
         oSevbWijQv4eAHsPzvMT2Wv0FuxY7r0Yz+l+lVDBezjhxHaAwkNBbHQZVmrnDXcxmA
         JOGqm//Y8feSgrrSeSmeYLfm0CxTOX5xR7OhV5xG7Z8677Xdhj4IaWXACwK4HlT3Nz
         SmdGf1lOzr7egQD9EZzXJi9U+yzxGJdky6e6VgPKRI3LfuXnbpM+PvdGKXD33Q/EAT
         jwBJQOAEaQwrR7/pF8sKN/9GOeSjtJITK7+rrKfm5oV9T7rNcvEWL2/D9jGYtwtQy2
         e97CBc2s57N1g==
Date:   Mon, 29 Aug 2022 15:15:30 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dhanuka Warusadura <wdnuka@gmail.com>
Cc:     dave.hansen@linux.intel.com, shuah@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/sgx: Fix OpenSSL deprecated warning for
 ERR_get_error_line
Message-ID: <Ywyt4tvHrK4r48RK@kernel.org>
References: <20220828061859.181061-1-wdnuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220828061859.181061-1-wdnuka@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Aug 28, 2022 at 11:48:59AM +0530, Dhanuka Warusadura wrote:
> These changes fix the "error: ‘ERR_get_error_line’ is deprecated:
> Since OpenSSL 3.0" warning.
> 
> Signed-off-by: Dhanuka Warusadura <wdnuka@gmail.com>
> ---
>  tools/testing/selftests/sgx/sigstruct.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
> index 50c5ab1aa6fa..671d9b58e274 100644
> --- a/tools/testing/selftests/sgx/sigstruct.c
> +++ b/tools/testing/selftests/sgx/sigstruct.c
> @@ -136,7 +136,7 @@ static bool check_crypto_errors(void)
>  			break;
>  
>  		had_errors = true;
> -		err = ERR_get_error_line(&filename, &line);
> +		err = ERR_peek_last_error_line(&filename, &line);
>  		ERR_error_string_n(err, str, sizeof(str));
>  		fprintf(stderr, "crypto: %s: %s:%d\n", str, filename, line);
>  	}
> -- 
> 2.37.2
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
