Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3588ECE58D
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3205206C0
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfJIEmn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:6367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIEmn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504409"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 0/7] x86/sgx: Improve add pages ioctl
Date:   Tue,  8 Oct 2019 21:42:34 -0700
Message-Id: <20191009044241.3591-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Enhance the SGX_IOC_ENCLAVE_ADD_PAGE{S} ioctl so that userspace can add
multiple pages to an enclave in a single syscall.  Also provide a flag
that allows replicating a single source page to multiple target pages so
that userspace doesn't need to allocate a giant chunk of memory when
initializing things like the enlave's .bss, heap, etc...

People that actually develop runtimes, please weigh in.  Jarkko also
suggested going with a fully flexible ioctl, e.g. essentially creating an
array of the existing struct so that mrmask and/or secinfo can be unique
per page.  AFAICT that's overkill and more cumbersome to use as it forces
userspace to allocate the full array.  My understanding is that the
majority of enclaves will have contiguous blocks of pages with identical
mrmask and secinfo, e.g. code segments, ro data, etc..., thus the less
flexible but easier-in-theory to use approach proposed here.

Sean Christopherson (7):
  x86/sgx: Modify ADD_PAGE ioctl to take offset instead of full address
  selftests/x86/sgx: Update test to account for ADD_PAGE change
  x86/sgx: Tweak ADD_PAGE ioctl to allow adding multiple pages
  selftests/x86/sgx: Update enclave build flow to do multi-page add
  x86/sgx: Add a flag to ADD_PAGES to allow replicating the source page
  selftests/x86/sgx: Update selftest to account for ADD_PAGES flag
  selftests/x86/sgx: Add test coverage for reclaim and replicate

 arch/x86/include/uapi/asm/sgx.h           | 25 +++++---
 arch/x86/kernel/cpu/sgx/ioctl.c           | 77 +++++++++++++++++------
 tools/testing/selftests/x86/sgx/defines.h | 28 +++++++++
 tools/testing/selftests/x86/sgx/main.c    | 40 ++++++------
 tools/testing/selftests/x86/sgx/sgxsign.c | 20 +++++-
 5 files changed, 140 insertions(+), 50 deletions(-)

-- 
2.22.0

