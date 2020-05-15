Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29825C433E1
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF0AC20727
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgEOApx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 20:45:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:44619 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgEOApx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 20:45:53 -0400
IronPort-SDR: yA8GHZaXQ03esXhBLAn7ehrNxcwCweavzpNIiAnzh5R9iy44DY1DjcgahCLivwL1CcEt35sbxP
 KHaaZPL0gagg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 17:45:52 -0700
IronPort-SDR: 6vwB3z44MgpBrcpqO/AB/BLxmqW4r6CLWxvt793HZ7JFIrujYrgEWhMI17RZaVQGuGrB3Af/N6
 m0ObU+2hDaMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,393,1583222400"; 
   d="scan'208";a="253644211"
Received: from ashadrin-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.38.112])
  by fmsmga008.fm.intel.com with ESMTP; 14 May 2020 17:45:45 -0700
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
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v30 09/20] mm: Introduce vm_ops->may_mprotect()
Date:   Fri, 15 May 2020 03:43:59 +0300
Message-Id: <20200515004410.723949-10-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
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
Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5a323422d783..dbcc2846b3b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -546,6 +546,8 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
+	int (*may_mprotect)(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long prot);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 494192ca954b..079ba92df377 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -603,13 +603,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
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
2.25.1

