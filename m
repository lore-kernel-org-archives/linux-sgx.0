Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD0DECAAD4
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Aug 2022 17:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiHaRin (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 13:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiHaRil (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 13:38:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3EC419BC
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 10:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB35A61B18
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 17:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990FCC433D7;
        Wed, 31 Aug 2022 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661967519;
        bh=gxtxa12tkzovKZU2AjzqUr7NU47JZ39aGvQFCayaDKg=;
        h=From:To:Cc:Subject:Date:From;
        b=TXLOcFNccl3Z7Dk+/ULk+sX5CZP2MbwLEhBtBHz0ZZNIbwy9fA8euqv7MoI8SHz/W
         kYZED/LvSvvC4JfnamEzR/nMZ52xuAHYEBIfKufkh30nVtBYg3bHwXeelYQVi/93MJ
         m1erQRsXnt0H07gseCtQsnKWF/Mz/CqAUJeyaEJfmQ7jum1EempZneRJonyJvER/Z3
         9cZOOzWRg4FCCxSRrhvovLPBIDhrwvRcwpROJ5AK2gh0yLn6Cd5BnU/GdUPgJU2SaX
         S2qHLmL3hkrMszh/Hp0DltLgXa0kHd5pZ/1VWoqOnozpyCHVB9UBbwdJuC7P5kC0VT
         YSAnavUx3SiZw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH v2 0/6] x86/sgx: A collection of tests and fixes
Date:   Wed, 31 Aug 2022 20:38:23 +0300
Message-Id: <20220831173829.126661-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

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
 arch/x86/kernel/cpu/sgx/main.c             |  42 ++++-
 tools/testing/selftests/sgx/alloc-error.bt |   9 +
 tools/testing/selftests/sgx/load.c         |   5 +-
 tools/testing/selftests/sgx/main.c         | 185 ++++++++++++++++++---
 tools/testing/selftests/sgx/main.h         |   3 +-
 tools/testing/selftests/sgx/sigstruct.c    |   6 +
 7 files changed, 218 insertions(+), 37 deletions(-)
 create mode 100644 tools/testing/selftests/sgx/alloc-error.bt

-- 
2.37.2

