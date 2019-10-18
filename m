Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00256CA9EA0
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4193222C6
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 10:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633251AbfJRKG7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:06:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:36238 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727249AbfJRKG7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 06:06:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 03:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="397889684"
Received: from glas-mobl.ger.corp.intel.com (HELO localhost) ([10.252.17.198])
  by fmsmga006.fm.intel.com with ESMTP; 18 Oct 2019 03:06:56 -0700
Date:   Fri, 18 Oct 2019 13:06:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 09/12] x86/sgx: Split second half of
 sgx_free_page() to a separate helper
Message-ID: <20191018100655.GC4835@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191016183745.8226-10-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016183745.8226-10-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 16, 2019 at 11:37:42AM -0700, Sean Christopherson wrote:
> Move the post-reclaim half of sgx_free_page() to a standalone helper so
> that it can be used in flows where the page is known to be
> non-reclaimable.

The call sites wher it is known to be reclaimable should handle the
error instead of creating call site specific versions of the function.

/Jarkko
