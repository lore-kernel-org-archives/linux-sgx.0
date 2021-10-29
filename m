Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4DFC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Oct 2021 17:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D89610A0
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Oct 2021 17:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhJ2RwS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Oct 2021 13:52:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:59467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhJ2RwS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 Oct 2021 13:52:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="230980474"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="230980474"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 10:49:48 -0700
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="725022010"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 10:49:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jarkko@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: SGX documentation fixes
Date:   Fri, 29 Oct 2021 10:49:56 -0700
Message-Id: <ab99a87368eef69e3fb96f073368becff3eff874.1635529506.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX documentation fixes are:

 * Remove capitalization from regular words in the middle of a sentence.
 * Remove punctuation found in the middle of a sentence.
 * Fix name of SGX daemon to consistently be ksgxd.
 * Fix typo of SGX instruction: ENIT -> EINIT

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Documentation/x86/sgx.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..0f9300bdd65e 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -10,7 +10,7 @@ Overview
 Software Guard eXtensions (SGX) hardware enables for user space applications
 to set aside private memory regions of code and data:
 
-* Privileged (ring-0) ENCLS functions orchestrate the construction of the.
+* Privileged (ring-0) ENCLS functions orchestrate the construction of the
   regions.
 * Unprivileged (ring-3) ENCLU functions allow an application to enter and
   execute inside the regions.
@@ -91,7 +91,7 @@ In addition to the traditional compiler and linker build process, SGX has a
 separate enclave “build” process.  Enclaves must be built before they can be
 executed (entered). The first step in building an enclave is opening the
 **/dev/sgx_enclave** device.  Since enclave memory is protected from direct
-access, special privileged instructions are Then used to copy data into enclave
+access, special privileged instructions are then used to copy data into enclave
 pages and establish enclave page permissions.
 
 .. kernel-doc:: arch/x86/kernel/cpu/sgx/ioctl.c
@@ -126,13 +126,13 @@ the need to juggle signal handlers.
 ksgxd
 =====
 
-SGX support includes a kernel thread called *ksgxwapd*.
+SGX support includes a kernel thread called *ksgxd*.
 
 EPC sanitization
 ----------------
 
 ksgxd is started when SGX initializes.  Enclave memory is typically ready
-For use when the processor powers on or resets.  However, if SGX has been in
+for use when the processor powers on or resets.  However, if SGX has been in
 use since the reset, enclave pages may be in an inconsistent state.  This might
 occur after a crash and kexec() cycle, for instance.  At boot, ksgxd
 reinitializes all enclave pages so that they can be allocated and re-used.
@@ -147,7 +147,7 @@ Page reclaimer
 
 Similar to the core kswapd, ksgxd, is responsible for managing the
 overcommitment of enclave memory.  If the system runs out of enclave memory,
-*ksgxwapd* “swaps” enclave memory to normal memory.
+*ksgxd* “swaps” enclave memory to normal memory.
 
 Launch Control
 ==============
@@ -156,7 +156,7 @@ SGX provides a launch control mechanism. After all enclave pages have been
 copied, kernel executes EINIT function, which initializes the enclave. Only after
 this the CPU can execute inside the enclave.
 
-ENIT function takes an RSA-3072 signature of the enclave measurement.  The function
+EINIT function takes an RSA-3072 signature of the enclave measurement.  The function
 checks that the measurement is correct and signature is signed with the key
 hashed to the four **IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}** MSRs representing the
 SHA256 of a public key.
@@ -184,7 +184,7 @@ CPUs starting from Icelake use Total Memory Encryption (TME) in the place of
 MEE. TME-based SGX implementations do not have an integrity Merkle tree, which
 means integrity and replay-attacks are not mitigated.  B, it includes
 additional changes to prevent cipher text from being returned and SW memory
-aliases from being Created.
+aliases from being created.
 
 DMA to enclave memory is blocked by range registers on both MEE and TME systems
 (SDM section 41.10).
-- 
2.25.1

