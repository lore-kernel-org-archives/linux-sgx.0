Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB9FC3A59E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 06:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 338AD2173E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 06:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfHZGcK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:32:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:10242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfHZGcK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 02:32:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 23:32:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="209252199"
Received: from chlopez-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.177])
  by fmsmga002.fm.intel.com with ESMTP; 25 Aug 2019 23:32:07 -0700
Date:   Mon, 26 Aug 2019 09:32:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/sgx: Pass userspace source address directly to EADD
Message-ID: <20190826063206.hx3gk7ma5f2qa6uc@linux.intel.com>
References: <20190823021009.3880-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823021009.3880-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 07:10:09PM -0700, Sean Christopherson wrote:
> Invoke EADD with the userspace source address instead of first copying
> the data to a kernel page to avoid the overhead of alloc_page() and
> copy_from_user().
> 
> Remove all pre-validation of TCS pages.  The source page is no longer
> readily available since it's not copied into the kernel, and validating
> the TCS essentially requires accessing the entire page since the vast
> majority of the TCS is reserved bytes.  Given that userspace can now
> cause EADD to fault simply by passing a bad pointer, validating the TCS
> to avoid faults on EADD provides little to no value.
> 
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I already merged this to my tree but just realized that the commit
message does not address why get_user_pages() is no option.

/Jarkko
