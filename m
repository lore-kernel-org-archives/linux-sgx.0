Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B37EEE49A3
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Aug 2023 10:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjHVKOP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Aug 2023 06:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjHVKOO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 22 Aug 2023 06:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88831B2;
        Tue, 22 Aug 2023 03:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77EAC6514A;
        Tue, 22 Aug 2023 10:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A00C433C8;
        Tue, 22 Aug 2023 10:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692699251;
        bh=PqdHrHoIJUKKi76bc5MopZSXWD7BLlEuyV79H/yi/l4=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=UfGhZKuiHLSEhNzyPafWMAQ3qsjJ4UcY2pmsUlFoSQYlPVo+Zv1lcJJ3XosTgm/T7
         m35r9VsD+NeY9+/NNnxIDtBKldgIEWC1jJOgsc2cnYGLMjUHNyJdiVl7qyjxGnsCPd
         ji3tFE/vBG6ydlHYCKbGT44rrko4Gct0UXqE+1K8M/lVZkjCg6IMyhWNx4Cev+XvWe
         T81AtEc4yP1qoccgaiBPJ30rUrW2RkYeiKfOqSf/1AgIRVNiOysR3M8NGA/47NloFx
         00fl1BcLF2/jzgFepMaPp4dzmNKDC5xVNoYWqB1mZpoblxfky/lPRzpls+5GJWEwPp
         KHC6ditaZX3CA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 22 Aug 2023 13:14:09 +0300
Message-Id: <CUYZSZWSDUHC.2QB1Z9GD76HF6@suppilovahvero>
Cc:     <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 9/9] selftests/sgx: Specify freestanding environment
 for enclave compilation
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jo Van Bulck" <jo.vanbulck@cs.kuleuven.be>, <kai.huang@intel.com>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.14.0
References: <20230819094332.8535-1-jo.vanbulck@cs.kuleuven.be>
 <20230819094332.8535-10-jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <20230819094332.8535-10-jo.vanbulck@cs.kuleuven.be>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat Aug 19, 2023 at 12:43 PM EEST, Jo Van Bulck wrote:
> Use -ffreestanding to assert the enclave compilation targets a
> freestanding environment (i.e., without "main" or standard libraries).
> This fixes clang reporting "undefined reference to `memset'" after
> erroneously optimizing away the provided memset/memcpy implementations.
>
> Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> ---
>  tools/testing/selftests/sgx/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftes=
ts/sgx/Makefile
> index 2de970f72..19a07e890 100644
> --- a/tools/testing/selftests/sgx/Makefile
> +++ b/tools/testing/selftests/sgx/Makefile
> @@ -14,8 +14,8 @@ endif
>  INCLUDES :=3D -I$(top_srcdir)/tools/include
>  HOST_CFLAGS :=3D -Wall -Werror -g $(INCLUDES) -fPIC
>  HOST_LDFLAGS :=3D -z noexecstack -lcrypto
> -ENCL_CFLAGS :=3D -Wall -Werror -static-pie -nostdlib -nostartfiles -fPIE=
 \
> -	       -fno-stack-protector -mrdrnd $(INCLUDES)
> +ENCL_CFLAGS :=3D -Wall -Werror -static-pie -nostdlib -ffreestanding -fPI=
E \
> +		-nostartfiles -fno-stack-protector -mrdrnd $(INCLUDES)
>  ENCL_LDFLAGS :=3D -Wl,-T,test_encl.lds,--build-id=3Dnone
> =20
>  TEST_CUSTOM_PROGS :=3D $(OUTPUT)/test_sgx
> --=20
> 2.25.1

Do you still need nostdfiles and nostartfiles with freestanding?

BR, Jarkko
