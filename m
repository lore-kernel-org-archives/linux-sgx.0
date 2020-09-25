Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D50BC4727C
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2742020936
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgIYLWJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 07:22:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:33464 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgIYLWI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 07:22:08 -0400
IronPort-SDR: p+K8xe557GJ0N+KoybFzeujBwXJzNkxu2gs+eMegwXvmaXBlr4CvmBt0Ggcm959w5icWAoQG4Q
 W5xmsMOcRnOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="223098903"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="223098903"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:22:08 -0700
IronPort-SDR: RVgYCnDXpS/kjEbVcAk1SEXoqK2sQu4HPShIb/MCHMdJBrYsGgTT0GG4+ewDbCMIKxfe1fQeye
 kh+84xcBuQEA==
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="487431745"
Received: from tjhenson-mobl.amr.corp.intel.com (HELO localhost) ([10.252.48.117])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:22:01 -0700
Date:   Fri, 25 Sep 2020 14:21:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver'
Message-ID: <20200925112159.GE180915@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
 <20200922154424.GL22660@zn.tnic>
 <20200923132037.GA5160@linux.intel.com>
 <20200923161733.GP28545@zn.tnic>
 <20200924115119.GD56811@linux.intel.com>
 <20200924155751.GJ5030@zn.tnic>
 <20200924203859.GD108958@linux.intel.com>
 <20200925075104.GD16872@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925075104.GD16872@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 09:51:04AM +0200, Borislav Petkov wrote:
> On Thu, Sep 24, 2020 at 11:38:59PM +0300, Jarkko Sakkinen wrote:
> > I assume this is a rethorical question
> 
> Of course - our text should not be write-only.
> 
> > and I notice what I suggested
> > looks as bad as my earlier commit message :-)
> > 
> > So, I gave it some thought that and decided to "open code" the paragraph
> > as
> > 
> > "Add sgx_vma_access() function that implements 'access' virtual function
> > of struct vm_operations_struct. Use formentioned leaf instructions to
> 
> "aforementioned"

Ugh, that the was worst spelling I've done for a while.

> > achieve read and write primitives for the enclave memory."
> 
> I'd say "to provide read and write access to enclave memory."

Sound better yes, thanks.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Updated the commit message accordingly. I also rebased now to x86
tip (and yes, merge conflicts were trivial to sort out).

/Jarkko
