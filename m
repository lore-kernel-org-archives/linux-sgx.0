Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE45EC2BA1A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 20:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92DEC2072A
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 20:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgDFUlG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 16:41:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:1809 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgDFUlG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 16:41:06 -0400
IronPort-SDR: RJ4RB9QwATBRv4AYFipperU/MnEcJqXUTQfv5uxfTjCeJg2Qr7i8mDPlYNHTWuxk2bT3At81X6
 sD5XcD2WQHuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 13:41:05 -0700
IronPort-SDR: 95DV75yf1yvu5mNCaX+FZ1BwTxS2l6kVRI0I92NiQN3K+2fb9m5pl9rr7+OQmnkt1/n2x9QGlM
 wSCA6UJTe0Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="269193905"
Received: from hmer-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.225])
  by orsmga002.jf.intel.com with ESMTP; 06 Apr 2020 13:41:04 -0700
Date:   Mon, 6 Apr 2020 23:41:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v3] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200406204047.GA31633@linux.intel.com>
References: <20200404010741.24486-1-jarkko.sakkinen@linux.intel.com>
 <20200406161557.GE21330@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406161557.GE21330@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 09:15:57AM -0700, Sean Christopherson wrote:
> >  	encl->ssaframesize = secs->ssa_frame_size;
> > +	encl->mm_list_version = 1;
> 
> This is unnecessary.  A mm_list_version of '0' means the list walk started
> when there were no mm structs associated with the enclave, i.e. skipping
> everything related to walking the list is ok.  It's subtle, and I dislike
> relying on that behavior, but IMO it's preferable to incorrectly implying
> that a list version of '0' is somehow bad.

'0' means whatever code requires to mean. There is no absolute meaning.

> > +	for ( ; ; ) {
> > +		next = encl->mm_list_version;
> >  
> > -		down_read(&encl_mm->mm->mmap_sem);
> > +		if (version == next)
> > +			break;
> 
> Functionally this works, but I personally find it the logic kludgy, and it
> generates worse code.  Not that we're at the point where counting uops is a
> to priority, but I don't think it makes sense to go out of our way to make
> the resulting code worse.

I'll pick v2 then.

/Jarkko
