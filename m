Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F37C00140
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Aug 2022 04:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiHOExt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Aug 2022 00:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiHOExt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 15 Aug 2022 00:53:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB1912D38
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 21:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660539227; x=1692075227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n25opYJBD7uj9AOtSZBDAxZT5V2T345pVT3pQZuv2vY=;
  b=L/+MI8c/GnWI492kCO38ijrUSdjn1RfSEfiElplrsxSPtCS2ZglkBI1m
   7hoZsQIlCPvp7w1hIE+NkjtBI9z+6E/AdRAw8U8E/GW2Qw8E80XIMo2oS
   CrBPZqAfgbJsg1r1YEf/SHVM/EOvf+wkzclfaJO3e2taaVALYd7j6R33Q
   hGQkGs09S1ODVQDlEDL/hHHnYBcyuPM3zea6ww7mznbz62AFkgWIsrqB/
   yiLNf40cmC7xD8jWuP7YyxbIhshJRoxWJYjPsA6d4AfDS1qIWoHxGdNQ5
   8O1PE39rhIR7uuwvS7/G9lZZBQR8vHIEJadBxQ7yi8wXcwdr1eAj/9BDk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="271662359"
X-IronPort-AV: E=Sophos;i="5.93,237,1654585200"; 
   d="scan'208";a="271662359"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2022 21:53:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,237,1654585200"; 
   d="scan'208";a="603079188"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga007.jf.intel.com with ESMTP; 14 Aug 2022 21:53:47 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org
Cc:     dave.hansen@linux.intel.com, haitao.huang@linux.intel.com,
        linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on PF.
Date:   Sun, 14 Aug 2022 21:53:47 -0700
Message-Id: <20220815045347.36173-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YvlOvZfhm6msW2Ca@kernel.org>
References: <YvlOvZfhm6msW2Ca@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.

link: https://lore.kernel.org/all/20220804201456.33418-1-vijay.dhanraj@intel.com/

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 24c1bb8eb196..de92c1c8b79d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	}
 
 	va_page = sgx_encl_grow(encl, false);
-	if (IS_ERR(va_page))
+	if (IS_ERR(va_page)) {
+		if (PTR_ERR(va_page) == -EBUSY)
+			vmret =  VM_FAULT_NOPAGE;
 		goto err_out_epc;
+	}
 
 	if (va_page)
 		list_add(&va_page->list, &encl->va_pages);
-- 
2.25.1

