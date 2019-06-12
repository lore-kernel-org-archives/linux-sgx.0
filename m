Return-Path: <SRS0=wmvE=UL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83434C31E46
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 15:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ACFA2082C
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jun 2019 15:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfFLPQL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:16:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:36284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbfFLPQL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 12 Jun 2019 11:16:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 08:16:10 -0700
X-ExtLoop1: 1
Received: from mderosix-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.159])
  by fmsmga004.fm.intel.com with ESMTP; 12 Jun 2019 08:16:07 -0700
Date:   Wed, 12 Jun 2019 18:16:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH 0/7] x86/sgx: Clean up and enhance add pages ioctl
Message-ID: <20190612151605.GB5723@linux.intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 12:48:38PM -0700, Sean Christopherson wrote:
> This series is intended to be included in v21 of Jarkko's SGX series and
> applies on Jarkko's current master:
> 
>   dfc89a83b5bc ("docs: x86/sgx: Document the enclave API")
> 
> The primary goal of the series is to tweak the ioctl for adding pages to
> an enclave so that it is somewhat extensible, e.g. add a flags field that
> can be reused for access control integration and SGX2/EAUG, and add a size
> field so that multiple pages can be added in a single call (batching EADD
> has been mentioned at various times in the past).
> 
> The secondary goal is to improve the performance of building enclaves.
> Handling multiple pages in a single call helps somewhat, but the real win
> (for some enclaves) is using the kernel's zero page as the source for EADD
> when possible.

For v21 I will add 1, 2 and 6 from these. Thanks.

I'll change the size or mrmask field to 32 bits.

/Jarkko
