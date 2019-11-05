Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18940C5DF60
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 22:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B84A0206BA
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 22:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfKEW6e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Nov 2019 17:58:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:48900 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfKEW6e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 5 Nov 2019 17:58:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 14:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="403528508"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 14:58:33 -0800
Date:   Tue, 5 Nov 2019 14:58:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 v2 1/4] x86/sgx: Destroy enclave if EADD fails
Message-ID: <20191105225833.GD23297@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 01:20:53PM +0200, Jarkko Sakkinen wrote:
> __sgx_encl_add_page() can only fail in the case of EPCM conflict at least
> in non-artificial situations. Also, it consistent semantics in rollback is
> something to pursue for. Thus, destroy enclave when the EADD fails as we do
> when EEXTEND fails already.

I still don't understand the motiviation for this change, EADD can fault
and fail for reasons that are purely under userspace control.  Yes, it's
all but guaranteed to be a userspace bug, but I can't think of another
instance in the kernel where the reaction to what is effectively an invalid
param is to torch the whole thing.  EEXTEND is special cased because the
kernel doesn't have any other sane choice.
