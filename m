Return-Path: <SRS0=FIyS=WC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC688C433FF
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Aug 2019 09:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89BE520651
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Aug 2019 09:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbfHFJxQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Aug 2019 05:53:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:50613 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731711AbfHFJxQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Aug 2019 05:53:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 02:53:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="202759441"
Received: from jzelhors-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.38.117])
  by fmsmga002.fm.intel.com with ESMTP; 06 Aug 2019 02:53:13 -0700
Date:   Tue, 6 Aug 2019 12:53:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com, serge.ayoun@intel.com,
        sean.j.christopherson@intel.com
Subject: Updated the GIT tree
Message-ID: <20190806095233.t3ap4acxofoswvc2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


Hi

I did some initial updates to prepare tree for v22 changes:

* Rebased https://github.com/intel/linux-sgx.git to v5.3-rc3.
* Fixed one merge conflict resulting from ioctl-number.txt being
  replaced with ioctl-number.rst.
* Removed changes from "x86/cpu/intel: Detect SGX support" that
  were leaked to the commit by mistake.
* Do not naturally align @addr and @len in sgx_get_unmapped_area().
* Check the kconfig flag INTEL_SGX_DRIVER in sgx_init() instead of
  defining two versions of sgx_drv_init().

/Jarkko
