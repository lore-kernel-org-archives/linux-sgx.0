Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97167C43461
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCD521941
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgIPUaY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:30:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:41489 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgIPUaS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Sep 2020 16:30:18 -0400
IronPort-SDR: NVsoKvnvCmBOTH/kFD8pm0vq56WMxcQpoAoitFGzcfQxo1kyigIOjozI2Z6YLzOnUi7PZUGoa1
 3QAzrcDhuG/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="147246911"
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="147246911"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 13:30:17 -0700
IronPort-SDR: J/ZiUkDkRxMZ0eZAC8eZeZYHPx/1ZWyZKpPM9Xgi/wQ4MOuUu7vV7EEf273Se9EeqnPm9RTEl8
 4ucdadIBvk8g==
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="452000971"
Received: from scusackx-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.87])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 13:30:10 -0700
Date:   Wed, 16 Sep 2020 23:30:08 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Borislav Petkov <bp@suse.de>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200916203008.GE25541@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-4-jarkko.sakkinen@linux.intel.com>
 <20200916114448.GI2643@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916114448.GI2643@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 16, 2020 at 01:44:48PM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:21PM +0300, Jarkko Sakkinen wrote:
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
> > Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
> > Reviewed-by: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/asm/traps.h | 14 ++++++++------
> 
> The SEV-ES patchset moved that to arch/x86/include/asm/trap_pf.h but
> fixing that up is real easy. Simply do this search-replace
> 
> s!arch/x86/include/asm/traps.h!arch/x86/include/asm/trap_pf.h!
> 
> on this patch.

Hey, I just did

git fetch mainline && git rebase mainline/master

Zero conflicts and there is no trap_pf.h yet. So this is not yet in
Linus' tree?

/Jarkko
