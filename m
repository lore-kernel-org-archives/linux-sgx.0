Return-Path: <SRS0=SeXc=WG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E94C433FF
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 11:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F12062166E
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 11:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfHJLWY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 10 Aug 2019 07:22:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:21051 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJLWY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 10 Aug 2019 07:22:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Aug 2019 04:22:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,369,1559545200"; 
   d="scan'208";a="166243962"
Received: from agudipat-mobl.ger.corp.intel.com (HELO localhost) ([10.249.36.164])
  by orsmga007.jf.intel.com with ESMTP; 10 Aug 2019 04:22:21 -0700
Date:   Sat, 10 Aug 2019 14:22:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v22] selftests/x86/sgx: Ensure SECS base (ELRANGE) is
 naturally aligned
Message-ID: <20190810112216.u2dolvtkv62dyeno@linux.intel.com>
References: <20190810003051.15712-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190810003051.15712-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 09, 2019 at 05:30:51PM -0700, Sean Christopherson wrote:
> Manually align ELRANGE now that the kernel doesn't automatically do so
> for SGX mappings.  To guarantee mmap() returns a region that can be
> naturally aligned, temporarily map 2x the enclave size and do fancy
> arithmetic to naturally align the base.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thank you.

I fine-tuned the calculations a bit:

area = mmap(NULL, secs->size * 2, PROT_NONE, MAP_SHARED, dev_fd, 0);
if (area == MAP_FAILED) {
	perror("mmap");
	return false;
}

secs->base = ((uint64_t)area + secs->size - 1) & ~(secs->size - 1);

munmap(area, secs->base - (uint64_t)area);
munmap((void *)(secs->base + secs->size),
       (uint64_t)area + secs->size - secs->base);

/Jarkko
