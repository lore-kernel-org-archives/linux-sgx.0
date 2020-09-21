Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ECAC4346E
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E8220888
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgIUSt6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:49:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:14046 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgIUSt6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 14:49:58 -0400
IronPort-SDR: kBaNvocmDj4CJooRbdRppdfMdLWdmAImHsDSf6074uWMxnqc/m6I3rdN0KfWI6trO0vnoV/X2P
 fT7DZhNUGFoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148212393"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="148212393"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 11:49:57 -0700
IronPort-SDR: yOjFgO+JASDoJWXCsFJyyGqSbA2UlKJcolvZQBtyuH2271liF19Bcs7ImLXTKGbe9ttgB9Iy3O
 14zT01aTm06w==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="485612138"
Received: from gkapusti-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.42.63])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 11:49:50 -0700
Date:   Mon, 21 Sep 2020 21:49:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20200921184948.GA49586@linux.intel.com>
References: <20200915110522.893152-14-jarkko.sakkinen@linux.intel.com>
 <op.0q2prldowjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200917160206.GF8530@linux.intel.com>
 <op.0q3pw0stwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200918020940.GA14678@sjchrist-ice>
 <20200918122029.GA27028@linux.intel.com>
 <20200918123932.GB27028@linux.intel.com>
 <20200919000918.GB21189@sjchrist-ice>
 <20200921114104.GB6038@linux.intel.com>
 <20200921164647.GC23989@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921164647.GC23989@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 09:46:48AM -0700, Sean Christopherson wrote:
> > This is also true. I meant by corrupt state e.g. a kernel bug, which
> > causes uninitalizes pages go the free queue.
> > 
> > I'd rephrase this in kdoc as: "The function deinitializes enclave and
> > returns -EIO when EPC is lost, while entering to a new power cycle".
> 
> The kdocs shouldn't speculate on why EEXTEND might fail.  E.g. in some (and
> possibility most) environments, the most common scenario of EEXTEND failure
> will be EPC invalidation due to virtual machine migration.
> 
> This is why I'd prefer that the kernel kill the enclave if and only if the
> error is guaranteed to be fatal, e.g. the docs can have a blanket statement
> along the lines of:
> 
>   An enclave will be killed and its EPC resources will be freed if an error that
>   is guaranteed to be fatal is encountered at any time, e.g. if EEXTEND fails as
>   EEXTEND can only fail due to loss of EPC, a kernel bug, or silicon bug, all of
>   which are unrecoverable.

Kernel bug is not a legit condition. Neither is a silicon failure. We do
not document speculated kernel bugs. If we used that kind of pattern for
documentation, we would have to put similar statements about every
single line of code.

Describing legit failure conditions with the best knowledge available is
the whole point why people read documentation in the first place.
Otherwise, the documentation has absolutely no value.

Documentation is also always, without exception, inaccurate. Lacking
something is not an issue, if it is not done on purpose.

I'd refine what I did as

"The function deinitializes enclave and returns -EIO when EPC was lost,
 while entering to a new power cycle, or any other condition where EPC
 gets invalidated."

It is not perfect, nothing ever is, but it is heck a lot more useful
than being too generic to fail.

> > > EADD is a little different, e.g. it could fault due to a bad source address,
> > > in which case the failure is not technically fatal.  But, Jarkko wanted to
> > > have consistent behavior for EADD and EEXTEND failures, and practically
> > > speaking the enclave is probably hosed anyways if EADD fails, i.e. killing the
> > > enclave on EADD failure isn't a sticking point (for me).
> > 
> > We need to figure out own return value for EADD, but I agree with this.
> > 
> > I would go with -EFAULT as we do when source VMA is no available. Does
> > this make sense to you?
> 
> If only EEXTEND will be treated as fatal, then I see no need to worry about
> the return code for EADD.  In that case, simply kill the enclave on EEXTEND
> failure instead of on a specific return code.

To have understandable semantics you have to map error codes to
conditions rather than opcodes. -EIO means loss of enclave in the event
of EPC gone invalid. Enclave is already lost, that is the reason why we
deinitialize the kernel data structures.

EADD must have a different error code because nothing is actually lost
but the failure conditions are triggered outside. -EFAULT would be
probably the most reasonable choice for that.

/Jarkko
