Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E2DC433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Jan 2021 03:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA88E224B8
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Jan 2021 03:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbhARD3L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 17 Jan 2021 22:29:11 -0500
Received: from mga18.intel.com ([134.134.136.126]:61008 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731662AbhARD3J (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 17 Jan 2021 22:29:09 -0500
IronPort-SDR: tUKcIBY8frfR0eWIK6eRoGe8ZXlglB5tfewGKbuEoEORE/+ioUaWBbXGcPmRSx0edaujbI6jjQ
 yKhKMS0RTidQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="166420875"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="166420875"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:28 -0800
IronPort-SDR: 2B30kzKDjdHXm0fBVVHZyQE0OELjHftXFVnt9AePbSlXVYidPDlrcpvk3nh1DqjpNhTO8SwKxP
 +S9Yq6HvvH1w==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573151020"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:24 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 12/26] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
Date:   Mon, 18 Jan 2021 16:28:05 +1300
Message-Id: <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a helper to update SGX_LEPUBKEYHASHn MSRs.  SGX virtualization also
needs to update those MSRs based on guest's "virtual" SGX_LEPUBKEYHASHn
before EINIT from guest.

Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 5 ++---
 arch/x86/kernel/cpu/sgx/main.c  | 8 ++++++++
 arch/x86/kernel/cpu/sgx/sgx.h   | 2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index e5977752c7be..1bae754268d1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -495,7 +495,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 			 void *token)
 {
 	u64 mrsigner[4];
-	int i, j, k;
+	int i, j;
 	void *addr;
 	int ret;
 
@@ -544,8 +544,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 			preempt_disable();
 
-			for (k = 0; k < 4; k++)
-				wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + k, mrsigner[k]);
+			sgx_update_lepubkeyhash(mrsigner);
 
 			ret = __einit(sigstruct, token, addr);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index bdda631c975b..1cf1f0f058b8 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -697,6 +697,14 @@ static bool __init sgx_page_cache_init(void)
 	return true;
 }
 
+void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
+}
+
 static void __init sgx_init(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 509f2af33e1d..ccd4f145c464 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -83,4 +83,6 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
 
+void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
+
 #endif /* _X86_SGX_H */
-- 
2.29.2

