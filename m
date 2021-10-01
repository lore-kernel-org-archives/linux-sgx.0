Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E6CC433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE77E61A85
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355208AbhJAQtQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Oct 2021 12:49:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:19801 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354807AbhJAQtQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 1 Oct 2021 12:49:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="222290383"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="222290383"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:31 -0700
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="540357486"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:31 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 0/7] Basic recovery for machine checks inside SGX
Date:   Fri,  1 Oct 2021 09:47:17 -0700
Message-Id: <20211001164724.220532-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927213452.212470-1-tony.luck@intel.com>
References: <20210927213452.212470-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Now version 8

Note that linux-kernel@vger.kernel.org and x86@kernel.org are still
dropped from the distribution. Time to get some internal agreement on these
changes before bothering the x86 maintainers with yet another version.

So I'm still looking for Acked-by: or Reviewed-by: on any bits of this
series that are worthy, and comments on the problems I need to fix
in the not-worthy parts.

Changes since v7

Parts 1 & 2: Added "Reviewed-by" tag from Jarkko (Thanks!!!)

Part 3: Jarkko had many good questions about the debugfs interface
	that was included to display addresses of pages on the SGX
	poison list. I don't have good answers to them all. While
	this was a useful hook while I was testing these patches
	(check that all the thousands of SGX pages that into which
	I had injected errors showed up on the list) it isn't needed
	for basic recovery. So I dropped the debugfs bits from the
	patch. We can revisit later when there is a clear use case
	for what should be provided.

Parts 4-7: Unchanged.

Tony Luck (7):
  x86/sgx: Add new sgx_epc_page flag bit to mark in-use pages
  x86/sgx: Add infrastructure to identify SGX EPC pages
  x86/sgx: Initial poison handling for dirty and free pages
  x86/sgx: Add SGX infrastructure to recover from poison
  x86/sgx: Hook arch_memory_failure() into mainline code
  x86/sgx: Add hook to error injection address validation
  x86/sgx: Add check for SGX pages to ghes_do_memory_failure()

 .../firmware-guide/acpi/apei/einj.rst         |  19 ++++
 arch/x86/include/asm/processor.h              |   8 ++
 arch/x86/include/asm/set_memory.h             |   4 +
 arch/x86/kernel/cpu/sgx/main.c                | 104 +++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h                 |   6 +-
 drivers/acpi/apei/einj.c                      |   3 +-
 drivers/acpi/apei/ghes.c                      |   2 +-
 include/linux/mm.h                            |  14 +++
 mm/memory-failure.c                           |  19 +++-
 9 files changed, 168 insertions(+), 11 deletions(-)


base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
-- 
2.31.1

