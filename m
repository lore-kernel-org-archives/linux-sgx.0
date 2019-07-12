Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915C1C742A8
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E5E216B7
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfGLD4J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:56:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:47871 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbfGLD4J (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:56:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:56:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="160273422"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga008.jf.intel.com with ESMTP; 11 Jul 2019 20:56:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21] x86/sgx: Flush work if and only if the work struct has been init'd
Date:   Thu, 11 Jul 2019 20:56:06 -0700
Message-Id: <20190712035606.6056-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

flush_work() complains if it is invoked with a null work function, and
the enclave's work function isn't initialized until the create ioctl().

WARNING: CPU: 10 PID: 1619 at linux/kernel/workqueue.c:3031 __flush_work+0x198/0x1b0
Modules linked in:
CPU: 10 PID: 1619 Comm: lsdt Tainted: G        W         5.2.0-rc2+ #651
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
RIP: 0010:__flush_work+0x198/0x1b0
Code: <0f> 0b 31 c0 eb b7 e8 4d fa fd ff 0f 1f 00 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffffc900011b7c60 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88846c79a020 RCX: 0000000000000000
RDX: ffff888465cc8000 RSI: 0000000000000000 RDI: ffff88846c79a240
RBP: ffff88846c79a240 R08: 0000000000000000 R09: 0000000000000000
R10: ffff8884683aba10 R11: 0000000000000001 R12: ffff88846c79a050
R13: ffff88846c79a040 R14: dead000000000200 R15: ffff88846d447f00
FS:  00007f110c801700(0000) GS:ffff88846fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c420009b80 CR3: 0000000005009003 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? kmem_cache_free+0x187/0x1b0
 sgx_release+0xa8/0xd0
 __fput+0xad/0x210
 task_work_run+0x84/0xa0
 do_exit+0x2db/0xb40
 do_group_exit+0x3a/0xa0
 get_signal+0x14e/0x7b0
 do_signal+0x30/0x680
 ? __x64_sys_futex+0x134/0x180
 exit_to_usermode_loop+0x61/0xd0
 do_syscall_64+0xfb/0x120
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 2d1943c13879..45e2dd8c2845 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -51,7 +51,8 @@ static int sgx_release(struct inode *inode, struct file *file)
 	encl->flags |= SGX_ENCL_DEAD;
 	mutex_unlock(&encl->lock);
 
-	flush_work(&encl->work);
+	if (encl->work.func)
+		flush_work(&encl->work);
 	kref_put(&encl->refcount, sgx_encl_release);
 
 	return 0;
-- 
2.22.0

