Return-Path: <SRS0=1HHV=63=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C75C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 22:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29C12205ED
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 22:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbgEMWS1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 May 2020 18:18:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:9664 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgEMWS1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 May 2020 18:18:27 -0400
IronPort-SDR: CWgkqGhp1RKHa+TVaVwKjZnst4UvE60D9dKFDWqxpTOh0WHyqo04ajRxhhsZzNAw+M+13Hyu/j
 hRrIFdlGD4Fw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 15:18:27 -0700
IronPort-SDR: iVxvhh4s5lHVai+3URZhj2lSdk9TOFyUp6at13bDpJoEKtrMJwy9rUVBWHPVBLpQ2RYdmkOgpc
 1Xq6wEGIQFIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,389,1583222400"; 
   d="scan'208";a="287186253"
Received: from rthurerx-mobl.ger.corp.intel.com ([10.249.36.107])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2020 15:18:19 -0700
Message-ID: <4bd7d47ef5478023dc27323fb2d6a7b2d7879787.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Date:   Thu, 14 May 2020 01:18:18 +0300
In-Reply-To: <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
         <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2020-05-14 at 01:14 +0300, Jarkko Sakkinen wrote:
> On Wed, 2020-05-06 at 17:42 -0400, Nathaniel McCallum wrote:
> > Tested on Enarx. This requires a patch[0] for v29 support.
> > 
> > Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> 
> Thank you. Update in my tree.
> 
> Sean, I'll fixed that whitespace issue too in my tree.
> 
> General question: maybe it would be easiest that I issue a pull request
> once everyone feels that the series is ready to be pulled and stop sending
> new versions of the series?

My honest feelings about the series ATM are:

1. It is not perfect like no code never is and there are always issues.
2. Some things are very well matured, even more so than in a lot of mainline
   code I've seen. I'm particularly happy how the locking code has been
   converged.
3. Not worried to maintain the code in its current state. It is manageable.

/Jarkko

