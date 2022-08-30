Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20115ECAAD3
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Aug 2022 03:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiH3DMY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Aug 2022 23:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiH3DMV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Aug 2022 23:12:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8127DF4A
        for <linux-sgx@vger.kernel.org>; Mon, 29 Aug 2022 20:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CFDFB815DA
        for <linux-sgx@vger.kernel.org>; Tue, 30 Aug 2022 03:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA732C433C1;
        Tue, 30 Aug 2022 03:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661829137;
        bh=MxxVTqlZ74W7dFtp4WYUTfJoZM6ok1QcSznNSD9dHYs=;
        h=From:To:Cc:Subject:Date:From;
        b=ry6ef0NaXhxv6/iJEYzmJwlBtX9jfmOsWW8YsJlOiFyHF6qz0UZiqnN1A7/g4BtI+
         dOq2BoD68jwXWN3bykqO4bNEnxiyHTV7z8StcRfEmtTq1fj47WccUmxME1U4r4Bxpk
         xeBlo5oZD/65jOJt1CJ32ow/RpFXQ2uXbdNCU1ufTRE6YXo+EQ0xs8tfgdltc490fV
         0M+wb5G3Rnovw3R4eedce0a/MiNZpuoBBbj8jdY54S1bVWftFEsLGSTjohkz9TQnSa
         8GCSZMeMIKtiJcIaVTxXXzyLaelYTqbGzJe9+6OlIBKdgrSEpVGO65kLAsQjUBZaQu
         4+pcgnoBjaDnA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 0/6] x86/sgx: Test and fixes
Date:   Tue, 30 Aug 2022 06:12:00 +0300
Message-Id: <20220830031206.13449-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A collection of tests and fixes for SGX.

Haitao Huang (2):
  x86/sgx: Handle VA page allocation failure for EAUG on PF.
  selftests/sgx: retry the ioctls returned with EAGAIN

Jarkko Sakkinen (2):
  x86/sgx: Do not consider unsanitized pages an error
  selftests/sgx: Add a bpftrace script for tracking allocation errors

Kristen Carlson Accardi (1):
  selftests/sgx: Ignore OpenSSL 3.0 deprecated functions warning

Vijay Dhanraj (1):
  selftests/sgx: Add SGX selftest augment_via_eaccept_long

 arch/x86/kernel/cpu/sgx/encl.c             |   5 +-
 arch/x86/kernel/cpu/sgx/main.c             |  19 ++-
 tools/testing/selftests/sgx/alloc-error.bt |   7 +
 tools/testing/selftests/sgx/load.c         |   5 +-
 tools/testing/selftests/sgx/main.c         | 180 +++++++++++++++++----
 tools/testing/selftests/sgx/main.h         |   3 +-
 tools/testing/selftests/sgx/sigstruct.c    |   8 +-
 7 files changed, 189 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/sgx/alloc-error.bt

-- 
2.37.2

