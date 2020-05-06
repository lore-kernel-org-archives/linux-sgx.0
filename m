Return-Path: <SRS0=a91O=6U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF9CC38A2A
	for <linux-sgx@archiver.kernel.org>; Wed,  6 May 2020 12:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A86C2073A
	for <linux-sgx@archiver.kernel.org>; Wed,  6 May 2020 12:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgEFMQ3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 May 2020 08:16:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:54465 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgEFMQ3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 May 2020 08:16:29 -0400
IronPort-SDR: 8Uv4s9Fdj0SGFaphJ1CbFtoEo54rTShdLOuFtgQZ72a7TjkYsAWBMB0WWhcUnsmy4tB4jl1AP8
 HAbOA43TbygQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 05:16:28 -0700
IronPort-SDR: JPc1qDvxWTtCQTa5kLHajZfavO2LC2sdMB2KoRj3adSpRVz9HEdoV9Pqvrhqm9O01NFfFPhQaw
 bgM8i1rw/9sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="284606158"
Received: from ngorb-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.52.39])
  by fmsmga004.fm.intel.com with ESMTP; 06 May 2020 05:16:21 -0700
Date:   Wed, 6 May 2020 15:16:18 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200506121618.GA170146@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
 <20200430034651.GB31820@linux.intel.com>
 <a9ff7817-32d1-e048-af05-862ca9f8aa46@fortanix.com>
 <20200430082328.GA6387@linux.intel.com>
 <1dd3ba07-f782-3a82-ac25-83d524a2c062@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dd3ba07-f782-3a82-ac25-83d524a2c062@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 30, 2020 at 04:12:07PM +0200, Jethro Beekman wrote:
> On 2020-04-30 10:23, Jarkko Sakkinen wrote:
> > On Thu, Apr 30, 2020 at 09:19:48AM +0200, Jethro Beekman wrote:
> >> On 2020-04-30 05:46, Jarkko Sakkinen wrote:
> >>> On Wed, Apr 29, 2020 at 05:27:48PM +0200, Jethro Beekman wrote:
> >>>> On 2020-04-21 23:52, Jarkko Sakkinen wrote:
> >>>>> Intel(R) SGX is a set of CPU instructions that can be used by applications
> >>>>> to set aside private regions of code and data. The code outside the enclave
> >>>>> is disallowed to access the memory inside the enclave by the CPU access
> >>>>> control.
> >>>>>
> >>>>> There is a new hardware unit in the processor called Memory Encryption
> >>>>> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> >>>>> one or many MEE regions that can hold enclave data by configuring them with
> >>>>> PRMRR registers.
> >>>>>
> >>>>> The MEE automatically encrypts the data leaving the processor package to
> >>>>> the MEE regions. The data is encrypted using a random key whose life-time
> >>>>> is exactly one power cycle.
> >>>>>
> >>>>> The current implementation requires that the firmware sets
> >>>>> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> >>>>> decide what enclaves it wants run. The implementation does not create
> >>>>> any bottlenecks to support read-only MSRs later on.
> >>>>>
> >>>>> You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> >>>>>
> >>>>> 	cat /proc/cpuinfo  | grep sgx
> >>>>
> >>>> Let's merge this.
> >>>
> >>> So can I tag reviewed-by's?
> >>>
> >>
> >> No, but you already have my tested-by's.
> >>
> >> If it helps I can try to review some patches, but 1) I know nothing
> >> about kernel coding guidelines and best practices and 2) I know little
> >> about most kernel internals, so I won't be able to review every patch.
> > 
> > Ackd-by *acknowledges* that the patches work for you. I think that would
> > be then the correct choice for the driver patch and patches before that.
> > 
> > Lets go with that if that is cool for you of course.
> > 
> > Did you run the selftest only or possibly also some internal Fortanix
> > tests?
> > 
> 
> v29 patches 2 through 18:
> 
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> 
> I only ran production SGX software. I didn't run the self test.

That's great to hear thank you.

Updated my tree accordingly.

/Jarkko
