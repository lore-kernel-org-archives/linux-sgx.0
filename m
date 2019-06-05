Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADABC28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C6382083E
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfFETt2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:2918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfFETt2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 15:49:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 12:49:27 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 05 Jun 2019 12:49:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [PATCH 0/7] x86/sgx: Clean up and enhance add pages ioctl
Date:   Wed,  5 Jun 2019 12:48:38 -0700
Message-Id: <20190605194845.926-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This series is intended to be included in v21 of Jarkko's SGX series and
applies on Jarkko's current master:

  dfc89a83b5bc ("docs: x86/sgx: Document the enclave API")

The primary goal of the series is to tweak the ioctl for adding pages to
an enclave so that it is somewhat extensible, e.g. add a flags field that
can be reused for access control integration and SGX2/EAUG, and add a size
field so that multiple pages can be added in a single call (batching EADD
has been mentioned at various times in the past).

The secondary goal is to improve the performance of building enclaves.
Handling multiple pages in a single call helps somewhat, but the real win
(for some enclaves) is using the kernel's zero page as the source for EADD
when possible.

Sean Christopherson (7):
  x86/sgx: Remove dead code to handle non-existent IOR ioctl
  x86/sgx: Remove unnecessary @cmd parameter from ioctl helpers
  x86/sgx: Let ioctl helpers do copy to/from user
  x86/sgx: Allow userspace to add multiple pages in single ioctl()
  x86/sgx: Add flag to zero added region instead of copying from source
  x86/sgx: Use the actual zero page as the source when adding zero pages
  x86/sgx: Add a reserved field to sgx_enclave_add_region to drop
    'packed'

 Documentation/x86/sgx/3.API.rst        |   2 +-
 arch/x86/include/uapi/asm/sgx.h        |  30 +--
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 252 +++++++++++++++----------
 3 files changed, 171 insertions(+), 113 deletions(-)

-- 
2.21.0

