Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9C5C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 12:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC2182075D
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 12:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCZMlE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:41:04 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:48225 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfCZMlE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 26 Mar 2019 08:41:04 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1h8lNx-0004aM-Ul; Tue, 26 Mar 2019 13:40:58 +0100
Date:   Tue, 26 Mar 2019 13:40:57 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Huang, Kai" <kai.huang@intel.com>
cc:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
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
In-Reply-To: <1553601688.17255.12.camel@intel.com>
Message-ID: <alpine.DEB.2.21.1903261340030.1789@nanos.tec.linutronix.de>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>  <20190320162119.4469-17-jarkko.sakkinen@linux.intel.com> <1553601688.17255.12.camel@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 26 Mar 2019, Huang, Kai wrote:
> On Wed, 2019-03-20 at 18:21 +0200, Jarkko Sakkinen wrote:
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
> I don't think x86 maintainers should have the burden to review every code
> change made to SGX driver?

I rather prefer to have it in x86. Why? Because driver code has a tendency
to get under the radar.

Thanks,

	tglx
