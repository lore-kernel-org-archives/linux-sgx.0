Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7E2C433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 16:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABAD207C3
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 16:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgEOQY4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 May 2020 12:24:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:10373 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgEOQY4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 15 May 2020 12:24:56 -0400
IronPort-SDR: wsU01/eh41w/yzzXn/0jig5XKxeuWKrDdE1Xd7pnyxQh26g0fvLg02bDjjLtqcfpHhlFKi+yrB
 KhBFH84RcSGg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 09:24:56 -0700
IronPort-SDR: oiOGs4kdGAkfrgpiXjs4Lu0J9gX6qJWhPUoDgYzrMTbPYfzbsrcbYQ9Olr50+WUDrxFYcjT4/b
 XTVkPOoBnE+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,395,1583222400"; 
   d="scan'208";a="307462542"
Received: from rmfrijns-mobl.ger.corp.intel.com ([10.252.41.136])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 09:24:48 -0700
Message-ID: <85e3304cb3f7bde102bd183d01a282b3b700a285.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr. Greg" <greg@enjellic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Date:   Fri, 15 May 2020 19:24:47 +0300
In-Reply-To: <20200515094230.GA19017@zn.tnic>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <20200426165753.GA11046@wind.enjellic.com>
         <87d07gk24l.fsf@nanos.tec.linutronix.de>
         <20200508190226.GA31465@wind.enjellic.com>
         <20200508195635.GR27052@linux.intel.com>
         <20200514091637.GA25156@wind.enjellic.com>
         <20200514161559.GA15603@linux.intel.com> <20200514162054.GE9266@zn.tnic>
         <666f4c3865fcd92e7d5c8437e69399cb55fb88a9.camel@linux.intel.com>
         <20200515094230.GA19017@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2020-05-15 at 11:42 +0200, Borislav Petkov wrote:
> On Fri, May 15, 2020 at 12:28:54PM +0300, Jarkko Sakkinen wrote:
> > Uh oh, should probably address this. Should I send v31 today with a "nosgx"
> > patch added? Sorry for missing this one :-/
> 
> Not the whole thing - just the one patch as a reply to your thread pls.
> 
> Thx.

OK, cool, thank you.

/Jarkko

