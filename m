Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDA3C742D7
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23E7A204FD
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 06:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfGMGv2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 02:51:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:55267 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfGMGv2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 02:51:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 23:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,485,1557212400"; 
   d="scan'208";a="318200501"
Received: from bxing-ubuntu.jf.intel.com ([10.23.30.27])
  by orsmga004.jf.intel.com with ESMTP; 12 Jul 2019 23:51:27 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com
Cc:     cedric.xing@intel.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com
Subject: [RFC PATCH v4 0/3] x86/sgx: Amend vDSO API to allow enclave/host parameter passing on untrusted stack
Date:   Fri, 12 Jul 2019 23:51:24 -0700
Message-Id: <cover.1563000446.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
In-Reply-To: <cover.1562813643.git.cedric.xing@intel.com>
References: <cover.1562813643.git.cedric.xing@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patchset is based upon, and can be applied cleanly on SGX1 patch v20
(https://lkml.org/lkml/2019/4/17/344) by Jarkko Sakkinen.

The current proposed __vdso_sgx_enter_enclave() requires enclaves to preserve
%rsp, which prohibits enclaves from allocating space on the untrusted stack.
However, there are existing enclaves (e.g. those built with current Intel SGX
SDK libraries) relying on the untrusted stack for passing parameters to
untrusted functions (aka. o-calls), which requires allocating space on the
untrusted stack by enclaves. After all, passing data via untrusted stack is
very easy to implement (by enclaves), with essentially no overhead, therefore
is very suitable for exchanging data in small amounts, so could be desirable by
future SGX applications as well.

This patchset introduces a new ABI for __vdso_sgx_enter_enclave() to anchor its
stack frame on %rbp (instead of %rsp), so as to allow enclaves to "push" onto
the untrusted stack by decrementing the untrusted %rsp. And in order to service
o-calls and to preserve the untrusted stack upon exceptions, the new vDSO API
takes one more optional parameter - "callback", which if supplied, will be
invoked on all enclave exits (including normal and asynchronous exits). Ample
details regarding the new ABI have been documented as comments inside the
source code located in arch/x86/entry/vsgx_enter_enclave.S

Please note that there was a lengthy discussion on what is the "best" approach
for passing parameters for trusted/untrusted calls. Unfortunately there's no
single "best" approach that fits all use cases, hence this new ABI has been
designed intentionally to accommodate varieties. Therefore, to those not
interested in using the untrusted stack, whatever worked with the old ABI
proposed by Sean will continue to work with this new ABI.

The SGX selftest has been augmented by two new tests. One exercises the new
callback interface, and serves as a simple example to showcase how to use it;
while the other validates the hand-crafted CFI directives in
__vdso_sgx_enter_enclave() by single-stepping through it and unwinding call
stack at every instruction.

Changelog:
  · This is version 4 of this patch series with the following changes.
    - Removed unrelated cosmetic changes.
    - Rewrote and reformatted comments in
      arch/x86/entry/vdso/vsgx_enter_enclave.S to follow kernel-doc
      conventions. New comments now can be converted to nice looking man pages.
    - Fixed minor issues in the unwinding selftest and now it can run to
      completion successfully with Sean's fix in vDSO fixup code
      (https://patchwork.kernel.org/patch/11040801/). Comments have also been
      added to describe the tests done.
  · v3 - https://patchwork.kernel.org/cover/11039263/
  · v2 - https://patchwork.kernel.org/cover/10914161/
  · v1 - https://patchwork.kernel.org/cover/10911615/

Cedric Xing (3):
  selftests/x86/sgx: Fix Makefile for SGX selftest
  x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing
    on untrusted stack
  selftests/x86/sgx: Augment SGX selftest to test vDSO API

 arch/x86/entry/vdso/vsgx_enter_enclave.S   | 310 ++++++++++++++-----
 arch/x86/include/uapi/asm/sgx.h            |  14 +-
 tools/testing/selftests/x86/sgx/Makefile   |  49 ++-
 tools/testing/selftests/x86/sgx/main.c     | 344 ++++++++++++++++++---
 tools/testing/selftests/x86/sgx/sgx_call.S |  40 ++-
 5 files changed, 600 insertions(+), 157 deletions(-)

-- 
2.17.1

