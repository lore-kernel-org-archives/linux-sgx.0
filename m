Return-Path: <SRS0=pIwf=6N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CA9C83003
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 05:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE41206D6
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 05:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgD2FXg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Apr 2020 01:23:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:7748 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgD2FXg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Apr 2020 01:23:36 -0400
IronPort-SDR: jsT+BjkEikvwukXB1RUxgJX5tqTn8D2ZLTh3uVvAeHx4hy4QV8OOQPfUsbYABdC1mV7A5WXDLu
 BdEOrjYm8KuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 22:23:36 -0700
IronPort-SDR: 5OKfLfolJg8d2aPIx2CQty7wHH+40bT32y0OHQ1NYAk0Aw2JzAe8kxQTPaA6g1IdNjuOcR+KgJ
 t0Ynz1mRpS4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,330,1583222400"; 
   d="scan'208";a="246735509"
Received: from ramibuso-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.170])
  by orsmga007.jf.intel.com with ESMTP; 28 Apr 2020 22:23:27 -0700
Date:   Wed, 29 Apr 2020 08:23:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200429052329.GD8452@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426165753.GA11046@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Apr 26, 2020 at 11:57:53AM -0500, Dr. Greg wrote:
> On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
> 
> Good day, I hope the weekend is going well for everyone.
> 
> > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > to set aside private regions of code and data. The code outside the enclave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.
> >
> > ... [ elided ] ..
> > 
> > The current implementation requires that the firmware sets
> > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > decide what enclaves it wants run. The implementation does not create
> > any bottlenecks to support read-only MSRs later on.
> 
> It seems highly unlikely that a driver implementation with any type of
> support for read-only launch control registers would ever get into the
> kernel.  All one needs to do is review the conversations that Matthew
> Garrett's lockdown patches engender to get a sense of that, ie:
> 
> https://lwn.net/Articles/818277/

We do not require read-only MSRs.

/Jarkko
