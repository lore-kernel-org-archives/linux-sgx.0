Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856CCC433E9
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Feb 2021 03:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F81664DA8
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Feb 2021 03:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBPDcV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Feb 2021 22:32:21 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53498 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhBPDcR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 15 Feb 2021 22:32:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UOk1HHd_1613446293;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UOk1HHd_1613446293)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Feb 2021 11:31:34 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v5 0/3] Some optimizations related to sgx
Date:   Tue, 16 Feb 2021 11:31:30 +0800
Message-Id: <20210216033133.79543-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This is an optimization of a set of sgx-related codes, each of which
is independent of the patch. Because the second and third patches have
conflicting dependencies, these patches are put together.

---
v5 changes:
  * Remove the two patches with no actual value
  * Typo fix in commit message

v4 changes:
  * Improvements suggested by review

v3 changes:
  * split free_cnt count and spin lock optimization into two patches

v2 changes:
  * review suggested changes

Tianjia Zhang (3):
  selftests/x86: Use getauxval() to simplify the code in sgx
  x86/sgx: Allows ioctl PROVISION to execute before CREATE
  x86/sgx: Remove redundant if conditions in sgx_encl_create

 arch/x86/kernel/cpu/sgx/driver.c   |  1 +
 arch/x86/kernel/cpu/sgx/ioctl.c    |  8 ++++----
 tools/testing/selftests/sgx/main.c | 24 ++++--------------------
 3 files changed, 9 insertions(+), 24 deletions(-)

-- 
2.19.1.3.ge56e4f7

