Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB90C48BC2
	for <linux-sgx@archiver.kernel.org>; Sun, 27 Jun 2021 22:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EE0261C34
	for <linux-sgx@archiver.kernel.org>; Sun, 27 Jun 2021 22:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhF0WjG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Jun 2021 18:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhF0WjF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 27 Jun 2021 18:39:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D187C061574;
        Sun, 27 Jun 2021 15:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ZAptBywAoHBGwItSc5F6X3/jFjFcVjPnCyB17Chtz8A=; b=ffgjZk2YVg4c5jyGsWHCo1SfYB
        r/MKcYi/mEchr0HKJskO8arPmLmFrs1VxZyXCz+Xs0nH7gQ4c1txTEFZkZNxbj3MMA68ZgofT5Qz7
        3a3l2qof4b6YOrEpe7pg/X9Lvm5g60lIMQTZ2kKHXfQbC53wGsD8zfWDVoXKT9tgtObo2Yuznglsk
        +U4WEu3NWP10zZi3pULm+SQ1Yq/Yucl+RMEbwnJfeRpTtZymsBzLkpReVmK54OE/WWeKbttnNGizQ
        NCM7893RQnkLKLTyeXFcwU2jhQhlfjPgA3dFAnBTZH3YnrBF5/2bk0zBPqFnyJOVA5LVZo0F9TRl6
        cQrGxNxg==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lxdOK-006FR6-NC; Sun, 27 Jun 2021 22:36:40 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org
Subject: [PATCH] x86/SGX: drop spurious kernel-doc notation
Date:   Sun, 27 Jun 2021 15:36:39 -0700
Message-Id: <20210627223639.27714-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Drop mistaken kernel-doc notation where plain C comments
should be used instead.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-sgx@vger.kernel.org
---
 arch/x86/kernel/cpu/sgx/encl.h  |    2 +-
 arch/x86/kernel/cpu/sgx/encls.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20210625.orig/arch/x86/kernel/cpu/sgx/encl.h
+++ linux-next-20210625/arch/x86/kernel/cpu/sgx/encl.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * Copyright(c) 2016-20 Intel Corporation.
  *
  * Contains the software defined data structures for enclaves.
--- linux-next-20210625.orig/arch/x86/kernel/cpu/sgx/encls.h
+++ linux-next-20210625/arch/x86/kernel/cpu/sgx/encls.h
@@ -11,7 +11,7 @@
 #include <asm/traps.h>
 #include "sgx.h"
 
-/**
+/*
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
  *
  * ENCLS has its own (positive value) error codes and also generates
