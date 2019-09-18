Return-Path: <SRS0=urvj=XN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5DAC4CEC9
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF63A20862
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Sep 2019 04:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfIREHM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Sep 2019 00:07:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:25457 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfIREHM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Sep 2019 00:07:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 21:07:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,519,1559545200"; 
   d="scan'208";a="186351554"
Received: from mordehay-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.53])
  by fmsmga008.fm.intel.com with ESMTP; 17 Sep 2019 21:07:10 -0700
Date:   Wed, 18 Sep 2019 07:07:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 14/17] x86/sgx: Replace section->free_cnt with a
 global sgx_nr_free_pages
Message-ID: <20190918040647.GB22434@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-15-jarkko.sakkinen@linux.intel.com>
 <20190917225028.GC10319@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917225028.GC10319@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 17, 2019 at 03:50:28PM -0700, Sean Christopherson wrote:
> This isn't safe when there are multiple EPC sections as each section has
> its own spinlock.

The variable does not need to be exact as long as it settles eventually
to the correct value. It is only used to retrigger the reclaimer.

/Jarkko
