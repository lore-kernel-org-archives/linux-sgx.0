Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A5CC3A5A3
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7A4421881
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbfH0T1T (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 15:27:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:33016 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730237AbfH0T1T (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 15:27:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="180318603"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2019 12:27:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v2 0/5] x86/sgx: Fix lock ordering bug w/ EADD
Date:   Tue, 27 Aug 2019 12:27:12 -0700
Message-Id: <20190827192717.27312-1-sean.j.christopherson@intel.com>
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
 arch/x86/kernel/cpu/sgx/ioctl.c   | 163 ++++++++++++++++--------------
 arch/x86/kernel/cpu/sgx/reclaim.c |  10 +-
 5 files changed, 105 insertions(+), 92 deletions(-)

-- 
2.22.0

