Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CF3C43333
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Feb 2021 11:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEBC264E8A
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Feb 2021 11:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhBHLAL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Feb 2021 06:00:11 -0500
Received: from mga17.intel.com ([192.55.52.151]:43443 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232837AbhBHK6W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Feb 2021 05:58:22 -0500
IronPort-SDR: NAtJpM4vWl2bbLGlbZgfbx8Qa5AMHVylLkCbhgdwkO1eKHSuXzz5wuRPcF735KP7VlmH8CoiLS
 GvdS9Elv3byw==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="161443931"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="161443931"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:55:21 -0800
IronPort-SDR: yyJ+SO9MgqzZ9M3pfQ6PiRrT5gY4+ZK6m/pZulHhSjQhZy9gpd5KGbaPDS8rJL/gkg7JkOTKEJ
 ViXRf7G/AmWg==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374451109"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:55:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 10/26] x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
Date:   Mon,  8 Feb 2021 23:54:53 +1300
Message-Id: <99ee8ed32c15885ec6e9be52f15d479ac0a7eb4e.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Define the ENCLS leafs that are available with SGX2, also referred to as
Enclave Dynamic Memory Management (EDMM).  The leafs will be used by KVM
to conditionally expose SGX2 capabilities to guests.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 3dbe7aacf552..756c8dacc52a 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -35,6 +35,9 @@ enum sgx_encls_function {
 	EPA	= 0x0A,
 	EWB	= 0x0B,
 	ETRACK	= 0x0C,
+	EAUG	= 0x0D,
+	EMODPR	= 0x0E,
+	EMODT	= 0x0F,
 };
 
 /**
-- 
2.29.2

