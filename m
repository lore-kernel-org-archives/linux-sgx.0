Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D644C282CE
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 20:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A6A5206A3
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 20:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfDVUnB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:43:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:62703 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfDVUnB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 16:43:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 13:43:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,383,1549958400"; 
   d="scan'208";a="144785992"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by orsmga003.jf.intel.com with ESMTP; 22 Apr 2019 13:42:59 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     cedric.xing@intel.com
Subject: [RFC PATCH v1 0/3] An alternative __vdso_sgx_enter_enclave() to allow enclave/host parameter passing using untrusted stack
Date:   Mon, 22 Apr 2019 13:42:56 -0700
Message-Id: <cover.1555965327.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The current proposed __vdso_sgx_enter_enclave() requires enclaves to preserve %rsp, which prohibits enclaves from allocating space on the untrusted stack. However, there are existing enclaves (e.g. those built with current Intel SGX SDK libraries) relying on the untrusted stack for passing parameters to untrusted functions (aka. o-calls), which requires allocating space on the untrusted stack by enclaves. And given its simplicity and convenience, it could be desired by future SGX applications as well.

This patchset introduces a new ABI for __vdso_sgx_enter_enclave() to anchor its stack frame on %rbp (instead of %rsp), so as to allow enclaves to "push" onto the untrusted stack by decrementing the untrusted %rsp. Additionally, this new __vdso_sgx_enter_enclave() will take one more parameter - a callback function, to be invoked upon all enclave exits (both AEX and normal exits). The callback function will be given the value of %rsp left off by the enclave, so that data "pushed" by the enclave (if any) could be addressed/accessed. Please note that the callback function is optional, and if not supplied (i.e. null), __vdso_sgx_enter_enclave() will just return (i.e. behave the same as the current implementation) after the enclave exits (or AEX due to exceptions).

The SGX selftest is augmented to test out the new callback interface, and to serve as a simple example to showcase how to use the callback interface in practice.

Cedric Xing (3):
  selftests/x86: Fixed Makefile for SGX selftest
  x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing
    on untrusted stack
  selftests/x86: Augment SGX selftest to test new
    __vdso_sgx_enter_enclave() and its callback interface

 arch/x86/entry/vdso/vsgx_enter_enclave.S   | 156 ++++++++++++---------
 arch/x86/include/uapi/asm/sgx.h            |  14 +-
 tools/testing/selftests/x86/Makefile       |  12 +-
 tools/testing/selftests/x86/sgx/Makefile   |  45 +++---
 tools/testing/selftests/x86/sgx/main.c     | 123 +++++++++++++---
 tools/testing/selftests/x86/sgx/sgx_call.S |  40 +++++-
 6 files changed, 264 insertions(+), 126 deletions(-)

-- 
2.17.1

