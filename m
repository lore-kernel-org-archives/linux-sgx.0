Return-Path: <SRS0=2S0p=B7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7BEC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Aug 2020 17:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BEEA20658
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Aug 2020 17:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHURfo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:35:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:20504 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgHURfn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Aug 2020 13:35:43 -0400
IronPort-SDR: Kkic0r1b5R9DXC2Mk/tZEdyOGlR+SXYbjWoW4O6+OuX0bpFORn37NHlm/z/3r/VwGMqPniiIPC
 MCbDrTttlWCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="154864475"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="154864475"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:35:43 -0700
IronPort-SDR: klasee6OdksvB3oQshH7S42SYdgGJyZOZcnid5EhxrrFgpCjxmu6F3r4chrX0urt4OvFm5yp7Y
 +TFHumC6YiSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="498598235"
Received: from jjakacki-mobl.ger.corp.intel.com (HELO localhost) ([10.252.52.112])
  by fmsmga005.fm.intel.com with ESMTP; 21 Aug 2020 10:35:37 -0700
Date:   Fri, 21 Aug 2020 20:35:36 +0300
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
Subject: Re: [PATCH v36 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200821173536.GA3559@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-4-jarkko.sakkinen@linux.intel.com>
 <20200820153114.GA17271@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820153114.GA17271@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 20, 2020 at 05:31:14PM +0200, Borislav Petkov wrote:
> On Thu, Jul 16, 2020 at 04:52:42PM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
> > a #PF with SGX set happens.
> > 
> > CPU throws a #PF with the SGX set in the event of Enclave Page Cache Map
> > (EPCM) conflict. The EPCM is a CPU-internal table, which describes the
> > properties for a enclave page. Enclaves are measured and signed software
> > entities, which SGX hosts. [1]
> > 
> > Although the primary purpose of the EPCM conflict checks  is to prevent
> > malicious accesses to an enclave, an illegit access can happen also for
> > legit reasons.
> > 
> > All SGX reserved memory, including EPCM is encrypted with a transient key
> > that does not survive from the power transition. Throwing a SIGSEGV allows
> > user space software to react when this happens (e.g. recreate the enclave,
> > which was invalidated).
> > 
> > [1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
> > 
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/asm/traps.h | 14 ++++++++------
> >  arch/x86/mm/fault.c          | 13 +++++++++++++
> >  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> Reviewed-by: Borislav Petkov <bp@suse.de>

Thank you. Appended to the commit.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
