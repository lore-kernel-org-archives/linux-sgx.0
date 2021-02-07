Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DF5C433DB
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Feb 2021 22:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2730964E35
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Feb 2021 22:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBGWOy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Feb 2021 17:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGWOx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Feb 2021 17:14:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D6AF64DEE;
        Sun,  7 Feb 2021 22:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612736052;
        bh=yLI+r9yxF4Usf8nmWDKhF8GsMG4dnZXjsjBHn97UbFA=;
        h=From:To:Cc:Subject:Date:From;
        b=pjN08tdXYOqee5+QsBDHbxXXQ72z6Q2HoAJH+PQdR6sqaWHagDVPO3cLUP7Zd0p3C
         WgdSG02zADag9+UkzedE6vX0CuAFpfVxbuKXBnpD5239yR2QVzQPjQfMNDzKvT7Kjv
         j7cKthdU4enD2/9VPE+4oa0ZkR1kl5BdcLPxurJfHruYJN2Tpgn6DuFiD+ey5r6o5W
         XrpFKs/DwsfwWcv9o3tnpLsVSBKhrYXqJlykVLAdi9faRCRWPGL/pp8h6s+k0iSSnd
         BDm0QqsIMZr35GDOCTHP3HXBcrS/7hQorvy+qo9+K97U4ZtcRQtk04aIt7wzxE5WKO
         bAM0WBc5pph4Q==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8] x86/sgx: Maintain encl->refcount for each encl->mm_list entry
Date:   Mon,  8 Feb 2021 00:14:01 +0200
Message-Id: <20210207221401.29933-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This has been shown in tests:

[  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100

This is essentially a use-after free, although SRCU notices it as
an SRCU cleanup in an invalid context.

== Background ==

SGX has a data structure (struct sgx_encl_mm) which keeps per-mm SGX
metadata.  This is separate from 'struct sgx_encl' because, in theory,
an enclave can be mapped from more than one mm.  sgx_encl_mm includes
a pointer back to the sgx_encl.

This means that sgx_encl must have a longer lifetime than all of the
sgx_encl_mm's that point to it.  That's usually the case: sgx_encl_mm
is freed only after the mmu_notifier is unregistered in sgx_release().

However, there's a race.  If the process is exiting,
sgx_mmu_notifier_release() can be called in parallel with sgx_release()
instead of being called *by* it.  The mmu_notifier path keeps encl_mm
alive past when sgx_encl can be freed.  This inverts the lifetime rules
and means that sgx_mmu_notifier_release() can access a freed sgx_encl.

== Fix ==

Increase encl->refcount when encl_mm->encl is established. Release
this reference encl_mm is freed.  This ensures that 'encl' outlives
'encl_mm'.

Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
Cc: Dave Hansen <dave.hansen@linux.intel.com
Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v8:
- Slight adjustments on call sites suggested by Dave, to make things
  more clear and obvious. Otherwise, semantically same as v7:
  https://lore.kernel.org/linux-sgx/b874673d-9d58-0d6f-ce2d-ef4d33ac5115@intel.com/
  Contains also long description written by Dave.
v7:
- No changes from v6. Resend of
  https://patchwork.kernel.org/project/intel-sgx/patch/20210204143845.39697-1-jarkko@kernel.org/
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

 arch/x86/kernel/cpu/sgx/driver.c | 3 +++
 arch/x86/kernel/cpu/sgx/encl.c   | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..8ce6d8371cfb 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -72,6 +72,9 @@ static int sgx_release(struct inode *inode, struct file *file)
 		synchronize_srcu(&encl->srcu);
 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
 		kfree(encl_mm);
+
+		/* 'encl_mm' is gone, put encl_mm->encl reference: */
+		kref_put(&encl->refcount, sgx_encl_release);
 	}
 
 	kref_put(&encl->refcount, sgx_encl_release);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 20a2dd5ba2b4..7449ef33f081 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -473,6 +473,9 @@ static void sgx_mmu_notifier_free(struct mmu_notifier *mn)
 {
 	struct sgx_encl_mm *encl_mm = container_of(mn, struct sgx_encl_mm, mmu_notifier);
 
+	/* 'encl_mm' is going away, put encl_mm->encl reference: */
+	kref_put(&encl_mm->encl->refcount, sgx_encl_release);
+
 	kfree(encl_mm);
 }
 
@@ -526,6 +529,8 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	if (!encl_mm)
 		return -ENOMEM;
 
+	/* Grab a refcount for the encl_mm->encl reference: */
+	kref_get(&encl->refcount);
 	encl_mm->encl = encl;
 	encl_mm->mm = mm;
 	encl_mm->mmu_notifier.ops = &sgx_mmu_notifier_ops;
-- 
2.30.0

