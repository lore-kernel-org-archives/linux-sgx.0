Return-Path: <SRS0=VHel=4U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653EFC3F2C6
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 23:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40BED20870
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 23:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgCCXMe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:12:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:61370 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgCCXMe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Mar 2020 18:12:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 15:12:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="233917237"
Received: from kwasilew-mobl.ger.corp.intel.com (HELO localhost) ([10.251.88.57])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2020 15:12:31 -0800
Date:   Wed, 4 Mar 2020 01:12:30 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/sgx: Remove non-LC bit from sgx_einit()
Message-ID: <20200303231230.GA709903@linux.intel.com>
References: <20200303205359.108336-1-jarkko.sakkinen@linux.intel.com>
 <20200303205359.108336-2-jarkko.sakkinen@linux.intel.com>
 <20200303223346.GD1439@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303223346.GD1439@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 03, 2020 at 02:33:46PM -0800, Sean Christopherson wrote:
> On Tue, Mar 03, 2020 at 10:53:59PM +0200, Jarkko Sakkinen wrote:
> > Remove the non-LC flow. While doing this, start using __encls_ret_3()
> > instead __einit() to reduce the insane amount of wrapping we have in
> > this flow.
> 
> I strongly prefer keeping __einit(), I find it much more readable than
> __encls_ret_3(EINIT, ...).  If you remove __einit() then I don't see the
> justification for keeping all the other wrappers, and for me, removing
> all of those would be a big step backwards.

Rather than arguing about this I'll merge only the part that removes
the LC flow.

/Jarkko
