Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981ADC3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 15:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7472220870
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 15:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389869AbfHWPCw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 11:02:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:59560 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfHWPCv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 11:02:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 08:02:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="180704275"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by fmsmga007.fm.intel.com with ESMTP; 23 Aug 2019 08:02:49 -0700
Date:   Fri, 23 Aug 2019 18:02:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     sean.j.christopherson@intel.com
Cc:     luto@kernel.org, linux-sgx@vger.kernel.org
Subject: sgx_encl_may_map() 
Message-ID: <20190823150248.kuxgdxyd4z5wlsz5@linux.intel.com>
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

Couple of remarks that are not reasoned in the code too well:

1. Why to allow to mmap() to a range where pages have differing
   permissions? I think it would be better just to require all
   pages in a range to have the same permissions.
2. Why not require exact match with the PROT bits?
3. Why don't just store SECINFO flags on EADD? Doing
   calc_vma_prot_bits() on fly is not expensive. Now
   data in SECINFO flags is scattered to two different
   fields (desc and vm_max_prot_bits). I'd just have a field
   called secinfo_flags.

This came up when I noted that SGX_IOC_ENCLAVE_ADD_PAGE documentation
was not updated when this permission handling came up. I started to
do it but stumped into these questions. I also wonder why the API
documentation has not been updated...

/Jarkko
