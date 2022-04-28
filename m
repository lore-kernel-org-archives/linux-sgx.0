Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E9DC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 20:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiD1UOz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiD1UOz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 16:14:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42930BAB81
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 13:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651176699; x=1682712699;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5pi0BmQiyh6xVAOW5Q+6JBZ9MAHemou3jDeIoPK797I=;
  b=VzG19itfauDuEglF4II9/bBCa+/2S9C1EqBIMApdQ+bp+6X0c4pUMGx7
   7yhIEfJ9EU0v9xWazPdseBG3tsdksM3keacQI3TzAmCHE9aDmp12S5Jk6
   56+YktZ8R5vkHf+GRSldMqdeYLglH9OOu/5/q4JmBTxn70pcRWHMwDeDc
   hPzFonedih/zW39JaHRnbAn9z0E2jZ5/5SNZ3SSEwtgLhAD05Z0t9DwK5
   ptZShDT3m4Tv+vOc7hSAVsWMW3lIdH1Vt4DXF7ryLZIFGVx/KwUlimVDB
   lDky54ESOLxVjAtDHiGnEs1kme87jY/dLVb4CXOyDYgmM/8Rkl64Tf4wq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246324257"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246324257"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="514458603"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:32 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [RFC PATCH 0/4] SGX shmem backing store issue
Date:   Thu, 28 Apr 2022 13:11:23 -0700
Message-Id: <cover.1651171455.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Everybody,

Haitao reported encountering the following WARN while stress testing SGX
with the SGX2 series [1] applied:

ELDU returned 1073741837 (0x4000000d)
WARNING: CPU: 72 PID: 24407 at arch/x86/kernel/cpu/sgx/encl.c:81 sgx_encl_eldu+0x3cf/0x400
...
Call Trace:
<TASK>
? xa_load+0x6e/0xa0
__sgx_encl_load_page+0x3d/0x80
sgx_encl_load_page_in_vma+0x4a/0x60
sgx_vma_fault+0x7f/0x3b0
? sysvec_call_function_single+0x66/0xd0
? asm_sysvec_call_function_single+0x12/0x20
__do_fault+0x39/0x110
__handle_mm_fault+0x1222/0x15a0
handle_mm_fault+0xdb/0x2c0
do_user_addr_fault+0x1d1/0x650
? exit_to_user_mode_prepare+0x45/0x170
exc_page_fault+0x76/0x170
? asm_exc_page_fault+0x8/0x30
asm_exc_page_fault+0x1e/0x30
...
</TASK>

ENCLS[ELDU] is returning a #GP when attempting to load an enclave
page from the backing store into the enclave. This is likely because
of a MAC verification failure.

Haitao's stress testing involves running two concurrent loops of the SGX
selftests on a system with 4GB EPC memory. One of the tests is modified
to reduce the oversubscription heap size:

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index d480c2dd2858..12008789325b 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -398,7 +398,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 	 * Create enclave with additional heap that is as big as all
 	 * available physical SGX memory.
 	 */
-	total_mem = get_total_epc_mem();
+	total_mem = get_total_epc_mem()/16;
 	ASSERT_NE(total_mem, 0);
 	TH_LOG("Creating an enclave with %lu bytes heap may take a while ...",
 	       total_mem);

If the the test compiled with above snippet is renamed as "test_sgx_small"
and the original renamed as "test_sgx_large" the two concurrent loops are
run as follows:

(for i in $(seq 1 999); do echo "Iteration $i"; sudo ./test_sgx_large; done ) > log.large 2>&1
(for i in $(seq 1 9999); do echo "Iteration $i"; sudo ./test_sgx_small; done ) > log.small 2>&1

If the SGX driver is modified to always WARN when ENCLS[ELDU] encounters a #GP
(see below) then the WARN appears after a few iterations of "test_sgx_large"
and shows up throughout the testing.

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..68c1dbc84ed3 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -18,7 +18,7 @@
 #define ENCLS_WARN(r, name) {						  \
 	do {								  \
 		int _r = (r);						  \
-		WARN_ONCE(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
+		WARN(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
 	} while (0);							  \
 }

I focused on investigating this issue the past two weeks and was able to
narrow down the cause but not yet fix the issue. Now I am out of ideas and
would really appreciate if you could provide guidance on how to proceed.

Here is what I have learned so far:
* Reverting commit 08999b2489b4 ("x86/sgx: Free backing memory after
  faulting the enclave page") resolves the issue. With that commit
  reverted the concurrent selftest loops can run to completion without
  encountering any WARNs.

* The issue is also resolved if only the calls (introduced by commit
  08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave
  page") ) to sgx_encl_truncate_backing_page() within __sgx_encl_eldu()
  are disabled.

* Two issues with commit 08999b2489b4 ("x86/sgx: Free backing memory
  after faulting the enclave page") are fixed with patch 1 and 2 in
  this series. These fixes do not resolve the WARN.

* There is a potential race between the reclaimer and the page fault
  handler while interacting with the backing store. This is addressed
  in patch 3, but it does not resolve the WARN.

* Lockdep did reveal a locking issue in SGX2 - the EAUG flow should not
  do direct reclaim since the page fault handler already has mmap_lock
  that the reclaimer will attempt to obtain. This will be fixed in the
  next version of SGX2 but that fix does not resolve the WARN.

* Since ENCLS[ELDU] returns #GP on MAC verification failure a possible
  cause could be if a problem occurs while loading the page from
  backing store.
  sgx_encl_get_backing_page() is used to both allocate backing storage
  in the ENCLS[EWB] flow as well as to lookup backing storage in the
  ENCLS[ELDU] flow.
  As part of the investigation the interface was split to ensure that
  backing storage is only allocated during the ENCLS[EWB] flow and only
  lookup occurs during the ENCLS[ELDU] flow. This can be found in
  patch 4.
  This change revealed that there are cases during ENCLS[ELDU] flow
  when the backing page is not present - attempting to lookup a
  backing page returns -ENOENT. Before patch 4 a new backing page
  would be allocated and thus trigger a #GP when ENCLS[ELDU] is
  attempted.
  This change is not a fix, the code path just fails earlier now, but
  it reveals a cause of the WARNs encountered (MAC verification will
  fail on a newly allocated page) but not why the pages cannot be found
  in the backing store. With this change the number of WARNs are
  reduced significantly but not completely. Even with this patch
  applied the WARN was encountered once while running the stress
  selftests.

Could you please advise on how to proceed? Do you perhaps have ideas
why the backing store could not contain a page when it is loaded back
during the ENCLS[ELDU] flow?
There is some interesting text in the comments within shmem_fault()
that hints that faulting pages should be avoided into holes as they
are being punched ... but I do not understand those details and
would really appreciate guidance on how to understand what is going on
here.

These SGX2 tests exercise the concurrent operation of reclaimer and page
fault handler and have a good track record of locating issues. Thanks
to it we already have:
8795359e35bc ("x86/sgx: Silence softlockup detection when releasing large enclaves")
ac5d272a0ad0 ("x86/sgx: Fix free page accounting")
While this issue is triggered by the SGX2 tests I cannot find a connection
with the SGX2 code paths. I have made a few attempts to create an
equivalent test for SGX1 but have not yet had success to create a SGX1
test that can trigger this issue.

These patches are based on v5.18-rc4 with the SGX2 series applied but
do not touch SGX2 code paths. Patch 1,2, and 3 also apply cleanly to
v5.18-rc4 while patch 4 has a conflict in arch/x86/kernel/cpu/sgx/encl.h
due to the SGX2 declarations.

Your feedback will be greatly appreciated.
Thank you very much

Reinette

[1] https://lore.kernel.org/lkml/cover.1649878359.git.reinette.chatre@intel.com/

Reinette Chatre (4):
  x86/sgx: Do not free backing memory on ENCLS[ELDU] failure
  x86/sgx: Set dirty bit after modifying page contents
  x86/sgx: Obtain backing storage page with enclave mutex held
  x86/sgx: Do not allocate backing pages when loading from backing store

 arch/x86/kernel/cpu/sgx/encl.c  | 89 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/encl.h  |  8 ++-
 arch/x86/kernel/cpu/sgx/ioctl.c |  1 +
 arch/x86/kernel/cpu/sgx/main.c  | 15 +++---
 4 files changed, 93 insertions(+), 20 deletions(-)

-- 
2.25.1

