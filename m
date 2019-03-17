Return-Path: <SRS0=Bw5y=RU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD1AC43381
	for <linux-sgx@archiver.kernel.org>; Sun, 17 Mar 2019 21:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420F82082F
	for <linux-sgx@archiver.kernel.org>; Sun, 17 Mar 2019 21:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfCQVUG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 17 Mar 2019 17:20:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:50822 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbfCQVUF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 17 Mar 2019 17:20:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Mar 2019 14:20:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,491,1544515200"; 
   d="scan'208";a="142817409"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.193])
  by orsmga002.jf.intel.com with ESMTP; 17 Mar 2019 14:19:55 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v19 27/27] x86/sgx: Update MAINTAINERS
Date:   Sun, 17 Mar 2019 23:14:56 +0200
Message-Id: <20190317211456.13927-28-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add the maintainer information for the SGX subsystem.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e17ebf70b548..7abcb460dde9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8044,6 +8044,18 @@ L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	drivers/gpio/gpio-intel-mid.c
 
+INTEL SGX
+M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+M:	Sean Christopherson <sean.j.christopherson@intel.com>
+L:	linux-sgx@vger.kernel.org
+S:	Maintained
+Q:	https://patchwork.kernel.org/project/intel-sgx/list/
+T:	git https://github.com/jsakkine-intel/linux-sgx.git
+F:	arch/x86/include/asm/sgx.h
+F:	arch/x86/include/uapi/asm/sgx.h
+F:	arch/x86/kernel/cpu/sgx/*
+K:	\bSGX_
+
 INTERCONNECT API
 M:	Georgi Djakov <georgi.djakov@linaro.org>
 S:	Maintained
-- 
2.19.1

