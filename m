Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9140AC32751
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D19217D7
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfHHAM7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:12:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:51237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbfHHAM7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:12:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519344"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 00/11] x86/sgx: Bug fixes for v22
Date:   Wed,  7 Aug 2019 17:12:43 -0700
Message-Id: <20190808001254.11926-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A variety of bug fixes, some for issues reported by Shay, the rest for
issues found by inspection.  Sent as a bundle because most of the patches
conflict in one way or another, and so that others can apply on master to
get a stable build.

Sean Christopherson (11):
  x86/sgx: Fix an SECS collision with enclave page at VA=0
  x86/sgx: Fix incorrect NULL pointer check
  x86/sgx: Return '0' when sgx_ioc_enclave_set_attribute() succeeds
  x86/sgx: x86/sgx: Require EADD destination to be page aligned
  x86/sgx: Require EADD source to be page aligned
  x86/sgx: Check the bounds of the enclave address against ELRANGE
  x86/sgx: Check that enclave is created at beginning of EADD/EINIT
    ioctl
  x86/sgx: Do not free enclave resources on redundant ECREATE
  x86/sgx: Refactor error handling for user of sgx_encl_grow()
  x86/sgx: Call sgx_encl_grow() with the enclave's lock held
  x86/sgx: Shrink the enclave if ECREATE/EADD fails

 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 143 +++++++++++++++----------
 arch/x86/kernel/cpu/sgx/encl.c         |  14 ++-
 2 files changed, 97 insertions(+), 60 deletions(-)

-- 
2.22.0

