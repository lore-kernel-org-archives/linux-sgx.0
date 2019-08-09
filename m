Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0E9C31E40
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 15:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1602171F
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 15:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407300AbfHIPN0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 11:13:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:12308 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406642AbfHIPN0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 11:13:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 08:13:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,364,1559545200"; 
   d="scan'208";a="193406792"
Received: from jsakkine-mobl1.tm.intel.com ([10.237.50.189])
  by fmsmga001.fm.intel.com with ESMTP; 09 Aug 2019 08:13:24 -0700
Message-ID: <8f537adf9928ab47b29cb513de508b913458b74b.camel@linux.intel.com>
Subject: Re: [PATCH for_v22 01/11] x86/sgx: Fix an SECS collision with
 enclave page at VA=0
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Date:   Fri, 09 Aug 2019 18:13:22 +0300
In-Reply-To: <20190808154412.GC23156@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
         <20190808001254.11926-2-sean.j.christopherson@intel.com>
         <20190808153434.tvrvpdl6o7yp2mje@linux.intel.com>
         <20190808154412.GC23156@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-08 at 08:44 -0700, Sean Christopherson wrote:
> On Thu, Aug 08, 2019 at 06:34:59PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Aug 07, 2019 at 05:12:44PM -0700, Sean Christopherson wrote:
> > > Detect the SECS in paging related flows by explicitly checking the page
> > > against the enclave's SECS page.  Assuming a page with VA=0 is the SECS
> > > will break enclaves that actually use VA=0, which is extremely unlikely
> > > but theoretically possible.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > I would define a macro to the same place where SGX_ENCL_PAGE_ADDR() is
> > defined and also SGX_ENCL_PAGE_IS_SECS() would definitely more
> > self-describing name.
> > 
> > Can't you BTW just use the backpointer in struct sgx_encl_page to the
> > enclave since we have it there? It is even set for SECS in
> > sgx_encl_create().
> 
> Yeah, that would work too.  I passed in @encl to match the format of
> sgx_encl_get_index(), perhaps it makes sense to use the backpointer there
> as well?

Yes, it does of course. Probably have just forgotten to add it.
This kind of inconsistencies exist because backpointer has not
been always existing.

/Jarkko

