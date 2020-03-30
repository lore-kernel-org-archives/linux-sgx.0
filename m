Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95F6C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8492B2072D
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgC3VNm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 17:13:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:45009 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgC3VNm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 17:13:42 -0400
IronPort-SDR: pnmp6IR9jzBXljGvtbfRFSqgmMIeGjwlkxCVDP8imtTp1xKeCK305t4LRJlkrzfmB4IQEosbo0
 U+H+9tG8w/ww==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 14:13:40 -0700
IronPort-SDR: /jeSRbqX+02oWcv4REbBMzlDM/fVZLcaahNXS7QOFTKr0LRMzSZwVQCXe8aP0p7PRwemQSj8xw
 0fB93OihC7MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="248838615"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2020 14:13:38 -0700
Date:   Tue, 31 Mar 2020 00:13:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     luto@kernel.org, Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/sgx: Remove PROT_NONE branch from sgx_encl_may_map().
Message-ID: <20200330211320.GA1389628@linux.intel.com>
References: <20200330185452.1382455-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330185452.1382455-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 09:54:52PM +0300, Jarkko Sakkinen wrote:
> sgx_encl_may_map() always succeeding when PROT_NONE is given is not that
> useful behaviour as one can just well as do an anonymous mapping as
> demonstrated by the change in this patch to the test program. As a
> consequence, remove the special case.
> 
> Pratically any possible way to make sure that you don't overwrite anything
> useful in the memory, should be fine. MAP_FIXED does not care what's
> underneath (if you want't it to care you ought to use
> MAP_FIXED_NO_REPLACE).
> 
> After this change, the selftest run called sgx_mmap() only three times
> (TCS, text, data) instead of four.
> 
>         test_sgx-1811  [002] ....   586.907585: sgx_mmap <-mmap_region
>         test_sgx-1811  [002] ....   586.911752: sgx_mmap <-mmap_region
>         test_sgx-1811  [002] ....   586.911756: sgx_mmap <-mmap_region
> 
> This also gives more angles to segregate enclave building and mapping as
> the mmap()'s need to be applied only when the enclave is fully built:
> 
> Cc: luto@kernel.org
> Cc: Haitao Huang <haitao.huang@linux.intel.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Sean, would be cool if you can try this out soonish because I'm
building on top of this.

I tried you vdso change on a GLK NUC and they seem to work.

/Jarkko
