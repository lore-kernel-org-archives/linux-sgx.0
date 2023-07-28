Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3989FC0015E
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jul 2023 19:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbjG1TCE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjG1TB6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jul 2023 15:01:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4453590;
        Fri, 28 Jul 2023 12:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9596B621DA;
        Fri, 28 Jul 2023 19:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FB2C433C7;
        Fri, 28 Jul 2023 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690570916;
        bh=BocxdpjOTctrYhzOJgbd0WsSHzA7A6LWsR6tM6zAEoY=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=AR3HsxxoKuh7xLqV60IfUmBKY2xRFuHR32tv/j2NERdhiIEyJM2wZJVKArHy6sDkx
         HNzhsyct27okQhQY14jrWM4kQKSjLGb5NyGBVw/wbtP4/uLW186ziugQS06JLo4eV9
         /XNFQYcy36358y8gKtZ4NS+YMCil9/SPS9x5HPcBt9ZNTjwAX1Ft9i7DeyeDXSTbXT
         hdC6aUyRaI98l+nHsTpx6PQobl+GMi1O9Q3z7lkggXnuKGhnQCXv9ro5mhw5OpuEfz
         /RG1Oxp48S1iUedl5VpYckBImiXw5/i6oYwltt6yRygVkfrYIIBqvrBGhDGupkBLzR
         kGZPjCQB+iCxQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 19:01:53 +0000
Message-Id: <CUE1DFU7H5CK.GDUK8X30CDWL@seitikki>
Subject: Re: [PATCH 0/5] selftests/sgx: Fix compilation errors.
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jo Van Bulck" <jo.vanbulck@cs.kuleuven.be>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc:     <dave.hansen@linux.intel.com>
X-Mailer: aerc 0.14.0
References: <20230724165832.15797-1-jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <20230724165832.15797-1-jo.vanbulck@cs.kuleuven.be>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon Jul 24, 2023 at 4:58 PM UTC, Jo Van Bulck wrote:
> Hi,
>
> This patch series ensures that all SGX selftests succeed when compiling
> with optimizations (as tested with -O{0,1,2,3,s} for both gcc 11.3.0 and
> clang 14.0.0). The aim of the patches is to avoid reliance on undefined,
> compiler-specific behavior that can make the test results fragile.
>
> If deemed useful, I can also include an elementary wrapper shell script t=
o
> compile and run the tests for different compilers (gcc/clang) and
> optimization levels.

Thank you, this sounds like an appropriate scope for the selftest.

I support also the idea of refining the selftest as a run-time, which
could perhaps consist of the following steps:

1. Create a repository of the self-compiling selftest with GPLv2. You
   could add also AUTHORS file for the initial content by crawling this
   data from the git log.
2. Create a commit with sob's from the required stakeholders, which
   changes the license to something more appropriate, and get the
   sob's with some process.

BR, Jarkko
