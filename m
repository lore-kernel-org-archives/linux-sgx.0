Return-Path: <SRS0=L3CU=R6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E84C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 05:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B74F72075E
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 05:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbfC0FDJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Mar 2019 01:03:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:38205 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfC0FDJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Mar 2019 01:03:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 22:03:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,275,1549958400"; 
   d="scan'208";a="156137125"
Received: from yannluen-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.254.205])
  by fmsmga004.fm.intel.com with ESMTP; 26 Mar 2019 22:02:59 -0700
Date:   Wed, 27 Mar 2019 07:02:58 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v19,RESEND 16/27] x86/sgx: Add the Linux SGX Enclave
 Driver
Message-ID: <20190327050258.GE15397@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-17-jarkko.sakkinen@linux.intel.com>
 <1553601688.17255.12.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553601688.17255.12.camel@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 26, 2019 at 12:01:31PM +0000, Huang, Kai wrote:
> On Wed, 2019-03-20 at 18:21 +0200, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> > 
> > This commit adds the Linux SGX Enclave Driver that provides an ioctl API
> > to manage enclaves. The address range for an enclave, commonly referred
> > as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
> > mmap() against /dev/sgx. After that a set ioctls is used to build
> > the enclave to the ELRANGE.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> > Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> > Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> >  Documentation/ioctl/ioctl-number.txt    |   1 +
> >  arch/x86/Kconfig                        |  17 +-
> >  arch/x86/include/uapi/asm/sgx.h         |  59 ++
> >  arch/x86/kernel/cpu/sgx/Makefile        |   5 +-
> >  arch/x86/kernel/cpu/sgx/driver/Makefile |   3 +
> >  arch/x86/kernel/cpu/sgx/driver/driver.h |  38 ++
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 795 ++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/driver/main.c   | 290 +++++++++
> >  arch/x86/kernel/cpu/sgx/encl.c          | 358 +++++++++++
> >  arch/x86/kernel/cpu/sgx/encl.h          |  88 +++
> >  arch/x86/kernel/cpu/sgx/encls.c         |   1 +
> >  arch/x86/kernel/cpu/sgx/main.c          |   3 +
> >  arch/x86/kernel/cpu/sgx/sgx.h           |   1 +
> >  13 files changed, 1657 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/x86/include/uapi/asm/sgx.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/Makefile
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/driver.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/main.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
> 
> Shouldn't the driver be located somewhere under drivers/, but not under arch/x86?
> 
> I don't think x86 maintainers should have the burden to review every code change made to SGX driver?

Not sure I got your angle. It is x86 tied code.

$ git grep tristate arch/x86/ | wc -l
22

/Jarkko
