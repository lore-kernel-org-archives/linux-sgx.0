Return-Path: <SRS0=mvcT=W2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD55C3A59F
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E86892173E
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfH3ARI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:17:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:30403 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfH3ARI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 20:17:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:17:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="205917813"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2019 17:17:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v3 0/5] x86/sgx: Fix lock ordering bug w/ EADD
Date:   Thu, 29 Aug 2019 17:17:01 -0700
Message-Id: <20190830001706.29309-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As discovered by Jarkko, taking mm->mmap_sem around EADD can lead to
deadlock as attempting to acquire mmap_sem while holding encl->lock
violates SGX's lock ordering.

Resolving the issue simply by reversing the lock ordering gets ugly due
to the behavior of sgx_encl_grow(), which has a path that drops encl->lock
in order to do EPC page reclaim, i.e. moving mm->mmap_sem up would require
it to be dropped and reacquired as well.

Luckily, the entire flow can be simplified by preventing userspace from
invoking concurrent ioctls on a single enclave.  Requiring ioctls to be
serialized means encl->lock doesn't need to be held to grow/shrink the
enclave, since only ioctls can grow/shrink the enclave.  This also
eliminates theoretical cases that sgx_encl_grow() has to handle, e.g. the
enclave being initialized while it's waiting on reclaim, since the
protection provided by serializing ioctls isn't dropped to do reclaim.


v3:
  - Move list_add() for VA page out of sgx_encl_grow() so that it's
    called while holding encl->lock in the EADD flow. [Jarkko]

v2:
  - Make encl->flags an atomic, reuse for "in ioctl" detection. [Jarkko]
  - Drop smp_{r,w}mb() patch as it is superceded by atomic flags. [Jarkko]
  - Tack on two interdependent bug fixes found when auditing encl->flags.
  - Rebase to Jarkko's latest master.

Sean Christopherson (5):
  x86/sgx: Convert encl->flags from an unsigned int to an atomic
  x86/sgx: Reject concurrent ioctls on single enclave
  x86/sgx: Take encl->lock inside of mm->mmap_sem for EADD
  x86/sgx: Reject all ioctls on dead enclaves
  x86/sgx: Destroy the enclave if EEXTEND fails

 arch/x86/kernel/cpu/sgx/driver.c  |   3 +-
 arch/x86/kernel/cpu/sgx/encl.c    |  18 ++--
 arch/x86/kernel/cpu/sgx/encl.h    |   3 +-
 arch/x86/kernel/cpu/sgx/ioctl.c   | 171 ++++++++++++++++--------------
 arch/x86/kernel/cpu/sgx/reclaim.c |  10 +-
 5 files changed, 113 insertions(+), 92 deletions(-)

-- 
2.22.0

