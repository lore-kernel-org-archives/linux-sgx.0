Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E984C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2455E206E6
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgGGDaA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:30:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:12458 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgGGDaA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Jul 2020 23:30:00 -0400
IronPort-SDR: pMqdgPgXTB3FFT84nUfLrVVCcf760B8H70rKT+jYSuRfXOAGavfUXCs1Huj5f65xqzNZ0Z5ya1
 dvNMsWv6bg7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="135778745"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="135778745"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 20:30:00 -0700
IronPort-SDR: CUOZC+1ZeC8kxSLZJJTm5Aq8u6JZcooZlcWac/BfdJ4TSR/cRTXWeIP5QNKvuGqvyKjvppuG1D
 uvu2GvmcaJJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="283250294"
Received: from apiccion-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.178])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 20:29:46 -0700
Date:   Tue, 7 Jul 2020 06:29:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200707032945.GA127977@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200627174335.GC15585@zn.tnic>
 <20200629152718.GA12312@linux.intel.com>
 <20200704014349.GB129411@linux.intel.com>
 <20200707013847.GA5208@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707013847.GA5208@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 06, 2020 at 06:38:47PM -0700, Sean Christopherson wrote:
> On Sat, Jul 04, 2020 at 04:43:49AM +0300, Jarkko Sakkinen wrote:
> > On Mon, Jun 29, 2020 at 08:27:19AM -0700, Sean Christopherson wrote:
> > > On Sat, Jun 27, 2020 at 07:43:35PM +0200, Borislav Petkov wrote:
> > > > And you could do similar sanity checks in the other ioctl functions.
> > > 
> > > Ya, as above, SGX_ENCL_INITIALIZED can be checked here.
> > > 
> > > SGX_ENCL_DEAD is actually already checked in in the top level sgx_ioctl(),
> > > i.e. the check in sgx_encl_add_page() can technically be flat out dropped.
> > > 
> > > I say "technically" because I'm a bit torn over SGX_ENCL_DEAD; encl->lock
> > > must be held to SGX_ENCL_DEAD (the page fault and reclaim flows rely on
> > > this), but as it stands today only ioctl() paths (guarded by SGX_ENCL_IOCTL)
> > > and sgx_release() (makes the ioctls() unreachable) set SGX_ENCL_DEAD.
> > > 
> > > So it's safe to check SGX_ENCL_DEAD from ioctl() context without holding
> > > encl->lock, at least in the current code base, but it feels weird/sketchy.
> > > 
> > > In the end I don't think I have a strong opinion.  Removing the technically
> > > unnecessary DEAD check in sgx_encl_add_page() is the simplest change, so it
> > > may make sense to do that and nothing more for initial upstreaming.  Long
> > > term, I fully expect we'll add paths that set SGX_ENCL_DEAD outside of
> > > ioctl() context, e.g. to handle EPC OOM, but it wouldn't be a bad thing to
> > > have a standalone commit in a future series to add DEAD checks (under
> > > encl->lock) in the ADD and INIT flows.
> > 
> > AFAIK nonne of th ioctl's should not need SGX_ENCL_DEAD check.
> 
> I can't tell if the double negative was intended, but I took a peek at your
> current master and see that you removed the SGX_ENCL_DEAD check in
> sgx_ioctl().  That check needs to stay, e.g. if EEXTEND fails we absolutely
> need to prevent any further operations on the enclave.
> 
> The above was calling out that additional checks on SGX_ENCL_DEAD after
> acquiring encl->lock are not necessary because SGX_ENCL_DEAD can only be
> set when the ioctls() are no longer reachable or from within an ioctl(),
> which provides exclusivity via SGX_ENCL_IOCTL.

Got it.

/Jarkko
