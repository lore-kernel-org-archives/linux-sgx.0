Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92527C4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 21:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5852222D06
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 21:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgLOVl0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 16:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbgLOVlY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Dec 2020 16:41:24 -0500
From:   Jarkko Sakkinen <jarkko@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Date:   Tue, 15 Dec 2020 23:40:28 +0200
Message-Id: <20201215214028.55352-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
period initiated by sgx_mmu_notifier_release().

A trivial example of a failing sequence with tasks A and B:

1. A: -> sgx_release()
2. B: -> sgx_mmu_notifier_release()
3. B: -> list_del_rcu()
3. A: -> sgx_encl_release()
4. A: -> cleanup_srcu_struct()

The loop in sgx_release() observes an empty list because B has removed its
entry in the middle, and calls cleanup_srcu_struct() before B has a chance
to calls synchronize_srcu().

Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ee50a5010277..fe7256db6e73 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -438,6 +438,12 @@ void sgx_encl_release(struct kref *ref)
 	if (encl->backing)
 		fput(encl->backing);
 
+	/*
+	 * Each sgx_mmu_notifier_release() starts a grace period. Therefore, an
+	 * additional sync is required here.
+	 */
+	synchronize_srcu_expedited(&encl->srcu);
+
 	cleanup_srcu_struct(&encl->srcu);
 
 	WARN_ON_ONCE(!list_empty(&encl->mm_list));
-- 
2.27.0

