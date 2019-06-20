Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD2DC43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 22:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F38E2070B
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 22:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfFTWHQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 18:07:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:61351 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfFTWHQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 18:07:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 15:07:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="162497105"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga007.fm.intel.com with ESMTP; 20 Jun 2019 15:07:12 -0700
Date:   Fri, 21 Jun 2019 01:07:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 02/12] x86/sgx: Do not naturally align MAP_FIXED
 address
Message-ID: <20190620220705.GC20474@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-3-sean.j.christopherson@intel.com>
 <38501f172141cde8d525ca82003f498911eb2614.camel@linux.intel.com>
 <20190619140853.GA1203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619140853.GA1203@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 07:08:53AM -0700, Sean Christopherson wrote:
> On Wed, Jun 19, 2019 at 04:24:05PM +0300, Jarkko Sakkinen wrote:
> > On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> > >  {
> > > -	if (len < 2 * PAGE_SIZE || len & (len - 1) || flags & MAP_PRIVATE)
> > > +	if (flags & MAP_PRIVATE)
> > > +		return -EINVAL;
> > > +
> > > +	if (flags & MAP_FIXED)
> > > +		return addr;
> > > +
> > > +	if (len < 2 * PAGE_SIZE || len & (len - 1))
> > >  		return -EINVAL;
> > >
> > >  	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
> > 
> > Just sanity checking that for MAP_FIXED case the mm checks that the area is
> > unmapped before calling this?
> 
> No, straight MAP_FIXED unmaps any existing mappings.  The NOREPLACE variant
> fails with -EEXIST if there are existing mappings.

Ah so it was [1]!

> The MAP_FIXED behavior is actually useful, bordering on mandatory, for the
> new flow.  It allows the loader to keep its initial mmap(PROT_NONE) of
> ELRANGE while (re)mapping the individual enclave sections, e.g. to prevent
> a different aspect of the process from mapping the require ELRANGE.

Yeah, totally agree.

[1] http://man7.org/linux/man-pages/man2/mmap.2.html

/Jarkko
