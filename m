Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2903DC46466
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F294E22211
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJCEvc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 00:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgJCEv1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 00:51:27 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4F9221EA;
        Sat,  3 Oct 2020 04:51:26 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v39 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Date:   Sat,  3 Oct 2020 07:50:45 +0300
Message-Id: <20201003045059.665934-11-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Background
==========

1. SGX enclave pages are populated with data by copying data to them from
   normal memory via an ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES).
2. It is desirable to be able to restrict those normal memory data sources.
   For instance, to ensure that the source data is executable before
   copying data to an executable enclave page.
3. Enclave page permissions are dynamic (just like normal permissions) and
   can be adjusted at runtime with mprotect().
4. The original data source may have long since vanished at the time when
   enclave page permissions are established (mmap() or mprotect()).

The solution (elsewhere in this series) is to force enclaves creators to
declare their paging permission *intent* up front to the ioctl().  This
intent can me immediately compared to the source data’s mapping (and
rejected if necessary).

The intent is also stashed off for later comparison with enclave PTEs.
This ensures that any future mmap()/mprotect() operations performed by the
enclave creator or done on behalf of the enclave can be compared with the
earlier declared permissions.

Problem
=======

There is an existing mmap() hook which allows SGX to perform this
permission comparison at mmap() time.  However, there is no corresponding
->mprotect() hook.

Solution
========

Add a vm_ops->mprotect() hook so that mprotect() operations which are
inconsistent with any page's stashed intent can be rejected by the driver.

Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/linux/mm.h | 3 +++
 mm/mprotect.c      | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b2f370f0b420..dca57fe80555 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -551,6 +551,9 @@ struct vm_operations_struct {
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

