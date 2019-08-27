Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC057C3A59F
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 01:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA87E217F5
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 01:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfH0B1e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 21:27:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:55149 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfH0B1e (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 21:27:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 18:27:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,435,1559545200"; 
   d="scan'208";a="380738963"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 26 Aug 2019 18:27:32 -0700
Date:   Mon, 26 Aug 2019 18:27:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH RFC] x86/sgx: Convert sgx_reclaim_pages() to
 sgx_reclaim_page()
Message-ID: <20190827012732.GC25260@linux.intel.com>
References: <20190826063323.22196-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826063323.22196-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 09:33:23AM +0300, Jarkko Sakkinen wrote:
> Convert sgx_reclaim_pages() to sgx_reclaim_page(), which reclaims only a
> signle page and returns it back to the caller instead of freeing it.
> 
> A simpler flow will allow also simplify sgx_alloc_page() flow and make it
> constant time. With this change it is easer to pin backing storage before

Nit: it doesn't run in constant time, its upper bound is simply lower.

> the pages are blocked, which stabilizes the EBLOCK/EWB/ETRACK flow: only an
> EPCM conflict could cause a EWB to fail.
> 
> Because sgx_alloc_page() operations run in parallel on different threads
> ETRACK's will still group multiple EBLOCK operations. ksgxswapd can be
> improved in future with multi-threading (e.g.a work queue).

I won't be able to give this a thorough review for a few days due to other
tasks.  We should definitely do some rudimentary performance testing given
the potential impact.
