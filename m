Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF03C31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D477C206BF
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFSOI7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:08:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:40542 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfFSOI7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 10:08:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 07:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="153816009"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 19 Jun 2019 07:08:53 -0700
Date:   Wed, 19 Jun 2019 07:08:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 02/12] x86/sgx: Do not naturally align MAP_FIXED
 address
Message-ID: <20190619140853.GA1203@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-3-sean.j.christopherson@intel.com>
 <38501f172141cde8d525ca82003f498911eb2614.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38501f172141cde8d525ca82003f498911eb2614.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 04:24:05PM +0300, Jarkko Sakkinen wrote:
> On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> >  {
> > -	if (len < 2 * PAGE_SIZE || len & (len - 1) || flags & MAP_PRIVATE)
> > +	if (flags & MAP_PRIVATE)
> > +		return -EINVAL;
> > +
> > +	if (flags & MAP_FIXED)
> > +		return addr;
> > +
> > +	if (len < 2 * PAGE_SIZE || len & (len - 1))
> >  		return -EINVAL;
> >
> >  	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
> 
> Just sanity checking that for MAP_FIXED case the mm checks that the area is
> unmapped before calling this?

No, straight MAP_FIXED unmaps any existing mappings.  The NOREPLACE variant
fails with -EEXIST if there are existing mappings.

The MAP_FIXED behavior is actually useful, bordering on mandatory, for the
new flow.  It allows the loader to keep its initial mmap(PROT_NONE) of
ELRANGE while (re)mapping the individual enclave sections, e.g. to prevent
a different aspect of the process from mapping the require ELRANGE.

> 
> I don't think we need to check any alignment constraints here anymore.
> 
> The summarize end result would be:
> 
> static unsigned long sgx_get_unmapped_area(struct file *file,
> 					   unsigned long addr,
> 					   unsigned long len,
> 					   unsigned long pgoff,
> 					   unsigned long flags)
> {
> 	if (flags & MAP_PRIVATE)
> 		return -EINVAL;
> 
> 	if (flags & MAP_FIXED)
> 		return addr;
> 
> 	return current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
> 					      flags);
> }
> 
> /Jarkko
> 
