Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07421C433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 00:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D75082076B
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 00:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgFAAx3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 May 2020 20:53:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:45598 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgFAAx3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 May 2020 20:53:29 -0400
IronPort-SDR: LAxiOo/y46AHoCwhWo4NYMr+OBxP8OIUJCYLiCMQ1/6SOWdPEdM2PYhkkPbAj8Fa5m0WT+95Mf
 IlxMhPWuOrng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 17:53:29 -0700
IronPort-SDR: gf7igff9Zi3QsTcKsTpZSNF5o0eOAc0tyd7BXI0+ahLYiqh/Gbui3nFlAIOMI25V7BJR2q0fn/
 lLnjwkiAlPkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,458,1583222400"; 
   d="scan'208";a="470113777"
Received: from hbetts-mobl.ger.corp.intel.com (HELO localhost) ([10.252.59.178])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2020 17:53:27 -0700
Date:   Mon, 1 Jun 2020 03:53:26 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v31 4/6] x86/sgx: Replace "grab" with "alloc" in VA
 page helper
Message-ID: <20200601005326.GB660229@linux.intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
 <20200529175407.2109-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529175407.2109-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 29, 2020 at 10:54:05AM -0700, Sean Christopherson wrote:
> Rename sgx_grab_va_page() to sgx_alloc_va_page() to align with
> sgx_alloc_epc_page() as well as sgx_free_epc_page(); the latter is used
> directly when freeing the VA page, i.e. the names should be consistent.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks I applied this directly to the page reclaimer patch.

/Jarkko
