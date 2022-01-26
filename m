Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D76C28CF5
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jan 2022 19:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244394AbiAZTRW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jan 2022 14:17:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:3417 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231214AbiAZTRV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Jan 2022 14:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643224641; x=1674760641;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3ELzvOvRMWmmrXxm7iL4G7ZlIjM5GQLMgDcSUq96FFs=;
  b=eMzvvLDStQd3M0QoOQGPQiidbnJI7XWZmzOBpHn3LSxjiQiNMJFn7Ptc
   xS+57ITtj98cWGvhUTv2FEE78RpUB+4bZa5hg2awxOpFuQi3JfjkuD5Bx
   IScdeDb0RDcuK8jlLh/vszA/ISvWD8lKZZj66YxKScwEP6+HDzfCpF8wd
   r6+8UaCew6S1uEp60I68glUGU3+p+pZicDFmAcvPzTcW/6Ao/cq7VSXoo
   75F/XAb8OJ5JvmRm4HLdcDjHNbzzrIU04eqq0t/pBAoe9n+XBRMFDYNM1
   Bz7LORXEeL93l/LHXeepnCOU62bw3oZFLzunYOuD+i9JWrKc/VR5lAiee
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="271082417"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="271082417"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:17:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="479992541"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.3.61])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:17:19 -0800
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, dave.hansen@intel.com
Cc:     haitao.huang@linux.intel.com, jarkko@kernel.org
Subject: [PATCH 0/2] Fixups for overcommit limit pages
Date:   Wed, 26 Jan 2022 11:17:09 -0800
Message-Id: <20220126191711.4917-1-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dave,
Here are some fixups for the patches in your tree for the overcommit
limit. The first was send earlier but is a resend. The second fixes
an issue reported by Haitao with hanging while attempting to add pages
when the limit is reached.

Kristen Carlson Accardi (2):
  x86/sgx: fixup for available backing pages calculation
  x86/sgx: Allow sgx_reclaim_pages() to report failure

 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

-- 
2.20.1

