Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9421C3A59C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 13:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA605206C1
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 13:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfHPNzY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 09:55:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:22939 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfHPNzY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 09:55:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 06:55:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,393,1559545200"; 
   d="scan'208";a="352546812"
Received: from ppiatekx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.24])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2019 06:55:21 -0700
Date:   Fri, 16 Aug 2019 16:55:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 1/8] selftests/x86/sgx: Align enclave binary
 on 4k boundary
Message-ID: <20190816135421.6kbbt4zeiaijm3uk@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813011252.4121-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 12, 2019 at 06:12:45PM -0700, Sean Christopherson wrote:
> Align the enclave's binary blob to 4096 bytes so that a pointer to the
> blob satisfies hardware's requirements that the source data for EADD be
> page aligned.  An upcoming kernel change will extend the alignment
> requirement to userspace so that the kernel can avoid copying the source
> into an internal buffer, i.e. pass the userspace pointer directly to
> EADD.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Requirement is too way strong vocabulary here. Whether it should be required
or there should fast and slow paths is debatable.

/Jarkko
