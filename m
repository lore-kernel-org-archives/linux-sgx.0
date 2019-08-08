Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE0CC0650F
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8A32173E
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733143AbfHHPoN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:44:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:5495 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732845AbfHHPoN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 11:44:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:44:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="165729479"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 08 Aug 2019 08:44:12 -0700
Date:   Thu, 8 Aug 2019 08:44:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 01/11] x86/sgx: Fix an SECS collision with
 enclave page at VA=0
Message-ID: <20190808154412.GC23156@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-2-sean.j.christopherson@intel.com>
 <20190808153434.tvrvpdl6o7yp2mje@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808153434.tvrvpdl6o7yp2mje@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 08, 2019 at 06:34:59PM +0300, Jarkko Sakkinen wrote:
> On Wed, Aug 07, 2019 at 05:12:44PM -0700, Sean Christopherson wrote:
> > Detect the SECS in paging related flows by explicitly checking the page
> > against the enclave's SECS page.  Assuming a page with VA=0 is the SECS
> > will break enclaves that actually use VA=0, which is extremely unlikely
> > but theoretically possible.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> I would define a macro to the same place where SGX_ENCL_PAGE_ADDR() is
> defined and also SGX_ENCL_PAGE_IS_SECS() would definitely more
> self-describing name.
> 
> Can't you BTW just use the backpointer in struct sgx_encl_page to the
> enclave since we have it there? It is even set for SECS in
> sgx_encl_create().

Yeah, that would work too.  I passed in @encl to match the format of
sgx_encl_get_index(), perhaps it makes sense to use the backpointer there
as well?
