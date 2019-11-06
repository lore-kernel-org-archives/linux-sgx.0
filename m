Return-Path: <SRS0=YfUE=Y6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD21C5DF63
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Nov 2019 22:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948352173E
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Nov 2019 22:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfKFWEF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Nov 2019 17:04:05 -0500
Received: from mga06.intel.com ([134.134.136.31]:16813 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfKFWEF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 Nov 2019 17:04:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 14:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="196350078"
Received: from ksterken-mobl6.amr.corp.intel.com (HELO localhost) ([10.252.10.117])
  by orsmga008.jf.intel.com with ESMTP; 06 Nov 2019 14:04:03 -0800
Date:   Thu, 7 Nov 2019 00:03:56 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 v2 2/4] x86/sgx: Remove a subordinate clause
Message-ID: <20191106220356.GB11526@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
 <20191105112056.21452-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105112056.21452-2-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 01:20:54PM +0200, Jarkko Sakkinen wrote:
> The subordinate clause of last sentence of the sgx_ioc_enclave_pages()
> does not provide any insight not already provided. Thus, remove it.
> Also, using "i.e." (and "e.g.") in the documentation should be
> considered a bad practice because it leaves it open ended.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Merged.

/Jarkko
