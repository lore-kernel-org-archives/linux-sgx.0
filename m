Return-Path: <SRS0=1HHV=63=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E0BC433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 21:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9435F2054F
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 21:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgEMVlJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 May 2020 17:41:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:26954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbgEMVlJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 May 2020 17:41:09 -0400
IronPort-SDR: C5qoFjMAOBoJlznbhAyz9uCQly+/8s2aTYXkcFHstfEWUCzUpxRMrOp/awP4JYc2HmCR0Xx/g1
 KTRMm6XNSX8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 14:41:08 -0700
IronPort-SDR: QDfsqhQI1vfkk52vEz67aeItZEtMsGebv+9WKFWpon6YL437ddc2q7JwZVC//VgPX6bh6DXwe5
 DwWUGDG7bR0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,389,1583222400"; 
   d="scan'208";a="251892299"
Received: from rthurerx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.36.107])
  by fmsmga007.fm.intel.com with ESMTP; 13 May 2020 14:41:01 -0700
Date:   Thu, 14 May 2020 00:40:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 14/20] x86/sgx: ptrace() support for the SGX driver
Message-ID: <20200513214059.GC31974@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200421215316.56503-15-jarkko.sakkinen@linux.intel.com>
 <20200506215048.GJ3329@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506215048.GJ3329@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 06, 2020 at 02:50:48PM -0700, Sean Christopherson wrote:
> On Wed, Apr 22, 2020 at 12:53:10AM +0300, Jarkko Sakkinen wrote:
> > Add VMA callbacks for ptrace() that can be used with debug enclaves.
> > With debug enclaves data can be read and write the memory word at a time
> > by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 88 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 88 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index fe7dbca40bb4..0c5ea2968868 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -326,6 +326,7 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> >  	return 0;
> >  }
> >  
> > +
> 
> Unnecessary whitespace change.

Would not update series just for this. If something else, will fix this
one.

/Jarkko
