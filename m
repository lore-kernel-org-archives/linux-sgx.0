Return-Path: <SRS0=25jF=6C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3931EC2BA19
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Apr 2020 04:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2D82223F
	for <linux-sgx@archiver.kernel.org>; Sat, 18 Apr 2020 04:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgDREhu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 18 Apr 2020 00:37:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:8732 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgDREhu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 18 Apr 2020 00:37:50 -0400
IronPort-SDR: ssmWE30gygJ023FXDifidM1Zdo+mdF0lhBcPf0tRckVRjQ0XZwiiZkFAw0z5oGO29A9eLNxD9d
 Pga54HAbRQLQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 21:37:50 -0700
IronPort-SDR: UF0gki3kqQO3Hh4P/bIkYdJlCkPQX7LIMj7+7s61bVUeFI3aLvq8fHvOPXXgWgEiUMhgzfL+3Q
 OAOYpS0U8LxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,397,1580803200"; 
   d="scan'208";a="455829642"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 17 Apr 2020 21:37:50 -0700
Date:   Fri, 17 Apr 2020 21:37:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Remove PROT_NONE branch from sgx_encl_may_map().
Message-ID: <20200418043749.GH15609@linux.intel.com>
References: <20200330185452.1382455-1-jarkko.sakkinen@linux.intel.com>
 <20200330211320.GA1389628@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330211320.GA1389628@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 12:13:36AM +0300, Jarkko Sakkinen wrote:
> On Mon, Mar 30, 2020 at 09:54:52PM +0300, Jarkko Sakkinen wrote:
> > sgx_encl_may_map() always succeeding when PROT_NONE is given is not that
> > useful behaviour as one can just well as do an anonymous mapping as
> > demonstrated by the change in this patch to the test program. As a
> > consequence, remove the special case.
> > 
> > Pratically any possible way to make sure that you don't overwrite anything
> > useful in the memory, should be fine. MAP_FIXED does not care what's
> > underneath (if you want't it to care you ought to use
> > MAP_FIXED_NO_REPLACE).
> > 
> > After this change, the selftest run called sgx_mmap() only three times
> > (TCS, text, data) instead of four.
> > 
> >         test_sgx-1811  [002] ....   586.907585: sgx_mmap <-mmap_region
> >         test_sgx-1811  [002] ....   586.911752: sgx_mmap <-mmap_region
> >         test_sgx-1811  [002] ....   586.911756: sgx_mmap <-mmap_region
> > 
> > This also gives more angles to segregate enclave building and mapping as
> > the mmap()'s need to be applied only when the enclave is fully built:
> > 
> > Cc: luto@kernel.org
> > Cc: Haitao Huang <haitao.huang@linux.intel.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Sean, would be cool if you can try this out soonish because I'm
> building on top of this.

Two and a half weeks is soonish, right?

Anyways, finally tested this, no issues.  Just to be different than the
selftest, I used MAP_PRIVATE instead of MAP_SHARED along with MAP_ANONYMOUS
in my test code.
