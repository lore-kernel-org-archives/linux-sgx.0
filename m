Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1AEECAAA1
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Oct 2022 19:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiJ0Tph (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbiJ0Tpf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Oct 2022 15:45:35 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C6B58514
        for <linux-sgx@vger.kernel.org>; Thu, 27 Oct 2022 12:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666899933; x=1698435933;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nJQs7U9vP4vtsfWTgOA/4aTp9q625YlWBDyCqqgm+vY=;
  b=LOF/zcFAn+oOo4jg1JVHEgHWOlYm1Bg4JqwBaahdRROQWK7iIpWTaG+7
   h8RZNuvwWYMK6jNO6bVVTE4K1432W/C2ftI+rfiCMnq5nwAieVps7E33Y
   4kOrOliiXRL0NsT+D+96oej0SmlASRpA2pfFb525QvYNlibzqo/K/NyAm
   H0vH1HLHd/LVww7hX3QiwJ2Y965awIxTg/sG9QzYNx2ADRzGIIz1O/XNZ
   XFkYrKHlmNDM5LvMofXaDbgFnm6R2tdMWSHEUC2qZMsrYDa7iHLWAgj2t
   6nyOuWiIUNCR2BJs7P2MlYx5I/sViqNeKoo/YEvCJeWU33hWOYgXl+fJB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="310021406"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="310021406"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 12:45:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961753287"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="961753287"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga005.fm.intel.com with ESMTP; 27 Oct 2022 12:45:32 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v2 0/4]  x86/sgx: implement support for MADV_WILLNEED
Date:   Thu, 27 Oct 2022 12:45:28 -0700
Message-Id: <20221027194532.180053-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

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

 arch/x86/kernel/cpu/sgx/driver.c        |  81 ++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c          |  46 ++++---
 arch/x86/kernel/cpu/sgx/encl.h          |   3 +-
 tools/testing/selftests/sgx/defines.h   |   1 +
 tools/testing/selftests/sgx/main.c      | 167 ++++++++++++++++++++++++
 tools/testing/selftests/sgx/test_encl.c |  20 ++-
 6 files changed, 295 insertions(+), 23 deletions(-)

-- 
2.25.1

