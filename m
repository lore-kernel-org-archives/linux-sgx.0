Return-Path: <SRS0=ol6i=4L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503C4C35671
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2892A2067D
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgBWR11 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:27:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:10522 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgBWR10 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Feb 2020 12:27:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 09:27:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,476,1574150400"; 
   d="scan'208";a="229650145"
Received: from ajbergin-mobl.ger.corp.intel.com (HELO localhost) ([10.252.23.203])
  by fmsmga007.fm.intel.com with ESMTP; 23 Feb 2020 09:27:18 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v27 09/22] mm: Introduce vm_ops->may_mprotect()
Date:   Sun, 23 Feb 2020 19:25:46 +0200
Message-Id: <20200223172559.6912-10-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add vm_ops()->may_mprotect() to check additional constrains set by a
subsystem for a mprotect() call.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 52269e56c514..ad08eb666e1c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -464,6 +464,8 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
+	int (*may_mprotect)(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long prot);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 7a8e84f86831..c0cb40e23b43 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -543,13 +543,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			goto out;
 		}
 
+		tmp = vma->vm_end;
+		if (tmp > end)
+			tmp = end;
+
+		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
+			error = vma->vm_ops->may_mprotect(vma, nstart, tmp,
+							  prot);
+			if (error)
+				goto out;
+		}
+
 		error = security_file_mprotect(vma, reqprot, prot);
 		if (error)
 			goto out;
 
-		tmp = vma->vm_end;
-		if (tmp > end)
-			tmp = end;
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
-- 
2.20.1

