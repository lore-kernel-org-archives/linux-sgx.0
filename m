Return-Path: <SRS0=4PDp=BX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6624C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Aug 2020 19:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FDD320791
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Aug 2020 19:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgHMTip (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Aug 2020 15:38:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:49393 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgHMTio (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Aug 2020 15:38:44 -0400
IronPort-SDR: /8VVSEtINFwOPBsvCo9HpdrL/w64ZWmE2+6EbKs40dAKAyZGCYnGMnmgsHm3Zzv5soUlF+VoBx
 Zd2q9QNDvSyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="154276590"
X-IronPort-AV: E=Sophos;i="5.76,309,1592895600"; 
   d="scan'208";a="154276590"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 12:38:43 -0700
IronPort-SDR: DzrqYHtiVYVsyOU+gg7XI4CBfhv+F7ihvlSrjxRBmKV5NZwQT11lZZHyixZHyrx8Iww6683MGW
 UZglPogzVZJA==
X-IronPort-AV: E=Sophos;i="5.76,309,1592895600"; 
   d="scan'208";a="470336080"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 12:38:43 -0700
Date:   Thu, 13 Aug 2020 12:38:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200813193842.GV29439@linux.intel.com>
References: <DD7996A6-CBA3-47CE-8DF2-9A6ADD3FE89E@amacapital.net>
 <C107C4D3-1730-41BA-960C-C75B32DB43A0@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C107C4D3-1730-41BA-960C-C75B32DB43A0@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 11, 2020 at 08:16:54AM -0700, Andy Lutomirski wrote:
> 
> > On Aug 10, 2020, at 5:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > 
> > ﻿
> >>> On Aug 10, 2020, at 4:48 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >>> 
> >>> ﻿On Mon, Aug 10, 2020 at 04:08:46PM -0700, Andy Lutomirski wrote:
> >>> What am I missing?  I still don't really understand why we are
> >>> supporting this mechanism at all.  Just the asm code to invoke the
> >>> callback seems to be about half of the entire function.
> >> 
> >> Because the Intel SDK (and other SDKs?) wants to use the host stack to pass
> >> parameters out of the enclave.
> > 
> > Ugh, right.  I forgot about that particular abomination.
> > 
> > I suppose that passing a context pointer would be reasonable.
> 
> The alternative would be to pass in a parameter that gets put in RSP before
> entering the enclave. The idea is that the untrusted runtime would allocate a
> couple pages with guard pages at either end, and enclaves using the
> regrettable arguments-on-the-stack scheme would end up using the alternative
> stack.
> 
> At the end of the day, none of this really matters too much. Languages that
> can do inline asm but can’t do container_of() can get fixed or use
> workarounds.

So, is your "official" opinion

   Go update the vDSO to allow passing an arbitrary pointer.

or

   Eh, don't bother.
