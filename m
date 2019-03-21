Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD2DC43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28617218D8
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfCUPkO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:40:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:56490 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfCUPkN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 11:40:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 08:40:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="136226548"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2019 08:40:11 -0700
Date:   Thu, 21 Mar 2019 08:40:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 13/27] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20190321154009.GD6519@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-14-jarkko.sakkinen@linux.intel.com>
 <20190319195907.GG25575@linux.intel.com>
 <20190321145153.GO4603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321145153.GO4603@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 04:51:53PM +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 19, 2019 at 12:59:07PM -0700, Sean Christopherson wrote:
> > On Sun, Mar 17, 2019 at 11:14:42PM +0200, Jarkko Sakkinen wrote:
> > > +/**
> > > + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> > > + *
> > > + * ENCLS has its own (positive value) error codes and also generates
> > > + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> > > + * with system error codes as everything percolates back up the stack.
> > > + * Unfortunately (for us), we need to precisely identify each unique
> > > + * error code, e.g. the action taken if EWB fails varies based on the
> > > + * type of fault and on the exact SGX error code, i.e. we can't simply
> > > + * convert all faults to -EFAULT.
> > > + *
> > > + * To make all three error types coexist, we set bit 30 to identify an
> > > + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> > > + * between positive (faults and SGX error codes) and negative (system
> > > + * error codes) values.
> > > + */
> > > +#define ENCLS_FAULT_FLAG 0x40000000
> > > +
> > > +/**
> > > + * Retrieve the encoded trapnr from the specified return code.
> > > + */
> > > +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
> > 
> > I honestly can't remember, is there a reason ENCLS_TRAPNR is still a macro
> > and not an inline function?
> 
> Not at all. And also the value should be unsigned and fault flag
> should be 0x80* because we never should get negative values.

From ENCLS itself, but we do have scenarios where the return code can
hold a system error code (negative value), an SGX error code (positive
value) or fault inforation.  E.g. sgx_encl_init() sets ret to -ERESTARTSYS,
and __sgx_encl_ewb() returns system error codes if get_backing() fails
and also directly returns the result of __ewb().  We could dance around
those issues, but IMO it's too fragile as it essentially requires a full
audit of every possible error path when modifying code.
