Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E86C43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B4E206DB
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgCaLoj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:44:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:15944 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbgCaLoj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 07:44:39 -0400
IronPort-SDR: ZvktIX+J+8Ihs3SzFDaw2QBSUr+3YrZAlLhsv9i8rnX5itAH4ABYDXi3RTI+lk/Fom81dqkKq1
 v+D2JxlOsoCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 04:44:38 -0700
IronPort-SDR: WmbXnddq4QTTe685pdvYtpZvk2iNu92Q9OFgg51So+RlCIBHLX8NAc8f4GM0npfxObi30XLyzd
 KezDBzQ2daUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="272717021"
Received: from tking1-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.59.94])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2020 04:44:35 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        luto@kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 0/4] Migrate enclave mapping to an anonymous inode
Date:   Tue, 31 Mar 2020 14:44:28 +0300
Message-Id: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Given that distributions are converting /dev to noexec, there is no really
other option than to use an anonymous inode for the enclave run-time
representation.

This results the following constraints:

1. Enclave can be fully built and initialized by a process with hno
   special privileges.
2. To run an initialized enclave, exec-from-mem is required.

This patche set segregates these responsibilities by keeping the build
interface in the device fd and moving the mapping interface to the
newly introduced enclave fd.

Cc: luto@kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>


Jarkko Sakkinen (4):
  x86/sgx: Remove PROT_NONE branch from sgx_encl_may_map().
  x86/sgx: Put enclaves into anonymous files
  x86/sgx: Move mmap() to the anonymous enclave file
  x86/sgx: Hand over the enclave file to the user space

 Documentation/x86/sgx.rst          |  13 ++--
 arch/x86/include/uapi/asm/sgx.h    |   2 +
 arch/x86/kernel/cpu/sgx/driver.c   | 119 +++++++++++++++++++----------
 arch/x86/kernel/cpu/sgx/encl.c     |   7 +-
 arch/x86/kernel/cpu/sgx/ioctl.c    |  64 +++++++++-------
 tools/testing/selftests/sgx/load.c |  19 +++--
 tools/testing/selftests/sgx/main.c |   3 +-
 tools/testing/selftests/sgx/main.h |   3 +-
 8 files changed, 136 insertions(+), 94 deletions(-)

-- 
2.25.1

