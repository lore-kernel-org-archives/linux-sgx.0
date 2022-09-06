Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88FCECAAD3
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Sep 2022 00:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiIFACb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Sep 2022 20:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiIFAC3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 5 Sep 2022 20:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB1C67455
        for <linux-sgx@vger.kernel.org>; Mon,  5 Sep 2022 17:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69BED60BED
        for <linux-sgx@vger.kernel.org>; Tue,  6 Sep 2022 00:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758ACC433D6;
        Tue,  6 Sep 2022 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662422547;
        bh=qHW3mYfqxaRh80U9jBmuBOToZgC4wZeKAjwGXClBfQM=;
        h=From:To:Cc:Subject:Date:From;
        b=BpN1cvf9dusXCuk2mFRne61OZsevQmAPkr5LuAAl2mrjMikjRRpJolot9vNsrSB1D
         kJYg1sOpyVAjmcrV2dE5t/kT3081jFRAiiIgrMHxYTa0E8l4806JAV1iuvAYmrGWLG
         UgPthwlinNccAJgc1erfoeLmja8Xf6YoalaSwZAnJtUVv7uBQ0OfMK9LyN3guR8+Xh
         SFt5z/Xr37lH+Ulj49nyjNkxeX9xZGfm6Q0DA7iioS9T6sUHBOzZdt2FPQf4uU3qgx
         mQ+FkUQNq8kgfSDJ1R1gLSrjRWdvoQaxZpFybJWi1aKAqopK5lXYLnF1JYNBVZky1L
         BXDwi8bf7zOYg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH v3 0/2] Critical fixes for v6.0
Date:   Tue,  6 Sep 2022 03:02:19 +0300
Message-Id: <20220906000221.34286-1-jarkko@kernel.org>
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
 arch/x86/kernel/cpu/sgx/main.c | 15 +++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.37.2

