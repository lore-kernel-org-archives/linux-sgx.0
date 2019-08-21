Return-Path: <SRS0=WfLj=WR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E59AC3A5A0
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D28222DD3
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfHUX3H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 19:29:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:18346 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbfHUX3H (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 19:29:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 16:29:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="181191240"
Received: from soegtrop-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.52.79])
  by orsmga003.jf.intel.com with ESMTP; 21 Aug 2019 16:29:04 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/2] v22 fixes
Date:   Thu, 22 Aug 2019 02:29:00 +0300
Message-Id: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Jarkko Sakkinen (2):
  x86/sgx: Remove duplicate check for entry->epc_page in
    sgx_encl_load_page()
  x86/sgx: Determine SECS at compile time in sgx_encl_eldu()

 arch/x86/kernel/cpu/sgx/driver/ioctl.c |  4 +--
 arch/x86/kernel/cpu/sgx/encl.c         | 50 ++++++++++++--------------
 arch/x86/kernel/cpu/sgx/encl.h         |  4 +--
 arch/x86/kernel/cpu/sgx/reclaim.c      | 34 +++++++++++-------
 4 files changed, 48 insertions(+), 44 deletions(-)

-- 
2.20.1

