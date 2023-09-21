Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B76E7D0AE
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Sep 2023 20:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjIUUap (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjIUUa3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Sep 2023 16:30:29 -0400
Received: from icts-p-cavspool-1.kulnet.kuleuven.be (icts-p-cavspool-1.kulnet.kuleuven.be [134.58.240.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9654F8CC99;
        Thu, 21 Sep 2023 10:42:40 -0700 (PDT)
Received: from icts-p-cavuit-4.kulnet.kuleuven.be (icts-p-cavuit-4.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:134])
        by icts-p-cavspool-1.kulnet.kuleuven.be (Postfix) with ESMTP id E8F7F29C9;
        Thu, 21 Sep 2023 16:37:01 +0200 (CEST)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 25D61144.A1983
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-0.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:140:242:ac11:1d])
        by icts-p-cavuit-4.kulnet.kuleuven.be (Postfix) with ESMTP id 25D61144;
        Thu, 21 Sep 2023 16:36:39 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_SIGNED#0.00,SA-HVU#DKIM_VALID#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1695306999;
        bh=G6MSMTKkZN7DyiwjN3c8ohciKNBn5ePbhZJEt6SrDZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NILEj4xVP98rUEUpRGLGl6kZ5Ot8IqZa0Xm6I2MnIGbEcshIW5yd2zVK0J6URzDa8
         d1EyUJbFK4KCen8Xua9RxnGlCft0S8SuzXu2Pz4xvD5RKu0MIJqVyFSjGPy+uQCQA5
         CXL0VszRmpvrbk82VPG4MVaLsOtQJqKzgj1UHW8M=
Received: from localhost.localdomain (ptr-82s0fs8p4onqm1q5sl7.18120a2.ip6.access.telenet.be [IPv6:2a02:1811:d31:8b00:c962:1db3:c9ed:fdfb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-0.kuleuven.be (Postfix) with ESMTPSA id E19CBD4F30837;
        Thu, 21 Sep 2023 16:36:38 +0200 (CEST)
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
To:     jarkko@kernel.org, kai.huang@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@linux.intel.com,
        Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Subject: [PATCH v6 06/13] selftests/sgx: Remove redundant enclave base address save/restore
Date:   Thu, 21 Sep 2023 16:35:57 +0200
Message-Id: <20230921143604.6561-7-jo.vanbulck@cs.kuleuven.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230921143604.6561-1-jo.vanbulck@cs.kuleuven.be>
References: <20230921143604.6561-1-jo.vanbulck@cs.kuleuven.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove redundant push/pop pair that stores and restores the enclave base
address in the test enclave, as it is never used after the pop and can
anyway be easily retrieved via the __encl_base symbol.

Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Acked-by: Kai Huang <kai.huang@intel.com>
---
 tools/testing/selftests/sgx/test_encl_bootstrap.S | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/sgx/test_encl_bootstrap.S b/tools/testing/selftests/sgx/test_encl_bootstrap.S
index 03ae0f57e29d..e0ce993d3f2c 100644
--- a/tools/testing/selftests/sgx/test_encl_bootstrap.S
+++ b/tools/testing/selftests/sgx/test_encl_bootstrap.S
@@ -55,12 +55,9 @@ encl_entry_core:
 	push	%rax
 
 	push	%rcx # push the address after EENTER
-	push	%rbx # push the enclave base address
 
 	call	encl_body
 
-	pop	%rbx # pop the enclave base address
-
 	/* Clear volatile GPRs, except RAX (EEXIT function). */
 	xor     %rcx, %rcx
 	xor     %rdx, %rdx
-- 
2.25.1

