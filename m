Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8DEC6FA82
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Sep 2022 07:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiIDHyM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Sep 2022 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiIDHyL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 4 Sep 2022 03:54:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB794B4A3
        for <linux-sgx@vger.kernel.org>; Sun,  4 Sep 2022 00:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F7AC60F18
        for <linux-sgx@vger.kernel.org>; Sun,  4 Sep 2022 07:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8887CC433D6;
        Sun,  4 Sep 2022 07:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662278049;
        bh=B2RYDqsezduQSYDUXDEYUBFIustBX/JJUNMGJE/i1KQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cmhIoh2MIaBT0j1kk6L2q3RMVsDlV5JRJSBABtpFi5/ctPXKe6GPtfACABHx6QwBL
         f+NdZXUu81yrH8AwTCM22bWCUBp7tLZ0froVQwVohNLo9SuwUNmrXwWULpo3y8y+dC
         oVdYMl12jz9myH0GfszYGgncq0axb0c2tpIUwjgmVLRh79OLiJGebGh8q5JXpQWjIx
         HDwSODJp7eTL55espI9IsqQOgKUWdCvyx6GFBDKm2uPhWRCp7PgK4bm3yEdxN6T9oi
         h/XRSRCJZdEPMb7mcZpe498ZtphUskITD3Z4R6PLXhj5Vrbx6NtAHVZQrxUSn23B9L
         LcSfrk3lGqXtA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 0/5] selftests/sgx: Test a large dynamic heap
Date:   Sun,  4 Sep 2022 10:53:53 +0300
Message-Id: <20220904075358.7727-1-jarkko@kernel.org>
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
 tools/testing/selftests/sgx/main.c      | 179 +++++++++++++++++++++---
 tools/testing/selftests/sgx/main.h      |   6 +-
 tools/testing/selftests/sgx/sigstruct.c |   8 +-
 4 files changed, 172 insertions(+), 29 deletions(-)

-- 
2.37.2

