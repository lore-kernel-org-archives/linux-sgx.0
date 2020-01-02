Return-Path: <SRS0=JJHd=2X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BB7C2D0DC
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 17:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 893152085B
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 17:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgABRGs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jan 2020 12:06:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:46802 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgABRGs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jan 2020 12:06:48 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 09:06:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="221929269"
Received: from krominsx-mobl.ger.corp.intel.com (HELO localhost) ([10.252.21.64])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2020 09:06:45 -0800
Date:   Thu, 2 Jan 2020 19:06:46 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v25 0/4] x86/sgx: Reclaim bug fix and cleanup
Message-ID: <20200102170633.GB17637@linux.intel.com>
References: <20191221003156.27236-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221003156.27236-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 20, 2019 at 04:31:52PM -0800, Sean Christopherson wrote:
> One bug fix in the SECS reclaim path and loosely related cleanup.
> 
> Sean Christopherson (4):
>   x86/sgx: Put SECS backing iff retrieving the backing succeeds
>   x86/sgx: Use goto to handle sgx_encl_get_backing() failure in SECS
>     flows
>   x86/sgx: Drop unused @encl parameter from __sgx_encl_ewb()
>   x86/sgx: Pre-calculate VA slot virtual address in sgx_encl_ewb()
> 
>  arch/x86/kernel/cpu/sgx/reclaim.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> -- 
> 2.24.1
> 

Thank you. I merged these and added a changelog entry describing the bug
that was fixed.

/Jarkko
