Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7E1C3A59E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 01:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33692339E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 01:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfHVB0V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 21:26:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:54306 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfHVB0V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 21:26:21 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 18:26:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="169607629"
Received: from soegtrop-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.52.79])
  by orsmga007.jf.intel.com with ESMTP; 21 Aug 2019 18:26:19 -0700
Date:   Thu, 22 Aug 2019 04:26:19 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Message-ID: <20190822012619.jffd4guzjtczmwkr@linux.intel.com>
References: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
 <20190715135902.GA442@linux.intel.com>
 <20190801162219.fqmkxlp4mgm4gi3f@linux.intel.com>
 <20190801162931.GB6783@linux.intel.com>
 <20190802193321.llx4dcqhslh46toy@linux.intel.com>
 <20190813012227.GJ4996@linux.intel.com>
 <20190815215600.u3cz27y27nrldq3i@linux.intel.com>
 <20190821172400.GH29345@linux.intel.com>
 <20190822002940.hb7xjbrdkxxx4zoe@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822002940.hb7xjbrdkxxx4zoe@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 03:29:40AM +0300, Jarkko Sakkinen wrote:
> On Wed, Aug 21, 2019 at 10:24:00AM -0700, Sean Christopherson wrote:
> > How does the current code not align with this approach?  The core subsystem
> > should tear itself down if loading the driver fails, which includes failing
> > because it doesn't exist.
> 
> I get now the real issue that you are trying to point out (did not
> earlier). Still, I think your approach to fix it needs some
> reconsideration.
> 
> Something that *does not exist* can never fail. That should be dead
> obvious.
> 
> If the SGX driver does not exit and KVM does not have SGX support
> compiled in, then the only logical conclusion that you can end up with
> is that neither the SGX core should exist in vmlinux in the first place.
> 
> This all summarizes to that I have to remove the INTEL_SGX_DRIVER
> kconfig flag. Its existence can only be considered when there >= 2
> in-kernel users for SGX.

The subdirectory for the driver has clearly turned into legacy with only
two source files and one header file in it.

Even if/when we want to add INTEL_SGX_DRIVER back it is easiest use it
in the main makefile.

I prepared snippets to execute these changes.

This is for driver.h, ioctl.c, main.c (rename):

git filter-branch -f --index-filter 'git ls-files -s | \
    sed "s/sgx\/driver\/main\.c/sgx\/driver.c/" | \
    GIT_INDEX_FILE=$GIT_INDEX_FILE.new git update-index --index-info && \
    mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"' mainline/master..master

This for for Makefile (remove):

git filter-branch -f --index-filter 'git ls-files -s | \
    sed "/sgx\/driver\/Makefile/d" | \
    GIT_INDEX_FILE=$GIT_INDEX_FILE.new git update-index --index-info && \
    mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"' mainline/master..master

/Jarkko
