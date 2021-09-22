Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B330FC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 18:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E0FA60EFF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 18:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhIVSXB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:23:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:16951 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236943AbhIVSXA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 Sep 2021 14:23:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="309220306"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="309220306"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 11:21:30 -0700
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="474789095"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 11:21:30 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 0/7] Basic recovery for machine checks inside SGX
Date:   Wed, 22 Sep 2021 11:21:16 -0700
Message-Id: <20210922182123.200105-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917213836.175138-1-tony.luck@intel.com>
References: <20210917213836.175138-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Now version 6 (what I actually meant to post as v5).

Note that I've dropped linux-kernel@vger.kernel.org and x86@kernel.org
from the distribution. Time to get some internal agreement on these
changes before bothering the x86 maintainers with yet another version.

So I'm looking for Acked-by: or Reviewed-by: on any bits of this
series that are worthy, and comments on the problems I need to fix
in the not-worthy parts.

Changes since v4 (I'm going to ignore the bogus v5 I posted):

Jarkko Sakkinen:
	+ Add linux-sgx@vger.kernel.org to Cc: list
	+ Remove explicit struct sgx_va_page *va_page type
	from argument and use in sgx_alloc_va_page(). Just
	use "void *" as this code doesn't do anything with the
	internals of struct sgx_va_page.
	+ Drop the union of all possible types for the "owner"
	field in struct sgx_epc_page (sorry Dave Hansen, this
	went in last time from your comment, but it doesn't
	seem to add much value). Back to "void *owner;"
	+ rename the xarray that tracks which addresses are
	EPC pages from "epc_page_ranges" to "sgx_epc_address_space".

Dave Hansen:
	+ Use more generic names for the globally visible
	functions that are needed in generic code:
		sgx_memory_failure -> arch_memory_failure
		sgx_is_epc_page -> arch_is_platform_page
	+ Commit comment on space used by xarray to track EPC pages.

Tony Luck:
	+ Found that ghes code spits warnings for memory addresses
	that it thinks are bad. Add a check for SGX pages.

Tony Luck (7):
  x86/sgx: Provide indication of life-cycle of EPC pages
  x86/sgx: Add infrastructure to identify SGX EPC pages
  x86/sgx: Initial poison handling for dirty and free pages
  x86/sgx: Add SGX infrastructure to recover from poison
  x86/sgx: Hook arch_memory_failure() into mainline code
  x86/sgx: Add hook to error injection address validation
  x86/sgx: Add check for SGX pages to ghes_do_memory_failure()

 .../firmware-guide/acpi/apei/einj.rst         |  19 +++
 arch/x86/include/asm/processor.h              |   8 +
 arch/x86/include/asm/set_memory.h             |   4 +
 arch/x86/kernel/cpu/sgx/encl.c                |   5 +-
 arch/x86/kernel/cpu/sgx/encl.h                |   2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c               |   2 +-
 arch/x86/kernel/cpu/sgx/main.c                | 137 ++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h                 |   7 +-
 drivers/acpi/apei/einj.c                      |   3 +-
 drivers/acpi/apei/ghes.c                      |   2 +-
 include/linux/mm.h                            |  14 ++
 mm/memory-failure.c                           |  19 ++-
 12 files changed, 196 insertions(+), 26 deletions(-)


base-commit: e4e737bb5c170df6135a127739a9e6148ee3da82
-- 
2.31.1

