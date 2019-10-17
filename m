Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40068ECE599
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 173E821928
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392144AbfJQDDr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:51163 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392135AbfJQDDr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026830"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 04/14] selftests/x86/sgx: Mark helper functions as static
Date:   Wed, 16 Oct 2019 20:03:30 -0700
Message-Id: <20191017030340.18301-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Tag a handful of local helper functions as static.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index fa93521ed4d3..e87e445f6de1 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -241,7 +241,7 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 	return false;
 }
 
-bool get_file_size(const char *path, off_t *bin_size)
+static bool get_file_size(const char *path, off_t *bin_size)
 {
 	struct stat sb;
 	int ret;
@@ -261,7 +261,7 @@ bool get_file_size(const char *path, off_t *bin_size)
 	return true;
 }
 
-bool encl_data_map(const char *path, void **bin, off_t *bin_size)
+static bool encl_data_map(const char *path, void **bin, off_t *bin_size)
 {
 	int fd;
 
@@ -288,7 +288,7 @@ bool encl_data_map(const char *path, void **bin, off_t *bin_size)
 	return false;
 }
 
-bool load_sigstruct(const char *path, void *sigstruct)
+static bool load_sigstruct(const char *path, void *sigstruct)
 {
 	int fd;
 
-- 
2.22.0

