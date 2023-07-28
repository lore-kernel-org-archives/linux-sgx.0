Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CD5C001DF
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jul 2023 19:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjG1TTu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjG1TTt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jul 2023 15:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4859419A1;
        Fri, 28 Jul 2023 12:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDC1E621CB;
        Fri, 28 Jul 2023 19:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A23C433C7;
        Fri, 28 Jul 2023 19:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690571988;
        bh=uWFztMgBxG65hlImxfGxGJjF4fSQ6YnFgXweqGvJtFg=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=T1Bf2YYZXL5v+aM5MDe5nEzj+r+UC/tsWSCTNdJTqlQpOCPG21M2iyOOIW2jPhKnz
         CI5khZdMutrebRqR0zFIlzU0+Ob9J+rtUD1AY5Jiw6bd/BuJO/8BNUERC/75kGzRH8
         jwbKSOhI5oDPMsBNBtfUUcU6RKFdSNeiv7w8AGx7NNHowZrtQWUb6xFIvxB6BYXx1f
         vMwqAs19naT4YG1t0qxayZlaq/WPK+NO+WaccnJJaj8wtridpVbx951QzWrwWA8ueW
         JFd2LD+4SK4SJguv9ze5SKHRXFR6B5bq3tLS62YiT9LmLL+jL9T8ejcXyhdYwOA9Od
         BNRGlE4aS1zxg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Jul 2023 19:19:45 +0000
Message-Id: <CUE1R4HRQ599.1BX4CEIPSDWRW@seitikki>
Cc:     <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 4/5] selftests/sgx: Ensure expected enclave data buffer
 size and placement.
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jo Van Bulck" <jo.vanbulck@cs.kuleuven.be>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.14.0
References: <20230724165832.15797-1-jo.vanbulck@cs.kuleuven.be>
 <20230724165832.15797-5-jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <20230724165832.15797-5-jo.vanbulck@cs.kuleuven.be>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon Jul 24, 2023 at 4:58 PM UTC, Jo Van Bulck wrote:
> Do not declare the enclave data buffer static to ensure it is not optimiz=
ed
                                         ~~~~~~
					 as static

/enclave data buffer/encl_buffer/

> away by the compiler, even when not used entirely by the test enclave cod=
e.

"Declare encl_buffer as global, in order to ensure that it is not
optimized away by the compiler."

So, when exactly is it optimized away by the compiler? This is missing.

BR, Jarkko
