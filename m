Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A79ECE58D
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27242190F
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfJJXVK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 19:21:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:34955 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfJJXVK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 19:21:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 16:21:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="207300618"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 10 Oct 2019 16:21:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v2 0/9] x86/sgx: Misc page related fixes
Date:   Thu, 10 Oct 2019 16:20:59 -0700
Message-Id: <20191010232108.27075-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Two critical bug fixes for a memory leak in sgx_encl_destroy() and a
livelock due to the EPC page free count getting corrupted.  The rest of
the patches are minor bug fixes and enhancements I collected in the
process of hunting down the livelock.

v2: Fully fix the memory leak, which was hilariously worse than originally
    thought.  Fun fact, the leak has existed since v18, i.e. nearly a year.

Sean Christopherson (9):
  x86/sgx: WARN once if an enclave is released with unfreed EPC pages
  x86/sgx: Do not EWB SECS if the enclave is dead
  x86/sgx: Fix a memory leak in sgx_encl_destroy()
  x86/sgx: WARN on any non-zero return from __eremove()
  x86/sgx: WARN only once if EREMOVE fails
  x86/sgx: Split second half of sgx_free_page() to a separate helper
  x86/sgx: Use the post-reclaim variant of __sgx_free_page()
  x86/sgx: Don't update free page count if EPC section allocation fails
  x86/sgx: Reinstate per EPC section free page counts

 arch/x86/kernel/cpu/sgx/encl.c    | 34 ++++++++++++-------
 arch/x86/kernel/cpu/sgx/ioctl.c   |  6 ++--
 arch/x86/kernel/cpu/sgx/main.c    | 54 ++++++++++++++++++++++---------
 arch/x86/kernel/cpu/sgx/reclaim.c | 25 +++++++-------
 arch/x86/kernel/cpu/sgx/sgx.h     | 19 ++++++++++-
 5 files changed, 96 insertions(+), 42 deletions(-)

-- 
2.22.0

