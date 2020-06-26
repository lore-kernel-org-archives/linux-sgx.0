Return-Path: <SRS0=bCPb=AH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1982BC433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 14:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFE8E208C9
	for <linux-sgx@archiver.kernel.org>; Fri, 26 Jun 2020 14:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgFZOSG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 Jun 2020 10:18:06 -0400
Received: from mga06.intel.com ([134.134.136.31]:6518 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgFZOSF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 26 Jun 2020 10:18:05 -0400
IronPort-SDR: cumnl4v8tc1XbBOCo6zIW/OsTM1NdLBJNFnoAAhh5J/RXDj28JI+HbmGgQrlxOao5Nuhmg+PYC
 tgv12YTK2TwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="206855726"
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="206855726"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 07:18:04 -0700
IronPort-SDR: 1rhyS+hhPOwexxCnXZhmv6wxn+Llf5TDl1/SmHa/GLq44oSzAy+HP57dyLziLG/aUoUMBhtgs6
 ZBJioV+2NSWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="320013816"
Received: from cgheban-mobl.ger.corp.intel.com (HELO localhost) ([10.249.40.199])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jun 2020 07:17:51 -0700
Date:   Fri, 26 Jun 2020 17:17:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20200626141750.GB390691@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200625185334.GN20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625185334.GN20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 08:53:34PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> 
> > Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
> 					 ^
> 					 Add

I'll change it to "Add SGX enclave driver".

> 
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the SGX hosted software entity is disallowed to
> > access the memory inside the enclave enforced by the CPU. We call these
> > entities as enclaves.
> 
> s/as //
> 
> > This commit implements a driver that provides an ioctl API to construct
> 
> s/This commit implements/Implement/
> 
> > and run enclaves. Enclaves are constructed from pages residing in
> > reserved physical memory areas. The contents of these pages can only be
> > accessed when they are mapped as part of an enclave, by a hardware
> > thread running inside the enclave.
> > 
> > The starting state of an enclave consists of a fixed measured set of
> > pages that are copied to the EPC during the construction process by
> > using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> > that defines the enclave properties.
> > 
> > Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and
> 
> Enclaves
> 
> > EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> > the EPC and EINIT check a given signed measurement and moves the enclave
> 
> 		   checks
> 
> > into a state ready for execution.
> > 
> > An initialized enclave can only be accessed through special Thread Control
> > Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
> > function converts a thread into enclave mode and continues the execution in
> > the offset defined by the TCS provided to EENTER. An enclave is exited
> > through syscall, exception, interrupts or by explicitly calling another
> > ENCLU leaf EEXIT.
> > 
> > The permissions, which enclave page is added will set the limit for maximum
> > permissions that can be set for mmap() and mprotect().
> 
> I can't parse that sentence.

Neither can I.

> > This will
> > effectively allow to build different security schemes between producers and
> > consumers of enclaves. Later on we can increase granularity with LSM hooks
> > for page addition (i.e. for producers) and mapping of the enclave (i.e. for
> > consumers)

I rephrased the whole paragraph:

"
The mmap() permissions are capped by the contained enclave page
permissions. The mapped areas must also be opaque, i.e. each page address
must contain a page. This logic is implemented in sgx_encl_may_map().
"

> Other than that, nice explanation. I like that in a commit message.
> 
> Thx.

Thank you.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
