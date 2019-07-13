Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F9AC31E40
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882AB2064A
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfGMRNi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:13:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:19294 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfGMRNi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:13:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:13:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="341981751"
Received: from hbriegel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.48])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2019 10:13:28 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v21 28/28] docs: x86/sgx: Document the enclave API
Date:   Sat, 13 Jul 2019 20:08:04 +0300
Message-Id: <20190713170804.2340-29-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Document the enclave driver API i.e. the set of ioctl's used to create
and manage enclaves and set their privileges

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/x86/sgx/3.API.rst | 27 +++++++++++++++++++++++++++
 Documentation/x86/sgx/index.rst |  1 +
 2 files changed, 28 insertions(+)
 create mode 100644 Documentation/x86/sgx/3.API.rst

diff --git a/Documentation/x86/sgx/3.API.rst b/Documentation/x86/sgx/3.API.rst
new file mode 100644
index 000000000000..b113aeb05f54
--- /dev/null
+++ b/Documentation/x86/sgx/3.API.rst
@@ -0,0 +1,27 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===
+API
+===
+
+The enclave life-cycle starts by opening `/dev/sgx/enclave`. After this there is
+already a data structure inside kernel tracking the enclave that is initially
+uncreated. After this a set of ioctl's can be used to create, populate and
+initialize the enclave.
+
+You can close (if you want) the fd after you've mmap()'d. As long as the file is
+open the enclave stays alive so you might want to do that after you don't need
+it anymore. Even munmap() won't destruct the enclave if the file is open.
+Neither will closing the fd as long as you have mmap() done over the fd (even
+if it does not across the range defined in SECS).
+
+Finally, there is ioctl to authorize priviliged attributes:
+`SGX_IOC_ENCLAVE_SET_ATTRIBUTE`. Each of them is presented by a file inside
+`/dev/sgx/`. Right now there is only one such file `/dev/sgx/provision`, which
+controls the `PROVISON_KEY` attribute.
+
+.. kernel-doc:: arch/x86/kernel/cpu/sgx/driver/ioctl.c
+   :functions: sgx_ioc_enclave_create
+               sgx_ioc_enclave_add_page
+               sgx_ioc_enclave_init
+               sgx_ioc_enclave_set_attribute
diff --git a/Documentation/x86/sgx/index.rst b/Documentation/x86/sgx/index.rst
index 5d660e83d984..de0b78328611 100644
--- a/Documentation/x86/sgx/index.rst
+++ b/Documentation/x86/sgx/index.rst
@@ -15,3 +15,4 @@ potentially malicious.
 
    1.Architecture
    2.Kernel-internals
+   3.API
-- 
2.20.1

