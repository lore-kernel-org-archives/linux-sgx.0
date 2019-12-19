Return-Path: <SRS0=bk6Q=2J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347FBC43603
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 00:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01A5522314
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 00:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfLSAjH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:39:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:56776 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfLSAjH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Dec 2019 19:39:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 16:39:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="228070707"
Received: from jtreacy-mobl1.ger.corp.intel.com ([10.251.82.127])
  by orsmga002.jf.intel.com with ESMTP; 18 Dec 2019 16:39:00 -0800
Message-ID: <dd33820c8874f8e4c7628243e0583a419be7fed4.camel@linux.intel.com>
Subject: Re: [PATCH v24 06/24] x86/sgx: Add wrappers for ENCLS leaf functions
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Date:   Thu, 19 Dec 2019 02:39:00 +0200
In-Reply-To: <20191217144548.GF28788@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
         <20191129231326.18076-7-jarkko.sakkinen@linux.intel.com>
         <20191217144548.GF28788@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2019-12-17 at 15:45 +0100, Borislav Petkov wrote:
> On Sat, Nov 30, 2019 at 01:13:08AM +0200, Jarkko Sakkinen wrote:
> > +/**
> > + * encls_failed() - Check if an ENCLS leaf function failed
> > + * @ret:	the return value of an ENCLS leaf function call
> > + *
> > + * Check if an ENCLS leaf function failed. This happens when the leaf function
> > + * causes a fault that is not caused by an EPCM conflict or when the leaf
> > + * function returns a non-zero value.
> > + */
> > +static inline bool encls_failed(int ret)
> > +{
> > +	int epcm_trapnr =
> > +		boot_cpu_has(X86_FEATURE_SGX2) ? X86_TRAP_PF : X86_TRAP_GP;
> > +	bool fault = ret & ENCLS_FAULT_FLAG;
> > +
> > +	return (fault && ENCLS_TRAPNR(ret) != epcm_trapnr) || (!fault && ret);
> > +}
> 
> Can we make this function more readable?
> 
> static inline bool encls_failed(int ret)
> {
>         int epcm_trapnr;
> 
>         if (boot_cpu_has(X86_FEATURE_SGX2))
>                 epcm_trapnr = X86_TRAP_PF;
>         else
>                 epcm_trapnr = X86_TRAP_GP;
> 
>         if (ret & ENCLS_FAULT_FLAG)
>                 return ENCLS_TRAPNR(ret) != epcm_trapnr;
> 
>         return !!ret;
> }
> 
> I hope I've converted it correctly but I might've missed some corner
> case...
> 
> Thx.

Absolutely. I absolutely hate too "clever code".

/Jarkko

