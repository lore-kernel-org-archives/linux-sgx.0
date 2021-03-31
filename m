Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE4DC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 02:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64DD0619D7
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 02:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCaC4c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Mar 2021 22:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233340AbhCaC4V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 30 Mar 2021 22:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C159619D8;
        Wed, 31 Mar 2021 02:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617159380;
        bh=u773bDbsKRyPswjZDFIZbgSjt0NBivr0gD8iiCtpke0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=atRZlUClz2KWQhd2L7kr8ViPVzNOyxB7TFuVTEz33kBF3GObAwPE4tSucGLgYpMEJ
         dgFTw4zsx3RclH0+S5IkneNsawvFPqtZOTb+UCJrXY2KuhSenPdW6/4PaP8+bXhljE
         qmHRzfaGB863IsXwKCHmw6V8gVidqRLKgx5Cus5PXItXhrKzmyUi75s3sQ/tmFriIU
         R7h2fd+cjKBYsCxWHgXzHW4EqO94ZOwgfPU6xHOxkjF7Gtk8pOiEJCKT1v6EonieAW
         vUM2+KQsdJnLgVklRQXB6Yhs0z5O1WqHW5833hY2Mp7HmqTvngobWS5tBelHCXQ8t5
         J/4Z5dspEhXiA==
Date:   Wed, 31 Mar 2021 05:56:18 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Aditya Srivastava <yashsri421@gmail.com>
Cc:     linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com,
        rdunlap@infradead.org, dave.hansen@linux.intel.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-sgx@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: fix incorrect kernel-doc comment syntax in files
Message-ID: <YGPk0h8OikOdRnyb@kernel.org>
References: <20210330211813.28030-1-yashsri421@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330211813.28030-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 31, 2021 at 02:48:13AM +0530, Aditya Srivastava wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> There are certain files in arch/x86/kernel/cpu/sgx, which follow this
> syntax, but the content inside does not comply with kernel-doc.
> Such lines were probably not meant for kernel-doc parsing, but are parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc.
> 
> E.g., presence of kernel-doc like comment in the header lines for
> arch/x86/kernel/cpu/sgx/encl.h causes this warning:
> "warning: expecting prototype for 2016(). Prototype was for _X86_ENCL_H() instead"
> 
> Similarly for arch/x86/kernel/cpu/sgx/arch.h too.
> 
> Provide a simple fix by replacing these occurrences with general comment
> format, i.e. '/*', to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
> ---
> * Applies perfectly on next-20210326
> 
>  arch/x86/kernel/cpu/sgx/arch.h | 2 +-
>  arch/x86/kernel/cpu/sgx/encl.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
> index 26315bea1cb4..70b84bbdaa1d 100644
> --- a/arch/x86/kernel/cpu/sgx/arch.h
> +++ b/arch/x86/kernel/cpu/sgx/arch.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/**
> +/*
>   * Copyright(c) 2016-20 Intel Corporation.
>   *
>   * Contains data structures defined by the SGX architecture.  Data structures
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index d8d30ccbef4c..76b9bc1c5c30 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/**
> +/*
>   * Copyright(c) 2016-20 Intel Corporation.
>   *
>   * Contains the software defined data structures for enclaves.
> -- 
> 2.17.1
> 
> 

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
