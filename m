Return-Path: <SRS0=MuLj=4M=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7308AC38BF9
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Feb 2020 21:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F14B21556
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Feb 2020 21:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXVNT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Feb 2020 16:13:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:33067 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgBXVNT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Feb 2020 16:13:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 13:13:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="271042927"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 24 Feb 2020 13:13:18 -0800
Date:   Mon, 24 Feb 2020 13:13:17 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v27 00/22] Intel SGX foundations
Message-ID: <20200224211317.GJ29865@linux.intel.com>
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
 <20200224100932.GA15526@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224100932.GA15526@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 24, 2020 at 04:09:32AM -0600, Dr. Greg wrote:
> On Sun, Feb 23, 2020 at 07:25:37PM +0200, Jarkko Sakkinen wrote:
> 
> Good morning, I hope the week is starting well for everyone.
> 
> > Intel(R) SGX is a set of CPU instructions that can be used by
> > applications to set aside private regions of code and data. The code
> > outside the enclave is disallowed to access the memory inside the
> > enclave by the CPU access control.
> 
> Do we misinterpret or is the driver not capable of being built in
> modular form?

Correct.

> If not, it would appear that this functionality has been lost since
> version 19 of the driver, admittedly some time ago.

It was removed in v20[*].

> > v19:
> >
> > ... [ deleted ] ...
> >
> > * Allow the driver to be compiled as a module now that it no code is using
> >   its routines and it only uses exported symbols. Now the driver is
> >   essentially just a thin ioctl layer.
> 
> Not having the driver available in modular form obviously makes work
> on the driver a bit more cumbersome.

Heh, depends on your development environment, e.g. I do 99% of my testing
in a VM with a very minimal kernel that even an anemic system can
incrementally build in a handful of seconds.

> I'm assuming that the lack of module support is secondary to some
> innate architectural issues with the driver?

As of today, the only part of the driver that can be extracted into a
module is effectively the ioctl() handlers, i.e. a module would just be an
ioctl() wrapper around a bunch of in-kernel functionality.  At that point,
building the "driver" as a module doesn't provide any novel benefit, e.g.
very little memory footprint savings, reloading the module wouldn't "fix"
any bugs with EPC management, SGX can still be forcefully disabled via
kernel parameter, etc...  And on the flip side, allowing it to be a module
would require exporting a non-trivial number of APIs that really shouldn't
be exposed outside of the SGX subsystem.

As for why things are baked into the kernel:

  - EPC management: support for future enhancements (KVM and EPC cgroup).

  - Reclaim: don't add a unnecessary infrastructure, i.e. avoid a callback
    mechanism for which there is a single implementation.

  - Tracking of LEPUBKEYHASH MSRs: KVM support.

[*] https://lkml.kernel.org/r/20190401225717.GA13450@linux.intel.com
