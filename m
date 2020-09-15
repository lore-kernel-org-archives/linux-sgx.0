Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2887CC433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D9320936
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="D6Njy2w5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgIPAyV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgIOLbo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Sep 2020 07:31:44 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA367C0612F2;
        Tue, 15 Sep 2020 04:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MfOGRytcH2FHakhj47oIMso8mjtUF700XLSJEE9DUHg=; b=D6Njy2w5GBx2AZNi0hg8uJomZA
        ktTNispwAzhgG8ycM1T5BuNQmd8oEFXtNjjv+mCr/Q85kaidk1sxRJb4dHQPa1yIlqC4oDY1b1bqu
        3bTsuqBnGQNW2dlS3wJzlm4NdOwI0BlA+t5UbP9E/D+F7NlhwN0IcOQeErPVhTPzI+VUNpwPZRmHB
        MOKYktqCQ/65yLxJbebdrQ8T+IBKjuJ1A2QHbj1w6U6CvbF3CNvlnrb+w/A4lz4+SJqlQ0TJ/Z515
        alJTPGzJLhBlc00eNzI2oKdY7XBYZRjUSq0jNMhHcJx6Ra0u/XPh+Xojwg5ggsujd+/JpqM9fkBhB
        6bDj9x2Q==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jjs@kapsi.fi>)
        id 1kI98k-0000ja-1X; Tue, 15 Sep 2020 14:28:50 +0300
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
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Date:   Tue, 15 Sep 2020 14:28:28 +0300
Message-Id: <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jjs@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
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
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/linux/mm.h | 3 +++
 mm/mprotect.c      | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 97c83773b6f0..717726fcace6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -547,6 +547,9 @@ struct vm_operations_struct {
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

