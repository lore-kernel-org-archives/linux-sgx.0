Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF52C433FE
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Mar 2022 09:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbiCDJit (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbiCDJhz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Mar 2022 04:37:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34F91A9497;
        Fri,  4 Mar 2022 01:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 698E6617F0;
        Fri,  4 Mar 2022 09:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F8BC340EF;
        Fri,  4 Mar 2022 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646386582;
        bh=EujyeEiPrt3MuKqeeERmQkL6miuA5IFlZ3VFOCkkzXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BH/M1IwYaOPx/EZjOz6A4da38FskPpbsoFIOVCQ3xEoaP3SDyFxmxaQdauB6gX+Sn
         0iZgS7/3tUUqEJfsjJ5qVcCT9qdIOs/UZcKd64SrqbD+5X/tz7/La/KL4D4Rl2KCHp
         wL6RBv/dcq4j7Vi33rzBFywO++NJ+T6pDX9JgSzaEPYl6qPwAeYxVbnXkyif4R226Q
         CkCj3LpsLvEAhvgYN4UHp7ubz1+b9az+CjCUO1XwRIU9/5eRobPvJ6X/f2rCK0Yuq8
         BXFdGXfMvm9ufdyadvTwJFRLS8J+u06vA8vOiU5KRSoKukFGRhJjhD6iyAAS7vuxDo
         7WR88xl4zKZug==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Nathaniel McCallum <nathaniel@profian.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [RFC PATCH v2.1 04/30] x86/sgx: Add wrapper for SGX2 EAUG function
Date:   Fri,  4 Mar 2022 11:34:58 +0200
Message-Id: <20220304093524.397485-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304093524.397485-1-jarkko@kernel.org>
References: <20220304093524.397485-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

Add a wrapper for the EAUG ENCLS leaf function used to
add a page to an initialized enclave.

EAUG:
1) Stores all properties of the new enclave page in the SGX
   hardware's Enclave Page Cache Map (EPCM).
2) Sets the PENDING bit in the EPCM entry of the enclave page.
   This bit is cleared by the enclave by invoking ENCLU leaf
   function EACCEPT or EACCEPTCOPY.

Access from within the enclave to the new enclave page is not
possible until the PENDING bit is cleared.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 7a1ecf704ec1..99004b02e2ed 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -227,4 +227,10 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(EMODT, secinfo, addr);
 }
 
+/* Zero a page of EPC memory and add it to an initialized enclave. */
+static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
+{
+	return __encls_2(EAUG, pginfo, addr);
+}
+
 #endif /* _X86_ENCLS_H */
-- 
2.35.1

