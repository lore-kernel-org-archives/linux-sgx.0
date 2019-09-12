Return-Path: <SRS0=BaFh=XH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D03C4CEC6
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED432081B
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfILTr3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Sep 2019 15:47:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:28920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbfILTr3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Sep 2019 15:47:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 12:47:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="190088012"
Received: from dscaswel-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.44])
  by orsmga006.jf.intel.com with ESMTP; 12 Sep 2019 12:47:24 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RESEND 00/11] v23 updates
Date:   Thu, 12 Sep 2019 20:47:09 +0100
Message-Id: <20190912194720.7107-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The previous send was a mistake and contains unfinished work. This
is my first flush of fixes and cleanups for v23.

Jarkko Sakkinen (11):
  selftest/x86/sgx: Remove encl_piggy.h
  x86/sgx: Clean up internal includes
  x86/sgx: Write backing storage only if EWB is successful
  x86/sgx: Rename 'j' as 'cnt' in sgx_reclaim_pages()
  x86/sgx: Turn encls_failed() as inline function
  x86/sgx: Move sgx_einit() to encls.c
  x86/sgx: Remove pages in sgx_reclaimer_write()
  x86/sgx: Calculate page index in sgx_reclaimer_write()
  x86/sgx: Move SGX_ENCL_DEAD check to sgx_reclaimer_write()
  x86/sgx: Free VA slot when the EWB flow fails
  x86/sgx: Call sgx_encl_destroy() when the EWB flow fails

 arch/x86/kernel/cpu/sgx/driver.c             |   2 +
 arch/x86/kernel/cpu/sgx/driver.h             |   3 -
 arch/x86/kernel/cpu/sgx/encl.c               |   2 -
 arch/x86/kernel/cpu/sgx/encl.h               |   1 +
 arch/x86/kernel/cpu/sgx/encls.c              |  54 ++++++--
 arch/x86/kernel/cpu/sgx/encls.h              |  23 +++-
 arch/x86/kernel/cpu/sgx/ioctl.c              |   2 +
 arch/x86/kernel/cpu/sgx/main.c               |  53 +-------
 arch/x86/kernel/cpu/sgx/reclaim.c            | 133 +++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h                |   3 +-
 tools/testing/selftests/x86/sgx/encl_piggy.h |  14 --
 tools/testing/selftests/x86/sgx/main.c       |   1 -
 12 files changed, 137 insertions(+), 154 deletions(-)
 delete mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.h

-- 
2.20.1

