Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8EBC433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Nov 2022 23:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiKOXYt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiKOXYh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Nov 2022 18:24:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98A927902
        for <linux-sgx@vger.kernel.org>; Tue, 15 Nov 2022 15:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E34CB81B79
        for <linux-sgx@vger.kernel.org>; Tue, 15 Nov 2022 23:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E13C433D6;
        Tue, 15 Nov 2022 23:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668554673;
        bh=WmwlsA58POfzzLH8XvPbktknvy1F6mfbqcONTHmLLT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AMH0TCW46Y+gpzGaIbQUytvmZkwHQl+ze/YI3EF7Hwo6VmlSxW+fq8lpT1WtahsdT
         vOi1nRrj40iL9KpwHWdNRwej8TS0rlfwuqLlnsvlsh5vrI6SbHjPkV9qF8vXDRcqQl
         4YQtDGWwpx1WO2fGTxO2YcvHpNdIJmyRK6K+KOSUL/2Qcq9X+Q/ZQFP6r+Qe7ANOjl
         fO66Ta2BZR6ajoKJS2LtxV8lzaj4a6m7zxRLrSgEsHqGdggwT+05TogPv2uh84sXc2
         yE+feA3xMUvMUbffTAV0hpTOSd+lH19+IkoyCHfLJG2wdRZIPlD4D/jy0LMSI0Snp6
         sVtRhHmyxNT8w==
Date:   Wed, 16 Nov 2022 01:24:29 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v3 3/4] selftests/sgx: add len field for EACCEPT op
Message-ID: <Y3QfrQFiWtOK3+c+@kernel.org>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
 <20221107220212.257422-4-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107220212.257422-4-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 07, 2022 at 02:02:11PM -0800, Haitao Huang wrote:
> So we can EACCEPT multiple pages inside enclave without EEXIT,
> preparing for testing with MADV_WILLNEED for ranges bigger than
> a single page.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  tools/testing/selftests/sgx/defines.h   |  1 +
>  tools/testing/selftests/sgx/test_encl.c | 20 ++++++++++++++------
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
> index d8587c971941..8578e773d3d8 100644
> --- a/tools/testing/selftests/sgx/defines.h
> +++ b/tools/testing/selftests/sgx/defines.h
> @@ -60,6 +60,7 @@ struct encl_op_eaccept {
>  	struct encl_op_header header;
>  	uint64_t epc_addr;
>  	uint64_t flags;
> +	uint64_t len;
>  	uint64_t ret;
>  };
>  
> diff --git a/tools/testing/selftests/sgx/test_encl.c b/tools/testing/selftests/sgx/test_encl.c
> index c0d6397295e3..fc797385200b 100644
> --- a/tools/testing/selftests/sgx/test_encl.c
> +++ b/tools/testing/selftests/sgx/test_encl.c
> @@ -35,14 +35,22 @@ static void do_encl_eaccept(void *_op)
>  	struct sgx_secinfo secinfo __aligned(sizeof(struct sgx_secinfo)) = {0};
>  	struct encl_op_eaccept *op = _op;
>  	int rax;

Should be empty line after declarations.

> +	if (op->len == 0)
> +		op->len = 4096;

What is this?

>  
>  	secinfo.flags = op->flags;
> -
> -	asm volatile(".byte 0x0f, 0x01, 0xd7"
> -				: "=a" (rax)
> -				: "a" (EACCEPT),
> -				  "b" (&secinfo),
> -				  "c" (op->epc_addr));
> +	for (uint64_t addr = op->epc_addr;
> +			addr < op->epc_addr + op->len; addr += 4096) {
> +		asm volatile(".byte 0x0f, 0x01, 0xd7"
> +					: "=a" (rax)
> +					: "a" (EACCEPT),
> +					  "b" (&secinfo),
> +					  "c" (addr));
> +		if (rax) {
> +			op->ret = rax;
> +			return;
> +		}
> +	}
>  
>  	op->ret = rax;
>  }
> -- 
> 2.25.1
> 

BR, Jarkko
