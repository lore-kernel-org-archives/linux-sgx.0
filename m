Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02151C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0E4822CEC
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436673AbfHWQQg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 12:16:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:17322 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436661AbfHWQQg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 12:16:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 09:16:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="263231694"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2019 09:16:19 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/4] Remaining updates for v22
Date:   Fri, 23 Aug 2019 19:16:12 +0300
Message-Id: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

These are my remaining updates for v22.

Jarkko Sakkinen (4):
  x86/sgx: Replace @is_secs_child with @pt in sgx_encl_ewb()
  x86/sgx: Validate TCS permssions in sgx_validate_secinfo()
  x86/sgx: Remove a deperecated enum
  x86/sgx: Move VM prot bits calculation to sgx_encl_page_alloc()

 arch/x86/kernel/cpu/sgx/encl.h    |  6 ----
 arch/x86/kernel/cpu/sgx/ioctl.c   | 51 +++++++++++++++++--------------
 arch/x86/kernel/cpu/sgx/reclaim.c | 43 ++++++++++++++++----------
 3 files changed, 55 insertions(+), 45 deletions(-)

-- 
2.20.1

