Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51298C48BE5
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 00:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B08461107
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Jun 2021 00:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhFPArN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Jun 2021 20:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhFPArN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Jun 2021 20:47:13 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF89DC06175F
        for <linux-sgx@vger.kernel.org>; Tue, 15 Jun 2021 17:45:07 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d7-20020ac811870000b02901e65f85117bso438246qtj.18
        for <linux-sgx@vger.kernel.org>; Tue, 15 Jun 2021 17:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LAtBe1i9QhHKeYZZABwyxEaBkt2ZmCBgZJOCDygERjA=;
        b=AnLpMAyg4/bsQ5ot7VlrLMCC3Gs/dLXo8gb9XR2t+kZPGucjlqTUQ2MhpMtPKhRz2J
         GM0zJcrIAIxIHwzmcZu8vBU3V4esevTpms5odDTEvk6a/FO3UqIvpZSj3xqYF7l0mQ4n
         9+17IZPmW1eYOT2ooLRrVr7n0aseNkeHHgybMwsQEIYdi0TgpPpOmCaQm1y1qNLXs+x+
         IL/EeLsMoBr+WRbtHqlkHyisbtmTA1Ww20hmdNC08vFLlWOFU1fu7T3ShfFqFLuHksB2
         BVOJunRyHNmDqMdGz5UXxMITAro7zABjRlWyPUVa0E1lJoNLWI8GEaxs54jCkCOzT3Nl
         xxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=LAtBe1i9QhHKeYZZABwyxEaBkt2ZmCBgZJOCDygERjA=;
        b=WMjaJM7JjP852YpAYUxyaGW5WLhQT14Oe99XJOM5UzguAGt+3LmBUivVrOs9wGxyTh
         TNqmwA3Kx8yK780i6Ce6s4bzWFFGLEStfSOEsC98NGOUlhmEJaGhH+v12+kvDear3cZ6
         3UtU9+QVFJDu2QoIwCnnzERz/EQTdkV9tRsTvQaLsERoasO98G4ElpUZUYH5x60oQxIF
         lvNK4b5bUbKRVTfbHP2DUZS9AArjCXUWSloswKSXnRP6Sw1WoOj/Xrqw6ZIgOnCzoHv8
         zVeVlH1t5dhr/ZEF5p1LnEdkUKGmZyeeqElMsYfu/MaSo4Go6gBABdLlwOlrQ9qUfowz
         MucQ==
X-Gm-Message-State: AOAM531LzJtWWuJ9ll1i05aqs9kMoBpy7wneveOQAYxHkjuGUP9KvhxJ
        X3PJ2XeCzrKyiCaSWiTU7lFY0u7Q0Hk=
X-Google-Smtp-Source: ABdhPJx7Ddxsv0ETLvnxMiVX9cRfwyC7fngv8f9xjb5fNX0FXjQCO3pF2wMX8mqou0Fys9G62nr2Ln2+lBk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:af9:198d:bf4e:6def])
 (user=seanjc job=sendgmr) by 2002:a0c:f684:: with SMTP id p4mr8247882qvn.16.1623804306792;
 Tue, 15 Jun 2021 17:45:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Jun 2021 17:44:58 -0700
Message-Id: <20210616004458.2192889-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH] x86/sgx: Suppress WARN on inability to sanitize EPC if ksgxd
 is stopped
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Du Cheng <ducheng2@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Don't WARN on having unsanitized EPC pages if ksgxd is stopped early,
e.g. if sgx_init() realizes there will be no downstream consumers of EPC.
If ksgxd is stopped early, EPC pages may be left on the dirty list, but
that's ok because ksgxd is only stopped if SGX initialization failed or
if the kernel is going down.  In either case, the EPC won't be used.

This bug was exposed by the addition of KVM support, but has existed and
was hittable since the original sanitization code was added.  Prior to
adding KVM support, if Launch Control was not fully enabled, e.g. when
running on older hardware, sgx_init() bailed immediately before spawning
ksgxd because X86_FEATURE_SGX was cleared if X86_FEATURE_SGX_LC was
unsupported.

With KVM support, sgx_drv_init() handles the X86_FEATURE_SGX_LC check
manually, so now there's any easy-to-hit case where sgx_init() will spawn
ksgxd and _then_ fail to initialize, which results in sgx_init() stopping
ksgxd before it finishes sanitizing the EPC.

Prior to KVM support, the bug was much harder to hit because it basically
required char device registration to fail.

Reported-by: Du Cheng <ducheng2@gmail.com>
Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Lightly tested due to lack of hardware.  I hacked the flow to verify that
stopping early will leave work pending, and that rechecking should_stop()
suppress the resulting WARN.

 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ad904747419e..fbad2b9625a5 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -425,7 +425,7 @@ static int ksgxd(void *p)
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
 	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	WARN_ON(!list_empty(&sgx_dirty_page_list) && !kthread_should_stop());
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
-- 
2.32.0.272.g935e593368-goog

