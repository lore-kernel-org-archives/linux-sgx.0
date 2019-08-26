Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D7FC3A5A1
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 03:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB88621744
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 03:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfHZDXp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 25 Aug 2019 23:23:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:13449 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfHZDXp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 25 Aug 2019 23:23:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 20:23:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="181250824"
Received: from donga-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.235])
  by fmsmga007.fm.intel.com with ESMTP; 25 Aug 2019 20:23:42 -0700
Date:   Mon, 26 Aug 2019 06:23:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com, luto@kernel.org
Subject: Re: sgx_reclaimer_write() refinement
Message-ID: <20190826032340.6b5l7fls3g34uyq6@linux.intel.com>
References: <20190823190809.n3np4v7hvlj5isku@linux.intel.com>
 <20190823191546.4wmkv3sh75x3czbb@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823191546.4wmkv3sh75x3czbb@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 10:15:46PM +0300, Jarkko Sakkinen wrote:
> On Fri, Aug 23, 2019 at 10:08:09PM +0300, Jarkko Sakkinen wrote:
> > It would greatly reduce the complexity of the flow. Would be much easier
> > to do fallback code paths. We have three trial EWB approach, which
> > should prevent already unnecesaary ETRACK's and IPI's.
> 
> I recall that I used a cluster ages ago to do minimize ETRACK's and
> IPI's. I implemented three trial EWB during the Spring 2018 when the
> reclaimer code was heavily refined but failed to notice that it rendered
> cluster's meaningless...

One potential caveat here: EBLOCK's could never sequence before ETRACK
with a single thread.

However, the existing code does work in parallel already i.e. there can
be multiple sgx_alloc_page() calls on different going on. This change
would make sgx_alloc_page() success or fail (in the rare case of no
pages to swap) always in constant time and these would group naturally
behind ETRACK's.

What I would do for the reclaimer thread would be to convert it from a
kthread to a multi-threaded work queue (albeit even current single
threaded approach might work reasonably well as it goes in parallel with
the sgx_alloc_page() calls).

/Jarkko
