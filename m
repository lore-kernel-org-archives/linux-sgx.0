Return-Path: <SRS0=oRrW=35=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23E4C2BA83
	for <linux-sgx@archiver.kernel.org>; Sun,  9 Feb 2020 21:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF9E620820
	for <linux-sgx@archiver.kernel.org>; Sun,  9 Feb 2020 21:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgBIVE2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 9 Feb 2020 16:04:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:31079 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgBIVE2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 9 Feb 2020 16:04:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Feb 2020 13:04:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,422,1574150400"; 
   d="scan'208";a="226036898"
Received: from jradtke-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.22.75])
  by fmsmga007.fm.intel.com with ESMTP; 09 Feb 2020 13:04:26 -0800
Date:   Sun, 9 Feb 2020 23:04:26 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     x86@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/sgx: Sanitize pages in two rounds
Message-ID: <20200209210426.GB3702@linux.intel.com>
References: <20200206161550.5920-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206161550.5920-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 06, 2020 at 06:15:50PM +0200, Jarkko Sakkinen wrote:
> WARN_ONCE() can trigger after kexec() on systems with multiple EPC
> sections. This can happen when an enclave has a SECS page in some section
> and child pages in a section processed after the section containing the
> SECS page. CPU does not allow to remove SECS before all of its children
> have been removed.
> 
> Fix this by removing the tail from sgx_sanitize_section() and iterate
> sections in two rounds by calling the resulting function.
> 
> Finally, report to the user space only after all processing has been
> done and not in the middle of processing as before. This improves the
> quality of reporting as kernel can tell how many unsanitized pages in
> each section was left unprocessed.
> 
> Cc: x86@kernel.org
> Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Merged.

/Jarkko
