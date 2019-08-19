Return-Path: <SRS0=kvvX=WP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE81C3A5A0
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 15:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5EBD22CE2
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 15:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfHSPZt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:25:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:46721 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSPZt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 11:25:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 08:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="180393006"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga003.jf.intel.com with ESMTP; 19 Aug 2019 08:25:45 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH 0/5] x86/sgx: Improve permission handing
Date:   Mon, 19 Aug 2019 18:25:39 +0300
Message-Id: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Refine the naming, documentation and validation of the page permissions.
silent behaviour to occur.

Cc: Sean Christopherson <sean.j.christpherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>

Jarkko Sakkinen (5):
  x86/sgx: Document permission handling better
  x86/sgx: Use memchr_inv() in sgx_validate_secinfo()
  x86/sgx: Make sgx_validate_secinfo() more readable
  x86/sgx: Validate TCS permssions in sgx_validate_secinfo()
  x86/sgx: Rename vm_prot_bits as max_vm_flags

 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 36 +++++++++++++++++++-------
 arch/x86/kernel/cpu/sgx/encl.c         | 14 +++++-----
 arch/x86/kernel/cpu/sgx/encl.h         |  4 +--
 3 files changed, 35 insertions(+), 19 deletions(-)

-- 
2.20.1

