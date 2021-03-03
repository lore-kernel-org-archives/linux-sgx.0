Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A18EC1551A
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7202764F20
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbhCDAtU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447580AbhCCPE1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Mar 2021 10:04:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3610E60240;
        Wed,  3 Mar 2021 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614783824;
        bh=Pdp8HasQTGb0k5IdZ2qjoyCInUHJAUjtkbKgyYuavoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=VmZWFuoHI5xReMJ1soS9FWVCRsTm48gQTKkc1OpGYdT0V8Z3ZgO3prlbme4fkFHDV
         82dUpqkYJMaddLIWzyP+29+tOIP8dvWvzEJat3Ew4G2vNNHy98xASuHGrYpzrMSKzQ
         APcGBW1s0pDNsjRUnA8LWstzhzWS/PCaFnFJZfqhPLL4FQOlVSEZPVuNuvOicGujEp
         Ke29IeYNyWMSUCUaRu3KDJh40SuuCu5I1bF+n740gYEKfwpKFVoH25UkW3OInm4Wgp
         OJJ+nPn4eqMKb3Zf+6eZ/DsojPnEezAD2LMhFxOHvQMvIjpuzO0/ZdK7lAMKFJs95S
         Dc20cD4Twfdmw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v3 0/5] x86/sgx: NUMA
Date:   Wed,  3 Mar 2021 17:03:18 +0200
Message-Id: <20210303150323.433207-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
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

v3:
* Expanded into a full patch set, which also implements more balanced
  EPC allocation among the NUMA nodes. Since none of the patches fully
  match the previous single patch entry, included earlier change log
  to the cover letter.
v2:
* s/section_list/numa_section_list/
* s/MAX_NUMNODES//num_possible_nodes()/
* Add more verbose inline comments that Dave provided.
* If NUMA mapping fails, print a warning and description of the fallbck.
  The physical address is alredy printed in pr_info(), just before the
  mapping happens.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Haitao Huang <haitao.huang@linux.intel.com>

Jarkko Sakkinen (5):
  x86/sgx: Fix a resource leak in sgx_init()
  x86/sgx: Use sgx_free_epc_page() in sgx_reclaim_pages()
  x86/sgx: Replace section->init_laundry_list with a temp list
  x86/sgx: Replace section->page_list with a global free page list
  x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()

 arch/x86/Kconfig               |   1 +
 arch/x86/kernel/cpu/sgx/main.c | 217 +++++++++++++++++++++------------
 arch/x86/kernel/cpu/sgx/sgx.h  |  22 ++--
 3 files changed, 146 insertions(+), 94 deletions(-)

-- 
2.30.1

