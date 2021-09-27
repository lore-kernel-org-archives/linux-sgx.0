Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24233C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047AB61074
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhI0Vgj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:36:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:2372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236723AbhI0Vgj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 17:36:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288227508"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="288227508"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="561547565"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:00 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 0/7] Basic recovery for machine checks inside SGX
Date:   Mon, 27 Sep 2021 14:34:45 -0700
Message-Id: <20210927213452.212470-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210922182123.200105-1-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Now version 7

Note that linux-kernel@vger.kernel.org and x86@kernel.org are still
dropped from the distribution. Time to get some internal agreement on these
changes before bothering the x86 maintainers with yet another version.

So I'm looking for Acked-by: or Reviewed-by: on any bits of this
series that are worthy, and comments on the problems I need to fix
in the not-worthy parts.

Changes since v6:

Jarkko Sakkinen:
	Don't use "owner" == NULL vs. != NULL as an indicator
	of whether an SGX EPC page is free vs. in-use. Just add
	a new flags bit. Note this drops most of the changes I
	had in part 0001. Remainder of the patches are largely
	unchanged except where they check for the new flags bit
	instead of owner != NULL.

Tony Luck (7):
  x86/sgx: Add new sgx_epc_page flag bit to mark in-use pages
  x86/sgx: Add infrastructure to identify SGX EPC pages
  x86/sgx: Initial poison handling for dirty and free pages
  x86/sgx: Add SGX infrastructure to recover from poison
  x86/sgx: Hook arch_memory_failure() into mainline code
  x86/sgx: Add hook to error injection address validation
  x86/sgx: Add check for SGX pages to ghes_do_memory_failure()

 .../firmware-guide/acpi/apei/einj.rst         |  19 +++
 arch/x86/include/asm/processor.h              |   8 ++
 arch/x86/include/asm/set_memory.h             |   4 +
 arch/x86/kernel/cpu/sgx/main.c                | 121 +++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h                 |   6 +-
 drivers/acpi/apei/einj.c                      |   3 +-
 drivers/acpi/apei/ghes.c                      |   2 +-
 include/linux/mm.h                            |  14 ++
 mm/memory-failure.c                           |  19 ++-
 9 files changed, 185 insertions(+), 11 deletions(-)


base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
-- 
2.31.1

