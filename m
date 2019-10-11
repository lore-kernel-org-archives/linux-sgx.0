Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05251ECE596
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB57D2053B
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfJKAlC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:41:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:44340 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbfJKAlB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 20:41:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 17:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="198542989"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 10 Oct 2019 17:41:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 0/5]  x86/vdso: sgx: Bug fixes
Date:   Thu, 10 Oct 2019 17:40:54 -0700
Message-Id: <20191011004059.28581-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Fix gwo bugs that were introduced in the refactoring, and tweak the
callback prototype to make it more readable.

Please don't apply patches 3/5 -> 5/5 until Cedric has weighed in.  The
CFI patch may or may not be correct, and the prototype change is a
continuation of a discussion (sending a patch seemed like the easiest
way to move forward).

Sean Christopherson (5):
  x86/vdso: sgx: Fix misaligned stack bug when invoking exit handler
  selftests/x86/sgx: Add check to verify exit handler stack alignment
  x86/vdso: sgx: Fix unwinder support
  x86/vdso: sgx: Reorder params to callback to improve readability
  selftests/x86/sgx: Update the callbacks function parameters

 arch/x86/entry/vdso/vsgx_enter_enclave.S  | 18 ++++++++---------
 arch/x86/include/uapi/asm/sgx.h           | 10 +++++-----
 tools/testing/selftests/x86/sgx/defines.h |  1 +
 tools/testing/selftests/x86/sgx/main.c    | 24 ++++++++++++++++++-----
 4 files changed, 34 insertions(+), 19 deletions(-)

-- 
2.22.0

