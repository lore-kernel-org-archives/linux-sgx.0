Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37597C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 11:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10CDA21900
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 11:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfCVLAZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:00:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:42018 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbfCVLAZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 07:00:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 04:00:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="157370625"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.199])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2019 04:00:15 -0700
Date:   Fri, 22 Mar 2019 13:00:14 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 13/27] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20190322110014.GF3122@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-14-jarkko.sakkinen@linux.intel.com>
 <20190319195907.GG25575@linux.intel.com>
 <20190321145153.GO4603@linux.intel.com>
 <20190321154009.GD6519@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321154009.GD6519@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 08:40:11AM -0700, Sean Christopherson wrote:
> On Thu, Mar 21, 2019 at 04:51:53PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Mar 19, 2019 at 12:59:07PM -0700, Sean Christopherson wrote:
> > > On Sun, Mar 17, 2019 at 11:14:42PM +0200, Jarkko Sakkinen wrote:
> > > > +/**
> > > > + * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
> > > > + *
> > > > + * ENCLS has its own (positive value) error codes and also generates
> > > > + * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
> > > > + * with system error codes as everything percolates back up the stack.
> > > > + * Unfortunately (for us), we need to precisely identify each unique
> > > > + * error code, e.g. the action taken if EWB fails varies based on the
> > > > + * type of fault and on the exact SGX error code, i.e. we can't simply
> > > > + * convert all faults to -EFAULT.
> > > > + *
> > > > + * To make all three error types coexist, we set bit 30 to identify an
> > > > + * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
> > > > + * between positive (faults and SGX error codes) and negative (system
> > > > + * error codes) values.
> > > > + */
> > > > +#define ENCLS_FAULT_FLAG 0x40000000
> > > > +
> > > > +/**
> > > > + * Retrieve the encoded trapnr from the specified return code.
> > > > + */
> > > > +#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
> > > 
> > > I honestly can't remember, is there a reason ENCLS_TRAPNR is still a macro
> > > and not an inline function?
> > 
> > Not at all. And also the value should be unsigned and fault flag
> > should be 0x80* because we never should get negative values.
> 
> From ENCLS itself, but we do have scenarios where the return code can
> hold a system error code (negative value), an SGX error code (positive
> value) or fault inforation.  E.g. sgx_encl_init() sets ret to -ERESTARTSYS,
> and __sgx_encl_ewb() returns system error codes if get_backing() fails
> and also directly returns the result of __ewb().  We could dance around
> those issues, but IMO it's too fragile as it essentially requires a full
> audit of every possible error path when modifying code.

There should be zero of those now but if you find one we can fix that.
These inline functions should only deal with what comes from ENCLS. I
think it is cleanest to fix those sites. I think here the focus should
be on clarity.

In ioctl.c there are total 5 sites and all of them are good.

Also encl.c is all good.

From the sites that you mentioned sgx_encl_ewb() needs to be fixed. In
reclaim.c that seems to be the only problematic site.

These are pretty easy to grep with 'encls_'.

For me it looks like that assuming the positive value is absolutely
the right thing to do as long as sgx_encl_ewb() is fixed properly.

/Jarkko
