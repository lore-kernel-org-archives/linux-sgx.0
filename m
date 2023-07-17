Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC6CC001B0
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jul 2023 13:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjGQNP3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jul 2023 09:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjGQNPZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Jul 2023 09:15:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BF9C7;
        Mon, 17 Jul 2023 06:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2936D61057;
        Mon, 17 Jul 2023 13:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A23C433C8;
        Mon, 17 Jul 2023 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689599723;
        bh=TPoLuNdok8xu469zt+gJUA+72duNsVIwHpKBEXyRj8U=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=eNDT/Gt2Zpla10k8gy1Fza+XuWfpc4fT2vL05ThKyjAfvKHwVhd2drBHf1OFuwNtS
         5kKARQIlTXZan+yWS97J8FbrysJ9uQC2SbPYeuE75MdNvX1SNSIxI2EkCvZx4uuK1u
         fU971SaXjOc9j5/tJFQ2ILNJu5GLfdWeOJMEFdzlV1ciUoTrPWH9k8ppua1iWbrR3b
         G1eifQQo1TKw4xPoeEkBDfluI37QQ3tmta+cjCBzS15mchxYAqUDklyIgr5TPXzRq6
         AcsberFs9b0a+0HS/80l0sZ8YSRfjOHsHJD8Br1KbXQ20hvl7AA/bFUAU0qUOoxrL9
         VuDThiaCVZgMQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 17 Jul 2023 13:15:19 +0000
Message-Id: <CU4H43P3H35X.1BCA3CE4D1250@seitikki>
Subject: Re: [PATCH v3 18/28] cgroup/misc: Fix an overflow
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Haitao Huang" <haitao.huang@linux.intel.com>,
        <dave.hansen@linux.intel.com>, <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
        <cgroups@vger.kernel.org>, "Zefan Li" <lizefan.x@bytedance.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>
Cc:     <kai.huang@intel.com>, <reinette.chatre@intel.com>,
        <zhiquan1.li@intel.com>, <kristen@linux.intel.com>
X-Mailer: aerc 0.14.0
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-19-haitao.huang@linux.intel.com>
In-Reply-To: <20230712230202.47929-19-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> Overflow may happen in misc_cg_try_charge if new_usage becomes above
> INT_MAX, for example, on platforms with large SGX EPC sizes.
>
> Change type of new_usage to long from int and check overflow.
>
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>

As are bug fixes, this is also precursory work that SGX cgroups patches
should build on top of. Therefore, it should be in the very beginning,
right after any possible bug fixes to the existing code.

BR, Jarkko


