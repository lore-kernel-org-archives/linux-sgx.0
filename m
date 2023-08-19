Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E9DEE49A5
	for <linux-sgx@archiver.kernel.org>; Sat, 19 Aug 2023 10:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjHSKkg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 19 Aug 2023 06:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjHSKkW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 19 Aug 2023 06:40:22 -0400
Received: from icts-p-cavuit-4.kulnet.kuleuven.be (icts-p-cavuit-4.kulnet.kuleuven.be [134.58.240.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA742EC94;
        Sat, 19 Aug 2023 02:44:00 -0700 (PDT)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 83D5DC3.A99C1
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-1.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:145:242:ac11:22])
        by icts-p-cavuit-4.kulnet.kuleuven.be (Postfix) with ESMTP id 83D5DC3;
        Sat, 19 Aug 2023 11:43:58 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_SIGNED#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1692438238;
        bh=9ixEDsItJ7s2bpi2Asbkroe2pqJ9+juR7RRMjomgz2Y=;
        h=From:To:Cc:Subject:Date;
        b=g+nNpdcCac0Jg9f0lxI89UlIUwY3PbHD065OGA8a5LvkFs3Qgv+tKQzTppQrCgUMf
         kunZ/6lH4yZVhxTuyTfFPOO+aypVWlBTvVErxJcYTcJiHPAvA0o+vETksrxjn2KNby
         Ye//VEVcJI5Js6+SbPioMAGsodC9RqAsRgpoQghI=
Received: from localhost.localdomain (ip-185-104-137-32.ptr.icomera.net [185.104.137.32])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-1.kuleuven.be (Postfix) with ESMTPSA id A501CD4EB61BA;
        Sat, 19 Aug 2023 11:43:56 +0200 (CEST)
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
To:     jarkko@kernel.org, kai.huang@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@linux.intel.com,
        Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH v3 0/9] selftests/sgx: Fix compilation errors
Date:   Sat, 19 Aug 2023 11:43:23 +0200
Message-Id: <20230819094332.8535-1-jo.vanbulck@cs.kuleuven.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,

This is the third iteration of a patch series to ensure that all SGX selftests
succeed when compiling with optimizations (as tested with -O{0,1,2,3,s} for
both gcc 11.3.0 and clang 14.0.0). The aim of the patches is to avoid reliance
on undefined, compiler-specific behavior that can make the test results
fragile.

If useful, I can also include an elementary wrapper shell script to compile and
run the tests for different compilers (gcc/clang) and optimization levels.
Reference output below:

.. Testing gcc   -O0    [OK]
.. Testing gcc   -O1    [OK]
.. Testing gcc   -O2    [OK]
.. Testing gcc   -O3    [OK]
.. Testing gcc   -Os    [OK]
.. Testing gcc   -Ofast [OK]
.. Testing gcc   -Og    [OK]
.. Testing clang -O0    [OK]
.. Testing clang -O1    [OK]
.. Testing clang -O2    [OK]
.. Testing clang -O3    [OK]
.. Testing clang -Os    [OK]
.. Testing clang -Ofast [OK]
.. Testing clang -Og    [OK]

Changelog
---------

v3
  - Refactor encl_op_array declaration and indexing (Jarkko)
  - Annotate encl_buffer with "used" attribute (Kai)
  - Split encl_buffer size and placement commits (Kai)

v2
  - Add additional check for NULL pointer (Kai)
  - Refine to produce proper static-pie executable
  - Fix linker script assertions
  - Specify memory clobber for inline asm instead of volatile (Kai)
  - Clarify why encl_buffer non-static (Jarkko, Kai)
  - Clarify -ffreestanding (Jarkko)

Best,
Jo

Jo Van Bulck (9):
  selftests/sgx: Fix uninitialized pointer dereference in error path
  selftests/sgx: Produce static-pie executable for test enclave
  selftests/sgx: Handle relocations in test enclave
  selftests/sgx: Fix linker script asserts
  selftests/sgx: Include memory clobber for inline asm in test enclave
  selftests/sgx: Ensure test enclave buffer is entirely preserved
  selftests/sgx: Ensure expected location of test enclave buffer
  selftests/sgx: Separate linker options
  selftests/sgx: Specify freestanding environment for enclave
    compilation

 tools/testing/selftests/sgx/Makefile          | 14 ++--
 tools/testing/selftests/sgx/defines.h         |  2 +
 tools/testing/selftests/sgx/sigstruct.c       |  5 +-
 tools/testing/selftests/sgx/test_encl.c       | 66 ++++++++++++-------
 tools/testing/selftests/sgx/test_encl.lds     | 10 +--
 .../selftests/sgx/test_encl_bootstrap.S       | 12 ++--
 6 files changed, 68 insertions(+), 41 deletions(-)

-- 
2.25.1

