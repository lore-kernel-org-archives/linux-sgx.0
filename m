Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C1CC433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 03:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbiEJDUV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 23:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbiEJDUU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 23:20:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BE73896
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 20:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152583; x=1683688583;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ncJU+9Z3u0nNtd3f7viRlRXVqRmPbznWQRvHBJoTpLA=;
  b=nnc9zTI1kqYerRk9A1px3rifKU4SYBIRFh0VsbPTEezjpNyP5iLmYA6y
   RqZTUB5LTBiIAj232rnnhHatXud1hucvABhajyaYWFkH+zG04z2MASqWG
   E7hNnSWsqlKDtNGps9zr8Wtl/QDjW0h1i6s3E8xD3llYva7+TsCxiuGDd
   PHCJ7zjX4KNr5rFeJG2GsN92g89Fhc3+MagK424lBJlCAbSSPbVwAbtdP
   +OSXz4Zj+jhHFJDZ2TsesQrR98T+SXbh2BtFYS+cqDNJhG1x6FOeckwiF
   RigyE4kVtLIH/4TqucOEoVICnG39NKVdVncCDkRHQwJhC8JJmD+Ulp7Wr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="268909103"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="268909103"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:16:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="710818514"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2022 20:16:20 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
Date:   Tue, 10 May 2022 11:16:46 +0800
Message-Id: <20220510031646.3181306-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi everyone,

This series contains a few patches to fine grained SGX MCA behavior.

When VM guest access a SGX EPC page with memory failure, current
behavior will kill the guest, expected only kill the SGX application
inside it.

To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
information for hypervisor to inject #MC information to guest, which
is helpful in SGX virtualization case.

However, current SGX data structures are insufficient to track the
EPC pages for vepc, so we introduce a new struct sgx_vepc_page which
can be the owner of EPC pages for vepc and saves the useful info of
EPC pages for vepc, like struct sgx_encl_page.

Moreover, canonical memory failure collects victim tasks by iterating
all the tasks one by one and use reverse mapping to get victim tasks’
virtual address. This is not necessary for SGX - as one EPC page can
be mapped to ONE enclave only. So, this 1:1 mapping enforcement
allows us to find task virtual address with physical address
directly.

Then we extend the solution for the normal SGX case, so that the task
has opportunity to make further decision while EPC page has memory
failure.

Tests:
1. MCE injection test for SGX in VM.
   As we expected, the application was killed and VM was alive.
2. MCE injection test for SGX on host.
   As we expected, the application received SIGBUS with extra info.
3. Kernel selftest/sgx: PASS
4. Internal SGX stress test: PASS
5. kmemleak test: No memory leakage detected.

Zhiquan Li (4):
  x86/sgx: Move struct sgx_vepc definition to sgx.h
  x86/sgx: add struct sgx_vepc_page to manage EPC pages for vepc
  x86/sgx: Fine grained SGX MCA behavior for virtualization
  x86/sgx: Fine grained SGX MCA behavior for normal case

 arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h  | 12 ++++++++++++
 arch/x86/kernel/cpu/sgx/virt.c | 29 +++++++++++++++++++----------
 3 files changed, 53 insertions(+), 12 deletions(-)

-- 
2.25.1

