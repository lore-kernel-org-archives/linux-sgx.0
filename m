Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B251BC3A5A6
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895662186A
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfH0ANa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 20:13:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:1582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfH0ANa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 20:13:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 17:11:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,435,1559545200"; 
   d="scan'208";a="171021242"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 26 Aug 2019 17:11:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 2/4] x86/sgx: Preserved allowed attributes during SGX_IOC_ENCLAVE_CREATE
Date:   Mon, 26 Aug 2019 17:11:26 -0700
Message-Id: <20190827001128.25066-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827001128.25066-1-sean.j.christopherson@intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Preserve any existing attributes set via ENCLAVE_SET_ATTRIBUTE when
setting the always allowed attributes during ENCLAVE_CREATE.  There is
no requirement that ENCLAVE_SET_ATTRIBUTE can only be called after the
enclave is created.

Note, this does not fix a race condition between ENCLAVE_CREATE and
ENCLAVE_SET_ATTRIBUTE, as the latter doesn't take encl->lock.  This will
be addressed in a future patch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 7134d68aecb3..103851babc75 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -232,7 +232,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	encl->secs.encl = encl;
 	encl->secs_attributes = secs->attributes;
-	encl->allowed_attributes = SGX_ATTR_ALLOWED_MASK;
+	encl->allowed_attributes |= SGX_ATTR_ALLOWED_MASK;
 	encl->base = secs->base;
 	encl->size = secs->size;
 	encl->ssaframesize = secs->ssa_frame_size;
-- 
2.22.0

