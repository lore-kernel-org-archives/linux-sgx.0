Return-Path: <SRS0=urvj=XN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C00C4CEC4
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D31C221848
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfIREMa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Sep 2019 00:12:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:55721 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbfIREMa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Sep 2019 00:12:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 21:12:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,519,1559545200"; 
   d="scan'208";a="198917011"
Received: from mordehay-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.53])
  by orsmga002.jf.intel.com with ESMTP; 17 Sep 2019 21:12:26 -0700
Date:   Wed, 18 Sep 2019 07:12:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 12/17] x86/sgx: Open code sgx_reclaimer_get() and
 sgx_reclaimer_put()
Message-ID: <20190918041225.GD22434@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-13-jarkko.sakkinen@linux.intel.com>
 <20190917230740.GE10319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917230740.GE10319@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 17, 2019 at 04:07:40PM -0700, Sean Christopherson wrote:
> On Mon, Sep 16, 2019 at 01:17:58PM +0300, Jarkko Sakkinen wrote:
> > Open code sgx_reclaimer_get() and sgx_reclaimer_put(). They are legacy
> > from the callback interface. Wrapping a function call inside a function
> > does not make sense.
> 
> I actually like the functions, IMO they make the loops more readable.
> They should be static, and probably static inline, but I doubt either
> annotation affects the compiler output.

The way I see it they only add to need to cross reference when you read
the code. Wrapping a single function call makes only sense when you
actually have a semantical need for it.

/Jarkko
