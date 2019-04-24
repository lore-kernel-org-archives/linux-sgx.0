Return-Path: <SRS0=QZjA=S2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEC7C282CE
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 06:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85EF5206A3
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Apr 2019 06:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfDXG0Z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Apr 2019 02:26:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:4222 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfDXG0Z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Apr 2019 02:26:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Apr 2019 23:26:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,388,1549958400"; 
   d="scan'208";a="145368045"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by fmsmga007.fm.intel.com with ESMTP; 23 Apr 2019 23:26:23 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     cedric.xing@intel.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com,
        jarkko.sakkinen@linux.intel.com
Subject: [RFC PATCH v2 0/3] An alternative __vdso_sgx_enter_enclave() to allow enclave/host parameter passing using untrusted stack
Date:   Tue, 23 Apr 2019 23:26:20 -0700
Message-Id: <20190424062623.4345-1-cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1555965327.git.cedric.xing@intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The current proposed __vdso_sgx_enter_enclave() requires enclaves to preserve
%rsp, which prohibits enclaves from allocating space on the untrusted stack.
However, there are existing enclaves (e.g. those built with current Intel SGX
SDK libraries) relying on the untrusted stack for passing parameters to
untrusted functions (aka. o-calls), which requires allocating space on the
untrusted stack by enclaves. And given its simplicity and convenience, it could
be desired by future SGX applications as well.  

This patchset introduces a new ABI for __vdso_sgx_enter_enclave() to anchor its
stack frame on %rbp (instead of %rsp), so as to allow enclaves to "push" onto
the untrusted stack by decrementing the untrusted %rsp. Additionally, this new
__vdso_sgx_enter_enclave() will take one more parameter - a callback function,
to be invoked upon all enclave exits (both AEX and normal exits). The callback
function will be given the value of %rsp left off by the enclave, so that data
"pushed" by the enclave (if any) could be addressed/accessed.  Please note that
the callback function is optional, and if not supplied (i.e. null),
__vdso_sgx_enter_enclave() will just return (i.e. behave the same as the
current implementation) after the enclave exits (or AEX due to exceptions).

The SGX selftest is augmented by two new tests. One exercises the new callback
interface, and serves as a simple example to showcase how to use it; while the
other validates the hand-crafted CFI directives in __vdso_sgx_enter_enclave()
by single-stepping through it and unwinding call stack at every instruction.

v2:
  - Revised comments in __vdso_sgx_enter_enclave(). See patch 2/3.
  - Added stack unwind test. See patch 3/3.

v1: https://lkml.org/lkml/2019/4/22/871

Note: This patchset is based upon SGX1 patch v20
(https://lkml.org/lkml/2019/4/17/344) by Jarkko Sakkinen

Cedric Xing (3):
  selftests/x86: Fixed Makefile for SGX selftest
  x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing
    on untrusted stack
  selftests/x86: Augment SGX selftest to test new
    __vdso_sgx_enter_enclave() and its callback interface

 arch/x86/entry/vdso/vsgx_enter_enclave.S   | 175 +++++++----
 arch/x86/include/uapi/asm/sgx.h            |  14 +-
 tools/testing/selftests/x86/Makefile       |  12 +-
 tools/testing/selftests/x86/sgx/Makefile   |  49 ++--
 tools/testing/selftests/x86/sgx/main.c     | 323 ++++++++++++++++++---
 tools/testing/selftests/x86/sgx/sgx_call.S |  40 ++-
 6 files changed, 471 insertions(+), 142 deletions(-)

-- 
2.17.1

