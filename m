Return-Path: <SRS0=R+G5=WJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8165C433FF
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE15E207E0
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfHMBMy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:12:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:29948 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfHMBMy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Aug 2019 21:12:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 18:12:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="176062468"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2019 18:12:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 v2 0/8] x86/sgx: Remove EADD worker and page copy
Date:   Mon, 12 Aug 2019 18:12:44 -0700
Message-Id: <20190813011252.4121-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As suggested by Andy, remove the work queue in favor of handling the
entire EADD flow in the context of the ioctl().  After the worker is
gone, pass the source page/address directly to EADD instead of first
copying the data into kernel memory.

v2:
  - Rebase to master, commit 36e0186296a7.
  - Incorporate patch to require EADD be aligned, and add a selftest
    update to obey the new alignment requirement.

Sean Christopherson (8):
  selftests/x86/sgx: Align enclave binary on 4k boundary
  x86/sgx: Require EADD source to be page aligned
  x86/sgx: Validate generic SECINFO immediately after copying from user
  x86/sgx: Set SGX_ENCL_PAGE_TCS when allocating encl_page
  x86/sgx: Move encl_page insertion into tree out of alloc flow
  x86/sgx: Allocate encl_page prior to taking encl->lock
  x86/sgx: Remove the EADD page worker
  x86/sgx: Pass userspace source address directly to EADD

 arch/x86/kernel/cpu/sgx/driver/ioctl.c       | 405 +++++--------------
 arch/x86/kernel/cpu/sgx/driver/main.c        |   4 -
 arch/x86/kernel/cpu/sgx/encl.h               |   2 -
 tools/testing/selftests/x86/sgx/encl_piggy.S |   1 +
 4 files changed, 106 insertions(+), 306 deletions(-)

-- 
2.22.0

