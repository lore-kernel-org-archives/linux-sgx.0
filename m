Return-Path: <SRS0=g3U3=T7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332B7C04AB6
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1512425725
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfEaXch (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 31 May 2019 19:32:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:59346 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbfEaXcd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 31 May 2019 19:32:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 16:32:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2019 16:32:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: [RFC PATCH 4/9] mm: Introduce vm_ops->mprotect()
Date:   Fri, 31 May 2019 16:31:54 -0700
Message-Id: <20190531233159.30992-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX will use the mprotect() hook to prevent userspace from circumventing
various security checks, i.e. Linux Security Modules.

Enclaves are built by copying data from normal memory into the Enclave
Page Cache (EPC).  Due to the nature of SGX, the EPC is represented by a
single file that must be MAP_SHARED, i.e. mprotect() only ever sees a
single MAP_SHARED vm_file.  Furthermore, all enclaves will need read,
write and execute pages in the EPC.

As a result, LSM policies cannot be meaningfully applied, e.g. an LSM
can deny access to the EPC as a whole, but can't deny PROT_EXEC on page
that originated in a non-EXECUTE file (which is long gone by the time
mprotect() is called).

By hooking mprotect(), SGX can make explicit LSM upcalls while an
enclave is being built, i.e. when the kernel has a handle to origin of
each enclave page, and enforce the result of the LSM policy whenever
userspace maps the enclave page in the future.

Alternatively, SGX could play games with MAY_{READ,WRITE,EXEC}, but
that approach is quite ugly, e.g. would require userspace to call an
SGX ioctl() prior to using mprotect() to extend a page's protections.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e8834ac32b7..50a42364a885 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -458,6 +458,8 @@ struct vm_operations_struct {
 	void (*close)(struct vm_area_struct * area);
 	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
+	int (*mprotect)(struct vm_area_struct * area, unsigned long start,
+			unsigned long end, unsigned long prot);
 	vm_fault_t (*fault)(struct vm_fault *vmf);
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf,
 			enum page_entry_size pe_size);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index bf38dfbbb4b4..e466ca5e4fe0 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -547,13 +547,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			goto out;
 		}
 
-		error = security_file_mprotect(vma, reqprot, prot);
-		if (error)
-			goto out;
-
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
+
+		if (vma->vm_ops && vma->vm_ops->mprotect) {
+			error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
+			if (error)
+				goto out;
+		}
+
+		error = security_file_mprotect(vma, reqprot, prot);
+		if (error)
+			goto out;
+
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
-- 
2.21.0

