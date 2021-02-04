Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416D4C433DB
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Feb 2021 18:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28AA64DDE
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Feb 2021 18:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhBDSvX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 4 Feb 2021 13:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbhBDSqI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 4 Feb 2021 13:46:08 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CA7C06178B
        for <linux-sgx@vger.kernel.org>; Thu,  4 Feb 2021 10:45:28 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l12so4035751wmq.2
        for <linux-sgx@vger.kernel.org>; Thu, 04 Feb 2021 10:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDlKe0WbpqBDHIpCDDh4FugA9Yl2NTww4rbLOTGr+nM=;
        b=BSD24lcMJFm1yoPHDL+vPC2t6eYWXJl+gb63Lc2kEu4Y6EX8foAiW4INgUcC7527BK
         is+2hBSUdsPg0+Z3aHdGn8s4rSjiYJZI/Wed+PMMBRS5JJPUJEcRXT6pfG8B2lPQ4COf
         jC+i/6A1QM62BytlMc5wKaK52uyyRjCdedByQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDlKe0WbpqBDHIpCDDh4FugA9Yl2NTww4rbLOTGr+nM=;
        b=r4SEL0aMMYYgVaj+hiooxp7XkOF9Ek9IqhpnWCcTj27Uu188ZM5sKjaoz3vCUBm5ae
         W9WSohThSVdBsYih5H8WPDlskKZ9/66Umn7j9JDjyo5ZH8fE14eJVVXfqahpGthTiANY
         gn0nZyqcOhcNFltnZq0au9vuYXDSZI3GOVKKiERyELtWOYERRP09lIlbaWfon+qcOEK9
         tE9GupWPXWGtF+uJYf6/AnE2qCN4hETDk4JB46Fbqr3O/cYaIRoTkU3Grw/Znn9Cnqw5
         knRPF07yVJW/c076U2rv78HA75uzi5pJn4PFIdaTKjKOWH3gJ34VeBpMmZmMhjLArl14
         UEzw==
X-Gm-Message-State: AOAM530F6ZHrzevYGO8F330KgLLKoWb4fFXuK/dAuODwRQMnreleX9S8
        I202/8ratvvdvlgaed/3W5PwZg==
X-Google-Smtp-Source: ABdhPJwr8sCr/vTIsvxni8hp5KegeEeUyEeymi2FitAM/6CHsPHduLd2lAH04rBfHoBvmYrzEYKENw==
X-Received: by 2002:a1c:105:: with SMTP id 5mr469215wmb.89.1612464326728;
        Thu, 04 Feb 2021 10:45:26 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id m10sm9322997wro.7.2021.02.04.10.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 10:45:26 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] x86/sgx: Drop racy follow_pfn check
Date:   Thu,  4 Feb 2021 19:45:19 +0100
Message-Id: <20210204184519.2809313-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PTE insertion is fundamentally racy, and this check doesn't do
anything useful. Quoting Sean:

"Yeah, it can be whacked.  The original, never-upstreamed code asserted that the
resolved PFN matched the PFN being installed by the fault handler as a sanity
check on the SGX driver's EPC management.  The WARN assertion got dropped for
whatever reason, leaving that useless chunk."

Jason stumbled over this as a new user of follow_pfn, and I'm trying
to get rid of unsafe callers of that function so it can be locked down
further.

This is independent prep work for the referenced patch series.

References: https://lore.kernel.org/dri-devel/20201127164131.2244124-1-daniel.vetter@ffwll.ch/
Reported-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sean Christopherson <seanjc@google.com>
Fixes: 947c6e11fa43 ("x86/sgx: Add ptrace() support for the SGX driver")
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: linux-sgx@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ee50a5010277..20a2dd5ba2b4 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -141,7 +141,6 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	struct sgx_encl_page *entry;
 	unsigned long phys_addr;
 	struct sgx_encl *encl;
-	unsigned long pfn;
 	vm_fault_t ret;
 
 	encl = vma->vm_private_data;
@@ -168,13 +167,6 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 
 	phys_addr = sgx_get_epc_phys_addr(entry->epc_page);
 
-	/* Check if another thread got here first to insert the PTE. */
-	if (!follow_pfn(vma, addr, &pfn)) {
-		mutex_unlock(&encl->lock);
-
-		return VM_FAULT_NOPAGE;
-	}
-
 	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(phys_addr));
 	if (ret != VM_FAULT_NOPAGE) {
 		mutex_unlock(&encl->lock);
-- 
2.30.0

