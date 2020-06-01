Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3F5C433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 01:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B1D20823
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 01:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgFABVU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 May 2020 21:21:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:42216 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgFABVU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 May 2020 21:21:20 -0400
IronPort-SDR: pDNyS3TmxGeuEH5sZ6z4rCtgUbUC5w/bF3WJAOKVbmbdbZjcqGl5XxFSqbm/DMahYsA1s+KGgF
 QEujrpCbL8Cw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 18:21:19 -0700
IronPort-SDR: kuhC/mM8WyuNwWl8g5cYFak4e2hfrkaoGmYVkReUsu2SP3ECXp2BlcAYfcMVts60WfV+qm7cbC
 VV0qXrgTrmvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,459,1583222400"; 
   d="scan'208";a="268157524"
Received: from hbetts-mobl.ger.corp.intel.com (HELO localhost) ([10.252.59.178])
  by orsmga003.jf.intel.com with ESMTP; 31 May 2020 18:21:09 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        yaozhangx@google.com
Subject: [PATCH v31 21/21] x86/sgx: Update MAINTAINERS
Date:   Mon,  1 Jun 2020 04:16:45 +0300
Message-Id: <20200601011645.794040-22-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200601011645.794040-1-jarkko.sakkinen@linux.intel.com>
References: <20200601011645.794040-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add the maintainer information for the SGX subsystem.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 091ec22c1a23..cdebc57f9901 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8840,6 +8840,17 @@ F:	Documentation/x86/intel_txt.rst
 F:	arch/x86/kernel/tboot.c
 F:	include/linux/tboot.h
 
+INTEL SGX
+M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+M:	Sean Christopherson <sean.j.christopherson@intel.com>
+L:	linux-sgx@vger.kernel.org
+S:	Maintained
+Q:	https://patchwork.kernel.org/project/intel-sgx/list/
+T:	git https://github.com/jsakkine-intel/linux-sgx.git
+F:	arch/x86/include/uapi/asm/sgx.h
+F:	arch/x86/kernel/cpu/sgx/*
+K:	\bSGX_
+
 INTERCONNECT API
 M:	Georgi Djakov <georgi.djakov@linaro.org>
 L:	linux-pm@vger.kernel.org
-- 
2.25.1

