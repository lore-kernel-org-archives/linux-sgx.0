Return-Path: <SRS0=ggfh=2C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6950C43603
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Dec 2019 23:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC360206B7
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Dec 2019 23:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbfLLX7i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Dec 2019 18:59:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:45512 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731143AbfLLX7i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Dec 2019 18:59:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 15:59:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,307,1571727600"; 
   d="scan'208";a="204145634"
Received: from dwidzins-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.21.195])
  by orsmga007.jf.intel.com with ESMTP; 12 Dec 2019 15:59:35 -0800
Date:   Fri, 13 Dec 2019 01:59:33 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Huang Haitao <haitao.huang@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix double-free when EADD fails
Message-ID: <20191212235933.GC7854@linux.intel.com>
References: <20191205100151.18950-1-jarkko.sakkinen@linux.intel.com>
 <20191209205254.GE4042@linux.intel.com>
 <20191211111152.GB16450@linux.intel.com>
 <20191211160755.GD5044@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211160755.GD5044@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 11, 2019 at 08:07:55AM -0800, Sean Christopherson wrote:
> On Wed, Dec 11, 2019 at 01:11:52PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Dec 09, 2019 at 12:52:55PM -0800, Sean Christopherson wrote:
> > > Not a fan of making this dependent on -EIO, IMO invalidating iff EEXTEND
> > > fails is cleaner.  In other words, I still think killing the enclave on
> > > on EADD failure is unnecessary.
> > 
> > This comes down to whether you consider them as a transaction. I do
> > and it makes a coherent API.
> 
> What's your definition of transaction in this context?  My interpretation
> of transaction here would be that each ioctl() should either succeed, fail
> without modifying persistent (enclave) state, or fail and kill the enclave
> (because its state modifications are irreversible).
> 
> EEXTEND falls into the last case because EADD can't be unwound.  EADD falls
> into the middle case because everything up to EADD can be cleanly undone.

My definition is that if any of EADD/EEXTEND fails the enclave
should be killed as there is no good reason to support that kind
of use in any possible way. As long as it is documented, it is
fine.

/Jarkko
