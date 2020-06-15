Return-Path: <SRS0=pBxd=74=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEAFC433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jun 2020 20:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E27207DD
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jun 2020 20:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgFOUHT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Jun 2020 16:07:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:10010 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729845AbgFOUHS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Jun 2020 16:07:18 -0400
IronPort-SDR: tvXHvZmh0d72dieinYRSAQZ9fmwJPmdwdDhIwcfhKHZD5khuvwis1u4toWAkOrns/Sl+Gtjrz3
 3mIw/Ta5mniQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 13:07:18 -0700
IronPort-SDR: 846do83smGTs/PwcvEetzFmsqMXtHXsa96DddxQjSJtGJB6NofKh5Cjw8F88Kriwe4FrcRD7SN
 lnnUbxUEppew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,516,1583222400"; 
   d="scan'208";a="449527601"
Received: from ifaivilx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.251])
  by orsmga005.jf.intel.com with ESMTP; 15 Jun 2020 13:07:05 -0700
Date:   Mon, 15 Jun 2020 23:07:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v32 08/21] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20200615200705.GC5416@linux.intel.com>
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
 <20200601075218.65618-9-jarkko.sakkinen@linux.intel.com>
 <2b95a9c4-c7fc-103c-5bc9-f5d13ce7d897@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b95a9c4-c7fc-103c-5bc9-f5d13ce7d897@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 01, 2020 at 08:15:17AM -0700, Randy Dunlap wrote:
> Hi,
> 
> Sorry I didn't respond to v31 with this so that it could
> have been fixed in v32.

v32 was just a quick update to v31 (did both within maybe 2h window).

> 
> On 6/1/20 12:52 AM, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 2d3f963fd6f1..d246c6071e8d 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1948,6 +1948,22 @@ config X86_INTEL_TSX_MODE_AUTO
> >  	  side channel attacks- equals the tsx=auto command line parameter.
> >  endchoice
> >  
> > +config INTEL_SGX
> > +	bool "Intel SGX"
> > +	depends on X86_64 && CPU_SUP_INTEL
> > +	depends on CRYPTO=y
> > +	depends on CRYPTO_SHA256=y
> > +	select SRCU
> > +	select MMU_NOTIFIER
> > +	help
> > +	  Intel(R) SGX is a set of CPU instructions that can be used by
> > +	  applications to set aside private regions of code and data, referred
> > +	  to as enclaves. An enclave's private memory can only be accessed by
> > +	  code running within the enclave. Accesses from outside the enclave,
> > +	  including other enclaves, are disallowed by hardware.
> 
> Either the prompt
> 	bool "Intel SGX"
> or the help text should tell us what SGX means.
> (Software Guard eXtensions)

Agreed.

> 
> > +
> > +	  If unsure, say N.
> > +
> >  config EFI
> >  	bool "EFI runtime service support"
> >  	depends on ACPI
> 
> thanks.
> -- 
> ~Randy
> 

Thanks for the feedback. I updated https://github.com/jsakkine-intel/linux-sgx.git
accordingly.

/Jarkko
