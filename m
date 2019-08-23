Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F69EC3A5A4
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD0F22CE3
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405739AbfHWNqA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:46:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:2319 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405715AbfHWNp6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 09:45:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 06:45:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="203774120"
Received: from unknown (HELO jsakkine-mobl1) ([10.252.39.229])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2019 06:45:56 -0700
Message-ID: <30cf15fc074f1fb4f8034a37d4a45cabf1148a28.camel@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Replace @is_secs_child with @pt in
 sgx_encl_ewb()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 16:45:55 +0300
In-Reply-To: <20190823023009.15766-1-jarkko.sakkinen@linux.intel.com>
References: <20190823023009.15766-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2019-08-23 at 05:30 +0300, Jarkko Sakkinen wrote:
> Sean complained about boolean parameters so I though that maybe it would
> be good to rework the EWB flow in a way that it operates by a page type and
> here is the result. The contract is and will be that as long as you give
> the correct page type, you will get what you want. That is why I set
> REG and TCS appropriately even though they are treated the same way
> at this point of time.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

One remark: I convert this to use SGX_SECINFO_TCS etc. Better to prefer
those. We use SGX_PAGE_TYPE only in EPA wrapper. Could even consider
removing those.

/Jarkko

