Return-Path: <SRS0=Mf4r=CX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EA6C43461
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 14:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB598207EA
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 14:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgINOpH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:45:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:15048 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbgINOoe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Sep 2020 10:44:34 -0400
IronPort-SDR: gLXOQCAvKoEuhFVmbG87PNg1e2d1W1cfVCQsxA3TqH8C2ZktQoNxrk9KjVZiyzEV/lifpE7XZv
 F7kK/VsvLNJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="223270538"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="223270538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 07:44:25 -0700
IronPort-SDR: XTabWNCG/ktPKxOdZQh6U1r+3GHeDJGFx3vJquH6qmEeBdBuIwT1TiQMHK4SCI/i05vHNOoEfN
 XMMCcfrlgwuQ==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="482364573"
Received: from jarea-mobl.ger.corp.intel.com (HELO localhost) ([10.249.44.206])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 07:44:23 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH] x86/sgx: Fine-tune page adding flow
Date:   Mon, 14 Sep 2020 17:44:13 +0300
Message-Id: <20200914144413.21858-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Make semantics follow more closely read()-syscall:

- A signal when nothing is yet processed results -EINTR.
- A signal when at least one page is processed results the length
  of the data processed.

Link: https://man7.org/linux/man-pages/man2/read.2.html
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 0ae00fa9b589..274557f66de2 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -530,7 +530,12 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		return -EINVAL;
 
 	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
-		if (c == SGX_MAX_ADD_PAGES_LENGTH || signal_pending(current)) {
+		if (signal_pending(current)) {
+			ret = c == 0 ? -EINTR : c;
+			break;
+		}
+
+		if (c == SGX_MAX_ADD_PAGES_LENGTH) {
 			ret = c;
 			break;
 		}
-- 
2.25.1

