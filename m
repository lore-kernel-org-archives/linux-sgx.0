Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706CEC433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Oct 2022 19:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJSTOU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJSTOS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 19 Oct 2022 15:14:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5B81CB539
        for <linux-sgx@vger.kernel.org>; Wed, 19 Oct 2022 12:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666206854; x=1697742854;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tkpyz/9ufIEHDAKskk7Qw4rHVZ//Euu81dPLqFeymCU=;
  b=nM2qbRXTXW2Tx+t7888HmH6Hy3OcE3CNPiAkfQqEKf3AT4f+4ykv3nIF
   IqeULL9gKETu/uawOxBPXR9KLn2UdQYoSIhOYxK2ctDirKfsJtHVYmrhk
   TzgyPkTTLYs110jp3aEKE6wkrUZwef/bFhISwaGOS7A5d+js5aT5Nj7M/
   Ui1xZt8kT3cVT7PoOnMvQq8RVu8eVcHyNhyDvXgITbEsQMlYasAVbUeBT
   5eW58Q2eBnrPnbrmsLCjFPKJjuq0FC0qiNCLGrHTq64To6Ar21xdUV0zH
   qQJpZPg+OiGfueS0NYCamJE2McHNBNvcQzdHEej/+VPosqYHGrhStwUxk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286226053"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286226053"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 12:14:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="874579965"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="874579965"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2022 12:14:13 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH 0/4] x86/sgx: implement support for MADV_WILLNEED
Date:   Wed, 19 Oct 2022 12:14:09 -0700
Message-Id: <20221019191413.48752-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Currently, after enclave initialization, EPC pages can only be added
one page at a time on page fault. This may be too slow for some use
cases in which large number of EPC pages are dynamically allocated.

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
would not need any changes in kernel outside sgx driver. The separate
madvise() call also offers flexibility for user space to specify a
subrange to EAUG in an enclosing VMA.

The core implementation is in the second patch while the first patch
only refactors out a function handling EAUG on PF to be reused.

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

