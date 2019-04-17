Return-Path: <SRS0=rDpG=ST=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6079C10F12
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0C3220821
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbfDQKnR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:43:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:54717 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731659AbfDQKnR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Apr 2019 06:43:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 03:43:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,361,1549958400"; 
   d="scan'208";a="132120357"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga007.jf.intel.com with ESMTP; 17 Apr 2019 03:43:09 -0700
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v20 27/28] docs: x86/sgx: Document kernel internals
Date:   Wed, 17 Apr 2019 13:39:37 +0300
Message-Id: <20190417103938.7762-28-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Document some of the more tricky parts of the kernel implementation
internals.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/x86/sgx/2.Kernel-internals.rst | 56 ++++++++++++++++++++
 Documentation/x86/sgx/index.rst              |  1 +
 2 files changed, 57 insertions(+)
 create mode 100644 Documentation/x86/sgx/2.Kernel-internals.rst

diff --git a/Documentation/x86/sgx/2.Kernel-internals.rst b/Documentation/x86/sgx/2.Kernel-internals.rst
new file mode 100644
index 000000000000..de359bf605ca
--- /dev/null
+++ b/Documentation/x86/sgx/2.Kernel-internals.rst
@@ -0,0 +1,56 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+Kernel Internals
+================
+
+CPU configuration
+=================
+
+Because SGX has an ever evolving and expanding feature set, it's possible for
+a BIOS or VMM to configure a system in such a way that not all CPUs are equal,
+e.g. where Launch Control is only enabled on a subset of CPUs.  Linux does
+*not* support such a heterogeneous system configuration, nor does it even
+attempt to play nice in the face of a misconfigured system.  With the exception
+of Launch Control's hash MSRs, which can vary per CPU, Linux assumes that all
+CPUs have a configuration that is identical to the boot CPU.
+
+EPC oversubscription
+====================
+
+SGX allows to have larger enclaves than amount of available EPC by providing a
+subset of leaf instruction for swapping EPC pages to the system memory.  The
+details of these instructions are discussed in the architecture document. Due
+to the unique requirements for swapping EPC pages, and because EPC pages do not
+have associated page structures, management of the EPC is not handled by the
+standard memory subsystem.
+
+SGX directly handles swapping of EPC pages, including a thread to initiate the
+reclaiming process and a rudimentary LRU mechanism. When the amount of free EPC
+pages goes below a low watermark the swapping thread starts reclaiming pages.
+The pages that have not been recently accessed (i.e. do not have the A bit set)
+are selected as victim pages. Each enclave holds an shmem file as a backing
+storage for reclaimed pages.
+
+Launch Control
+==============
+
+The current kernel implementation supports only writable MSRs. The launch is
+performed by setting the MSRs to the hash of the public key modulus of the
+enclave signer and a token with the valid bit set to zero. Because kernel makes
+ultimately all the launch decisions token are not needed for anything.  We
+don't need or have a launch enclave for generating them as the MSRs must always
+be writable.
+
+Provisioning
+============
+
+The use of provisioning must be controlled because it allows to get access to
+the provisioning keys to attest to a remote party that the software is running
+inside a legit enclave. This could be used by a malware network to ensure that
+its nodes are running inside legit enclaves.
+
+The driver introduces a special device file /dev/sgx/provision and a special
+ioctl SGX_IOC_ENCLAVE_SET_ATTRIBUTE to accomplish this. A file descriptor
+pointing to /dev/sgx/provision is passed to ioctl from which kernel authorizes
+the PROVISION_KEY attribute to the enclave.
diff --git a/Documentation/x86/sgx/index.rst b/Documentation/x86/sgx/index.rst
index c5dfef62e612..5d660e83d984 100644
--- a/Documentation/x86/sgx/index.rst
+++ b/Documentation/x86/sgx/index.rst
@@ -14,3 +14,4 @@ potentially malicious.
    :maxdepth: 1
 
    1.Architecture
+   2.Kernel-internals
-- 
2.19.1

