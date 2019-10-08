Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C52EC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0617B20684
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfJHEM1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:12:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:1148 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfJHEM1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:12:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:12:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="197581664"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 07 Oct 2019 21:12:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 0/2] x86/sgx: Revert two recent master changes
Date:   Mon,  7 Oct 2019 21:12:24 -0700
Message-Id: <20191008041226.2974-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Revert two changes that break the build and cause panic during boot.
Not true reverts since the chanes have already been squashed.

Sean Christopherson (2):
  x86/sgx: Revert using BIT() to define ENCLS_FAULT_FLAG
  x86/sgx: Revert moving sgx_init() call to sgx_detect()

 arch/x86/include/asm/sgx.h        |  7 -------
 arch/x86/kernel/cpu/intel.c       |  5 -----
 arch/x86/kernel/cpu/sgx/encls.h   |  2 +-
 arch/x86/kernel/cpu/sgx/main.c    | 16 +++++++++-------
 arch/x86/kernel/cpu/sgx/reclaim.c |  2 +-
 arch/x86/kernel/cpu/sgx/sgx.h     |  2 +-
 6 files changed, 12 insertions(+), 22 deletions(-)
 delete mode 100644 arch/x86/include/asm/sgx.h

-- 
2.22.0

