Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3238BC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0364623402
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbfHVQe7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:34:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:21307 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfHVQe7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:34:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:34:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="180435959"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 22 Aug 2019 09:34:59 -0700
Date:   Thu, 22 Aug 2019 09:34:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Message-ID: <20190822163458.GG25467@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
 <20190822035510.GV29345@linux.intel.com>
 <d0e8313b7817a43151b11602ad55b1136f614850.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0e8313b7817a43151b11602ad55b1136f614850.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 22, 2019 at 07:31:39PM +0300, Jarkko Sakkinen wrote:
> On Wed, 2019-08-21 at 20:55 -0700, Sean Christopherson wrote:
> > Why are we validating the TCS protection bits?  Hardware ignores them, so
> > why do we care?  sgx_ioc_enclave_add_page() sets the internal protection
> > bits so there's no danger of putting the wrong thing in the page tables.
> 
> I think that in this commit I got it wrong but I think this is awkward:
> 
> 	/*
> 	 * TCS pages must always RW set for CPU access while the SECINFO
> 	 * permissions are *always* zero - the CPU ignores the user provided
> 	 * values and silently overwrites with zero permissions.
> 	 */
> 	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
> 		prot |= PROT_READ | PROT_WRITE;
> 
> In my opinion the right thing to do would be check that SECINFO has *at
> minimum* RW and return -EINVAL if not.

Based on Serge's comment, hardware updates MRENCLAVE with SECINFO *after*
it overwrites the flags for TCS pages.  I.e. requiring RW for the TCS
would result in every enclave failing EINIT due to an invalid measurement.
It'd be fairly easy to verify this if we want to triple check that that is
indeed hardware behavior.
