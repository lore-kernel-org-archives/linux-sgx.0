Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D80DC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 03:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiESDKl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 May 2022 23:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiESDKj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 May 2022 23:10:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9689D9E94
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 20:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652929838; x=1684465838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WS5JJ6NmCIeLPUUNNvKWVQcUtf16QW6OqKEFZ1lBFEk=;
  b=MKtO/0F/307V6qn9vPK005u0K/LDV9LGJV4Gbv0EZSNTfDC1QGNWqKhr
   O4VgCX3zzoymrok9IpwIauAULI6WYv7/706nkxoEolS9TBPhwreB3HNIL
   gW/DO1SFCyftzpt8fIulz8aAFBJqO6B4r3QIGljJJkToJ3G2lrRxr0GzA
   Kiht8Mxn3ojIxe/AfS7nhNEjDB+e+uHhNgKdOqcYHX5x1TkkMLJ0eJ5us
   Y5RROxf2bIwwvDAZPbBnpQKA83DySxb2vI145mkee9CPt5bXbddwbZfqf
   9gMDlKALJHWMRyslJ07xq/lB66FD8D1enMm8qqcFEu1W5xVinkpkBlXFN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="252511992"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="252511992"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 20:10:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="569928705"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2022 20:10:32 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v2 1/4] x86/sgx: Move struct sgx_vepc definition to sgx.h
Date:   Thu, 19 May 2022 11:11:17 +0800
Message-Id: <20220519031117.245698-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move struct sgx_vepc definition to sgx.h so that it can be used outside
of virt.c.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
Changes since V1:
- Add documentation suggested by Jarkko.
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 13 +++++++++++++
 arch/x86/kernel/cpu/sgx/virt.c |  5 -----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0f17def9fe6f..ad3b455ed0da 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -101,4 +101,17 @@ static inline int __init sgx_vepc_init(void)
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
+/**
+ * struct sgx_vepc - SGX virtual EPC structure
+ * @page_array:		the xarray of virtual EPC pages allocated to guest
+ * @lock:			the mutex lock to protect a virtual EPC instance
+ *
+ * When hypervisor opens /dev/sgx_vepc a virtual EPC instance. The
+ * virtual EPC pages allocated to guest will be added to its page_array.
+ */
+struct sgx_vepc {
+	struct xarray page_array;
+	struct mutex lock;
+};
+
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a77a14eee38..c9c8638b5dc4 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -18,11 +18,6 @@
 #include "encls.h"
 #include "sgx.h"
 
-struct sgx_vepc {
-	struct xarray page_array;
-	struct mutex lock;
-};
-
 /*
  * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
  * virtual EPC instances, and the lock to protect it.
-- 
2.25.1

