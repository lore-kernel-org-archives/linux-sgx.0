Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010FEC433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343871AbiDAO0I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbiDAO0I (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A8010C52D
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823058; x=1680359058;
  h=from:to:cc:subject:date:message-id;
  bh=hLta5EUpto1mgPSiF6J29ZRMSWgnU/m0rJ2cz02yKUY=;
  b=BoNtZ8jsPuoxr35guxH7D1JxeaTO+FV3gEe6tx1dExaHqX+O/5BCxcMU
   Ugo5sU2jkfT8cIBaadohkcVyAUHGScNlFlxsyVvf0rAcNoHUvTuBayOxw
   M+NbZrGLRHMFG+dawE4mcZPs/U5PbwuvtNrSvEAcHLuvRbxoh3waiLn3e
   P1CMVFyeABgPMzOD41ksOCpLuCZWkxAJpUQK4EOxOtzFhh4vZTrbfWe4u
   ig87Wm/0vYAvrNqSZKDiPmpD/w2lCmH8HsvYZfi/hWpGSimxlKDh8ovFX
   pZb/G/rsJjdblEK4LE/8cPV/wf5UsmWPEUjQ3S/pCswKrKdeXCuTlLMgL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739854"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739854"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908313"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:15 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 00/10] Support microcode updates affecting SGX
Date:   Fri,  1 Apr 2022 22:23:59 +0800
Message-Id: <20220401142409.26215-1-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

v2:
https://lore.kernel.org/lkml/20220315010300.10199-1-cathy.zhang@intel.com/

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
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#m44e2b931e82a87a8b2c80058130182eb747fbcf0
"x86/sgx: Rename sgx_encl_ewb_cpumask() as sgx_encl_cpumask()"
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#mf6268a66b5c48ca9a18a772b6eaea097c315dc1d
"x86/sgx: Make sgx_ipi_cb() available internally"
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#ma3330f8ee8136aa084d0a2b5f110331e37f44c52
"x86/sgx: Keep record of SGX page type"
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#m4ae80fdf67ad330119bfc2abaea845baa24ed14c

Cathy Zhang (10):
  x86/sgx: Introduce mechanism to prevent new initializations of EPC
    pages
  x86/sgx: Provide VA page non-NULL owner
  x86/sgx: Save enclave pointer for VA page
  x86/sgx: Keep record for SGX VA and Guest page type
  x86/sgx: Save the size of each EPC section
  x86/sgx: Forced EPC page zapping for EUPDATESVN
  x86/sgx: Define error codes for ENCLS[EUPDATESVN]
  x86/sgx: Implement ENCLS[EUPDATESVN]
  x86/cpu: Call ENCLS[EUPDATESVN] procedure in microcode update
  x86/sgx: Call ENCLS[EUPDATESVN] during SGX initialization

 arch/x86/include/asm/microcode.h |   5 +
 arch/x86/include/asm/sgx.h       |  48 +++-
 arch/x86/kernel/cpu/sgx/encl.h   |   4 +-
 arch/x86/kernel/cpu/sgx/encls.h  |  14 +
 arch/x86/kernel/cpu/sgx/sgx.h    |  23 +-
 arch/x86/kernel/cpu/common.c     |   9 +
 arch/x86/kernel/cpu/sgx/encl.c   |  40 ++-
 arch/x86/kernel/cpu/sgx/ioctl.c  |  28 +-
 arch/x86/kernel/cpu/sgx/main.c   | 459 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/virt.c   |  22 ++
 10 files changed, 628 insertions(+), 24 deletions(-)

-- 
2.17.1

