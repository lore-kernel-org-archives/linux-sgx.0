Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CC4C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Sep 2021 21:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CD161250
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Sep 2021 21:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbhIQVkN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Sep 2021 17:40:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:54587 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhIQVkM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 Sep 2021 17:40:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="286563045"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="286563045"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 14:38:49 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="546646796"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 14:38:49 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 0/7] Basic recovery for machine checks inside SGX
Date:   Fri, 17 Sep 2021 14:38:29 -0700
Message-Id: <20210917213836.175138-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827195543.1667168-1-tony.luck@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Now version 5.

Changes since v4:

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
 arch/x86/kernel/cpu/sgx/main.c                | 140 ++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h                 |  14 +-
 drivers/acpi/apei/einj.c                      |   3 +-
 drivers/acpi/apei/ghes.c                      |   2 +-
 include/linux/mm.h                            |  13 ++
 mm/memory-failure.c                           |  19 ++-
 12 files changed, 203 insertions(+), 28 deletions(-)


base-commit: 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f
-- 
2.31.1

