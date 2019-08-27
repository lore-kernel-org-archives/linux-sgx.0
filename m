Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87298C3A59F
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67E682173E
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfH0ANa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 20:13:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:1582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfH0AN3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 20:13:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 17:11:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,435,1559545200"; 
   d="scan'208";a="171021240"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 26 Aug 2019 17:11:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 0/4] x86/sgx: Fix lock ordering bug w/ EADD
Date:   Mon, 26 Aug 2019 17:11:24 -0700
Message-Id: <20190827001128.25066-1-sean.j.christopherson@intel.com>
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

Alternatively, the issue could be resolved by sitching to get_user_pages()
to snapshot the physical page when performance the noexec check (and maybe
in the future, LSM checks).  Since there is no significant (dis)advantage
to using gup(), and simplifying sgx_encl_grow() is a worthwhile change on
its own, I'd prefer get this issue resolved and have a separate discussion
on gup() vs passing the userspace address to ENCLS as is.

Patches 1 and 2 are bug fixes that are affected somewhat by serializing
the ioctls.  I included them here to have the full context of what the
final code/semantics.

Sean Christopherson (4):
  x86/sgx: Ensure enclave state is visible before marking it created
  x86/sgx: Preserved allowed attributes during SGX_IOC_ENCLAVE_CREATE
  x86/sgx: Reject concurrent ioctls on single enclave
  x86/sgx: Take encl->lock inside of mm->mmap_sem for EADD

 arch/x86/kernel/cpu/sgx/driver.c |   1 +
 arch/x86/kernel/cpu/sgx/encl.h   |   1 +
 arch/x86/kernel/cpu/sgx/ioctl.c  | 162 +++++++++++++++++--------------
 3 files changed, 89 insertions(+), 75 deletions(-)

-- 
2.22.0

