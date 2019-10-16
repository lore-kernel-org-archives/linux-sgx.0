Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D37FA372A
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 16:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DB021D7C
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 16:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406394AbfJPQjQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 12:39:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:6303 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404348AbfJPQjP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 12:39:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 09:39:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="194885281"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 09:39:14 -0700
Date:   Wed, 16 Oct 2019 09:39:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 0/4] x86/sgx: Fix add page bugs
Message-ID: <20191016163914.GD5866@linux.intel.com>
References: <20191010225530.26400-1-sean.j.christopherson@intel.com>
 <20191014210317.GU15552@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014210317.GU15552@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 15, 2019 at 12:03:17AM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 10, 2019 at 03:55:26PM -0700, Sean Christopherson wrote:
> > Three bug fixes in the add page flow, along with a related enhancement.
> > Note, patch 4/4 is effectively a revert.
> > 
> > Sean Christopherson (4):
> >   x86/sgx: Pass EADD the kernel's virtual address for the source page
> >   x86/sgx: Check the validity of the source page address for EADD
> >   x86/sgx: Fix EEXTEND error handling
> >   x86/sgx: Drop mmap_sem before EEXTENDing an enclave page
> > 
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 46 ++++++++++++++++++---------------
> >  1 file changed, 25 insertions(+), 21 deletions(-)
> 
> So, which one should be merged first. This or v2 of the other series.

Shouldn't matter.

> Can you send a single "for-v23 fixes" series with everything needed just
> so that there is no room guess work? You can call v3 of the series that
> you first started.

Will do, I'll get it sent out today.
