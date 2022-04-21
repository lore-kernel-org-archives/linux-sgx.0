Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709FFC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388698AbiDULHK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiDULHH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:07:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7AA2E681
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539058; x=1682075058;
  h=from:to:cc:subject:date:message-id;
  bh=rjmeFg9Y2yk6SAk2Tzf4q8M/Y+O/R0tD9OoCgVJ+B7I=;
  b=evC+ihgAmLSKRH7I8IlrIrA/gogV2y0PZXMqh767PTE40jdZd6aY/ykD
   dGwV0RM8VKG3xoqQB9ihS4Xqe3GVqQoen68oYeqzEVg1coIGlpXVRPObU
   2GRh6BX+DrMw370y7EFYqKP3frsatDCZVqNvIm42UUxDRteeOJ/snhd0p
   hV7lHk3DUmVhyFishg90RD01QVWp7kYsPz5Ut1Ep0k65G5hAL3UidVX2n
   bR/MmrYpy2XjnKvSd0Kw0bupVAaJBBmQuaF9khAVBA3Wol482GZ8abDHV
   7KXpSw3t5SHzZxjBe2Q8RhXXWWQLuy5Z4X9AXIoCvXbf3f/E33HulOovg
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244893315"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244893315"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039100"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:15 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 0/9] Support microcode updates affecting SGX
Date:   Thu, 21 Apr 2022 19:03:17 +0800
Message-Id: <20220421110326.856-1-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Thanks for reviewers' great help on improving the series' quality!
We removed RFC in this version.

v3:
https://lore.gnuweeb.org/gwml/20220401142409.26215-4-cathy.zhang@intel.com/T/

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
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#m44e2b931e82a87a8b2c80058130182eb747fbcf0
"x86/sgx: Rename sgx_encl_ewb_cpumask() as sgx_encl_cpumask()"
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#mf6268a66b5c48ca9a18a772b6eaea097c315dc1d
"x86/sgx: Make sgx_ipi_cb() available internally"
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#ma3330f8ee8136aa084d0a2b5f110331e37f44c52
"x86/sgx: Keep record of SGX page type"
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/#m4ae80fdf67ad330119bfc2abaea845baa24ed14c

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

 arch/x86/include/asm/microcode.h |   1 +
 arch/x86/include/asm/sgx.h       |  49 +++-
 arch/x86/kernel/cpu/sgx/encl.h   |   4 +-
 arch/x86/kernel/cpu/sgx/encls.h  |  14 +
 arch/x86/kernel/cpu/sgx/sgx.h    |  23 +-
 arch/x86/kernel/cpu/common.c     |  10 +
 arch/x86/kernel/cpu/sgx/encl.c   |  40 ++-
 arch/x86/kernel/cpu/sgx/ioctl.c  |  46 +++-
 arch/x86/kernel/cpu/sgx/main.c   | 459 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/virt.c   |  22 ++
 10 files changed, 638 insertions(+), 30 deletions(-)

-- 
2.17.1

