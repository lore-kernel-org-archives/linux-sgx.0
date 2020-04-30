Return-Path: <SRS0=MviC=6O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F23DC83001
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 03:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C1012082E
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 03:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD3D7X (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Apr 2020 23:59:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:52651 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgD3D7W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Apr 2020 23:59:22 -0400
IronPort-SDR: ZJhZhyHehvW/g29fNP4/8+w3qqlrmaEUq+zFfrn4MeCLpcq/Syf43iClscJoKJsC7JfeQrOxVy
 3gvxA9SUjQag==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 20:59:22 -0700
IronPort-SDR: VOTVsbRJbD49pzQSkQdPM+6nI5c9fCzBN6AfdleYJKGnsaDNaYTIURnGp+qAn2J48BV80oxTue
 xpdDqzPZtADw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="432812461"
Received: from aanderso-mobl3.amr.corp.intel.com (HELO localhost) ([10.252.52.101])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2020 20:59:12 -0700
Date:   Thu, 30 Apr 2020 06:59:11 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200430035850.GC31820@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
 <20200429052329.GD8452@linux.intel.com>
 <20200429151459.GC15992@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429151459.GC15992@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 29, 2020 at 08:14:59AM -0700, Sean Christopherson wrote:
> On Wed, Apr 29, 2020 at 08:23:29AM +0300, Jarkko Sakkinen wrote:
> > On Sun, Apr 26, 2020 at 11:57:53AM -0500, Dr. Greg wrote:
> > > On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
> > > 
> > > Good day, I hope the weekend is going well for everyone.
> > > 
> > > > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > > > to set aside private regions of code and data. The code outside the enclave
> > > > is disallowed to access the memory inside the enclave by the CPU access
> > > > control.
> > > >
> > > > ... [ elided ] ..
> > > > 
> > > > The current implementation requires that the firmware sets
> > > > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > > > decide what enclaves it wants run. The implementation does not create
> > > > any bottlenecks to support read-only MSRs later on.
> > > 
> > > It seems highly unlikely that a driver implementation with any type of
> > > support for read-only launch control registers would ever get into the
> > > kernel.  All one needs to do is review the conversations that Matthew
> > > Garrett's lockdown patches engender to get a sense of that, ie:
> > > 
> > > https://lwn.net/Articles/818277/
> > 
> > We do not require read-only MSRs.
> 
> Greg is pointing out the opposite, that supporting read-only MSRs is highly
> unlikely to ever be supported in the mainline kernel.

In a nutshell, what is wrong in the current code changes and what
*exactly* should we change? This is way too high level at the moment at
least for my limited brain capacity.

/Jarkko
