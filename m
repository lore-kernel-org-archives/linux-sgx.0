Return-Path: <SRS0=qhvV=WL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A535C3A589
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Aug 2019 12:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9DBF2067D
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Aug 2019 12:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbfHOM04 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 15 Aug 2019 08:26:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:56573 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfHOM04 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 15 Aug 2019 08:26:56 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 05:26:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="376365977"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.163])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2019 05:26:54 -0700
Date:   Thu, 15 Aug 2019 15:26:53 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH for_v22] selftests/x86/sgx: Ensure SECS base (ELRANGE) is
 naturally aligned
Message-ID: <20190815122653.uh2biknt5e4epqmf@linux.intel.com>
References: <20190810003051.15712-1-sean.j.christopherson@intel.com>
 <d38b3d14-a30d-88b0-ac60-a71d4577ca16@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38b3d14-a30d-88b0-ac60-a71d4577ca16@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Aug 10, 2019 at 12:39:54AM +0000, Jethro Beekman wrote:
> On 2019-08-09 17:30, Sean Christopherson wrote:
> > Manually align ELRANGE now that the kernel doesn't automatically do so
> > for SGX mappings.
> 
> What was the rationale for moving this out of the kernel? Now every user of
> this API needs to implement it manually.

The binding is now loose between VMAs and enclave e.g. you can
even create and initialize enclave without even a single mmap()
call.

/Jarkko
