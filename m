Return-Path: <SRS0=YLWQ=2B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5F6C2D0C6
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Dec 2019 16:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C693208C3
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Dec 2019 16:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfLKQH7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:07:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:61501 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731366AbfLKQH4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 11 Dec 2019 11:07:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 08:07:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="245335665"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 11 Dec 2019 08:07:55 -0800
Date:   Wed, 11 Dec 2019 08:07:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Huang Haitao <haitao.huang@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix double-free when EADD fails
Message-ID: <20191211160755.GD5044@linux.intel.com>
References: <20191205100151.18950-1-jarkko.sakkinen@linux.intel.com>
 <20191209205254.GE4042@linux.intel.com>
 <20191211111152.GB16450@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211111152.GB16450@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 11, 2019 at 01:11:52PM +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 09, 2019 at 12:52:55PM -0800, Sean Christopherson wrote:
> > Not a fan of making this dependent on -EIO, IMO invalidating iff EEXTEND
> > fails is cleaner.  In other words, I still think killing the enclave on
> > on EADD failure is unnecessary.
> 
> This comes down to whether you consider them as a transaction. I do
> and it makes a coherent API.

What's your definition of transaction in this context?  My interpretation
of transaction here would be that each ioctl() should either succeed, fail
without modifying persistent (enclave) state, or fail and kill the enclave
(because its state modifications are irreversible).

EEXTEND falls into the last case because EADD can't be unwound.  EADD falls
into the middle case because everything up to EADD can be cleanly undone.
