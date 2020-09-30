Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3D3C4727E
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 14:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C17D820789
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 14:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgI3OUX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:20:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:7600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgI3OUX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 10:20:23 -0400
IronPort-SDR: KIgm6UQmupe3Qv69+lxENMukT4cQ9oqhBYoQX5I2R48kuPsf8HJt9uWmxXLkIxEjCaAe77XOCX
 Gmta5gHumjZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="226603812"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="226603812"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 07:20:23 -0700
IronPort-SDR: J96EtW2FG0A9rJZLfOopN5pOeqG7gL0dISlieEMwC/ZkIvxp4RUQNHiArgL1oHD63PCw4SOqgY
 7vgSCXrVxICg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="497738180"
Received: from geigerri-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.47])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 07:20:20 -0700
Date:   Wed, 30 Sep 2020 17:20:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Message-ID: <20200930142017.GA49393@linux.intel.com>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 07:08:58AM -0700, Dave Hansen wrote:
> On 9/30/20 7:01 AM, Jarkko Sakkinen wrote:
> > The user handler, which can be optionally used to handle enclave
> > exceptions, is always the same global handler provided by the SGX
> > runtime, who wants to use such a handler instead returning on exception.
> > 
> > Thus, there is no any non-deterministic branch prediction happening.
> > The code path is always the same and never change. Obviously, you could
> > change it all the time purposely but for any sane real-world use that
> > would not make any sense.
> 
> The fundamental problem mitigated by retpolines is that indirect branch
>  instructions themselves are non-deterministic (speculatively).
> 
> This:
> 
> > +	call	*%rax
> 
> is an indirect branch instruction.  That leaves me a bit confused since
> the changelog doesn't really match the code.
> 
> Do we care about mitigating Spectre-v2-style attacks for the VDSO's
> indirect calls?

It is yes, my wording was just extremely bad. What I meant to say is
that there is branch prediction happening but it is, given how runtime
will use the handler, leading always unconditionally to the same
destination.

I asked does this have any bad mitigations yesterday:

https://lkml.org/lkml/2020/9/29/2505

I'm not expert on Spectre, or any sort of security researcher, but I've
read a few papers about and understand the general concept. With the
constraints how the callback is used in practice, I'd *guess* it is
fine to drop retpoline but I really need some feedback on this from
people who understand these attacks better.

I'll submit a patch with boot time patching (aka using ALTERNATE) if
this does not get the buy-in. Just have to evaluate the both options
before making any decisions.

/Jarkko
