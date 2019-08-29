Return-Path: <SRS0=j74F=WZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B84AC3A59F
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 22:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 364B02166E
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 22:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfH2WWN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:22:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:14287 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbfH2WWM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 18:22:12 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 15:22:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="265126803"
Received: from friedlmi-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.26])
  by orsmga001.jf.intel.com with ESMTP; 29 Aug 2019 15:22:10 -0700
Date:   Fri, 30 Aug 2019 01:22:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2 2/5] x86/sgx: Reject concurrent ioctls on single
 enclave
Message-ID: <20190829222208.tqcwo7xg4t4wiuv7@linux.intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
 <20190827192717.27312-3-sean.j.christopherson@intel.com>
 <20190829131543.ejdsviysr2u33rnj@linux.intel.com>
 <20190829160001.GD26580@linux.intel.com>
 <20190829181438.oxix5d7qfgru7bd7@linux.intel.com>
 <20190829184332.GA27262@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829184332.GA27262@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 29, 2019 at 11:43:33AM -0700, Sean Christopherson wrote:
> On Thu, Aug 29, 2019 at 09:14:38PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Aug 29, 2019 at 09:00:01AM -0700, Sean Christopherson wrote:
> > > > #PF handler should be good as it has this conditional:
> > > > 
> > > > flags = atomic_read(&encl->flags);
> > > > 
> > > > if ((flags & SGX_ENCL_DEAD) || !(flags & SGX_ENCL_INITIALIZED))
> > > > 	return ERR_PTR(-EFAULT);
> > > > 
> > > > What about the reclaimer?
> > > 
> > > Can you elaborate?  I'm not sure what you're asking.
> > 
> > I'm thinking of a race between list_add() in the ioctl and
> > list_move_tail() in the reclaimer.
> 
> Ah crud, I forgot that the reclaimer can manipulate the list of VA pages,
> I was thinking they were invisible to the reclaimer.
> 
> > A quick way to fix this would be move sgx_alloc_va_page() from
> > sgx_encl_grow() and return NULL if a new allocation is required.
> 
> We don't even need to do that, moving the list_add() from sgx_encl_grow()
> to its caller would be sufficient.  Same concept, but the allocation would
> be handled by sgx_encl_grow() instead of having to duplicate that code in
> sgx_encl_add_page() and sgx_encl_create().

Yeah, that was whole point that list_add() cannot be done without
encl->lock. Anything that works goes...

/Jarkko
