Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EF5C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiCIKlV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiCIKlU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:20 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E63D499
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822422; x=1678358422;
  h=from:to:cc:subject:date:message-id;
  bh=hcr8GknjN7k7UjpecmFuIxzkm/lu6+JvMxXiobq87MM=;
  b=jox6gIyKxbQ3DiB6xJ0h5pCYnVbvwinxfJXckEE8YLZ14q9bUVi8GSn+
   oI/SOO6sEBLwuSZOwDXNuSzbMUCTl4FqQaVits5P66vBDDGzchsxvF+oZ
   amt9pJhHmGuR5mA/pT0WjgAtH+lZsM/mS2MDgBtmkh2OSRDX6skeiMBpa
   a7TEeM5bStRFo8lI/Z/naqx1148OxkS+IAX3FxvBRHR0aKuHbZJHm82Bf
   b8QttAVKJkCX4VVEa+1yKqUPaHNK196/pg/DuDKK6vKcvGvJxPN1srGHd
   vc2JSrtcXTg0+HgCuNXIJJwpGROVh7Y1DamM9W6wfLHkkU1ZdT/JXSMDa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373530"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373530"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582824"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:20 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 00/11] Support microcode updates affecting SGX
Date:   Wed,  9 Mar 2022 18:40:39 +0800
Message-Id: <20220309104050.18207-1-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Users hate reboots. This lets SGX enclaves attest to updated microcode
without a reboot.

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

Today, many microcode updates _can_ be applied without a reboot.
But users have strongly and specifically expressed a desire to
perform *any* microcode update on a running system without a reboot.
This work is a direct result of those user requests and lets SGX
enclaves take full advantage of microcode updates without a reboot.

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
down bare-metal enclaves and then run EUPDATESVN. This is expected
to be triggered by administrators via sysfs at some convenient time
after a microcode update, probably by the microcode update tooling
itself.

This is a very slow operation. It is, of course, exceedingly disruptive
to enclaves but should be infrequent as microcode updates are released
on the order of every few months. Also, this is not the first piece of
the SGX architecture which will destroy all enclave contents. Enclaves
are expected to be designed to be volatile and survive termination at
any time gracefully.

A follow-on series will add Virtual EPC (KVM guest) support.

SGX Seamless should handle most SGX flows while doing SVN update, so, this
RFC series is based on SGX EDMM v2 which introduces SGX2 flows.
https://lore.kernel.org/lkml/cover.1644274683.git.reinette.chatre@intel.com/T/

Here is the spec for your reference:
https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true

Cathy Zhang (11):
  x86/sgx: Introduce mechanism to prevent new initializations of EPC
    pages
  x86/sgx: Provide VA page non-NULL owner
  x86/sgx: Save enclave pointer for VA page
  x86/sgx: Keep record for SGX VA and Guest page type
  x86/sgx: Save the size of each EPC section
  x86/sgx: Forced EPC page zapping for EUPDATESVN
  x86/sgx: Define error codes for ENCLS[EUPDATESVN]
  x86/sgx: Implement ENCLS[EUPDATESVN]
  x86/microcode: Expose EUPDATESVN procedure via sysfs
  x86/sgx: Call ENCLS[EUPDATESVN] during SGX initialization
  Documentation/x86/sgx: Document EUPDATESVN sysfs file

 arch/x86/include/asm/microcode.h              |   5 +
 arch/x86/include/asm/sgx.h                    |  46 +-
 arch/x86/kernel/cpu/sgx/encl.h                |   3 +-
 arch/x86/kernel/cpu/sgx/encls.h               |  16 +
 arch/x86/kernel/cpu/sgx/sgx.h                 |  23 +-
 arch/x86/kernel/cpu/microcode/core.c          |  44 ++
 arch/x86/kernel/cpu/sgx/encl.c                |  46 +-
 arch/x86/kernel/cpu/sgx/ioctl.c               |  53 +-
 arch/x86/kernel/cpu/sgx/main.c                | 469 +++++++++++++++++-
 arch/x86/kernel/cpu/sgx/virt.c                |  22 +
 .../ABI/testing/sysfs-devices-system-cpu      |  14 +
 Documentation/x86/sgx.rst                     |  43 ++
 12 files changed, 759 insertions(+), 25 deletions(-)

-- 
2.17.1

