Return-Path: <SRS0=PIOK=C3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B6CC43464
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 23:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 007CB21734
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 23:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgIRXZU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Sep 2020 19:25:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:32638 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgIRXZU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Sep 2020 19:25:20 -0400
IronPort-SDR: qSksG/9yLCgvd3Gxdw3DYCD0lXRxcUr/6e3YTtxTc0PCsio/6p2MgxiSALV5BcPtgKmizDSMLP
 4NhzbzI/CRnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="157444944"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="157444944"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:25:09 -0700
IronPort-SDR: bwQl4yFHMgKEVeADmPLf3YddIA9jvYk9OyDQiQiin4hc6P/CFDEWDJIJlPKkoifvB7h/HuS3xt
 xZ7bK1/tc/YA==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="484421587"
Received: from pbaltus-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.234])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:25:02 -0700
Date:   Sat, 19 Sep 2020 02:24:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()'
Message-ID: <20200918232458.GA6175@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
 <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 18, 2020 at 08:09:04AM -0700, Andy Lutomirski wrote:
> On Tue, Sep 15, 2020 at 4:28 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Add vm_ops()->mprotect() for additional constraints for a VMA.
> >
> > Intel Software Guard eXtensions (SGX) will use this callback to add two
> > constraints:
> >
> > 1. Verify that the address range does not have holes: each page address
> >    must be filled with an enclave page.
> > 2. Verify that VMA permissions won't surpass the permissions of any enclave
> >    page within the address range. Enclave cryptographically sealed
> >    permissions for each page address that set the upper limit for possible
> >    VMA permissions. Not respecting this can cause #GP's to be emitted.
> 
> It's been awhile since I looked at this.  Can you remind us: is this
> just preventing userspace from shooting itself in the foot or is this
> something more important?
> 
> --Andy

Haitao found this:

https://patchwork.kernel.org/patch/10978327/

The way I understand it, for an LSM hook it makes sense that the
mprotect() can deduce a single permission for an enclave address range.
With those constraints it is possible.

/Jarkko
