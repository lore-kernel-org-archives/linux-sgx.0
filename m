Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AF3E9270D
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Oct 2023 16:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239240AbjJEQPv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Oct 2023 12:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbjJEQOH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 5 Oct 2023 12:14:07 -0400
Received: from icts-p-cavuit-3.kulnet.kuleuven.be (icts-p-cavuit-3.kulnet.kuleuven.be [134.58.240.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A742C288;
        Thu,  5 Oct 2023 08:39:04 -0700 (PDT)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 8B62E2005A.A6A6D
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-1.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:213:242:ac11:64])
        by icts-p-cavuit-3.kulnet.kuleuven.be (Postfix) with ESMTP id 8B62E2005A;
        Thu,  5 Oct 2023 17:38:59 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_SIGNED#0.00,SA-HVU#DKIM_VALID#0.00,SA-HVU#OURIPS#-35.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1696520339;
        bh=xeT3PLcbuZl38n6owU7MJRWwK/4IHMoTULMTupbtSIA=;
        h=From:To:Cc:Subject:Date;
        b=YQiSbDObPEvDrFVTijyOZfhjVpLcBiTy6mznIxvi8hKUiKC9XBeSNxzeX4++3+++Y
         r+WJxiGLF66WMZwWuYJzEtzJKkoPbEdNxmjnqUkCI8my80IFgxBKKfNBuETDpKrknP
         Zis3bCWOy5Lp3xoUMfioSRG0rJ6BinQN+isIqfNA=
Received: from librem.dyn.cs.kuleuven.be (unknown [IPv6:2a02:2c40:500:a006:548e:e4dd:76a4:afd8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-1.kuleuven.be (Postfix) with ESMTPSA id 5C465D4F34F1A;
        Thu,  5 Oct 2023 17:38:59 +0200 (CEST)
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
To:     jarkko@kernel.org, kai.huang@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@linux.intel.com,
        Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH v7 00/13] selftests/sgx: Fix compilation errors
Date:   Thu,  5 Oct 2023 17:38:41 +0200
Message-Id: <20231005153854.25566-1-jo.vanbulck@cs.kuleuven.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi,

This patch series ensures that all SGX selftests succeed when compiling with
optimizations (as tested with -O{0,1,2,3,s} for both gcc 11.3.0 and clang
14.0.0). The aim of the patches is to avoid reliance on undefined,
compiler-specific behavior that can make the test results fragile.

As far as I see, all commits in this series now have an explicit reviewed-by
tag, so hopefully this can get merged upstream? Please let me know if any
concerns remain and I'd happily address them.

Reference output below:

.. Testing   gcc   -O0    [OK]
.. Testing   gcc   -O1    [OK]
.. Testing   gcc   -O2    [OK]
.. Testing   gcc   -O3    [OK]
.. Testing   gcc   -Os    [OK]
.. Testing   gcc   -Ofast [OK]
.. Testing   gcc   -Og    [OK]
.. Testing   clang -O0    [OK]
.. Testing   clang -O1    [OK]
.. Testing   clang -O2    [OK]
.. Testing   clang -O3    [OK]
.. Testing   clang -Os    [OK]
.. Testing   clang -Ofast [OK]
.. Testing   clang -Og    [OK]

Changelog
---------

v7
  - Add reviewed-by tag (Jarkko)

v6
  - Collect final ack/reviewed-by tags (Jarkko, Kai)

v5
  - Reorder patches (Jarkko, Kai)
  - Include fixes tag for inline asm memory clobber patch (Kai)
  - Include linker error in static-pie commit message (Kai)
  - Include generated assembly in relocations commit (Kai)

v4
  - Remove redundant -nostartfiles compiler flag (Jarkko)
  - Split dynamic symbol table removal in separate commit (Kai)
  - Split redundant push/pop elimination in separate commit (Kai)
  - Remove (incomplete) register cleansing on enclave exit
  - Fix possibly uninitialized pointer dereferences in load.c

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

Jo Van Bulck (13):
  selftests/sgx: Fix uninitialized pointer dereference in error path
  selftests/sgx: Fix uninitialized pointer dereferences in
    encl_get_entry
  selftests/sgx: Include memory clobber for inline asm in test enclave
  selftests/sgx: Separate linker options
  selftests/sgx: Specify freestanding environment for enclave
    compilation
  selftests/sgx: Remove redundant enclave base address save/restore
  selftests/sgx: Produce static-pie executable for test enclave
  selftests/sgx: Handle relocations in test enclave
  selftests/sgx: Fix linker script asserts
  selftests/sgx: Ensure test enclave buffer is entirely preserved
  selftests/sgx: Ensure expected location of test enclave buffer
  selftests/sgx: Discard unsupported ELF sections
  selftests/sgx: Remove incomplete ABI sanitization code in test enclave

 tools/testing/selftests/sgx/Makefile          | 12 ++--
 tools/testing/selftests/sgx/defines.h         |  2 +
 tools/testing/selftests/sgx/load.c            |  9 ++-
 tools/testing/selftests/sgx/sigstruct.c       |  5 +-
 tools/testing/selftests/sgx/test_encl.c       | 67 +++++++++++++------
 tools/testing/selftests/sgx/test_encl.lds     | 10 +--
 .../selftests/sgx/test_encl_bootstrap.S       | 28 +++-----
 7 files changed, 77 insertions(+), 56 deletions(-)

-- 
2.25.1

