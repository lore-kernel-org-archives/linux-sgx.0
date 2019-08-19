Return-Path: <SRS0=kvvX=WP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16FBC3A5A0
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 13:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC0272085A
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 13:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHSN2g (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:28:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:20845 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfHSN2g (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 09:28:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 06:28:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="329377802"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2019 06:28:33 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        sean.j.christopherson@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v3 0/7] Fix the reported SGX selftest makefile issues
Date:   Mon, 19 Aug 2019 16:28:23 +0300
Message-Id: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Cedric Xing reported various issues in the selftest makefiles, which are
hopefully taken care by these patches.

As the last patch this patch set contains a patch that implements the
subdirectory traversal the for the x86 selftest directory tree. This
patch is meant to be a separate patch in the main SGX patch set so that
the bindings can be reviewed separately.

v3: 1,$s/SUB_DIRS/SUBDIRS/g
v2: Added patch to implement the traversal to the subdirectories
    selftest.

Jarkko Sakkinen (7):
  selftests/x86/sgx: Fix objcopy call in the Makefile
  selftests/x86/sgx: Do not generate object files
  selftests/x86/sgx: Add -I$(OUTPUT) when compiling encl_piggy.S
  selftests/x86/sgx: Fix EXTRA_CLEAN
  selftests/x86/sgx: Fix target in the Makefile
  selftests/x86: Revert SGX changes
  selftests/x86: Recurse into subdirectories

 tools/testing/selftests/x86/Makefile     | 54 +++++++++++++++++++-----
 tools/testing/selftests/x86/sgx/Makefile | 33 ++++++++-------
 tools/testing/selftests/x86/sgx/encl.lds |  1 +
 3 files changed, 63 insertions(+), 25 deletions(-)

-- 
2.20.1

