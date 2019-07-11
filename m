Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052BBC73C66
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C1120872
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfGKRzx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 13:55:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:24401 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbfGKRzx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 13:55:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 10:55:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="364894696"
Received: from jolivell-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.138])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jul 2019 10:55:51 -0700
Date:   Thu, 11 Jul 2019 20:55:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org,
        luto@kernel.org, jethro@fortanix.com, greg@enjellic.com
Subject: Re: [RFC PATCH v3 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave()
 to allow parameter passing on untrusted stack
Message-ID: <20190711175550.s5u46chozj5acjjr@linux.intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com>
 <cover.1562813643.git.cedric.xing@intel.com>
 <742dfe18ee4128ccccf8313b6c6cb3ee8b961712.1562813643.git.cedric.xing@intel.com>
 <20190711095317.v6tlrx2vt4tkibb3@linux.intel.com>
 <20190711154231.GA15067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711154231.GA15067@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 08:42:31AM -0700, Sean Christopherson wrote:
> On Thu, Jul 11, 2019 at 12:53:17PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Jul 10, 2019 at 09:21:32PM -0700, Cedric Xing wrote:
> > > -#ifdef SGX_KERNEL_DOC
> > 
> > Why is this removed?
> > 
> > > + * int __vdso_sgx_enter_enclave(int leaf, void *tcs,
> > > + *				struct sgx_enclave_exinfo *exinfo,
> > > + *				sgx_callback callback)
> > > + * {
> > > + *	while (leaf == EENTER || leaf == ERESUME) {
> > > + *		int rc;
> > > + *		try {
> > > + *			ENCLU[leaf];
> > > + *			rc = 0;
> > > + *			if (exinfo)
> > > + *				exinfo->leaf = EEXIT;
> > > + *		} catch (exception) {
> > > + *			rc = -EFAULT;
> > > + *			if (exinfo)
> > > + *				*exinfo = exception;
> > > + *		}
> > > + *
> > > + *		leaf = !callback ? rc: (*callback)(rdi, rsi, rdx, exinfo,
> > > + *						   r8, r9, tcs, ursp);
> > > + *	}
> > > + *
> > > + *	return leaf > 0 ? -EINVAL : leaf;
> > > + * }
> > >   */
> > 
> > What is this? C++ and anyway there is already a source code. No need
> > to duplicate with pseudo-code. Only adds maintenance burde. Please get
> > rid of this.
> 
> Adding C pseudo-code was my idea, e.g. it already exists in v20.  Declaring
> a psuedo-C function coerces kernel-doc into generating documentation for
> the asm routine.  IIRC, fully defining the function is not required for
> docs, but IMO it's significantly easier to gain an understanding of a blob
> of asm if there is higher level pseudocode.

The way to do this right would be to write a documentation block before
kdoc's for the functions. It is described in the last section of

https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt0

I.e. organize the file as

1. Documentation block describing the theory of operation.
2. Functions and their associated documentations.

/Jarkko
