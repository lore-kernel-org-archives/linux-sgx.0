Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52226C4321E
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 10:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbiETKln (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 06:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348242AbiETKlA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 06:41:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503001261E
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 03:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653043259; x=1684579259;
  h=from:to:cc:subject:date:message-id;
  bh=DOgMKPEx9vSZBWNLCmG9drJ813hPaa1JkoLavtuFKrA=;
  b=VfhK+fb6dDW/FeT5BVhduRiQyz8J+n7ZYPUK8IGLbWZ8p9hgNgLWwePs
   F36s6N4UiM/h+aPone4w3D4UUSrfckjVv1Zn1lHZYpqrmilP0deyWLhuX
   hk1BhO8TAh/F8hGnQmk2A7+5h2PzeH3jsLyTpfZCKt+SVWxjkH1JQY47X
   f7qsbdTFC2RG3+ZiVmHAp1tSIvDugvD8UzCWg9vB5JqNGfzHQUGORYZ3/
   LiIETp2A3fEXxmq6g+qEb7cB0NG5WgTHMMkguUx+NMNVbsrkQH0+Y0ML/
   EUrZGn7RIQqKZ9zjKlj2nvQ9W5H1KtoychNeXb9fAnc8hCGG4vTG7x7xu
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271386912"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271386912"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 03:40:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715470945"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2022 03:40:55 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v5 0/9] Support microcode updates affecting SGX
Date:   Fri, 20 May 2022 18:38:55 +0800
Message-Id: <20220520103904.1216-1-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

v4:
https://lore.kernel.org/all/2682d32989ea40578065b2c14ef20b19@intel.com/T/

Changes since v4:
 - Add "goto err" for *if* branch and remove *else* branch for less
   branching for common (success) case in sgx_ioc_enclave_create().
   (Jarkko Sakkinen)
 - Add back the blank line removed unintenitonally in encl.h.
   (Jarkko Sakkinen)
 - Move *-EBUSY* into one line in the three sgx_zap_* functions'
   annotates. (Jarkko Sakkinen).
 - Remove #include <asm/sgx.h> from microcode.h which is not needed.
   (Borislav Petkov)

Changes since v3:
 - Refine the comments when sgx_update_cpusvn_intel() is called by
   microcode_check(). (suggested by Borislav Petkov, Dave Hansen)
 - Rename update_cpusvn_intel() as sgx_update_cpusvn_intel().
   (suggested by Dave Hansen)
 - Define both the 'static inline' stub *and* the declaration for
   sgx_update_cpusvn_intel() in sgx.h. (suggested by Dave Hansen)
 - Squash patch "x86/sgx: Provide VA page non-NULL owner" and
   "x86/sgx: Save enclave pointer for VA page". Update commit log.
   (suggested by Jarkko Sakkinen)
 - Rename SGX_EPC_PAGE_GUEST as SGX_EPC_PAGE_KVM_GUEST. (suggested by
   Jarkko, Sakkinen)
 - Refer to changelogs for other changes.

Changes since v2:
 - Changes are made in patch "x86/sgx: Introduce mechanism to prevent
   new initializations of EPC pages" by moving SGX2 related changes out.
   It allows this series to be applied on tip/x86/sgx branch with only
   picking up some auxiliary changes from SGX2 series, rather than
   depend on the whole set. (Jarkko Sakkinen, Reinette Chatre)

Changes since v1:
 - Remove the sysfs file svnupdate. (Thomas Gleixner, Dave Hansen)
 - Let late microcode load path call ENCLS[EUPDATESVN] procedure
   directly. (Borislav Petkov)
 - Update cover letter by removing saying that "...triggered by
   administrators via sysfs...".
 - Drop the patch for documentation change.

cover letter:

== General Microcode Background ==

Historically, microcode updates are applied by the BIOS or early in
boot. In recent years, several trends have made these old approaches
less palatable.

First, the cadence of microcode updates has increased to deliver
security mitigations. Second, the value of those updates has increased,
meaning that any delay in applying them is unacceptable. Third, users
have become accustomed to approaches like hot patching their kernels
and have a growing aversion to reboots in general.

Users want microcode updates to behave more like a hot patching a
kernel and less like a BIOS update.

== SGX Attestation Background ==

SGX enclaves have an attestation mechanism. An enclave might, for
instance, need to attest to its state before it is given a special
decryption key. Since SGX must trust the CPU microcode, attestation
incorporates the microcode versions of all processors on the system
and is affected by microcode updates. This allows the entity to which
the enclave is attesting to make deployment decisions based on the
microcode version. For example, an enclave might be denied a decryption
key if it runs on a system that has old microcode without a specific
mitigation.

Unfortunately, this attestation metric (called CPUSVN) is only a
snapshot. When the kernel first uses SGX (successfully executes any
ENCLS instruction), SGX inspects all CPUs in the system and incorporates
a record of their microcode versions into CPUSVN. Today, that value is
locked and is not updated until a reboot.

== Problems ==

This means that, although the microcode may be update, enclaves can
never attest to this fact. Enclaves are stuck attesting to the old
version until a reboot.

Old enclaves created before the microcode update are presumed to be
compromised must not be allowed to attest with the new microcode
version.

== Solution ==

EUPDATESVN is a new SGX instruction which allows enclave attestation
to include information about updated microcode without a reboot.

Whenever a microcode update affects SGX, the SGX attestation
architecture assumes that all running enclaves and cryptographic
assets (like internal SGX encryption keys) have been compromised.
To mitigate the impact of this presumed compromise, EUPDATESVN success
requires that all SGX memory to be marked as "unused" and its contents
destroyed. This requirement ensures that no compromised enclave can
survive the EUPDATESVN procedure and provides an opportunity to
generate new cryptographic assets.

This series implements the infrastructure needed to track and tear
down bare-metal enclaves and then run EUPDATESVN, it will be called
by the late microcode load path after the microcode update.

This is a very slow operation. It is, of course, exceedingly disruptive
to enclaves but should be infrequent as microcode updates are released
on the order of every few months. Also, this is not the first piece of
the SGX architecture which will destroy all enclave contents.

A follow-on series will add Virtual EPC (KVM guest) support.

Here is the spec for your reference:
https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true

This is series is based on tip/x86/sgx with the following additionally
applied:

"x86/sgx: Export sgx_encl_ewb_cpumask()"
https://lore.kernel.org/lkml/YnrllJ2OqmcqLUuv@kernel.org/T/#mc6d998d583c9fa512f25219f477353c3fbd214a0
"x86/sgx: Rename sgx_encl_ewb_cpumask() as sgx_encl_cpumask()"
https://lore.kernel.org/lkml/YnrllJ2OqmcqLUuv@kernel.org/T/#me953d1983c1749daeec25f86d0f3ff09cede6c7a
"x86/sgx: Make sgx_ipi_cb() available internally"
https://lore.kernel.org/lkml/YnrllJ2OqmcqLUuv@kernel.org/T/#m5f32fbecb20b34e7745d8bd30c5d133d588b15dc
"x86/sgx: Keep record of SGX page type"
https://lore.kernel.org/lkml/YnrllJ2OqmcqLUuv@kernel.org/T/#m3a218f751b2e41950068dbcccf465426d0ec771e

Cathy Zhang (9):
  x86/sgx: Introduce mechanism to prevent new initializations of EPC
    pages
  x86/sgx: Save enclave pointer for VA page
  x86/sgx: Keep record for SGX VA and Guest page type
  x86/sgx: Save the size of each EPC section
  x86/sgx: Forced EPC page zapping for EUPDATESVN
  x86/sgx: Define error codes for ENCLS[EUPDATESVN]
  x86/sgx: Implement ENCLS[EUPDATESVN]
  x86/cpu: Call ENCLS[EUPDATESVN] procedure in microcode update
  x86/sgx: Call ENCLS[EUPDATESVN] during SGX initialization

 arch/x86/include/asm/sgx.h      |  49 ++--
 arch/x86/kernel/cpu/sgx/encl.h  |   3 +-
 arch/x86/kernel/cpu/sgx/encls.h |  14 +
 arch/x86/kernel/cpu/sgx/sgx.h   |  23 +-
 arch/x86/kernel/cpu/common.c    |  10 +
 arch/x86/kernel/cpu/sgx/encl.c  |  39 ++-
 arch/x86/kernel/cpu/sgx/ioctl.c |  51 +++-
 arch/x86/kernel/cpu/sgx/main.c  | 456 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/virt.c  |  22 ++
 9 files changed, 636 insertions(+), 31 deletions(-)

-- 
2.17.1

