Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF3DC433DB
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 22:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8F164F51
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 22:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhBEWdg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:33:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhBEOOr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Feb 2021 09:14:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7877A650E9;
        Fri,  5 Feb 2021 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612538158;
        bh=1sEW+rtg5YJG4p9Obi9qq7oVcTQWtSvG+Gb0mHpyNM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5uGP6H8vyQLn3hzvdc2oI0Wsj9H6KabWgkB55CVhy4/bzpnBs0BiswDlXtPUmTbz
         8/25XHXXGAWByLz7F5mw338mbqRJBMoSJ7xQm2OgFgRxADCVTQdy4S0fl1Z23q926T
         RZw3qoyeT5q1129rgHxO4RY20YtM77/6CSP2+luxZ8C2GEvapWEyeLJKC5pci+K1Sz
         9u+r6KugDyXp9m9fKM5c4QdT+626TfCFzRicUvPTyOt8Wpe/4HHxrpELrjDowNXx+l
         8VzuGXbJZ/7BoxZYUA6g1/0BuPzM6sBktPnYMZCXu50vQ2ZfTDeTO3IHJoT8eGZ22+
         +RMe63td2tJGQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     sgx@eclists.intel.com
Cc:     dave.hansen@intel.com, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86/sgx: Maintain encl->refcount for each encl->mm_list entry
Date:   Fri,  5 Feb 2021 17:15:45 +0200
Message-Id: <20210205151546.144810-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205151546.144810-1-jarkko@kernel.org>
References: <20210205151546.144810-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This has been shown in tests:

[  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100

There are two functions that drain encl->mm_list:

- sgx_release() (i.e. VFS release) removes the remaining mm_list entries.
- sgx_mmu_notifier_release() removes mm_list entry for the registered
  process, if it still exists.

If encl->refcount is taken only for VFS, this can lead to
sgx_encl_release() being executed before sgx_mmu_notifier_release()
completes, which is exactly what happens in the above klog entry.

Each process also needs its own enclave reference.

In order to fix the race condition, increase encl->refcount when an
entry to encl->mm_list added for a process. Release this reference
when the mm_list entry is cleaned up, either in
sgx_mmu_notifier_release() or sgx_release().

Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v7:
- Same as v6 but v6 was missing cc to Dave. Thus, also the
  MAINTAINERS update.
v6:
- Maintain refcount for each encl->mm_list entry.
v5:
- To make sure that the instance does not get deleted use kref_get()
  kref_put(). This also removes the need for additional
  synchronize_srcu().
v4:
- Rewrite the commit message.
- Just change the call order. *_expedited() is out of scope for this
  bug fix.
v3: Fine-tuned tags, and added missing change log for v2.
v2: Switch to synchronize_srcu_expedited().
 arch/x86/kernel/cpu/sgx/driver.c | 6 ++++++
 arch/x86/kernel/cpu/sgx/encl.c   | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..8d8fcc91c0d6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -72,6 +72,12 @@ static int sgx_release(struct inode *inode, struct file *file)
 		synchronize_srcu(&encl->srcu);
 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
 		kfree(encl_mm);
+
+		/*
+		 * Release the mm_list reference, as sgx_mmu_notifier_release()
+		 * will only do this only, when it grabs encl_mm.
+		 */
+		kref_put(&encl->refcount, sgx_encl_release);
 	}
 
 	kref_put(&encl->refcount, sgx_encl_release);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ee50a5010277..c1d9c86c0265 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -474,6 +474,7 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 	if (tmp == encl_mm) {
 		synchronize_srcu(&encl_mm->encl->srcu);
 		mmu_notifier_put(mn);
+		kref_put(&encl_mm->encl->refcount, sgx_encl_release);
 	}
 }
 
@@ -545,6 +546,13 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	}
 
 	spin_lock(&encl->mm_lock);
+
+	/*
+	 * Take a reference to guarantee that the enclave is not destroyed,
+	 * while sgx_mmu_notifier_release() is active.
+	 */
+	kref_get(&encl->refcount);
+
 	list_add_rcu(&encl_mm->list, &encl->mm_list);
 	/* Pairs with smp_rmb() in sgx_reclaimer_block(). */
 	smp_wmb();
-- 
2.30.0

