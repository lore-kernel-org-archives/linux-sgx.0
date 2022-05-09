Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B90C4332F
	for <linux-sgx@archiver.kernel.org>; Mon,  9 May 2022 21:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiEIVxg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 17:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiEIVw1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 17:52:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF3F274A24
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 14:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652132894; x=1683668894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3CwrkwoWgI+gj3QvjNXSD+lpJOi4/RJbVtvcKVuxOlM=;
  b=BpcqQROPw/Ig/cBIzRvSxugBsMKAElrk24b4Bcp3bNEAonizo4BNKtyb
   1zsIGwjBx2smS0/uDo3Bsuq3UAGZlI4r0Vc/k1sITEyazWRpLdiiFCmkX
   /wNYazZke6FQGzxNf48FWn8R8eyIJ941eXZBu0zrSym9Iswhg63XzY45Z
   sx1Q4VS1Lc+nJxVnOqnmWxte+XUuQi2Zvq+Md9xXixIi4wNx1GjaZ41+u
   7CwR/nuK8xZ/jywLGnboN8ip/XRfKvLWQ1urvGYUbFVflUANF+KC1Ut7N
   483F9O/zXOmvdz5c/hEPTPonl28NWu40DBaTE664zcyAxDRKottw2RCHK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332212853"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="332212853"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="565293493"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [PATCH V2 2/5] x86/sgx: Mark PCMD page as dirty when modifying contents
Date:   Mon,  9 May 2022 14:48:00 -0700
Message-Id: <217608112793e76b335540edde75dfda290de16c.1652131695.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1652131695.git.reinette.chatre@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
after faulting the enclave page") expanded __sgx_encl_eldu()
to clear an enclave page's PCMD (Paging Crypto MetaData)
from the PCMD page in the backing store after the enclave
page is restored to the enclave.

Since the PCMD page in the backing store is modified the page
should be marked as dirty to ensure the modified data is retained.

Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC v1:
- Do not set dirty bit on enclave page since it is not being
  written to and always will be discarded.  (Dave)

 arch/x86/kernel/cpu/sgx/encl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 398695a20605..2521d64e8bcf 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -83,6 +83,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 		ret = -EFAULT;
 	}
 
+	set_page_dirty(b.pcmd);
 	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
 
 	/*
-- 
2.25.1

