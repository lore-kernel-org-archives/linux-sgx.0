Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F06EC4338F
	for <linux-sgx@archiver.kernel.org>; Tue, 10 Aug 2021 22:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BA861058
	for <linux-sgx@archiver.kernel.org>; Tue, 10 Aug 2021 22:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhHJW44 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 Aug 2021 18:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhHJW4z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 10 Aug 2021 18:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA9360F25;
        Tue, 10 Aug 2021 22:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628636193;
        bh=oYqYHEAmCih4vRE/dhGYo0W/vHBpg2yCYZzyz/s+cNE=;
        h=From:To:Cc:Subject:Date:From;
        b=uwRicw94F3mTbXwQTPLJjmxo1avqWhtqgySmCzB7d/ZznUlRHaA9+/CJ//utmvmww
         JyKczQ49dRV7+xZSEywvfNTgWgblDPHhkU5T5rUosuF3pJr2OpZ6oAFsoIjbrQ+UV1
         3LfHvzyBuaLcuaJY96BVgangYese2jqxpYbCcce1Og2OsRk4Gct0JmXZffvo43WVQL
         BL+rX99a5UZ5C2622IPeWtPyFNKOx/3zxL5+ERSvdQhFn306djD6fPdE3CTEZf4tsZ
         fLkRNH3GLCxKB19g1p7r23T3M9/sqJlBnzq4IppmHB/PeuME3AUo79YIk2HoMoNljg
         TRSwH+DaZ8zEA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Always deregister /dev/sgx_provision on failure
Date:   Wed, 11 Aug 2021 01:56:27 +0300
Message-Id: <20210810225627.202890-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When /dev/sgx_vepc for KVM was added, the initialization was relaxed so
that this file can be accessed even when the driver is disabled.

Deregister /dev/sgx_provision when the driver is disabled, because it is
only useful for the driver.

Fixes: faa7d3e6f3b9 ("x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/driver.c | 17 +++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c   | 20 +-------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index aa9b8b868867..b7698f7628d4 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -143,6 +143,17 @@ static struct miscdevice sgx_dev_enclave = {
 	.fops = &sgx_encl_fops,
 };
 
+const struct file_operations sgx_provision_fops = {
+	.owner			= THIS_MODULE,
+};
+
+static struct miscdevice sgx_dev_provision = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "sgx_provision",
+	.nodename = "sgx_provision",
+	.fops = &sgx_provision_fops,
+};
+
 int __init sgx_drv_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
@@ -176,5 +187,11 @@ int __init sgx_drv_init(void)
 	if (ret)
 		return ret;
 
+	ret = misc_register(&sgx_dev_provision);
+	if (ret) {
+		misc_deregister(&sgx_dev_enclave);
+		return ret;
+	}
+
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..b8f210f15b62 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -745,17 +745,6 @@ void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
 		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
 }
 
-const struct file_operations sgx_provision_fops = {
-	.owner			= THIS_MODULE,
-};
-
-static struct miscdevice sgx_dev_provision = {
-	.minor = MISC_DYNAMIC_MINOR,
-	.name = "sgx_provision",
-	.nodename = "sgx_provision",
-	.fops = &sgx_provision_fops,
-};
-
 /**
  * sgx_set_attribute() - Update allowed attributes given file descriptor
  * @allowed_attributes:		Pointer to allowed enclave attributes
@@ -806,10 +795,6 @@ static int __init sgx_init(void)
 		goto err_page_cache;
 	}
 
-	ret = misc_register(&sgx_dev_provision);
-	if (ret)
-		goto err_kthread;
-
 	/*
 	 * Always try to initialize the native *and* KVM drivers.
 	 * The KVM driver is less picky than the native one and
@@ -821,13 +806,10 @@ static int __init sgx_init(void)
 	ret = sgx_drv_init();
 
 	if (sgx_vepc_init() && ret)
-		goto err_provision;
+		goto err_kthread;
 
 	return 0;
 
-err_provision:
-	misc_deregister(&sgx_dev_provision);
-
 err_kthread:
 	kthread_stop(ksgxd_tsk);
 
-- 
2.32.0

