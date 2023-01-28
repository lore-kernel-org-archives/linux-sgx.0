Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3518EC27C76
	for <linux-sgx@archiver.kernel.org>; Sat, 28 Jan 2023 04:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjA1Ezb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Jan 2023 23:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1Eza (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 27 Jan 2023 23:55:30 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F300F8497D
        for <linux-sgx@vger.kernel.org>; Fri, 27 Jan 2023 20:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674881729; x=1706417729;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lSJ/KWetvWET3we430rF4k3tDMnJiqJFXsqFf6HtwLg=;
  b=V2Yc5RhiVYJHJQn04URH06wotC6JjjF2pT6g72PDyfX2vGixIq8pQyem
   cD1mhD5SsDhG+ckxqPk/Db8ECd6U2n5EOOGKoKLZHpurhYA9Z/0Y6F1E7
   E48Kwn7Q9TlyeNboIwyzL3FDuYW7Dr0vyYMuzbcO1Kz28jHL4MYdya1gp
   CVBGt7m2vAwjJcz4rXTF6jG7BzaxryvvcSoIhe4wOISmIkYkKB2y2cx6g
   yg50AxQi/j3Fu0fr2zv3mAWF82rblCWUtT0V2u6KvHWpEtXak6lD7TYeI
   b1MFoZZutixf3zMVG+qjA0Ye4bE38Vj8X7GMZl2jGWH1aKKatFPJLAzgR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="413484071"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="413484071"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 20:55:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="640942036"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="640942036"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga006.jf.intel.com with ESMTP; 27 Jan 2023 20:55:29 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v4 0/4]  x86/sgx: implement support for MADV_WILLNEED
Date:   Fri, 27 Jan 2023 20:55:25 -0800
Message-Id: <20230128045529.15749-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

V3: https://lore.kernel.org/linux-sgx/20221107220212.257422-1-haitao.huang@linux.intel.com/#t
Changes since V3:
- improve comments for return values of sgx_encl_eaug_page (Jarkko)
- update selftests to set value for the len field of all EACCEPT ops (Jarkko)
- remove unneeded check for 'encl' and reordered input checks and
  initialization of local vars in sgx_fadvise (Jarkko)

V2: https://lore.kernel.org/linux-sgx/20221027194532.180053-1-haitao.huang@linux.intel.com/T/#t
Changes since V2:
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

 arch/x86/kernel/cpu/sgx/driver.c        |  74 ++++++++++
 arch/x86/kernel/cpu/sgx/encl.c          |  59 ++++----
 arch/x86/kernel/cpu/sgx/encl.h          |   2 +
 tools/testing/selftests/sgx/defines.h   |   1 +
 tools/testing/selftests/sgx/main.c      | 182 ++++++++++++++++++++++++
 tools/testing/selftests/sgx/test_encl.c |  18 ++-
 6 files changed, 306 insertions(+), 30 deletions(-)

-- 
2.25.1

