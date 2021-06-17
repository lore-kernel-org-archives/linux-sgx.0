Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12797C2B9F4
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Jun 2021 19:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EABBB613D8
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Jun 2021 19:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhFQTtb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Jun 2021 15:49:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:23303 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233057AbhFQTta (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Jun 2021 15:49:30 -0400
IronPort-SDR: TR8lXcpHxbed9EszQJjZtbQ5y1D/jGbZNZu7jSPcy8FX0QTeNspHc7D3SGqn1385pfDrr257Jc
 0s4aWtQ3VMbw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="186818419"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="186818419"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 12:47:22 -0700
IronPort-SDR: MprMayKO8/gtCYVlX9IaZQPRQFqztxrVqbt9byaOD2vrPghqLKIFyolw41o5ztTnoG0BFK0kX9
 niEzMGYN8+pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="443343800"
Received: from viggo.jf.intel.com (HELO localhost.localdomain) ([10.54.77.144])
  by orsmga007.jf.intel.com with ESMTP; 17 Jun 2021 12:47:21 -0700
Subject: [PATCH] x86/mm: avoid truncating memblocks for SGX memory
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>, fan.du@intel.com,
        reinette.chatre@intel.com, jarkko@kernel.org,
        dan.j.williams@intel.com, dave.hansen@intel.com, x86@kernel.org,
        linux-sgx@vger.kernel.org, luto@kernel.org, peterz@infradead.org
From:   Dave Hansen <dave.hansen@linux.intel.com>
Date:   Thu, 17 Jun 2021 12:46:57 -0700
Message-Id: <20210617194657.0A99CB22@viggo.jf.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


From: Fan Du <fan.du@intel.com>

tl;dr:

Several SGX users reported seeing the following message on NUMA systems:

	sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback to the NUMA node 0.

This turned out to be the 'memblock' code mistakenly throwing away
SGX memory.

=== Full Changelog ===

The 'max_pfn' variable represents the highest known RAM address.  It can
be used, for instance, to quickly determine for which physical addresses
there is mem_map[] space allocated.  The numa_meminfo code makes an
effort to throw out ("trim") all memory blocks which are above 'max_pfn'.

SGX memory is not considered RAM (it is marked as "Reserved" in the
e820) and is not taken into account by max_pfn.  Despite this, SGX
memory areas have NUMA affinity and are enumerated in the ACPI SRAT.
The existing SGX code uses the numa_meminfo mechanism to look up the
NUMA affinity for its memory areas.

In cases where SGX memory was above max_pfn (usually just the one EPC
section in the last highest NUMA node), the numa_memblock is truncated
at 'max_pfn', which is below the SGX memory.  When the SGX code tries to
look up the affinity of this memory, it fails and produces an error message:

	sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback to the NUMA node 0.

and assigns the memory to NUMA node 0.

Instead of silently truncating the memory block at 'max_pfn' and
dropping the SGX memory, add the truncated portion to
'numa_reserved_meminfo'.  This allows the SGX code to later determine
the NUMA affinity of its 'Reserved' area.

Without this patch, numa_meminfo looks like this (from 'crash'):

  blk = { start =          0x0, end = 0x2080000000, nid = 0x0 }
        { start = 0x2080000000, end = 0x4000000000, nid = 0x1 }

numa_reserved_meminfo is empty.

After the patch, numa_meminfo looks like this:

  blk = { start =          0x0, end = 0x2080000000, nid = 0x0 }
        { start = 0x2080000000, end = 0x4000000000, nid = 0x1 }

and numa_reserved_meminfo has an entry for node 1's SGX memory:

  blk =  { start = 0x4000000000, end = 0x4080000000, nid = 0x1 }

 [ daveh: completely rewrote/reworked changelog ]

Signed-off-by: Fan Du <fan.du@intel.com>
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Fixes: 5d30f92e7631 ("x86/NUMA: Provide a range-to-target_node lookup facility")
Cc: x86@kernel.org
Cc: linux-sgx@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---

 b/arch/x86/mm/numa.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/numa.c~sgx-srat arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~sgx-srat	2021-06-17 11:23:05.116159990 -0700
+++ b/arch/x86/mm/numa.c	2021-06-17 11:55:46.117155100 -0700
@@ -254,7 +254,13 @@ int __init numa_cleanup_meminfo(struct n
 
 		/* make sure all non-reserved blocks are inside the limits */
 		bi->start = max(bi->start, low);
-		bi->end = min(bi->end, high);
+
+		/* preserve info for non-RAM areas above 'max_pfn': */
+		if (bi->end > high) {
+			numa_add_memblk_to(bi->nid, high, bi->end,
+					   &numa_reserved_meminfo);
+			bi->end = high;
+		}
 
 		/* and there's no empty block */
 		if (bi->start >= bi->end)
_
