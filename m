Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA35C3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 00:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E64233FD
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 00:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbfHWAjr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 20:39:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:60602 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732102AbfHWAjr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 20:39:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 17:39:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="263030967"
Received: from nmordaws-mobl1.amr.corp.intel.com ([10.252.38.129])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2019 17:39:44 -0700
Message-ID: <37fcfdb9f54c01573a83de439e6cbd51ff677649.camel@linux.intel.com>
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Date:   Fri, 23 Aug 2019 03:39:43 +0300
In-Reply-To: <20190822163458.GG25467@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
         <20190822035510.GV29345@linux.intel.com>
         <d0e8313b7817a43151b11602ad55b1136f614850.camel@linux.intel.com>
         <20190822163458.GG25467@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2019-08-22 at 09:34 -0700, Sean Christopherson wrote:
> On Thu, Aug 22, 2019 at 07:31:39PM +0300, Jarkko Sakkinen wrote:
> > On Wed, 2019-08-21 at 20:55 -0700, Sean Christopherson wrote:
> > > Why are we validating the TCS protection bits?  Hardware ignores them, so
> > > why do we care?  sgx_ioc_enclave_add_page() sets the internal protection
> > > bits so there's no danger of putting the wrong thing in the page tables.
> > 
> > I think that in this commit I got it wrong but I think this is awkward:
> > 
> > 	/*
> > 	 * TCS pages must always RW set for CPU access while the SECINFO
> > 	 * permissions are *always* zero - the CPU ignores the user provided
> > 	 * values and silently overwrites with zero permissions.
> > 	 */
> > 	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
> > 		prot |= PROT_READ | PROT_WRITE;
> > 
> > In my opinion the right thing to do would be check that SECINFO has *at
> > minimum* RW and return -EINVAL if not.
> 
> Based on Serge's comment, hardware updates MRENCLAVE with SECINFO *after*
> it overwrites the flags for TCS pages.  I.e. requiring RW for the TCS
> would result in every enclave failing EINIT due to an invalid measurement.
> It'd be fairly easy to verify this if we want to triple check that that is
> indeed hardware behavior.

This is from the signing tool that I wrote back in 2016 used in the
selftest:

struct mreadd {
	uint64_t tag;
	uint64_t offset;
	uint64_t flags; /* SECINFO flags */
	uint8_t reserved[40];
} __attribute__((__packed__));

static bool mrenclave_eadd(EVP_MD_CTX *ctx, uint64_t offset, uint64_t flags)
{
	struct mreadd mreadd;

	memset(&mreadd, 0, sizeof(mreadd));
	mreadd.tag = MREADD;
	mreadd.offset = offset;
	mreadd.flags = flags;

	return mrenclave_update(ctx, &mreadd);
}

If MRENCLAVE was updated after the overwrite, this would not work.

The least confusing semantics would be to require RW, no more or less.

/Jarkko

