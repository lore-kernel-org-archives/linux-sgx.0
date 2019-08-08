Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DB2C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 22:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5BD21773
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 22:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390493AbfHHWNn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 18:13:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:19058 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390491AbfHHWNm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 18:13:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 15:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,363,1559545200"; 
   d="scan'208";a="193247253"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2019 15:13:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 0/6] x86/sgx: Remove EADD worker and page copy
Date:   Thu,  8 Aug 2019 15:13:34 -0700
Message-Id: <20190808221340.29460-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As suggested by Andy, remove the work queue in favor of handling the
entire EADD flow in the context of the ioctl().  After the worker is
gone, pass the source page/address directly to EADD instead of first
copying the data into kernel memory.

This applies on top the bug fix series I sent yesterday,
https://patchwork.kernel.org/cover/11082995/.

Sean Christopherson (6):
  x86/sgx: Validate generic SECINFO immediately after copying from user
  x86/sgx: Set SGX_ENCL_PAGE_TCS when allocating encl_page
  x86/sgx: Move encl_page insertion into tree out of alloc flow
  x86/sgx: Allocate encl_page prior to taking encl->lock
  x86/sgx: Remove the EADD page worker
  x86/sgx: Pass userspace source address directly to EADD

 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 402 +++++++------------------
 arch/x86/kernel/cpu/sgx/driver/main.c  |   4 -
 arch/x86/kernel/cpu/sgx/encl.h         |   2 -
 3 files changed, 103 insertions(+), 305 deletions(-)

-- 
2.22.0

