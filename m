Return-Path: <SRS0=l2ne=WD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDADEC433FF
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 21:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C999821871
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 21:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfHGVWa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 17:22:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:28182 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfHGVWa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 17:22:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 12:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="192976255"
Received: from geyerral-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.199])
  by fmsmga001.fm.intel.com with ESMTP; 07 Aug 2019 12:12:14 -0700
Date:   Wed, 7 Aug 2019 22:12:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "cedric.xing@intel.com" <cedric.xing@intel.com>
Subject: Re: [PATCH v21 18/28] x86/sgx: Add swapping code to the core and SGX
 driver
Message-ID: <20190807191214.45xnr5y5jmplyups@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-19-jarkko.sakkinen@linux.intel.com>
 <ba0aa229-d764-4e26-5de3-044fe28ddf61@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba0aa229-d764-4e26-5de3-044fe28ddf61@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 06:33:32AM +0000, Jethro Beekman wrote:
> On 2019-07-13 10:07, Jarkko Sakkinen wrote:
> > Because the kernel is untrusted, swapping pages in/out of the Enclave
> > Page Cache (EPC) has specialized requirements:
> > 
> > * The kernel cannot directly access EPC memory, i.e. cannot copy data
> >    to/from the EPC.
> > * To evict a page from the EPC, the kernel must "prove" to hardware that
> >    are no valid TLB entries for said page since a stale TLB entry would
> >    allow an attacker to bypass SGX access controls.
> > * When loading a page back into the EPC, hardware must be able to verify
> >    the integrity and freshness of the data.
> > * When loading an enclave page, e.g. regular pages and Thread Control
> >    Structures (TCS), hardware must be able to associate the page with a
> >    Secure Enclave Control Structure (SECS).
> > 
> > To satisfy the above requirements, the CPU provides dedicated ENCLS
> > functions to support paging data in/out of the EPC:
> > 
> > * EBLOCK:   Mark a page as blocked in the EPC Map (EPCM).  Attempting
> >              to access a blocked page that misses the TLB will fault.
> > * ETRACK:   Activate blocking tracking.  Hardware verifies that all
> >              translations for pages marked as "blocked" have been flushed
> > 	    from the TLB.
> > * EPA:      Add version array page to the EPC.  As the name suggests, a
> >              VA page is an 512-entry array of version numbers that are
> > 	    used to uniquely identify pages evicted from the EPC.
> > * EWB:      Write back a page from EPC to memory, e.g. RAM.  Software
> >              must supply a VA slot, memory to hold the a Paging Crypto
> > 	    Metadata (PCMD) of the page and obviously backing for the
> > 	    evicted page.
> > * ELD{B,U}: Load a page in {un}blocked state from memory to EPC.  The
> >              driver only uses the ELDU variant as there is no use case
> > 	    for loading a page as "blocked" in a bare metal environment.
> > 
> > To top things off, all of the above ENCLS functions are subject to
> > strict concurrency rules, e.g. many operations will #GP fault if two
> > or more operations attempt to access common pages/structures.
> > 
> > To put it succinctly, paging in/out of the EPC requires coordinating
> > with the SGX driver where all of an enclave's tracking resides.  But,
> > simply shoving all reclaim logic into the driver is not desirable as
> > doing so has unwanted long term implications:
> > 
> > * Oversubscribing EPC to KVM guests, i.e. virtualizing SGX in KVM and
> >    swapping a guest's EPC pages (without the guest's cooperation) needs
> >    the same high level flows for reclaim but has painfully different
> >    semantics in the details.
> > * Accounting EPC, i.e. adding an EPC cgroup controller, is desirable
> >    as EPC is effectively a specialized memory type and even more scarce
> >    than system memory.  Providing a single touchpoint for EPC accounting
> >    regardless of end consumer greatly simplifies the EPC controller.
> > * Allowing the userspace-facing driver to be built as a loaded module
> >    is desirable, e.g. for debug, testing and development.  The cgroup
> >    infrastructure does not support dependencies on loadable modules.
> > * Separating EPC swapping from the driver once it has been tightly
> >    coupled to the driver is non-trivial (speaking from experience).
> 
> Some of these points seem stale now.

Thanks for spotting. I'll do a full edit for the commit message and try
to make it more short and punctual.

/Jarkko
