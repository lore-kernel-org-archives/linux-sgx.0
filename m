Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9484C433FE
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 22:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiKGWCU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 17:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiKGWCN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 17:02:13 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5705F58D
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 14:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667858532; x=1699394532;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h1ak/FXDtFE3l9TbSMLWrkcD5jefKTQoeVJ1xxdxXGE=;
  b=nB5OtTE7zWCAt2M8t2Vp9ZkmkqcAFvLTBR6SGaZKZ11Pp4YjGSX/G2Hu
   XGRk+Kp6hpflQKHXqhZ3eQ4DjGVFcMDjVjV0SpG1ustoK0hPA43vJA+b/
   kdZfE5G4TSiRf66d/Ujr0CwgeHvW9c6Yyq6DKw2oD8j0qUk6GHBv1Ebgl
   Q4s1Bt40iChsbwwieGgLITWNDfDRnTqt34V8/pWbyQQELK6RCWD2FQYH0
   e6CXZVDv2htkAR7zFqJa88NQ6/qfRbZT1Z8XDTlKq/+hkXaIbqrwEeC0r
   28lvZO+xTuaUQQ6bETRJ5NAAQzzg8RjeHkkTDCe/kuZOu7a9ruw13/tUq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308158022"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308158022"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:02:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630643318"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630643318"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga007.jf.intel.com with ESMTP; 07 Nov 2022 14:02:12 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v3 0/4]  x86/sgx: implement support for MADV_WILLNEED
Date:   Mon,  7 Nov 2022 14:02:08 -0800
Message-Id: <20221107220212.257422-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

V2: https://lore.kernel.org/linux-sgx/20221027194532.180053-1-haitao.huang@linux.intel.com/T/#t
Chnages since V2:
- format changes and remove unneeded comments. (Jarkko)
- use PFN_DOWN instead of ">> PAGE_SHIFT". (Jarkko)

V1: https://lore.kernel.org/linux-sgx/20221019191413.48752-1-haitao.huang@linux.intel.com/T/#t
Changes since V1:
- Separate patch for exporting sgx_encl_eaug_page
- Move return code changes for sgx_encl_eaug_page to the same patch
  implementing sgx_fadvise
- Small improvement in commit messages and the cover letter

Hi Everybody,

The current SGX2 (EDMM) implementation in the kernel only adds
an EPC page when a page fault is triggered on an address without
EPC allocated. Although this is adquate for allocations of smaller
address ranges or ranges with sparse accessing patterns, it is
inefficient for other cases in which large number of EPC pages
need be added and accessed immediately afterwards.

Previously we have attempted [1] to address this issue by implementing
support for the semantics of MAP_POPULATE flag passed into mmap(). However,
some mm maintainers have concerns on adding a new callback in fops [2].

This series is to adopt the MADV_WILLNEED alternative suggested
by Dave in previous discussions [3]. The sgx driver implements the
fops->fadvise() so that user space will be able to use
madvise(..., MADV_WILLNEED) to instruct kernel to EAUG pages as
soon as possible for a given range.

Compared to the MAP_POPULATE approach, this alternative requires an
additional call to madvise() after mmap() from user space. But it
would not need any changes in kernel outside the SGX driver. The separate
madvise() call also offers flexibility for user space to specify a
subrange to EAUG in an enclosing VMA.

The core implementation is in the second patch while the first patch
only exports a function handling EAUG on PF to be reused.

The last two patches are to add a microbenchmark in the sgx selftest to
measure the performance difference.  Following speedup on various
allocation sizes were observed when I ran it on a platform with 4G EPC.
It indicates that the change would roughly half the run time until
EPC swapping is activated, at which point EAUG for madvise is stopped.
-------------------------
  Alloc. size: Speedup
-------------------------
      1 page : 75%
      2 pages: 48%
      4 pages: 55%
      8 pages: 58%
     16 pages: 62%
     32 pages: 62%
     64 pages: 62%
    128 pages: 62%
    256 pages: 73%
    512 pages: 62%
   1024 pages: 62%
   2048 pages: 62%
   4096 pages: 61%
   8192 pages: 61%
  16384 pages: 61%
  32768 pages: 71%
  65536 pages: 61%
 131072 pages: 62%
 262144 pages: 62%
 524288 pages: 62%
1048576 pages: 55%
2097152 pages: 19%
-------------------------

Thank you very much for your attention and any comments/feedback.

Haitao

[1]https://lore.kernel.org/all/20220308112833.262805-1-jarkko@kernel.org/
[2]https://lore.kernel.org/linux-sgx/20220306021534.83553-1-jarkko@kernel.org/
[3]https://lore.kernel.org/linux-sgx/c3083144-bfc1-3260-164c-e59b2d110df8@intel.com/

Haitao Huang (4):
  x86/sgx: Export sgx_encl_eaug_page
  x86/sgx: Implement support for MADV_WILLNEED
  selftests/sgx: add len field for EACCEPT op
  selftests/sgx: Add test for madvise(..., WILLNEED)

 arch/x86/kernel/cpu/sgx/driver.c        |  76 +++++++++++
 arch/x86/kernel/cpu/sgx/encl.c          |  46 ++++---
 arch/x86/kernel/cpu/sgx/encl.h          |   2 +
 tools/testing/selftests/sgx/defines.h   |   1 +
 tools/testing/selftests/sgx/main.c      | 167 ++++++++++++++++++++++++
 tools/testing/selftests/sgx/test_encl.c |  20 ++-
 6 files changed, 290 insertions(+), 22 deletions(-)

-- 
2.25.1

