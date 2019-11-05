Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B23BC010A2
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61C9206BA
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfKELVF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:21:05 -0500
Received: from mga12.intel.com ([192.55.52.136]:63879 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfKELVF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 5 Nov 2019 06:21:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 03:21:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="200347521"
Received: from zpanjkov-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.3.163])
  by fmsmga008.fm.intel.com with ESMTP; 05 Nov 2019 03:21:02 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH for v24 v2 2/4] x86/sgx: Remove a subordinate clause
Date:   Tue,  5 Nov 2019 13:20:54 +0200
Message-Id: <20191105112056.21452-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The subordinate clause of last sentence of the sgx_ioc_enclave_pages()
does not provide any insight not already provided. Thus, remove it.
Also, using "i.e." (and "e.g.") in the documentation should be
considered a bad practice because it leaves it open ended.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 289af607f634..87b2fb62825a 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -468,11 +468,9 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
  * @encl:       pointer to an enclave instance (via ioctl() file pointer)
  * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
  *
- * Add (EADD) one or more pages to an uninitialized enclave, and optionally
- * extend (EEXTEND) the measurement with the contents of the page. The range of
- * pages must be virtually contiguous. The SECINFO and measurement mask are
- * applied to all pages, i.e. pages with different properties must be added in
- * separate calls.
+ * Add one or more pages to an uninitialized enclave, and optionally extend the
+ * measurement with the contents of the page. The address range of pages must
+ * be contiguous. The SECINFO and measurement mask are applied to all pages.
  *
  * A SECINFO for a TCS is required to always contain zero permissions because
  * CPU silently zeros them. Allowing anything else would cause a mismatch in
-- 
2.20.1

