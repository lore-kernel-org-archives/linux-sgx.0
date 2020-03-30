Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C739C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630D62072E
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgC3SIO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:08:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:35626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgC3SIO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 14:08:14 -0400
IronPort-SDR: Qv4oWiyuOOxHUEL85JDkMjOufOe8VQ4bQpS42Ei+ZWPtFUHoLu18LjCuNKcBEnFYdlw9jaHv1D
 5eoW9GP1RKFA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:08:13 -0700
IronPort-SDR: uEeyeFTymkCcFnrLK9TgowbO2wr1rYZ0X/ml6SUADbo12voSZGSfDA1U3Z8dzKHPA1ELxxe74k
 EWbcvr++J+7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="283721693"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2020 11:08:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v2 0/5]  x86/sgx: Make vDSO callable from C
Date:   Mon, 30 Mar 2020 11:08:06 -0700
Message-Id: <20200330180811.31381-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
close to being callable from C (with caveats and a cooperative enclave).
The missing pieces are preserving %rbx and taking @leaf as a standard
parameter.

v2:
  - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
  - Add CFI directive for RBX. [Cedric]

v1:
  - https://patchwork.kernel.org/cover/11446355/

Sean Christopherson (5):
  x86/sgx: vdso: Make __vdso_sgx_enter_enclave() callable from C code
  x86/sgx: vdso: Define a typedef for __vdso_sgx_enter_enclave
  selftests/sgx: Pass EENTER to vDSO wrapper instead of hardcoding
  selftests/sgx: Stop clobbering non-volatile registers
  selftests/sgx: Add selftest to invoke __vsgx_enter_enclave() from C

 arch/x86/entry/vdso/vsgx_enter_enclave.S      | 64 ++-----------------
 arch/x86/include/uapi/asm/sgx.h               | 61 ++++++++++++++++++
 tools/testing/selftests/sgx/call.S            |  1 -
 tools/testing/selftests/sgx/defines.h         |  1 +
 tools/testing/selftests/sgx/main.c            | 20 ++++--
 tools/testing/selftests/sgx/main.h            |  2 +-
 .../selftests/sgx/test_encl_bootstrap.S       |  6 +-
 7 files changed, 84 insertions(+), 71 deletions(-)

-- 
2.24.1

