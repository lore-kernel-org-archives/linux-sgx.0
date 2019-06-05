Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58112C28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 22:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32AB22070B
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 22:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFEWUa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 18:20:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:54982 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfFEWU3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 18:20:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 15:20:29 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jun 2019 15:20:28 -0700
Date:   Wed, 5 Jun 2019 15:20:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v20 15/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190605222028.GH26328@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
 <20190422215831.GL1236@linux.intel.com>
 <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com>
 <20190424002653.GB14422@linux.intel.com>
 <20190604201232.GA7775@linux.intel.com>
 <20190605142908.GD11331@linux.intel.com>
 <20190605145219.GC26328@linux.intel.com>
 <20190605212536.GA22510@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605212536.GA22510@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 04:25:37PM -0500, Dr. Greg wrote:
> On Wed, Jun 05, 2019 at 07:52:19AM -0700, Sean Christopherson wrote:
> 
> Good afternoon to everyone.
> 
> > At this point I don't see the access control stuff impacting the LKM
> > decision.
> > 
> > Irrespetive of the access control thing, there are (at least) two issues
> > with using ACPI to probe the driver:
> > 
> >   - ACPI probing breaks if there are multiple device, i.e. when KVM adds
> >     a raw EPC device.  We could do something like probe the driver via
> >     ACPI but manually load the raw EPC device from core SGX code, but IMO
> >     taking that approach should be a concious decision.
> 
> If that is the case, I assume that ACPI probing will also be
> problematic for kernels that will be running on systems that have the
> SGX accelerator cards that Intel has announced in them.

Just to make sure we're all on the same page, by "multiple devices" I
was referring to multiple char devices in the kernel, not multiple EPC
"devices".

> We haven't seen a solid technical description regarding how SGX
> functionality is to be surfaced via these cards.  However, since the
> SDM/SGX specification indicates that multiple PRM/EPC's are supported,
> the logical assumption would be that each card would be surfaced as a
> separate EPC's.

I haven't seen the details for the cards, but for multi-socket systems
with multiple EPC sections, the ACPI tables will enumerate a single EPC
"device" without any size or location information.  I.e. ACPI can be
used to detect that the system has EPC, but software will need to use
CPUID to enumerate the number of sections and their size/location. 
