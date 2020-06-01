Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE561C433E0
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 07:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A3220734
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 07:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgFAHxQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jun 2020 03:53:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:18186 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFAHxQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jun 2020 03:53:16 -0400
IronPort-SDR: NBXu+W4QNESf8Y8Bj3tApc8+wK3ntUwFc/YQG9LZADB9q1ZN/UZcyXc1kga2liaa+yMEXmrvE6
 QkBSqMVS6mPw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 00:53:16 -0700
IronPort-SDR: PtTTqghyPNi5ol6U3rUdS7wgwi+UMXQYkXM5ECw3C8MpknElsdi3+kZa0zK+BCqLi+OpwZA/rg
 9rasj/zodpvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,460,1583222400"; 
   d="scan'208";a="311879578"
Received: from yhanin-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.43.17])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Jun 2020 00:53:10 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v32 07/21] x86/cpu/intel: Add nosgx kernel parameter
Date:   Mon,  1 Jun 2020 10:52:04 +0300
Message-Id: <20200601075218.65618-8-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add kernel parameter to disable Intel SGX kernel support.

Tested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 ++
 arch/x86/kernel/cpu/feat_ctl.c                  | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 7bc83f3d9bdf..9f7202a54db6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3268,6 +3268,8 @@
 
 	nosep		[BUGS=X86-32] Disables x86 SYSENTER/SYSEXIT support.
 
+	nosgx		[X86-64,SGX] Disables Intel SGX kernel support.
+
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel,
 			and disable the IO APIC.  legacy for "maxcpus=0".
 
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index c3afcd2e4342..1837df39527f 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -101,6 +101,15 @@ static void clear_sgx_caps(void)
 	setup_clear_cpu_cap(X86_FEATURE_SGX2);
 }
 
+static int __init nosgx(char *str)
+{
+	clear_sgx_caps();
+
+	return 0;
+}
+
+early_param("nosgx", nosgx);
+
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
 	bool tboot = tboot_enabled();
-- 
2.25.1

