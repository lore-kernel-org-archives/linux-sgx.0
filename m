Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC578C3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD5823405
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbfHWCF0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 22:05:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:42421 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733086AbfHWCFX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 22:05:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 19:05:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="203622476"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 22 Aug 2019 19:05:22 -0700
Date:   Thu, 22 Aug 2019 19:05:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Message-ID: <20190823020522.GK25467@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
 <20190822035510.GV29345@linux.intel.com>
 <d0e8313b7817a43151b11602ad55b1136f614850.camel@linux.intel.com>
 <20190822163458.GG25467@linux.intel.com>
 <37fcfdb9f54c01573a83de439e6cbd51ff677649.camel@linux.intel.com>
 <ef15d08e54d62cea3f659e17f0a1b4a881aeb96f.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef15d08e54d62cea3f659e17f0a1b4a881aeb96f.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 03:57:36AM +0300, Jarkko Sakkinen wrote:
> On Fri, 2019-08-23 at 03:39 +0300, Jarkko Sakkinen wrote:
> > On Thu, 2019-08-22 at 09:34 -0700, Sean Christopherson wrote:
> > > On Thu, Aug 22, 2019 at 07:31:39PM +0300, Jarkko Sakkinen wrote:
> > > > On Wed, 2019-08-21 at 20:55 -0700, Sean Christopherson wrote:
> > > > > Why are we validating the TCS protection bits?  Hardware ignores them, so
> > > > > why do we care?  sgx_ioc_enclave_add_page() sets the internal protection
> > > > > bits so there's no danger of putting the wrong thing in the page tables.
> > > > 
> > > > I think that in this commit I got it wrong but I think this is awkward:
> > > > 
> > > > 	/*
> > > > 	 * TCS pages must always RW set for CPU access while the SECINFO
> > > > 	 * permissions are *always* zero - the CPU ignores the user provided
> > > > 	 * values and silently overwrites with zero permissions.
> > > > 	 */
> > > > 	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
> > > > 		prot |= PROT_READ | PROT_WRITE;
> > > > 
> > > > In my opinion the right thing to do would be check that SECINFO has *at
> > > > minimum* RW and return -EINVAL if not.
> > > 
> > > Based on Serge's comment, hardware updates MRENCLAVE with SECINFO *after*
> > > it overwrites the flags for TCS pages.  I.e. requiring RW for the TCS
> > > would result in every enclave failing EINIT due to an invalid measurement.
> > > It'd be fairly easy to verify this if we want to triple check that that is
> > > indeed hardware behavior.
> > 
> > This is from the signing tool that I wrote back in 2016 used in the
> > selftest:
> > 
> > struct mreadd {
> > 	uint64_t tag;
> > 	uint64_t offset;
> > 	uint64_t flags; /* SECINFO flags */
> > 	uint8_t reserved[40];
> > } __attribute__((__packed__));
> > 
> > static bool mrenclave_eadd(EVP_MD_CTX *ctx, uint64_t offset, uint64_t flags)
> > {
> > 	struct mreadd mreadd;
> > 
> > 	memset(&mreadd, 0, sizeof(mreadd));
> > 	mreadd.tag = MREADD;
> > 	mreadd.offset = offset;
> > 	mreadd.flags = flags;
> > 
> > 	return mrenclave_update(ctx, &mreadd);
> > }
> > 
> > If MRENCLAVE was updated after the overwrite, this would not work.
> > 
> > The least confusing semantics would be to require RW, no more or less.
> 
> OK, it is how Serge said.
> 
> This can we verified from the SDM easily (SCRATCH_SECINFO gets zeros
> is extended after that).
> 
> And also from my signing tool :-)
> 
> for (offset = 0; offset < sb.st_size; offset += 0x1000) {
> 	if (!offset)
> 		flags = SGX_SECINFO_TCS;
> 	else
> 		flags = SGX_SECINFO_REG | SGX_SECINFO_R |
> 			SGX_SECINFO_W | SGX_SECINFO_X;
> 
> OK, so this looks like that my patch does exactly the right thing,
> right?

That's my understanding as well.  Definitely worthy of a comment
explaining all of the above.
