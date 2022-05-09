Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F2DC43217
	for <linux-sgx@archiver.kernel.org>; Mon,  9 May 2022 21:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiEIVxj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 17:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiEIVwl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 17:52:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041142701BE
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652132895; x=1683668895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bbYYQxyHa8LEuTGa6nZky7nvbJ9u7KqCGscsCsj+0Xw=;
  b=UmBnNobAgHyoZET40cNm176zODj02mk3Cj+y4ZsJt3H4hCRkf/vkmqNe
   5052uo5Zi041bw0gObFlH20BD9sMoHDJxUTbketLvDW2G3Hgazrd0b/UQ
   OB1Rc1QCKHsqSsrkoI4SULwZMgafOGGy7faiAYKF8wjqaO9KZlOK/ihav
   yKw93LBoEJVNT88rQVJSVA6foQOo7g+VPtQkpu85P6YmnIgDjFEPJOdue
   UBo8QMxBu6ZfbOxb0XXbL+oiqTEnSM9ZLG5uLQ5hjKGxOMKTJtE1e/ELf
   +ErOa856LQeG/2SfMHsaywUqFwsUosdAcdhwIdu7bsYc73ogoTwSHXwJg
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332212856"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="332212856"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="565293501"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [PATCH V2 5/5] x86/sgx: Ensure no data in PCMD page after truncate
Date:   Mon,  9 May 2022 14:48:03 -0700
Message-Id: <bca979301e2fbb55c314fed29c06e72e82074fba.1652131695.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1652131695.git.reinette.chatre@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A PCMD (Paging Crypto MetaData) page contains the PCMD
structures of enclave pages that have been encrypted and
moved to the shmem backing store. When all enclave pages
sharing a PCMD page are loaded in the enclave, there is no
need for the PCMD page and it can be truncated from the
backing store.

A few issues appeared around the truncation of PCMD pages. The
known issues have been addressed but the PCMD handling code could
be made more robust by loudly complaining if any new issue appears
in this area.

Add a check that will complain once with a WARN if the PCMD page is not
actually empty after it has been truncated. There should never be data
in the PCMD page at this point since it is always updated with the
enclave mutex held.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index d1d4e8572702..af972dbad965 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -183,12 +183,19 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
+	get_page(b.pcmd);
 	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page))
+	if (pcmd_page_empty && !pcmd_page_in_use(encl, pcmd_first_page)) {
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+		pcmd_page = kmap_atomic(b.pcmd);
+		WARN_ON_ONCE(memchr_inv(pcmd_page, 0, PAGE_SIZE));
+		kunmap_atomic(pcmd_page);
+	}
+
+	put_page(b.pcmd);
 
 	return ret;
 }
-- 
2.25.1

