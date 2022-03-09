Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EC1C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiCIKlj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiCIKli (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75548E1B
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822440; x=1678358440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=CR66GoAYRkRMDG9ffhT2KTaIYI/UrE0IVfMIcfgTB7U=;
  b=Ksh/YSEqMYb0rTmyNn/Uk8DdetEzw+VP4NDg3bP+jjQcp59qr7HIn3gl
   K5/DIIZ6n4FEBKGvP1nQNlB+2/neYI84vx5BWa8CDO1jmA08OOuPSlhZ9
   +GZf/Rf14Tl+xDvjyZnDmu+IIyAQS50c7yzB3cKYfBkjpaI18zK9NucfH
   5AnGOtIlTc4rfvp0biSQO6vj9LLc20ZiJCqBdEwxtGbRxGLXKNKI86sZC
   fYgKb1dbgetcjwgE3UGttOCK34oJE8Uf1dT1Gfu/wHo9DBBmtglZXhCwD
   xRQXEj1JsqgFzEae/4WSeplwZgxS3ONUyoe8BFW469ieZXKeC96pYEvc6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373608"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373608"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582964"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:38 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 11/11] Documentation/x86/sgx: Document EUPDATESVN sysfs file
Date:   Wed,  9 Mar 2022 18:40:50 +0800
Message-Id: <20220309104050.18207-12-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A new sysfs file /sys/devices/system/cpu/microcode/svnupdate is
provided, it allows system admin to echo 1 to trigger the CPUSVN
update process.

Document the new sysfs ABI.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 .../ABI/testing/sysfs-devices-system-cpu      | 14 ++++++
 Documentation/x86/sgx.rst                     | 43 +++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 74962c200790..785709c53325 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -687,3 +687,17 @@ Description:
 		(RO) the list of CPUs that are isolated and don't
 		participate in load balancing. These CPUs are set by
 		boot parameter "isolcpus=".
+
+What: 		/sys/devices/system/cpu/microcode/svnupdate
+Date:		Feb 2022
+Contact:	linux-sgx@vger.kernel.org
+Description:	Applying SGX Runtime Microcode Updates to Enclaves
+
+		Whenever a microcode update affects SGX, ENCLS[EUPDATESVN]
+		should be taken to update the attestation metric (called
+		CPUSVN) and generate new cryptographic assets without a
+		reboot. EUPDATESVN success requires that all SGX memory
+		be marked as "unused" and its contents destroyed.
+
+		This sysfs interface is only exposed to userspace on host,
+		to trigger enclave destruction and the EUPDATESVN operation.
diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index 4059efbb4d2e..68f82a3683d6 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -339,3 +339,46 @@ to expected failures and handle them as follows:
    first call.  It indicates a bug in the kernel or the userspace client
    if any of the second round of ``SGX_IOC_VEPC_REMOVE_ALL`` calls has
    a return code other than 0.
+
+
+Applying Runtime Microcode Updates to Enclaves
+==============================================
+
+SGX enclaves have an attestation mechanism. An enclave might, for
+instance, need to attest to its state before it is given a special
+decryption key. Since SGX must trust the CPU microcode, attestation
+incorporates the microcode versions of all processors on the system
+and is affected by microcode updates. This enables deployment
+decisions based on the microcode version. For example, an enclave
+might be denied a decryption key if it runs on a system that has
+old microcode without a specific mitigation.
+
+Unfortunately, this attestation metric (called CPUSVN) is only a
+snapshot. When the kernel first uses SGX (successfully executes any
+ENCLS instruction), SGX inspects all CPUs in the system and incorporates
+a record of their microcode versions into CPUSVN. CPUSVN is only
+automatically updated at reboot. This means that, although the
+microcode has been updated, enclaves can never attest to this fact.
+Enclaves are stuck attesting to the old version until a reboot.
+
+The SGX architecture has an alternative to these reboots: the
+ENCLS[EUPDATESVN] instruction. It allows another snapshot to be
+taken to update CPUSVN after a runtime microcode update without a
+reboot.
+
+Whenever a microcode update affects SGX, the SGX attestation
+architecture assumes that all running enclaves and cryptographic
+assets (like internal SGX encryption keys) have been compromised.
+To mitigate the impact of this presumed compromise, ENCLS[EUPDATESVN]
+success requires that all SGX memory be marked as "unused" and
+its contents destroyed. This requirement ensures that no compromised
+enclaves can survive the procedure to run ENCLS[EUPDATESVN] and
+provides an opportunity to generate new cryptographic assets.
+
+The procedure to run ENCLS[EUPDATESVN] was designed to be separate
+from the microcode update to provide flexibility to administrators.
+They can immediately update the microcode and then schedule enclave
+destruction and run ENCLS[EUPDATESVN] for a later more convenient time.
+
+Write 1 to the sysfs file: **/sys/devices/system/cpu/microcode/svnupdate**
+triggers enclave destruction and the EUPDATESVN operation.
-- 
2.17.1

