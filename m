Return-Path: <SRS0=0rGN=YQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05FDCA9EB6
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 11:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF0F5214B2
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 11:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732092AbfJWL5y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:57:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:56416 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbfJWL5y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Oct 2019 07:57:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 04:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="201968567"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.121])
  by orsmga006.jf.intel.com with ESMTP; 23 Oct 2019 04:57:52 -0700
Date:   Wed, 23 Oct 2019 14:57:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 01/12] x86/sgx: Pass EADD the kernel's virtual
 address for the source page
Message-ID: <20191023115752.GB23733@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-2-sean.j.christopherson@intel.com>
 <20191018095713.GA4835@linux.intel.com>
 <20191022032207.GC32147@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022032207.GC32147@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 21, 2019 at 08:22:07PM -0700, Sean Christopherson wrote:
> On Fri, Oct 18, 2019 at 12:57:13PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 16, 2019 at 11:37:34AM -0700, Sean Christopherson wrote:
> > > Use the kernel's virtual address to reference the source page when
> > > EADDing a page to the enclave.  gup() "does not guarantee that the page
> > > exists in the user mappings", i.e. EADD can still fault and deadlock
> > > due to mmap_sem contention if it consumes the userspace address.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > +	kunmap_atomic((void *)pginfo.contents);
> > 
> > Remark: if not casted first to unsigned long,  it will give a warning on
> > 32-bit build.
> 
> Do we care?  SGX is 64-bit only, I don't see that changing anytime soon.

Nope, that's why I started it with remark :-) It's merely note to
myself.

/Jarkko
