Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B80ECAAD5
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Sep 2022 02:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiIECE3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Sep 2022 22:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiIECE2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 4 Sep 2022 22:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9D025EA
        for <linux-sgx@vger.kernel.org>; Sun,  4 Sep 2022 19:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC5DB61074
        for <linux-sgx@vger.kernel.org>; Mon,  5 Sep 2022 02:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A1CC433D6;
        Mon,  5 Sep 2022 02:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662343466;
        bh=Z2LnxgWUQgzlgQWTcCVKj5gxPqHgm8x634UfmLQszQk=;
        h=From:To:Cc:Subject:Date:From;
        b=S4k0YmsLb2Q2VRk7tCeQAtnhaWeIkfTydo/6L8R2AVX4mLMcjtnyAE8ioIWmptdfT
         sWZskrRqeIKrvBWjSHpnfNKFe67+0RIxZXdeSfzXaq5W8IdyZWhpXvsTlv6yqx3/2D
         YDe3Eud5bZmv7YiZRQ6na0BfL8eypE3JXuVh2ByWdTr99hYXu9nCG4llvvk247dVMD
         EoH0dAhjwI+IBMqERkDxX4BDbsgrXQS1TalkIpCGByDJSCrvPJF7nRZzmqSPlxQ0Qs
         13EJy/Zxm/RW0CSzyXcjeIucbDQLywbcS8vgNO0GJnwG4npj4QxBpTI1aX+HFApjT1
         mWAtCdZ9Y2rZA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH v2 0/5] Test a large dynamic heap
Date:   Mon,  5 Sep 2022 05:04:06 +0300
Message-Id: <20220905020411.17290-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Implement functionality to define a dynamic heap for the test
enclave. Then, implement a new augmentation test for a large
dynamic heap.

1/5 is critical for v6.0. More information in the patch
change log.

v2:
* Use dynamic heap in tcs_create test.

Haitao Huang (1):
  selftests/sgx: Retry the ioctl()'s returned with EAGAIN

Jarkko Sakkinen (3):
  selftests/sgx: Move ENCL_HEAP_SIZE_DEFAULT to main.c
  selftests/sgx: Use encl->encl_size in sigstruct.c
  selftests/sgx: Include the dynamic heap size to the ELRANGE
    calculation

Vijay Dhanraj (1):
  selftests/sgx: Add SGX selftest augment_via_eaccept_long

 tools/testing/selftests/sgx/load.c      |   8 +-
 tools/testing/selftests/sgx/main.c      | 177 +++++++++++++++++++++---
 tools/testing/selftests/sgx/main.h      |   6 +-
 tools/testing/selftests/sgx/sigstruct.c |   8 +-
 4 files changed, 170 insertions(+), 29 deletions(-)

-- 
2.37.2

