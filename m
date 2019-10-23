Return-Path: <SRS0=0rGN=YQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE9FCA9EB6
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 11:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A7E214B2
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 11:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbfJWL7e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:59:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:62088 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbfJWL7e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Oct 2019 07:59:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 04:59:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="201968902"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.121])
  by orsmga006.jf.intel.com with ESMTP; 23 Oct 2019 04:59:31 -0700
Date:   Wed, 23 Oct 2019 14:59:31 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 09/12] x86/sgx: Split second half of
 sgx_free_page() to a separate helper
Message-ID: <20191023115931.GC23733@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-10-sean.j.christopherson@intel.com>
 <20191018100655.GC4835@linux.intel.com>
 <20191022033617.GD32147@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022033617.GD32147@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 21, 2019 at 08:36:17PM -0700, Sean Christopherson wrote:
> On Fri, Oct 18, 2019 at 01:06:55PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 11:37:42AM -0700, Sean Christopherson wrote:
> > > Move the post-reclaim half of sgx_free_page() to a standalone helper so
> > > that it can be used in flows where the page is known to be
> > > non-reclaimable.
> > 
> > The call sites wher it is known to be reclaimable should handle the
> > error instead of creating call site specific versions of the function.
> 
> What if we completely split the function(s)?  The existing callers of
> sgx_free_page() stay as is, there is one and only one "free_page()", we
> don't take sgx_active_page_list_lock in most flows, and the one case
> where failure is acceptable gets to do its thing.  I think this'd make
> both of us happy.  E.g.:

The split is a clean way to sort this out.

Makes sense also from "symmetry" perspective: we don't mark pages
reclaimable in sgx_alloc_page().

/Jarkko
