Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F263ECAAA1
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Sep 2022 23:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiIEXyh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Sep 2022 19:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiIEXyd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 5 Sep 2022 19:54:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFFFCC4
        for <linux-sgx@vger.kernel.org>; Mon,  5 Sep 2022 16:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B97B8076D
        for <linux-sgx@vger.kernel.org>; Mon,  5 Sep 2022 23:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A34C433D6;
        Mon,  5 Sep 2022 23:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662422064;
        bh=zT4cg7b/7KpTIjlcPwnRmYTEKbV1dJ0m6P7NGtCdgXM=;
        h=From:To:Cc:Subject:Date:From;
        b=Dhf8D3saK0nDuZruwbX4MGKGQXFD2EMmudIW4ATm31NQzusB/B8b6Dt72b7QAS5yv
         UPoHohbwtqnUPu427+wQFdUGcbPiu637epyZ6tiwiGeMuPjtchGTUloF1BgSL/fxsW
         S//rvg+TXyMAdNtceMUelYipLEhiyrV+cBhIngS7Jkws6Sv8NNghYNl0dqfmDaq5Kk
         Ik4pPE1VgwNKef0BgCkVR4dJZ8Oiz14Vi2f1j4HQVf+KTB88duaMD1v36Blt7yp4G5
         ERzM9gnDjC3b+3TiH309fMwlFR74zdcf0GvO4UaFA8CqHbooxlslIXluuDoeo6CI77
         moe+ZRp8rGPnQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH v2 0/2] x86/sgx: Critical fixes for v6.0
Date:   Tue,  6 Sep 2022 02:54:13 +0300
Message-Id: <20220905235415.9519-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Two critical fixes for v6.0.

Haitao Huang (1):
  x86/sgx: Handle VA page allocation failure for EAUG on PF.

Jarkko Sakkinen (1):
  x86/sgx: Do not fail on incomplete sanitization on premature stop of
    ksgxd

 arch/x86/kernel/cpu/sgx/encl.c |  5 ++++-
 arch/x86/kernel/cpu/sgx/main.c | 17 +++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.37.2

