Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A7CC56202
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EF2C22201
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzBBBZE5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgKLWCo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgKLWCk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:40 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E106B22201;
        Thu, 12 Nov 2020 22:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218559;
        bh=zJx4e7mNcNnTToB29aO9Ny/o14a9p3GCHActo+yKdJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzBBBZE5WwOMsI7lDNwxIeQKUQHqDig/c1IxAbBptENai206PDp3BkkGNIMQSYzbQ
         K5jip7VPxFJsOz2jIujMkHc0e1gIWT90to8Pv7luEmWFtuouP/wDMN1nR3H+7cKyTK
         i5g/KdolDM8fhPClZSSiItXA8Ebftzuh7+scRbpQ=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 08/24] x86/cpu/intel: Add nosgx kernel parameter
Date:   Fri, 13 Nov 2020 00:01:19 +0200
Message-Id: <20201112220135.165028-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add kernel parameter to disable Intel SGX kernel support, along with
supporting Documentation.

Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
# Tested-by: Sean Christopherson <sean.j.christopherson@intel.com>
# Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 ++
 arch/x86/kernel/cpu/feat_ctl.c                  | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bd1a5b87a5e2..4684611edf09 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3385,6 +3385,8 @@
 
 	nosep		[BUGS=X86-32] Disables x86 SYSENTER/SYSEXIT support.
 
+	nosgx		[X86-64,SGX] Disables Intel SGX kernel support.
+
 	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel,
 			and disable the IO APIC.  legacy for "maxcpus=0".
 
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index d38e97325018..3b1b01f2b248 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -99,6 +99,15 @@ static void clear_sgx_caps(void)
 	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
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
2.27.0

