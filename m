Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23D4C3A59E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 05:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9994A2190F
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 05:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfHZFix (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 01:38:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:1518 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfHZFix (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 01:38:53 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 22:38:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="263830628"
Received: from chlopez-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.177])
  by orsmga001.jf.intel.com with ESMTP; 25 Aug 2019 22:38:50 -0700
Date:   Mon, 26 Aug 2019 08:38:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 0/3] x86/sgx: Misc code cleanups
Message-ID: <20190826053849.iujtna7satqlwu6c@linux.intel.com>
References: <20190823215236.8081-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823215236.8081-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 02:52:33PM -0700, Sean Christopherson wrote:
> Fix a few minor issues flagged by checkpatch.  No functional change
> intended.
> 
> Sean Christopherson (3):
>   x86/sgx: Tweak Kconfig help section according to checkpatch
>   x86/sgx: Add missing SPDX license to encls.c
>   x86/sgx: Fix whitespace damage in sgx_encl_page_alloc()
> 
>  arch/x86/Kconfig                |  2 +-
>  arch/x86/kernel/cpu/sgx/encls.c |  3 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c | 23 +++++++++++------------
>  3 files changed, 15 insertions(+), 13 deletions(-)
> 
> -- 
> 2.22.0
> 

I merged this and my kdoc update. Thank you.

/Jarkko
