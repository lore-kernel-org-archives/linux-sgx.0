Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBD2C56202
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3442B22201
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwQqrGiZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgKLWCx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbgKLWCw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:52 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B8F22201;
        Thu, 12 Nov 2020 22:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218572;
        bh=ZmhXE36jtL3HtMS5ufKNwCYsk50uyD05pQfvQHhjPtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwQqrGiZ8FvcBpWtUgQK4Puj96Spdfn6UulQro7zxzl4yPt52jLe17aL7qRkiArta
         C2mc2wnK2xOIa3PEz6al5Tzo0BreT+1NKF5x1IAQc+78BHYN4nVW7Z1OroQB9G6tDX
         SMFU+lYa+wPnnvzOOyYpwCwzD6XPfMeaBF65TdsY=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: [PATCH v41 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Date:   Fri, 13 Nov 2020 00:01:21 +0200
Message-Id: <20201112220135.165028-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Background
==========

1. SGX enclave pages are populated with data by copying from normal memory
   via ioctl() (SGX_IOC_ENCLAVE_ADD_PAGES), which will be added later in
   this series.
2. It is desirable to be able to restrict those normal memory data sources.
   For instance, to ensure that the source data is executable before
   copying data to an executable enclave page.
3. Enclave page permissions are dynamic (just like normal permissions) and
   can be adjusted at runtime with mprotect().

This creates a problem because the original data source may have long since
vanished at the time when enclave page permissions are established (mmap()
or mprotect()).

The solution (elsewhere in this series) is to force enclaves creators to
declare their paging permission *intent* up front to the ioctl().  This
intent can be immediately compared to the source data’s mapping and
rejected if necessary.

The “intent” is also stashed off for later comparison with enclave
PTEs. This ensures that any future mmap()/mprotect() operations
performed by the enclave creator or done on behalf of the enclave
can be compared with the earlier declared permissions.

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
Cc: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
Acked-by: Dave Hansen <dave.hansen@intel.com> # v40
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
Changes from v40:
* Move mprotect_fixup() outside of the callback. This keeps mm internals
  outside of the callback.

 include/linux/mm.h | 7 +++++++
 mm/mprotect.c      | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index db6ae4d3fb4e..1813fa86b981 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -559,6 +559,13 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
+	/*
+	 * Called by mprotect() to make driver-specific permission
+	 * checks before mprotect() is finalised.   The VMA must not
+	 * be modified.  Returns 0 if eprotect() can proceed.
+	 */
+	int (*mprotect)(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, unsigned long newflags);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 56c02beb6041..ab709023e9aa 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -616,9 +616,16 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
+
+		if (vma->vm_ops && vma->vm_ops->mprotect)
+			error = vma->vm_ops->mprotect(vma, nstart, tmp, newflags);
+		if (error)
+			goto out;
+
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
+
 		nstart = tmp;
 
 		if (nstart < prev->vm_end)
-- 
2.27.0

