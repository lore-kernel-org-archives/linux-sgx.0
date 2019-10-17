Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82030FA372A
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 16:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FFDB2089C
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 16:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502528AbfJQQZY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:25:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:50096 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389403AbfJQQZX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Oct 2019 12:25:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 09:25:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="279931821"
Received: from eshoguli-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.19.56])
  by orsmga001.jf.intel.com with ESMTP; 17 Oct 2019 09:25:20 -0700
Date:   Thu, 17 Oct 2019 19:25:19 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 0/4] x86/sgx: Fix add page bugs
Message-ID: <20191017162519.GC6667@linux.intel.com>
References: <20191010225530.26400-1-sean.j.christopherson@intel.com>
 <20191014210317.GU15552@linux.intel.com>
 <20191016163914.GD5866@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016163914.GD5866@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 09:39:14AM -0700, Sean Christopherson wrote:
> On Tue, Oct 15, 2019 at 12:03:17AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 10, 2019 at 03:55:26PM -0700, Sean Christopherson wrote:
> > > Three bug fixes in the add page flow, along with a related enhancement.
> > > Note, patch 4/4 is effectively a revert.
> > > 
> > > Sean Christopherson (4):
> > >   x86/sgx: Pass EADD the kernel's virtual address for the source page
> > >   x86/sgx: Check the validity of the source page address for EADD
> > >   x86/sgx: Fix EEXTEND error handling
> > >   x86/sgx: Drop mmap_sem before EEXTENDing an enclave page
> > > 
> > >  arch/x86/kernel/cpu/sgx/ioctl.c | 46 ++++++++++++++++++---------------
> > >  1 file changed, 25 insertions(+), 21 deletions(-)
> > 
> > So, which one should be merged first. This or v2 of the other series.
> 
> Shouldn't matter.
> 
> > Can you send a single "for-v23 fixes" series with everything needed just
> > so that there is no room guess work? You can call v3 of the series that
> > you first started.
> 
> Will do, I'll get it sent out today.

Thank you. I'll start to go through and merging (have the patch set
now).

Rather than send any new versions lets just discuss if there is
something that looks weird and I'll either pick the patch unmodified or
do whatever mods needs depending on the resolution.

/Jarkko
