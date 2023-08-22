Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699B3EE4996
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Aug 2023 10:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbjHVKJ2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Aug 2023 06:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjHVKJ2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 22 Aug 2023 06:09:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A2018B;
        Tue, 22 Aug 2023 03:09:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDFC6162C;
        Tue, 22 Aug 2023 10:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F38CC433C8;
        Tue, 22 Aug 2023 10:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692698965;
        bh=CZDcapZMT6KJZ2xTcpV5wlhRFiE1a2rJHijUp7yyqtc=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=SCoSR3q4YigFszhIOZhnU6QugKeiGp5yxoh5i/Uma8Tp2su4Yto6tEO/faITsVBl7
         UEEqG6HwNqk7cWp8XtNtvt3Jv37XYyZ7n7c0lR1EAOrlGh5aG5tt5w6TEfEkP+uc/1
         Gwqvab7RWYFuRkBr4u8vcW279y7R4nTlB6BG+tjALZ+n3fG7dq943NQyzlXpu+suIX
         ku5o2bf0jSX+eHAbbDEzyyE4gJJhqepeQiSKU2e4dzqUPGL8CqxExilfk+Mdc7ujmx
         0eej6xkaHKalhPGHvdsI9p23EmtxRb6T10pRsqRgmLvREETndzPvsaRplyuhCRXQjK
         5+P7VOZUSZX2Q==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 22 Aug 2023 13:09:22 +0300
Message-Id: <CUYZPCDTQSRR.32LXC3ILC7JM5@suppilovahvero>
Cc:     <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 4/9] selftests/sgx: Fix linker script asserts
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jo Van Bulck" <jo.vanbulck@cs.kuleuven.be>, <kai.huang@intel.com>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.14.0
References: <20230819094332.8535-1-jo.vanbulck@cs.kuleuven.be>
 <20230819094332.8535-5-jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <20230819094332.8535-5-jo.vanbulck@cs.kuleuven.be>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat Aug 19, 2023 at 12:43 PM EEST, Jo Van Bulck wrote:
> DEFINED only considers symbols, not section names. Hence, replace the
> check for .got.plt with the _GLOBAL_OFFSET_TABLE_ symbol and remove other
> (non-essential) asserts.
>
> Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> ---
>  tools/testing/selftests/sgx/test_encl.lds | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/sgx/test_encl.lds b/tools/testing/se=
lftests/sgx/test_encl.lds
> index b86c86060..13144b045 100644
> --- a/tools/testing/selftests/sgx/test_encl.lds
> +++ b/tools/testing/selftests/sgx/test_encl.lds
> @@ -37,8 +37,4 @@ SECTIONS
>  	}
>  }
> =20
> -ASSERT(!DEFINED(.altinstructions), "ALTERNATIVES are not supported in en=
claves")
> -ASSERT(!DEFINED(.altinstr_replacement), "ALTERNATIVES are not supported =
in enclaves")
> -ASSERT(!DEFINED(.discard.retpoline_safe), "RETPOLINE ALTERNATIVES are no=
t supported in enclaves")
> -ASSERT(!DEFINED(.discard.nospec), "RETPOLINE ALTERNATIVES are not suppor=
ted in enclaves")
> -ASSERT(!DEFINED(.got.plt), "Libcalls are not supported in enclaves")
> +ASSERT(!DEFINED(_GLOBAL_OFFSET_TABLE_), "Libcalls through GOT are not su=
pported in enclaves")
> --=20
> 2.25.1

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
