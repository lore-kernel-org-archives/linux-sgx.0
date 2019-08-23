Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11B1C3A5A4
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C323022CEC
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436661AbfHWQQh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 12:16:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:17322 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436675AbfHWQQh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 12:16:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 09:16:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="263231706"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2019 09:16:30 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 2/4] x86/sgx: Validate TCS permssions in sgx_validate_secinfo()
Date:   Fri, 23 Aug 2019 19:16:14 +0300
Message-Id: <20190823161616.27644-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
References: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The validation of TCS permissions was missing from
sgx_validate_secinfo(). This patch adds the validation.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index f9eef0f2125f..5423d7c45d5e 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -298,6 +298,13 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
 	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
 		return -EINVAL;
 
+	/*
+	 * CPU will silently overwrite the permissions as zero, which means
+	 * that we need to validate it ourselves.
+	 */
+	if (pt == SGX_SECINFO_TCS && perm)
+		return -EINVAL;
+
 	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
 		return -EINVAL;
 
-- 
2.20.1

