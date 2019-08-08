Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E975C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8062173E
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403890AbfHHPuM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:50:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:49631 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403889AbfHHPuM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 11:50:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:50:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="203621168"
Received: from sandersb-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.239])
  by fmsmga002.fm.intel.com with ESMTP; 08 Aug 2019 08:50:09 -0700
Date:   Thu, 8 Aug 2019 18:50:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 11/11] x86/sgx: Shrink the enclave if
 ECREATE/EADD fails
Message-ID: <20190808155008.i3ll4dglbc7qmqvn@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-12-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808001254.11926-12-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 05:12:54PM -0700, Sean Christopherson wrote:
> Add sgx_encl_shrink() to pair with sgx_encl_grow() and use it to adjust
> the VA page count when ECREATE or EADD fails.  Return the allocated VA
> page from sgx_encl_grow() so that it can be freed during shrink.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
