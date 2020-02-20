Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A873DC11D0C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D3D52467C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgBTSso (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:48:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:46666 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgBTSso (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Feb 2020 13:48:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 10:48:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="436687206"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 20 Feb 2020 10:48:42 -0800
Date:   Thu, 20 Feb 2020 10:48:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jordan Hand <jorhand@linux.microsoft.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200220184842.GE3972@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
 <7738b3cf-fb32-5306-5740-59974444e327@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7738b3cf-fb32-5306-5740-59974444e327@linux.microsoft.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 20, 2020 at 10:33:36AM -0800, Jordan Hand wrote:
> On 2/20/20 10:13 AM, Sean Christopherson wrote:
> > There are essentially two paths we can take:
> > 
> >  1) Exempt EPC pages from RIE during mmap()/mprotect(), i.e. don't add
> >     PROT_EXEC for enclaves.
> > 
> >  2) Punt the issue to userspace.
> > 
> > Option (1) is desirable in some ways:
> > 
> >   - Enclaves will get an executable stack if and only if the loader/creator
> >     intentionally configures it to have an executable stack.
> > 
> >   - Separates enclaves from the personality of the loader.
> > 
> >   - Userspace doesn't have to do anything for the common case of not
> >     wanting an executable stack for its enclaves.
> > 
> > The big down side to (1) is that it'd require an ugly hook in architecture
> > agnostic code.  And arguably, it reduces the overall security of the
> > platform (more below).
> > 
> > For (2), userspace has a few options:
> > 
> >  a) Tell the linker the enclave loader doesn't need RIE, either via a .note
> >     in assembly files or via the global "-z noexecstack" flag.
> > 
> >  b) Spawn a separate process to run/map the enclave if the enclave loader
> >     needs RIE.
> > 
> >  c) Require enclaves to allow PROT_EXEC on all pages.  Note, this is an
> >     absolutely terrible idea and only included for completeness.
> > 
> > As shown by the lack of a mmap()/mprotect() hook in this series to squash
> > RIE, we chose option (2).  Given that enclave loaders are not legacy code
> > and hopefully following decent coding practices, option (2a) should suffice
> > for all loaders.  The security benefit mentioned above is that forcing
> > enclave loaders to squash RIE eliminates an exectuable stack as an attack
> > vector on the loader.
> 
> I see your point and I do agree that there are security benefits to (2a)
> and I think we could do that for our loader. That said, it does concern
> me that this breaks perfectly valid userspace behavior. If a userspace
> process decides to use RIE, I don't know that the SGX driver should
> disobey that decision.
> 
> So option (3) would be to just honor RIE for enclave pages and when page
> permissions are set to PROT_READ in sgx_encl_page_alloc and RIE is set,
> also add PROT_EXEC.

Ah, right, IIRC that idea also came up in our internal discussions.  Note,
SGX would need to implement this option by checking for RIE in
sgx_encl_may_map(), as the process that built the enclave may not be the
same process that is running the enclave.

> I understand your concerns that this using RIE is bad security practice
> and I'm not convinced that (3) is the way to go, but from a philosophy
> perspective I don't know that the kernel should be in the business of
> stopping userspace from doing valid things.
> 
> If option (3) can't/shouldn't be done for some reason, option (1) at
> least keeps from breaking expected userspace behavior. But I do agree
> that (1) is ugly to implement.

My biggest concern for allowing PROT_EXEC if RIE is that it would result
in #PF(SGX) (#GP on Skylake) due to an EPCM violation if the enclave
actually tried to execute from such a page.  This isn't a problem for the
kernel as the fault will be reported cleanly through the vDSO (or get
delivered as a SIGSEGV if the enclave isn't entered through the vDSO), but
it's a bit weird for userspace as userspace will see the #PF(SGX) and
likely assume the EPC was lost, e.g. silently restart the enclave instead
of logging an error that the enclave is broken.
