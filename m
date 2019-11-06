Return-Path: <SRS0=YfUE=Y6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FF9FC6195
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Nov 2019 23:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 936CE217F5
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Nov 2019 23:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfKFX1E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Nov 2019 18:27:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:24549 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfKFX1E (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 Nov 2019 18:27:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 15:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="196369961"
Received: from jjmulgra-mobl.amr.corp.intel.com (HELO localhost) ([10.252.7.192])
  by orsmga008.jf.intel.com with ESMTP; 06 Nov 2019 15:27:01 -0800
Date:   Thu, 7 Nov 2019 01:26:59 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 v2 1/4] x86/sgx: Destroy enclave if EADD fails
Message-ID: <20191106232659.GB13378@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
 <20191105225833.GD23297@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105225833.GD23297@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 02:58:33PM -0800, Sean Christopherson wrote:
> On Tue, Nov 05, 2019 at 01:20:53PM +0200, Jarkko Sakkinen wrote:
> > __sgx_encl_add_page() can only fail in the case of EPCM conflict at least
> > in non-artificial situations. Also, it consistent semantics in rollback is
> > something to pursue for. Thus, destroy enclave when the EADD fails as we do
> > when EEXTEND fails already.
> 
> I still don't understand the motiviation for this change, EADD can fault
> and fail for reasons that are purely under userspace control.  Yes, it's
> all but guaranteed to be a userspace bug, but I can't think of another
> instance in the kernel where the reaction to what is effectively an invalid
> param is to torch the whole thing.  EEXTEND is special cased because the
> kernel doesn't have any other sane choice.

-EIO should be returned in both cases so that caller has a way to
determine if the ENCLS operations failed. They sum into a transaction
that is why the rollback must be the same for any sane semantics.

If the caller wants to purposely cause that, it is caller choice. And we
don't want to purposely support completely undeterministic behaviour
when there is no backwards compatibility to maintain.

/Jarkko
