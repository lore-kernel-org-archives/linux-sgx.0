Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71918C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Mar 2021 16:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3284564F23
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Mar 2021 16:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhCMQCC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Mar 2021 11:02:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233570AbhCMQBr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Mar 2021 11:01:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D207B64E4B;
        Sat, 13 Mar 2021 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615651307;
        bh=w5avCqJPYZnI6MW5o/2lQs4OOOXSdgA0VaI1iON9214=;
        h=From:To:Cc:Subject:Date:From;
        b=jU8GKxi+EqiMLwt+g7FFgeZt5R9iCzG2p3AteqyEME2pcD/8Z+kf0mNXqBX2elcsg
         7GEXLzd5T8J/4yjhFnE4Rap9W5PkBElU22vrcgeVaSUlLs0Bd/3ODsXurq/cAGvAPx
         QIezkytUbviHeJJrMjBTLYH/qla7AMAwzrfXhAQ86GPVKfD0KJ2Yu4kEuSD8R9rsZh
         jKQGqHybplmtixr1mPDxnUgOoJWoc+LyEnvUdiTi0nVY8+P2cYu/ar8O5kQHWMb0hL
         nSdB8YWq/65LrzlvRVA84/4v1r0fvZ0mz0beVP96W0UY3O6TYno3O3z4FY3Z2/2vzQ
         zys7szFNGGlWw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v4 0/3] x86/sgx: NUMA
Date:   Sat, 13 Mar 2021 18:01:16 +0200
Message-Id: <20210313160119.1318533-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Make sgx_alloc_epc_page() more balanced among the NUMA nodes, refactoring
hierarchical listi into a single global free list managed in FIFO fashion.

Introduce NUMA node local free EPC page lists. In sgx_alloc_epc_page(), try
first to allocate from the local free list, and fallback to global free
list, if the local list is empty.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Haitao Huang <haitao.huang@linux.intel.com>

v3:
* Expanded into a full patch set, which also implements more balanced
  EPC allocation among the NUMA nodes. Since none of the patches fully
  match the previous single patch entry, included earlier change log
  to the cover letter.

v2:
* s/section_list/numa_section_list/
* s/MAX_NUMNODES//num_possible_nodes()/
* Add more verbose inline comments that Dave provided.
* If NUMA mapping fails, print a warning and description of the fallback.
  The physical address is already printed in pr_info(), just before the
  mapping happens.

Jarkko Sakkinen (3):
  x86/sgx: Use sgx_free_epc_page() in sgx_reclaim_pages()
  x86/sgx: Replace section local dirty page lists with a global list
  x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()

 arch/x86/Kconfig               |   1 +
 arch/x86/kernel/cpu/sgx/main.c | 203 ++++++++++++++++++---------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  23 ++--
 3 files changed, 121 insertions(+), 106 deletions(-)

-- 
2.30.2

