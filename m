Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C1EC433E3
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBFA2082F
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgGPNzt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:55:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:3709 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgGPNzt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:55:49 -0400
IronPort-SDR: aIUu1wy8ZCtLFcPtNv7B0ojtJxap6OcF+fNivX3D51V+0Ae2kaSLGSrFbKP9XFxqu9SWpc10JY
 C6PwqwSv9dgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137503104"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="137503104"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:55:42 -0700
IronPort-SDR: B4HalyJrsEM8N/ae32r6qbEtX7zWufdSx74IGi0JnQJHSpsFR6gjSFx7/O/WNot/3dOPe6M1uO
 4ShV7/gXMiKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150392"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:55:21 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 10/24] mm: Add vm_ops->mprotect()
Date:   Thu, 16 Jul 2020 16:52:49 +0300
Message-Id: <20200716135303.276442-11-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add vm_ops()->mprotect() for additional constraints for a VMA.

Intel Software Guard eXtensions (SGX) will use this callback to add two
constraints:

1. Verify that the address range does not have holes: each page address
   must be filled with an enclave page.
2. Verify that VMA permissions won't surpass the permissions of any enclave
   page within the address range. Enclave cryptographically sealed
   permissions for each page address that set the upper limit for possible
   VMA permissions. Not respecting this can cause #GP's to be emitted.

Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/linux/mm.h | 3 +++
 mm/mprotect.c      | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dc7b87310c10..458e8cb99aaf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -542,6 +542,9 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
+	int (*mprotect)(struct vm_area_struct *vma,
+			struct vm_area_struct **pprev, unsigned long start,
+			unsigned long end, unsigned long newflags);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ce8b8a5eacbb..f170f3da8a4f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -610,7 +610,10 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
+		if (vma->vm_ops && vma->vm_ops->mprotect)
+			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp, newflags);
+		else
+			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
 		nstart = tmp;
-- 
2.25.1

