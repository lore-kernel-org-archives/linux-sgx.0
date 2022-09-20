Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B069ECAAD8
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Sep 2022 06:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiITGgh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Sep 2022 02:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiITGf7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 20 Sep 2022 02:35:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6335E54D
        for <linux-sgx@vger.kernel.org>; Mon, 19 Sep 2022 23:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663655655; x=1695191655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KTDkXIBwwhlOyZ46m6R/yla+RcYnn0UPLlaaECsxTeQ=;
  b=krZbQJAauTR6LAk9NpBKwMholR2sj8oP6I5Wpr0PEouIM2AjivF78uGn
   ZU15ZjsCRb3XvykfcrAkP3WI5VZKWTczvvIImUitWszcihQEVo4BrDrM7
   qUHwhO616jK+t8migMgZ9ZUA2R8bXFwpqbSFmlUt2qyvXLw0rU6oA5mNS
   ghaX8amRZMl2OI9A3GhbBlk3aCYzYvCU624gJecQso2QgnOO6mTLisrq8
   ebcPSEoBN9ekpya5aK2jI8Ws9kH/UkXuGKyctqTuF+zMqejRZL4uQs0P1
   +wF7vknSWGN+2KI7jayCeTzQG05B7pfVRLYOSG4PwEY/Mb1XV3NzB49GL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="279993655"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="279993655"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 23:34:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="947537916"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga005.fm.intel.com with ESMTP; 19 Sep 2022 23:34:12 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        zhiquan1.li@intel.com
Subject: [PATCH v9 0/3] x86/sgx: fine grained SGX MCA behavior
Date:   Tue, 20 Sep 2022 14:39:45 +0800
Message-Id: <20220920063948.3556917-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

V8: https://lore.kernel.org/linux-sgx/20220913145330.2998212-1-zhiquan1.li@intel.com/T/#t

Changes since V8:
- Remove excess Acked-by from patch 02 and 03.

V7: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#t

Changes since V7:
- Enrich the motivation for renaming in commit message of patch 01 with
  the explanation from Kai.
- Add Acked-by from Jarkko.
  Link: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#mc1c93e7d9643588b27cefa9540f988a070469b5b
- Add Acked-by from Kai Huang at patch 01.

V6: https://lore.kernel.org/linux-sgx/20220826160503.1576966-1-zhiquan1.li@intel.com/T/#t

Changes since V6:
- Revise the commit message of patch 01 suggested by Jarkko.
- Fix build warning due to type changes.

V5: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#t

Changes since V5:
- Rename the 'owner' field as 'encl_owner' and update the references
  as a separate patch.
- To prevent casting the 'encl_owner' field, introduce a union with
  another field - "vepc_vaddr", suggested by Dave Hansen.
- Clean up the commit message of patch 02 suggested by Dave Hansen.
- Remove patch 03 unless we have better reason to keep it.
- Add Reviewed-by from Jarkko.
  Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m379d00fc7f1d43726a42b3884637532061a8c0d1

V4: https://lore.kernel.org/linux-sgx/20220608032654.1764936-1-zhiquan1.li@intel.com/T/#t

Changes since V4:
- Switch the order of the two variables at patch 02 so all of variables
  are in reverse Christmas style.
- Do not initialize 'ret' because it will be overridden by the return
  value of force_sig_mceerr() unconditionally.
- Add Co-developed-by and Signed-off-by from Cathy Zhang at patch 01.
- Add Acked-by from Kai Huang at patch 01.

V3: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#t

Changes since V3:
- Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
  Cathy Zhang's third patch of SGX rebootless recovery patch set but
  discard irrelevant portion, since it might need some time to re-forge
  and these are two different features.
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
  information from Jarkko, Tony and Kai's comments.
- Added documentations for struct struct sgx_vepc and
  struct sgx_vepc_page.

Hi everyone,

This series contains a few patches to fine grained SGX MCA behavior.
Today, if a guest accesses an SGX EPC page with memory failure,
the kernel behavior will kill the entire guest.  This blast radius is
too large.  It would be idea to kill only the SGX application inside
the guest.

To fix this, send a SIGBUS to host userspace (like QEMU) which can
follow up by injecting a #MC to the guest.
However, when a page triggers a machine check, it only reports the
PFN.  But in order to inject #MC into hypervisor, the virtual address
is required.  The 'encl_owner' field is useless in virtualization
case, then repurpose it as 'vepc_vaddr' - the virtual address of the
virtual EPC page for such case so that arch_memory_failure() can easily
retrieve it.

Suppose an enclave is shared by multiple processes, when an enclave
page triggers a machine check, the enclave will be disabled so that
it couldn't be entered again.  Killing other processes with the same
enclave mapped would perhaps be overkill, but they are going to find
that the enclave is "dead" next time they try to use it.  Thanks for
Jarkko’s head up and Tony’s clarification on this point.
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
2. Kernel selftest/sgx: PASS
3. Internal SGX stress test: PASS
4. kmemleak test: No memory leakage detected.

Much appreciate your feedback.

Best Regards,
Zhiquan

Zhiquan Li (3):
  x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
  x86/sgx: Introduce union with vepc_vaddr field for virtualization case
  x86/sgx: Fine grained SGX MCA behavior for virtualization

 arch/x86/kernel/cpu/sgx/main.c | 48 +++++++++++++++++++++++++---------
 arch/x86/kernel/cpu/sgx/sgx.h  |  8 +++++-
 arch/x86/kernel/cpu/sgx/virt.c |  4 ++-
 3 files changed, 46 insertions(+), 14 deletions(-)

-- 
2.25.1

