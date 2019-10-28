Return-Path: <SRS0=ep0c=YV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD63CA9EC1
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Oct 2019 21:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30208218AC
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Oct 2019 21:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbfJ1VHk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Oct 2019 17:07:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:42989 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404060AbfJ1VHj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Oct 2019 17:07:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 14:07:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400"; 
   d="scan'208";a="224760299"
Received: from shrehore-mobl1.ti.intel.com (HELO localhost) ([10.251.82.5])
  by fmsmga004.fm.intel.com with ESMTP; 28 Oct 2019 14:07:31 -0700
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
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-doc@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v23 24/24] docs: x86/sgx: Document kernel internals
Date:   Mon, 28 Oct 2019 23:03:24 +0200
Message-Id: <20191028210324.12475-25-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Document some of the more tricky parts of the kernel implementation
internals.

Cc: linux-doc@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/x86/sgx/2.Kernel-internals.rst | 78 ++++++++++++++++++++
 Documentation/x86/sgx/index.rst              |  1 +
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/x86/sgx/2.Kernel-internals.rst

diff --git a/Documentation/x86/sgx/2.Kernel-internals.rst b/Documentation/x86/sgx/2.Kernel-internals.rst
new file mode 100644
index 000000000000..7bfd5cb19b8e
--- /dev/null
+++ b/Documentation/x86/sgx/2.Kernel-internals.rst
@@ -0,0 +1,78 @@
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
+EPC management
+==============
+
+Because the kernel can't arbitrarily read EPC memory or share RO backing pages
+between enclaves, traditional memory models such as CoW and fork() do not work
+with enclaves.  In other words, the architectural rules of EPC force it to be
+treated as MAP_SHARED at all times.
+
+The inability to employ traditional memory models also means that EPC memory
+must be isolated from normal memory pools, e.g. attempting to use EPC memory
+for normal mappings would result in faults and/or perceived data corruption.
+Furthermore, EPC is not enumerated as normal memory, e.g. BIOS enumerates
+EPC as reserved memory in the e820 tables, or not at all.  As a result, EPC
+memory is directly managed by the SGX subsystem, e.g. SGX employs VM_PFNMAP to
+manually insert/zap/swap page table entries, and exposes EPC to userspace via
+a well known device, /dev/sgx/enclave.
+
+The net effect is that all enclave VMAs must be MAP_SHARED and are backed by
+a single file, /dev/sgx/enclave.
+
+EPC oversubscription
+====================
+
+SGX allows to have larger enclaves the than amount of available EPC by providing
+a subset of leaf instructions for swapping EPC pages to the system memory. The
+details of these instructions are discussed in the architecture document. Due to
+the unique requirements for swapping EPC pages, and because EPC pages do not
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
+enclave signer and a token with the valid bit set to zero.
+
+If the MSRs were read-only, the platform would need to provide a launch enclave
+(LE), which would be signed with the key matching the MSRs. The LE creates
+cryptographic tokens for other enclaves that they can pass together with their
+signature to the ENCLS(EINIT) opcode, which is used to initialize enclaves.
+
+Provisioning
+============
+
+The use of provisioning must be controlled because it allows to get access to
+the provisioning keys to attest to a remote party that the software is running
+inside a legitimate enclave. This could be used by a malware network to ensure
+that its nodes are running inside legitimate enclaves.
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
2.20.1

