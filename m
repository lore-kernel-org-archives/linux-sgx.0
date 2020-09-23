Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EA7C2D0A8
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37F94221F0
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 13:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgIWNVC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:21:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:51334 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWNVC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 09:21:02 -0400
IronPort-SDR: yfha8BQq5SAmxsNtRi9kR0BRV6CB9JJEPXbCBbLpeZrdF846djoNyApYu0UCiux9qa5ml4oWXZ
 UFUhMxRcnr2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="148536324"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148536324"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 06:21:01 -0700
IronPort-SDR: RrOeYneMNxGRx1oRtDH0k7xV9+XCUs84mR9G1Ixu7FmWaEDXG8D1JNxrgdvbWwsd9nuCSey4GK
 bTFoOmDn+0pA==
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486439488"
Received: from ichiojdo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.51.82])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 06:20:51 -0700
Date:   Wed, 23 Sep 2020 16:20:49 +0300
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
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
Message-ID: <20200923132037.GA5160@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
 <20200922154424.GL22660@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922154424.GL22660@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 05:44:24PM +0200, Borislav Petkov wrote:
> 
> > Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
> 			     ... x86/sgx: Add ptrace() support...
> 
> subject needs a verb.
> 
> On Tue, Sep 15, 2020 at 02:28:35PM +0300, Jarkko Sakkinen wrote:
> > Add VMA callbacks for ptrace() that can be used with debug enclaves.
> > With debug enclaves data can be read and write the memory word at a time
> 
> I think you wanna say here
> 
> "... data can be read and/or written a memory word at a time by using..."

I also fixed the other issues but I'll paste here the rewrite that I did
for the commit message:

"
x86/sgx: Add ptrace() support for the SGX driver

Intel Sofware Guard eXtensions (SGX) allows creation of executable blobs
called enclaves, which cannot be accessed by default when not executing
inside the enclave. Enclaves can be entered by only using predefined memory
addresses, which are defined the enclave is loaded.

However, enclaves can defined as debug enclaves during the load time. In
debug enclaves data can be read and/or written a memory word at a time by
using by using ENCLS[EDBGRD] and ENCLS[EDBGWR] leaf instructions.

Add 'access' implementation to vm_ops with the help of these functions.
This allows to use ptrace() with debug enclaves.
"

I also think that mm CC would make sense also for this patch.

/Jarkko
