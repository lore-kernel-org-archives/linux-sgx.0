Return-Path: <SRS0=lkUJ=3D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA07C33C9E
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 21:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4542824658
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 21:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgANV4v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:56:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:25618 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANV4u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Jan 2020 16:56:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 13:56:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,320,1574150400"; 
   d="scan'208";a="213482859"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 14 Jan 2020 13:56:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25] x86/sgx: Remove unused SGX_DRV_NR_DEVICES define
Date:   Tue, 14 Jan 2020 13:56:48 -0800
Message-Id: <20200114215648.29248-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove a define that got left behind when SGX moved to using standard
misc devices instead of manually creating the equivalent.

Fixes: e44714158119 ("x86/sgx: Linux Enclave Driver")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index eb68c0c872c3..72747d01c046 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -12,7 +12,6 @@
 #include <uapi/asm/sgx.h>
 #include "sgx.h"
 
-#define SGX_DRV_NR_DEVICES	2
 #define SGX_EINIT_SPIN_COUNT	20
 #define SGX_EINIT_SLEEP_COUNT	50
 #define SGX_EINIT_SLEEP_TIME	20
-- 
2.24.1

