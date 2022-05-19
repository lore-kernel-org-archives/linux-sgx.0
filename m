Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E194C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 03:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiESDKT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 May 2022 23:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiESDKG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 May 2022 23:10:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB5FD9EAA
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 20:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652929804; x=1684465804;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WajiVPXEUq96c606rkYX5qP74BZW5K6xreAp9idgKLI=;
  b=mfW6jxrJ5IFetsyYMEFe/MPY4ruKOc/sWnViOotdeElyOUbrrWjwnQiz
   EpqN8P1JbpeTVt8J1J3aZ9oVrbVjI15WdvSn1YjjKqlZTNa8YxjVrQ+FO
   Rqq/5gJrd0fCNeedz4vUxuDR6Ds8wgHwRpVuVVlK7K3yslY7kHB++/gTM
   rzXhVZmnhug8ScCKD/0ky12llFUOzPo8EuU5DkYxKQgYaigUkjvk0o0A8
   0yat8OMpFL8t0urhFPEmV3Ct2f4pgRcl7alkpjCantEoAsbwSXWp1ah34
   8hD2t7wfQqI4p5YY/mrXVo7e2LRwfCK3Z0aIyS464je59sDPXDUQ9vPWR
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="271948497"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="271948497"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 20:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="545845126"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga006.jf.intel.com with ESMTP; 18 May 2022 20:10:01 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v2 0/4] x86/sgx: fine grained SGX MCA behavior
Date:   Thu, 19 May 2022 11:10:30 +0800
Message-Id: <20220519031030.245589-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#t

Changes since V1:
- Updated cover letter and commit messages, added valuable
  information from Jarkko, Tony and Kai's comments.
- Added documentations for struct struct sgx_vepc and
  struct sgx_vepc_page.

Hi everyone,

This series contains a few patches to fine grained SGX MCA behavior.
When VM guest access a SGX EPC page with memory failure, current
behavior will kill the guest, expected only kill the SGX application
inside it.

To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
information for hypervisor to inject #MC information to guest, which
is helpful in SGX virtualization case.

The rest of things are guest side. Currently the hypervisor like
Qemu already has mature facility to convert HVA to GPA and inject #MC
to the guest OS.

Then we extend the solution for the normal SGX case, so that the task
has opportunity to make further decision while EPC page has memory
failure.

However, current SGX data structures are insufficient to track the
EPC pages for vepc, so we introduce a new struct sgx_vepc_page which
can be the owner of EPC pages for vepc and saves the useful info of
EPC pages for vepc, like struct sgx_encl_page.

Moreover, canonical memory failure collects victim tasks by iterating
all the tasks one by one and use reverse mapping to get victim tasks'
virtual address. This is not necessary for SGX - as one EPC page can
be mapped to ONE enclave only. So, this 1:1 mapping enforcement
allows us to find task virtual address with physical address directly.
Even though an enclave has been shared by multiple processes, the
virtual address is the same.

Suppose an enclave is shared by multiple processes, when an enclave
page triggers a machine check, the enclave will be disabled so that
it couldn't be entered again. Killing other processes with the same
enclave mapped would perhaps be overkill, but they are going to find
that the enclave is "dead" next time they try to use it. Thanks for
Jarkko"s head up and Tony's clarification on this point.

Our intension is to provide additional info so that the application has
more choices. Current behavior looks gently, and we don't want to
change it.

If you expect the other processes to be informed in such case, then
you're looking for an MCA "early kill" feature which worth another
patch set to implement it.

Unlike host enclaves, virtual EPC instance cannot be shared by multiple
VMs. It is because how enclaves are created is totally up to the guest.
Sharing virtual EPC instance will be very likely to unexpectedly break
enclaves in all VMs.

SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
being shared by multiple VMs via fork(). However KVM doesn't support
running a VM across multiple mm structures, and the de facto userspace
hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
this should not happen.

Tests:
1. MCE injection test for SGX in VM.
   As we expected, the application was killed and VM was alive.
2. MCE injection test for SGX on host.
   As we expected, the application received SIGBUS with extra info.
3. Kernel selftest/sgx: PASS
4. Internal SGX stress test: PASS
5. kmemleak test: No memory leakage detected.

Much appreciate your feedback.

Best Regards,
Zhiquan

Zhiquan Li (4):
  x86/sgx: Move struct sgx_vepc definition to sgx.h
  x86/sgx: add struct sgx_vepc_page to manage EPC pages for vepc
  x86/sgx: Fine grained SGX MCA behavior for virtualization
  x86/sgx: Fine grained SGX MCA behavior for normal case

 arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h  | 30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/virt.c | 29 +++++++++++++++++++----------
 3 files changed, 71 insertions(+), 12 deletions(-)

-- 
2.25.1

