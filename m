Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60192C433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 01:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AAB12067B
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 01:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgFABBa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 May 2020 21:01:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:46194 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgFABB3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 May 2020 21:01:29 -0400
IronPort-SDR: jTffv/hG/UaOKv5YLRH0zv+DGCWaZIoDQNSm0uf5bQ+yTlL1E0TdQBE9WKye9FPwg/tlDgrnEv
 1vtGiSbRVt5A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 18:01:29 -0700
IronPort-SDR: i2v9pjy4DQ2QroTJfK4J0CSiBWHxhrN9S7QbvIY/BYbzz+Y/8iEL6VVAEpO2tWb/9az7n3LDGG
 w4T/04q3sE+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,458,1583222400"; 
   d="scan'208";a="470115575"
Received: from hbetts-mobl.ger.corp.intel.com (HELO localhost) ([10.252.59.178])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2020 18:01:27 -0700
Date:   Mon, 1 Jun 2020 04:01:26 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v31 6/6] x86/sgx: Drop the message that fires when
 there are too many EPC sections
Message-ID: <20200601010126.GD660229@linux.intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
 <20200529175407.2109-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529175407.2109-7-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 29, 2020 at 10:54:07AM -0700, Sean Christopherson wrote:
> Terminate the section loop with '<' instead of '<=' and drop the
> associated pr_warn in sgx_page_cache_init().  Per Boris, there's no
> point in warning the user if they can't do anything about it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Applied this directly to the correct patch, thanks.

/Jarkko
