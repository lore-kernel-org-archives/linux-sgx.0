Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DFAC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 25 May 2022 10:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiEYKGP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 May 2022 06:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242267AbiEYKFt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 25 May 2022 06:05:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50C393463
        for <linux-sgx@vger.kernel.org>; Wed, 25 May 2022 03:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653473143; x=1685009143;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rdgEFjyUdjrPgZfxCAp33r8+6xXzryblkOzPGVg+1xA=;
  b=KBnhjorHS4ZhqDPrgLAE91yzpLxyomdVybxBy8yy0sU4eWwb0BcX3T1K
   QX4dWzetl+sf6Rw83E9NhB9We9fZcQ4iZZFuxTGrI34xOIYlnR4YhMict
   nczRK7zszktmXYH0B477KdBTAcJDkG75JN5Tmh7Q0O1Bw+SKdKRPq4pCZ
   11nDvwFQKMugWId7CrIM9O3IbTBK/Lr7bNjmnUoHIkNIrlBdY7gQ+NN4M
   DKzmjypZFWDJWaNXUhZGoEsnTQ1DLwW/f377hXwHCVIGMJi+4aOg/ohVV
   GDxcI31vmsNAfb//+XyUmFLbR+r4wCxkVueBHTVapl42eKxF0CjFh7grj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="273771447"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="273771447"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 03:05:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="717572780"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2022 03:05:40 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v3 1/3] x86/sgx: Repurpose the owner field as the virtual address of virtual EPC page
Date:   Wed, 25 May 2022 18:06:25 +0800
Message-Id: <20220525100625.760633-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When a page triggers a machine check, it only reports the
physical address of EPC page. But in order to inject #MC into
hypervisor, the virtual address is required. Then repurpose the
"owner" field as the virtual address of the virtual EPC page so that
arch_memory_failure() can easily retrieve it.

The EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the meaning
of the field.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
Changes since V2:
- Rework the patch suggested by Jarkko.
- Remove struct sgx_vepc_page and relevant code.
- Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
  duplicated to SGX_EPC_PAGE_KVM_GUEST.
  Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u

Changes since V1:
- Add documentation suggested by Jarkko.
---
 arch/x86/kernel/cpu/sgx/virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 8c7c1d0451c2..776ae5c1c032 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -46,7 +46,7 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 	if (epc_page)
 		return 0;
 
-	epc_page = sgx_alloc_epc_page(vepc, false);
+	epc_page = sgx_alloc_epc_page((void *)addr, false);
 	if (IS_ERR(epc_page))
 		return PTR_ERR(epc_page);
 
-- 
2.25.1

