Return-Path: <SRS0=7mz1=7M=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E65DC433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 30 May 2020 08:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A4320776
	for <linux-sgx@archiver.kernel.org>; Sat, 30 May 2020 08:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgE3Irj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 May 2020 04:47:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:21172 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgE3Irj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 30 May 2020 04:47:39 -0400
IronPort-SDR: tpvCXhdsLeFehXaoHy/sKGzwLwbKelO/+5nl1aareZEOqg48d3HrMOQpBUkJ/qU2u0RoCFlNGm
 zinzf+2qgrDw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2020 01:47:39 -0700
IronPort-SDR: Dr4tJLgkwVxKiPjS9fg9ZHlji3yYMvpKHVj9/ZjKigWSWb9wFfcq+O2dIE3JFw17yqa2EJRDl9
 bnnU7SuEq/vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,451,1583222400"; 
   d="scan'208";a="256743413"
Received: from elang-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.42.245])
  by orsmga007.jf.intel.com with ESMTP; 30 May 2020 01:47:37 -0700
Date:   Sat, 30 May 2020 11:47:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v31 2/6] x86/sgx: Remove unnecessary globals after
 merging reclaim.c into main.c
Message-ID: <20200530084733.GB4896@linux.intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
 <20200529175407.2109-3-sean.j.christopherson@intel.com>
 <20200530084336.GA4896@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530084336.GA4896@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, May 30, 2020 at 11:43:39AM +0300, Jarkko Sakkinen wrote:
> On Fri, May 29, 2020 at 10:54:03AM -0700, Sean Christopherson wrote:
> > Make all variables that are only used in main.c static, rearranging code
> > as needed.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> As with merging, it is a multiphase process to make these changes.
> 
> I.e. I'll do manually similar changes but cannot use this patch for
> anything.

Also this moves sgx_nr_epc_sections and sgx_epc_sections to a wrong
location. Reclaimer code is before other code. I don't understand
why sgx_epc_sections had to be moved as part of changing variables
to static.

/Jarkko
