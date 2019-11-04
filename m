Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019B5CA9EC9
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 22:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6ADC2084D
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 22:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfKDWbi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 17:31:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:38301 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbfKDWbi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 17:31:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 14:31:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="200620593"
Received: from rczubala-mobl.ger.corp.intel.com (HELO localhost) ([10.252.7.245])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2019 14:31:31 -0800
Date:   Tue, 5 Nov 2019 00:31:25 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 2/3] x86/sgx: Destroy enclave if EADD fails
Message-ID: <20191104223019.GB3606@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104200141.5385-2-jarkko.sakkinen@linux.intel.com>
 <20191104205401.GB5960@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104205401.GB5960@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 04, 2019 at 12:54:01PM -0800, Sean Christopherson wrote:
> On Mon, Nov 04, 2019 at 10:01:40PM +0200, Jarkko Sakkinen wrote:
> > __sgx_encl_add_page() can only fail in the case of EPCM conflict at least
> > in non-artificial situations.
> 
> Huh?  EADD can fail for a variety of reasons.  I can't think of a use case
> where userspace _won't_ kill the enclave in response to failure, but that
> doesn't justify killing the enclave, e.g. we don't kill the enclave in any
> other error path that is just as indicative of a userspace bug.

I think it does because it is the only sane metrics to take and it
also makes the semantics more sound and coherent.

> > Also, it consistent semantics in rollback is something to pursue for.
> 
> I don't follow this at all.  How is it inconsistent to state that errors
> are handled gracefully unless they're unrecoverable?

Always when the user space gets -EIO it will know that enclave ceased
to exist. That is very consistent.

> > Thus, destroy enclave when the EADD fails as we do when EEXTEND fails
> > already.
> > 
> > In the cases it is sane to return -EIO. From this the caller can deduce
> > the failure and knows that the enclave was destroyed. The previous
> > -EFAULT could happen in numerous situations.
> 
> This should be a separate patch.

No it shouldn't because it is so closely connected to the semantics
change.

/Jarkko
