Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E0FC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 07:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46FB64F69
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 07:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbhCSHW5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 03:22:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:8484 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234181AbhCSHWy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 03:22:54 -0400
IronPort-SDR: go/EJmHaj35m9TJWRLKXLibMP6ocsVkBr9j19WoNa4qtXE40X3l70B76tzT3uaVh0SurbrqYj2
 be6jFuqQ6G/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="187490567"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="187490567"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:22:54 -0700
IronPort-SDR: D2j64iHsI7lcvJwBUGL3za+jOdxaew+LM5d8nKSMyOLPSk5LlNC8XWZjWsX+ZKCuj6LyV7VcUW
 5hGsFlTOFMTw==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409215"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:22:47 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 04/25] x86/sgx: Add SGX_CHILD_PRESENT hardware error code
Date:   Fri, 19 Mar 2021 20:22:20 +1300
Message-Id: <050b198e882afde7e6eba8e6a0d4da39161dbb5a.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

SGX driver can accurately track how enclave pages are used.  This
enables SECS to be specifically targeted and EREMOVE'd only after all
child pages have been EREMOVE'd.  This ensures that SGX driver will
never encounter SGX_CHILD_PRESENT in normal operation.

Virtual EPC is different.  The host does not track how EPC pages are
used by the guest, so it cannot guarantee EREMOVE success.  It might,
for instance, encounter a SECS with a non-zero child count.

Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
the SGX virtualization driver to handle recoverable EREMOVE errors when
saniziting EPC pages after they are freed.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/arch.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
index dd7602c44c72..abf99bb71fdc 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/kernel/cpu/sgx/arch.h
@@ -26,12 +26,14 @@
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
  *				been completed yet.
+ * %SGX_CHILD_PRESENT		SECS has child pages present in the EPC.
  * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
 	SGX_NOT_TRACKED			= 11,
+	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_UNMASKED_EVENT		= 128,
 };
-- 
2.30.2

