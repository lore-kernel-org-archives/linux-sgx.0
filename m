Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2934BC433EF
	for <linux-sgx@archiver.kernel.org>; Sun, 15 May 2022 01:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiEOBSr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 May 2022 21:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiEOBSq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 14 May 2022 21:18:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E76F25
        for <linux-sgx@vger.kernel.org>; Sat, 14 May 2022 18:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FACD60DB5
        for <linux-sgx@vger.kernel.org>; Sun, 15 May 2022 01:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09A7C340EE;
        Sun, 15 May 2022 01:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652577523;
        bh=L4nvGY6IpBFGjol7f2Ai2nLUCQf5dbe0dER126wYupE=;
        h=Subject:From:To:Cc:Date:From;
        b=AwtArX2M8DruExz4SsuHQjLbfoSsO/a0VVcWfij3gRTdu4XJVg1hHLtrOzjFrrnUB
         w8RPqIstRZpMisvCIoGBNbSYk7MA8KnzaWY2+V8nQn23lD6nIyf4lWfZgSUG4sGSaz
         UtGl1Y+9262jWciqkjH6hoE1FhI5NJ0u22SuFHznKyhqdUAttMcnRws6QglnGwcW/g
         wqhAbYYOyfoPFaqWuIUO4TFojrxNTq1qXiG+eUok9d3l9XZNHYs3nOLTQviL130I1y
         6s58zlzW8jFb7BILke5YWGBvGJpgbn3OKEWqawKQHwDL6Zx+XfyXVMgxHg1B8I35Ta
         ii/MRejXHSzkQ==
Message-ID: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
Subject: VMA's not getting merged
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        reinette.chatre@intel.com
Date:   Sun, 15 May 2022 04:20:22 +0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Looks like VMA's do not get merged properly:

7f8f00000000-7f8f00009000 r--s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f00009000-7f8f00034000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f00034000-7f8f000ff000 r-xs 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f000ff000-7f8f00201000 ---p 00000000 00:00 0=20
7f8f00201000-7f8f003fc000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f003fc000-7f8f003fd000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f003fd000-7f8f00400000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f00400000-7f8f00643000 r--s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f00643000-7f8f0197b000 r-xs 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0197b000-7f8f01bab000 r--s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f01bab000-7f8f01fa7000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f01fa7000-7f8f08000000 ---p 00000000 00:00 0=20
7f8f08000000-7f8f08001000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08001000-7f8f08003000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08003000-7f8f08006000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08006000-7f8f0800b000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0800b000-7f8f08014000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08014000-7f8f08025000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08025000-7f8f08046000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08046000-7f8f0804a000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0804a000-7f8f0804b000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0804b000-7f8f0804c000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0804c000-7f8f0804d000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0804d000-7f8f0804e000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0804e000-7f8f0804f000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0804f000-7f8f08050000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08050000-7f8f08051000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08051000-7f8f08052000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08052000-7f8f08053000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08053000-7f8f08054000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08054000-7f8f08055000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08055000-7f8f08056000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08056000-7f8f08057000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08057000-7f8f08058000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08058000-7f8f08059000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08059000-7f8f0805a000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0805a000-7f8f0805b000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0805b000-7f8f0805c000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0805c000-7f8f0805d000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0805d000-7f8f0805e000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0805e000-7f8f0805f000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0805f000-7f8f08060000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08060000-7f8f08062000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08062000-7f8f08063000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08063000-7f8f08064000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08064000-7f8f08065000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08065000-7f8f08066000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08066000-7f8f08067000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08067000-7f8f08068000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08068000-7f8f08069000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08069000-7f8f0806a000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0806a000-7f8f0806b000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0806b000-7f8f0806c000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0806c000-7f8f0806d000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0806d000-7f8f0806e000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0806e000-7f8f0806f000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0806f000-7f8f08070000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08070000-7f8f08071000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08071000-7f8f08072000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08072000-7f8f08081000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08081000-7f8f08082000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08082000-7f8f08083000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08083000-7f8f08084000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08084000-7f8f08085000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08085000-7f8f08086000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08086000-7f8f08087000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08087000-7f8f08088000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08088000-7f8f08089000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08089000-7f8f0808a000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0808a000-7f8f0808b000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0808b000-7f8f0809a000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0809a000-7f8f0809c000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0809c000-7f8f0809d000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0809d000-7f8f0809e000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0809e000-7f8f080a0000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080a0000-7f8f080a3000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080a3000-7f8f080a9000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080a9000-7f8f080b5000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080b5000-7f8f080c0000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080c0000-7f8f080c6000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080c6000-7f8f080d1000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080d1000-7f8f080dd000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080dd000-7f8f080f4000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f080f4000-7f8f08121000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08121000-7f8f0814a000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f0814a000-7f8f08162000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08162000-7f8f08177000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08177000-7f8f081a0000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f081a0000-7f8f081c1000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f081c1000-7f8f081d6000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f081d6000-7f8f081ff000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f081ff000-7f8f08228000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave
7f8f08228000-7f8ffffff000 ---p 00000000 00:00 0=20
7f8ffffff000-7f9000000000 rw-s 00000000 00:05 84                         /d=
ev/sgx_enclave

BR, Jarkko
