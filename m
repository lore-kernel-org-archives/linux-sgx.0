Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AE8C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 00:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4BF20828
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 00:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfCTAWr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:22:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:52577 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfCTAWr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Mar 2019 20:22:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2019 17:22:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,246,1549958400"; 
   d="scan'208";a="135510828"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga003.jf.intel.com with ESMTP; 19 Mar 2019 17:22:46 -0700
Date:   Tue, 19 Mar 2019 17:22:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
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
        "rientjes@google.com" <rientjes@google.com>
Subject: Re: [PATCH v19 00/27] Intel SGX1 support
Message-ID: <20190320002246.GO25575@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190319234103.GM25575@linux.intel.com>
 <d04bd50e-4fc1-70ee-780d-2c2acd939bdb@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d04bd50e-4fc1-70ee-780d-2c2acd939bdb@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 19, 2019 at 11:52:32PM +0000, Jethro Beekman wrote:
> On 2019-03-19 16:41, Sean Christopherson wrote:
> >On Sun, Mar 17, 2019 at 11:14:29PM +0200, Jarkko Sakkinen wrote:
> >>* Allow the driver to be compiled as a module now that it no code is using
> >>   its routines and it only uses exported symbols. Now the driver is
> >>   essentially just a thin ioctl layer.
> >
> >I'm not convinced it's worth the effort to allow the driver to be compiled
> >as a module, especially if we drop the ACPI-based probing.  Making the
> >driver loadable means the kernel can easily end up in situations where it's
> >tracking EPC and running its reclaimer kthread, but the driver can't be
> >loaded and can *never* be loaded, e.g. because the platform doesn't support
> >Launch Control.
> 
> Tracking EPC etc. is necessary for KVM anyway.

This part isn't related to KVM.  As it's written, a kernel with SGX support
running on a non-LC system will allocate memory and spin up a kthread, and
then do absolutely nothing with it.

When KVM support is added, then yes, it's a slightly different story.  But
we end up in the same spot if the kernel isn't built with EPC virtualization
support.

> 
> >And IMO encl.{c,h} belongs in the "driver" code, but to let the driver be
> >loadable it got shoved into the core subsystem.  All of that code is
> >specific to running enclaves in the host, i.e. it shouldn't exist if I
> >compile out the driver entirely (in a future world where I want the core
> >SGX subsystem for virtualization purposes).
> 
> Your argument here is "something that belongs in the driver isn't, therefore
> we shouldn't have a loadable driver". This seems backwards to me. Instead,
> we should see what interface would be needed so that this stuff *can* be in
> the driver.

Speaking of rehashing arguments, that approach got nixed in a previous
revision because it requires implementing the EPC eviction flows via
callbacks.  Specifically, Dave Hansen argued that we shouldn't be adding
infrastructure (the callback framework, layer of indirection, etc...)
without any true need or user for it.

> >And yes, I realize this is a full 180 from my stance a year ago :)
> 
> I don't really want to rehash this argument but I think it should be a
> module.

I agree that ideally the userspace facing driver would be a module, but
practically speaking making the driver a module complicates the kernel
a bit and leads to some undesirable behavior.  A loadable module is
"nice", but I haven't seen a true use case that requires the driver to
be a module.
