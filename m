Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E24C3A59C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 17:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E27A72086C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 17:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfHPRX4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:23:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:4418 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfHPRX4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 13:23:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 10:23:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,394,1559545200"; 
   d="scan'208";a="328740282"
Received: from ppiatekx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.24])
  by orsmga004.jf.intel.com with ESMTP; 16 Aug 2019 10:23:50 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 0/6] Fix the reported SGX selftest makefile issues
Date:   Fri, 16 Aug 2019 20:23:41 +0300
Message-Id: <20190816172347.32561-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Cedric Xing reported various issues, which are hopefully taken care by
these patches. In addition, it removes the bindings from x86/Makefile as
it makes sense to split that into a separate commit.

Cc: Cedric Xing <cedric.xing@intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>

Jarkko Sakkinen (6):
  selftests/x86/sgx: Fix objcopy call in the Makefile
  selftests/x86/sgx: Do not generate object files
  selftests/x86/sgx: Add -I$(OUTPUT) when compiling encl_piggy.S
  selftests/x86/sgx: Fix EXTRA_CLEAN
  selftests/x86/sgx: Fix target in the Makefile
  selftests/x86: Revert SGX changes

 tools/testing/selftests/x86/Makefile     | 10 -------
 tools/testing/selftests/x86/sgx/Makefile | 33 +++++++++++++-----------
 tools/testing/selftests/x86/sgx/encl.lds |  1 +
 3 files changed, 19 insertions(+), 25 deletions(-)

-- 
2.20.1

