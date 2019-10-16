Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1399FA372A
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88E3521A4C
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394278AbfJPSht (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:37:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:22394 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfJPShs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 14:37:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 11:37:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="397258411"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2019 11:37:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v3 00/12] x86/sgx: Bug fixes for v23
Date:   Wed, 16 Oct 2019 11:37:33 -0700
Message-Id: <20191016183745.8226-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As requested, the merge of the EPC and EADD bug fix series.  The headliners
are two critical bug fixes for a memory leak in sgx_encl_destroy() and a
livelock due to the EPC page free count getting corrupted.

Sean Christopherson (12):
  x86/sgx: Pass EADD the kernel's virtual address for the source page
  x86/sgx: Check the validity of the source page address for EADD
  x86/sgx: Fix EEXTEND error handling
  x86/sgx: Drop mmap_sem before EEXTENDing an enclave page
  x86/sgx: Remove redundant message from WARN on non-emtpy mm_list
  x86/sgx: Fix a memory leak in sgx_encl_destroy()
  x86/sgx: WARN on any non-zero return from __eremove()
  x86/sgx: WARN only once if EREMOVE fails
  x86/sgx: Split second half of sgx_free_page() to a separate helper
  x86/sgx: Use the post-reclaim variant of __sgx_free_page()
  x86/sgx: Don't update free page count if EPC section allocation fails
  x86/sgx: Reinstate per EPC section free page counts

 arch/x86/kernel/cpu/sgx/encl.c    | 29 ++++++++++-------
 arch/x86/kernel/cpu/sgx/ioctl.c   | 52 +++++++++++++++--------------
 arch/x86/kernel/cpu/sgx/main.c    | 54 ++++++++++++++++++++++---------
 arch/x86/kernel/cpu/sgx/reclaim.c |  8 ++---
 arch/x86/kernel/cpu/sgx/sgx.h     | 19 ++++++++++-
 5 files changed, 106 insertions(+), 56 deletions(-)

-- 
2.22.0

