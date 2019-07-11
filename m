Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B48C74A4B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 09:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3375120872
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 09:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfGKJiN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:38:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:49129 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727595AbfGKJiM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 05:38:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 02:38:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,478,1557212400"; 
   d="scan'208";a="167976225"
Received: from spoledic-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.84])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2019 02:38:08 -0700
Date:   Thu, 11 Jul 2019 12:38:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v2 0/3] An alternative __vdso_sgx_enter_enclave() to
 allow enclave/host parameter passing using untrusted stack
Message-ID: <20190711093809.4ogxe25laeoyp4ve@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-1-cedric.xing@intel.com>
 <20190710111719.nnoedfo4wvbfghq7@linux.intel.com>
 <686e47d2-f45c-6828-39d1-48374925de6c@intel.com>
 <20190710224628.epjxwlpqqxdurmzo@linux.intel.com>
 <20190710231538.dkc7tyeyvns53737@linux.intel.com>
 <27cf0fc7-71c6-7dc1-f031-86bf887f1fe1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27cf0fc7-71c6-7dc1-f031-86bf887f1fe1@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 10, 2019 at 04:37:41PM -0700, Xing, Cedric wrote:
> On 7/10/2019 4:15 PM, Jarkko Sakkinen wrote:
> > On Thu, Jul 11, 2019 at 01:46:28AM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Jul 10, 2019 at 11:08:37AM -0700, Xing, Cedric wrote:
> > > > > With these conclusions I think the current vDSO API is sufficient for
> > > > > Linux.
> > > > 
> > > > The new vDSO API is to support data exchange on stack. It has nothing to do
> > > > with debugging. BTW, the community has closed on this.
> > > 
> > > And how that is useful?
> > > 
> > > > The CFI directives are for stack unwinding. They don't affect what the code
> > > > does so you can just treat them as NOPs if you don't understand what they
> > > > do. However, they are useful to not only debuggers but also exception
> > > > handling code. libunwind also has a setjmp()/longjmp() implementation based
> > > > on CFI directives.
> > > 
> > > Of course I won't merge code of which usefulness I don't understand.
> > 
> > I re-read the cover letter [1] because it usually is the place
> > to "pitch" a feature.
> > 
> > It fails to address two things:
> > 
> > 1. How and in what circumstances is an untrusted stack is a better
> >     vessel for handling exceptions than the register based approach
> >     that we already have?
> 
> We are not judging which vessel is better (or the best) among all possible
> vessels. We are trying to enable more vessels. Every vessel has its pros and
> cons so there's *no* single best vessel.

I think reasonable metric is actually the coverage of the Intel SDK
based enclaves. How widely are they in the wild? If the user base is
large, it should be reasonable to support this just based on that.

/Jarkko
