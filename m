Return-Path: <SRS0=NgZr=W6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA14C3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B7523697
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfICO2l (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:28:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:34226 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbfICO2l (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Sep 2019 10:28:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 07:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="189825976"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.39.67])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Sep 2019 07:28:34 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: [PATCH v22 11/24] mm: Introduce vm_ops->may_mprotect()
Date:   Tue,  3 Sep 2019 17:26:42 +0300
Message-Id: <20190903142655.21943-12-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
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
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0334ca97c584..405cea65057a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -469,6 +469,8 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
+	int (*may_mprotect)(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long prot);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index bf38dfbbb4b4..18732543b295 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -547,13 +547,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			goto out;
 		}
 
+		tmp = vma->vm_end;
+		if (tmp > end)
+			tmp = end;
+
+		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
+			error = vma->vm_ops->may_mprotect(vma, nstart, tmp, prot);
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

