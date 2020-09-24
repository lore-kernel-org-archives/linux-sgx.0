Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B0FC4346E
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 23:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403DD2344C
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 23:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgIXXL3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 19:11:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:43845 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgIXXL3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 19:11:29 -0400
IronPort-SDR: 9Hc2pzNECPv5G4I4WAX65G5tO+9UlmZ4HaNrWtbQwd0RxOiSQNNrQ1Hwh+JkAHL5k87BMerV4l
 1x9tZQcQb1oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="141385314"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="141385314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 16:11:17 -0700
IronPort-SDR: nDslaICw6OZoGWsFRlqPXAUKCLSwtpovhnuBBMu184OuC61vJMzD3zzeHyIMt+OhfFhj63rwRW
 ZBRKsIhYdScA==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="487166697"
Received: from nspindel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.44.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 16:11:11 -0700
Date:   Fri, 25 Sep 2020 02:11:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 20/24] x86/traps: Attempt to fixup exceptions in vDSO
 before signaling
Message-ID: <20200924231059.GG119995@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-21-jarkko.sakkinen@linux.intel.com>
 <20200924163128.GM5030@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924163128.GM5030@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 06:31:28PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:38PM +0300, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 9e5ec861aba0..ebe290a68c36 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -30,6 +30,7 @@
> >  #include <asm/cpu_entry_area.h>		/* exception stack		*/
> >  #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
> >  #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
> > +#include <asm/vdso.h>			/* fixup_vdso_exception()	*/
> >  
> >  #define CREATE_TRACE_POINTS
> >  #include <asm/trace/exceptions.h>
> > @@ -775,6 +776,10 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
> >  
> >  		sanitize_error_code(address, &error_code);
> >  
> > +		if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code,
> > +		    address))
> 
> No need to break that line.

Thanks, fixed.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
