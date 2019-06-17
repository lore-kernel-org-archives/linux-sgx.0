Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACECC31E5D
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 020FA20861
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfFQWYt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:43046 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfFQWYt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:24:47 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 15:24:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v3 02/12] x86/sgx: Do not naturally align MAP_FIXED address
Date:   Mon, 17 Jun 2019 15:24:28 -0700
Message-Id: <20190617222438.2080-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX enclaves have an associated Enclave Linear Range (ELRANGE) that is
tracked and enforced by the CPU using a base+mask approach, similar to
how hardware range registers such as the variable MTRRs.  As a result,
the ELRANGE must be naturally sized and aligned.

To reduce boilerplate code that would be needed in every userspace
enclave loader, the SGX driver naturally aligns the mmap() address and
also requires the range to be naturally sized.  Unfortunately, SGX fails
to grant a waiver to the MAP_FIXED case, e.g. incorrectly rejects mmap()
if userspace is attempting to map a small slice of an existing enclave.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 03eca4bccee1..d7de4d9aea87 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -105,7 +105,13 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
 					   unsigned long pgoff,
 					   unsigned long flags)
 {
-	if (len < 2 * PAGE_SIZE || len & (len - 1) || flags & MAP_PRIVATE)
+	if (flags & MAP_PRIVATE)
+		return -EINVAL;
+
+	if (flags & MAP_FIXED)
+		return addr;
+
+	if (len < 2 * PAGE_SIZE || len & (len - 1))
 		return -EINVAL;
 
 	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
-- 
2.21.0

