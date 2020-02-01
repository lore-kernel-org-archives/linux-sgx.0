Return-Path: <SRS0=7EJM=3V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7694C33CB3
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 17:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1612067C
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 17:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgBARtm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 1 Feb 2020 12:49:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:64397 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgBARtm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 1 Feb 2020 12:49:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 09:49:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="429034026"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2020 09:49:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 0/3] x86/sgx: Fix feature control rebase
Date:   Sat,  1 Feb 2020 09:49:37 -0800
Message-Id: <20200201174940.20984-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Two patches to fix the Feature Control MSR bit definitions, which didn't
get correctly rebased.

Patch 03 reworks SGX handling of Feature Control to use the new feat_ctl.c
code, which was the entire point of that series.  Patch 03 is a drop-in
replacement for 4249f9b240b7 ("x86/cpu/intel: Detect SGX supprt").

*** DISCLAIMER ***
These patches are untested against your master, as your master doesn't boot
on my system.  The fully tested version is available at 
https://github.com/sean-jc/linux.git, branch sgx/for_jarkko_v25_rebased.
I'll dig into the boot issue next week.

Sean Christopherson (3):
  x86/msr: Fixup "Add Intel SGX hardware bits"
  x86/msr: Fixup "Intel SGX Launch Control hardware bits"
  x86/cpu: Configure SGX support when initializing feature control MSR

 arch/x86/include/asm/msr-index.h |  9 ++------
 arch/x86/kernel/cpu/feat_ctl.c   | 29 +++++++++++++++++++++++-
 arch/x86/kernel/cpu/intel.c      | 39 --------------------------------
 3 files changed, 30 insertions(+), 47 deletions(-)

-- 
2.24.1

