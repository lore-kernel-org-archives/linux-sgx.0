Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C78C433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Dec 2021 22:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhLQWb5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Dec 2021 17:31:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:24612 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhLQWb5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 Dec 2021 17:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639780317; x=1671316317;
  h=subject:to:cc:from:date:message-id;
  bh=h/kh3f2NEylLar0CwBJfdtaQ4b1B2h781BlpcjgooB8=;
  b=Pdo+eZfepygf27FisyapigmQesKzoCsf+OsE8hx3xIb/PMI55/+yz3eh
   zzkR76OIAsuJYt7xi4BL7tRU3htOwX85x/Jzw2Uk+Zc7h7t7zgqT9s1RT
   iC+OGz/BAnyMV2r84CXQ7MAtcM5O5xlDVZIZfIPX/DSsus+v8Z9fJI4kz
   sDG/P4mcNhxttGF57rW3VQ5EC0BcG+eDdievYD+Hl8ZMFOpW2FF7Xle4e
   XJ7R7pNikKOf2GzYp2wA9cRhBbNNRLUb5LVD8IY7upUJXmk66/XemhaNF
   1lWuiR3F4hy+UZ/Gq3FQtSmGv4omZw1cXpHJRsWeke68uTK/+q1q8Ovzb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="227133126"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="227133126"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 14:31:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="662970076"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.28.105])
  by fmsmga001.fm.intel.com with ESMTP; 17 Dec 2021 14:31:53 -0800
Subject: [PATCH] x86/sgx: Fix NULL pointer dereference on non-SGX systems
To:     dave@sr71.net
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, nathan@kernel.org,
        gregkh@linuxfoundation.org, jarkko@kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
From:   Dave Hansen <dave.hansen@linux.intel.com>
Date:   Fri, 17 Dec 2021 14:31:53 -0800
Message-Id: <20211217223153.837591E0@davehans-spike.ostc.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Nathan Chancellor reported an oops when aceessing the
'sgx_total_bytes' sysfs file:

	https://lore.kernel.org/all/YbzhBrimHGGpddDM@archlinux-ax161/

The sysfs output code accesses the sgx_numa_nodes[] array
unconditionally.  However, this array is allocated during SGX
initialization, which only occurs on systems where SGX is
supported.

If the sysfs file is accessed on systems without SGX support,
sgx_numa_nodes[] is NULL and an oops occurs.

Add a check to ensure that SGX has been initialized to the point
where sgx_numa_nodes[] is allocated, before accessing it.

Reported-by: Nathan Chancellor <nathan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-sgx@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/kernel/cpu/sgx/main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr arch/x86/kernel/cpu/sgx/main.c
--- a/arch/x86/kernel/cpu/sgx/main.c~sgx-null-ptr	2021-12-17 13:38:00.217312383 -0800
+++ b/arch/x86/kernel/cpu/sgx/main.c	2021-12-17 14:00:36.293044390 -0800
@@ -906,7 +906,13 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 #ifdef CONFIG_NUMA
 static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%lu\n", sgx_numa_nodes[dev->id].size);
+	unsigned long node_bytes = 0;
+
+	/* Avoid acccessing sgx_numa_nodes[] when it is not allocated: */
+	if (!nodes_empty(sgx_numa_mask))
+		node_bytes = sgx_numa_nodes[dev->id].size;
+
+	return sysfs_emit(buf, "%lu\n", node_bytes);
 }
 static DEVICE_ATTR_RO(sgx_total_bytes);
 
_
