Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C4AC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Dec 2021 17:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbhLTRrj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Dec 2021 12:47:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:9236 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhLTRri (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 Dec 2021 12:47:38 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="220909187"
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="220909187"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 09:46:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="586393010"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.42.105])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 09:46:52 -0800
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Subject: [PATCH 0/2] x86/sgx: Limit EPC overcommit
Date:   Mon, 20 Dec 2021 09:46:38 -0800
Message-Id: <20211220174640.7542-1-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX currently allows EPC pages to be overcommitted. If the system is
out of enclave memory, EPC pages are swapped to normal RAM via
a per enclave shared memory area. This shared memory is not charged
to the enclave or the task mapping it, making it hard to account
for using normal methods. Since SGX will allow EPC pages to be
overcommitted without limits, enclaves can consume system memory
for these backing pages without limits.

In order to prevent this, set a cap on the amount of overcommit SGX
allows based on a module param which can be set at boot time. Then,
whenever a backing page is requested by an enclave, keep track of
the total amount of shared memory pages used across all enclaves and
return an error if the overcommit limit has been reached. This will
restrict the total amount of backing pages that all enclaves can
consume to a maximum amount, and prevent enclaves from consuming
all the system RAM for backing pages.

The overcommit percentage has a default value of 100, which
limits shared memory page consumption to equal to the number of
EPC pages in the system. If sgx.overcommit_percent is set to a
negative value, SGX will not place any limits on the amount of
overcommit that might be requested, and SGX will behave as it has
previously without the sgx.overcommit_percent limit.


Kristen Carlson Accardi (2):
  x86/sgx: Add accounting for tracking overcommit
  x86/sgx: account backing pages

 .../admin-guide/kernel-parameters.txt         |  7 ++
 Documentation/x86/sgx.rst                     | 16 +++-
 arch/x86/kernel/cpu/sgx/Makefile              |  6 +-
 arch/x86/kernel/cpu/sgx/encl.c                | 76 ++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h                |  6 +-
 arch/x86/kernel/cpu/sgx/main.c                | 70 ++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +
 7 files changed, 173 insertions(+), 10 deletions(-)

-- 
2.20.1

