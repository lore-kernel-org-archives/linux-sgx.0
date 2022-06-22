Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8F7C43334
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Jun 2022 09:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiFVJgw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Jun 2022 05:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiFVJgv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 22 Jun 2022 05:36:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A92A36E09
        for <linux-sgx@vger.kernel.org>; Wed, 22 Jun 2022 02:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655890610; x=1687426610;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0p9g5EGpyP/bcZCVPcs55KVj1iQh0wpllgD+17WADjI=;
  b=UjeKTxFBd5qCTcD0t/mLGVvjY/qub1Huor9I9q5+14aUVPy5p/fRAc5M
   D4tnDZeggODlPEmtkFDQ3NOyDj85nME5jX4kKZDGra+50DHDRo+Jmk9P9
   Pt4wCSItTGv3/eVg1AQHZW/yT7PL4/ucmi5OrRKzwjhZd3R6YVW6Q+YvE
   gCAhxmZJTa3kbRqMgadtsVosx3Rjv0OMelZVOlUlyf61sXqLCIqQsPlBl
   2vGLJuNjS5h6UA4qZae3bLw7Hu+/tASXsSVxUUQ3bbaYPNz+tceikNGYZ
   0Ssdr1t78FaKK7xUgIrifEk/8NCLZxBnNJlidzvoucsuUrUGHvAKnXnDV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="269089421"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="269089421"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:36:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677448826"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2022 02:36:46 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v5 0/3] x86/sgx: fine grained SGX MCA behavior
Date:   Wed, 22 Jun 2022 17:37:02 +0800
Message-Id: <20220622093705.2891642-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

V4: https://lore.kernel.org/linux-sgx/20220608032654.1764936-1-zhiquan1.li@intel.com/T/#t

Change since V4:
- Switch the order of the two variables at patch 02 so all of variables
  are in reverse Christmas style.
- Do not initialize "ret" because it will be overridden by the return
  value of force_sig_mceerr() unconditionally.
- Add Co-developed-by and Signed-off-by from Cathy Zhang at patch 01.
- Add Acked-by from Kai Huang at patch 01.

V3: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#t

Changes since V3:
- Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
  Cathy Zhang's third patch of SGX rebootless recovery patch set but
  discard irrelevant portion, since it might need some time to
  re-forge and these are two different features.
  Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170

V2: https://lore.kernel.org/linux-sgx/694234d7-6a0d-e85f-f2f9-e52b4a61e1ec@intel.com/T/#t

Changes since V2:
- Repurpose the owner field as the virtual address of virtual EPC page
- Remove struct sgx_vepc_page and relevant code.
- Remove patch 01 as the changes are not necessary in new design.
- Rework patch 02 suggested by Jarkko.
- Adapt patch 03 and 04 since struct sgx_vepc_page was discarded.
- Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
  SGX_EPC_PAGE_KVM_GUEST as they are duplicated.
  Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u

V1: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#t

Changes since V1:
- Updated cover letter and commit messages, added valuable
  information from Jarkko, Tony and Kai’s comments.
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

However, when a page triggers a machine check, it only reports the PFN.
But in order to inject #MC into hypervisor, the virtual address
is required. Then repurpose the “owner” field as the virtual address of
the virtual EPC page so that arch_memory_failure() can easily retrieve
it.

Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
meaning of the field.

Suppose an enclave is shared by multiple processes, when an enclave
page triggers a machine check, the enclave will be disabled so that
it couldn't be entered again. Killing other processes with the same
enclave mapped would perhaps be overkill, but they are going to find
that the enclave is "dead" next time they try to use it. Thanks for
Jarkko’s head up and Tony’s clarification on this point.

Our intension is to provide additional info so that the application has
more choices. Current behavior looks gently, and we don’t want to
change it.

If you expect the other processes to be informed in such case, then
you’re looking for an MCA “early kill” feature which worth another
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

This series is based on tip/x86/sgx.

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

Zhiquan Li (3):
  x86/sgx: Repurpose the owner field as the virtual address of virtual
    EPC page
  x86/sgx: Fine grained SGX MCA behavior for virtualization
  x86/sgx: Fine grained SGX MCA behavior for normal case

 arch/x86/kernel/cpu/sgx/main.c | 27 +++++++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
 arch/x86/kernel/cpu/sgx/virt.c |  4 +++-
 3 files changed, 30 insertions(+), 3 deletions(-)

-- 
2.25.1

