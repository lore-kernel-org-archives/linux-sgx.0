Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BC1C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288B6206FA
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405302AbgFYUw2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:52:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:23530 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405069AbgFYUw2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 16:52:28 -0400
IronPort-SDR: SgGlBmvM8bGRNyFxmNxKjSuFY1122AoAsr8mXspTbsBzf/ZZZFhlqE89UvsSwOhtwjE8CwD9C8
 88mBvHCOZAjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="132510021"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="132510021"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 13:52:27 -0700
IronPort-SDR: lhqmeeMU1VKewbxdvhcjxeP7Tu8QvDIAsKbMD9K2MyAwo8Vt35yrHOOPca5e9TddtJyNxYvKXX
 1tbOXQKnCycA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="302123586"
Received: from drews-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.247])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 13:52:18 -0700
Date:   Thu, 25 Jun 2020 23:52:11 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 03/21] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200625205211.GC15394@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-4-jarkko.sakkinen@linux.intel.com>
 <20200625085931.GB20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625085931.GB20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 10:59:31AM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:25AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
> > a #PF with SGX set happens.
> > 
> > CPU throws a #PF with the SGX bit in the event of Enclave Page Cache Map
> 				   ^
> 				   set
> 
> > (EPCM) conflict. The EPCM is a CPU-internal table, which describes the
> > properties for a enclave page. Enclaves are measured and signed software
> > entities, which SGX hosts. [1]
> > 
> > Although the primary purpose of the EPCM conflict checks  is to prevent
> > malicious accesses to an enclave, an illegit access can happen also for
> > legit reasons.
> > 
> > All SGX reserved memory, including EPCM is encrypted with a transient
> > key that does not survive from the power transition. Throwing a SIGSEGV
> > allows user space software react when this happens (e.g. rec-create the
> 			    ^
> 			    to				   recreate
> 
> > enclave, which was invalidated).
> > 
> > [1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
> > 
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/asm/traps.h |  1 +
> >  arch/x86/mm/fault.c          | 13 +++++++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> > index 714b1a30e7b0..ee3617b67bf4 100644
> > --- a/arch/x86/include/asm/traps.h
> > +++ b/arch/x86/include/asm/traps.h
> > @@ -58,5 +58,6 @@ enum x86_pf_error_code {
> >  	X86_PF_RSVD	=		1 << 3,
> >  	X86_PF_INSTR	=		1 << 4,
> >  	X86_PF_PK	=		1 << 5,
> > +	X86_PF_SGX	=		1 << 15,
> 
> Needs to be added to the doc above it.

I ended up with:

 *   bit 5 ==				1: protection keys block access
 *   bit 6 ==				1: inside SGX enclave
 */

/Jarkko
