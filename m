Return-Path: <SRS0=urvj=XN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FF6C4CED4
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 717B2214AF
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfIREQI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Sep 2019 00:16:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:49515 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbfIREQH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Sep 2019 00:16:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 21:16:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,519,1559545200"; 
   d="scan'208";a="387788029"
Received: from mordehay-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.53])
  by fmsmga006.fm.intel.com with ESMTP; 17 Sep 2019 21:16:04 -0700
Date:   Wed, 18 Sep 2019 07:15:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 09/17] x86/sgx: Move SGX_ENCL_DEAD check to
 sgx_reclaimer_write()
Message-ID: <20190918041558.GE22434@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-10-jarkko.sakkinen@linux.intel.com>
 <20190917231326.GF10319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917231326.GF10319@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 17, 2019 at 04:13:26PM -0700, Sean Christopherson wrote:
> SGX_ENCL_PAGE_RECLAIMED is left dangling on encl_page in the SGX_ENCL_DEAD
> case.  It doesn't affect functionality, but it could complicate debug if
> anything goes awry.

Agreed. It is a regression in this patch actually because my purpose was
not to affect semantics.

/Jarkko
