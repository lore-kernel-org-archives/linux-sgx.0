Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D563CC433FF
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 20:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFC3F214C6
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 20:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfHIUpA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 16:45:00 -0400
Received: from mga05.intel.com ([192.55.52.43]:14542 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfHIUpA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 16:45:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 13:44:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="177740234"
Received: from wulili-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.36.9])
  by orsmga003.jf.intel.com with ESMTP; 09 Aug 2019 13:44:57 -0700
Date:   Fri, 9 Aug 2019 23:44:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 01/11] x86/sgx: Fix an SECS collision with
 enclave page at VA=0
Message-ID: <20190809204456.3fvveocds2sl6zlz@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808001254.11926-2-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 05:12:44PM -0700, Sean Christopherson wrote:
> Detect the SECS in paging related flows by explicitly checking the page
> against the enclave's SECS page.  Assuming a page with VA=0 is the SECS
> will break enclaves that actually use VA=0, which is extremely unlikely
> but theoretically possible.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I applied this with the tweaks mentioned in the discussion:

* SGX_ENCL_PAGE_IS_SECS() as a macro.
* Removed @encl both sgx_get_index() and SGX_ENCL_PAGE_IS_SECS().

Not yet pushed. Just noting that I'm taking care of it.

/Jarkko
