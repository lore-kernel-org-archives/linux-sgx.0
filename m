Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0F0C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 16:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689BE20775
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 16:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="r7MZdWvF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbgFYQtr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 12:49:47 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48730 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391034AbgFYQtq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 12:49:46 -0400
Received: from zn.tnic (p200300ec2f0ed10035c3b797f40e07e6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:35c3:b797:f40e:7e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EDEBB1EC0103;
        Thu, 25 Jun 2020 18:49:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593103785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zKr+xsUqnBWde4lQVzfFTLrVybIlx5wYc2zlELScPRY=;
        b=r7MZdWvF8Am0McUIxicQadDbNxJdFS4apYHLXB3T7MMSfuEKVUkid4VF66NPuJyu3HD0ZP
        LTBjVApGeJT0w2srFtQJupvVgLGJ7C6E35rrtk/gJ5X9SUtK8f/LaFrDCx0KioUapQDcsy
        mPZM9QDT+Kln2DmfG8lMRcpLES2pg5g=
Date:   Thu, 25 Jun 2020 18:49:39 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20200625164939.GF20319@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-4-jarkko.sakkinen@linux.intel.com>
 <20200625085931.GB20319@zn.tnic>
 <20200625153431.GA3437@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200625153431.GA3437@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 08:34:31AM -0700, Sean Christopherson wrote:
> However, building and running enclaves is complex, and the vast majority of
> SGX enabled applications are expected to leverage a library of one kind or
> another to hand the bulk of the gory details.

I gotta say this rings a bell: dhansen alluded on IRC to the jumping
through hoops one needs to do in order to run SGX enclaves.

...

> The vDSO stuff is in patches 15-18 of this series.
> 
> There's a gigantic thread on all the alternatives that were considered[2].
> 
> [1] https://lkml.kernel.org/r/CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com
> [2] https://lkml.kernel.org/r/CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com

Yeah, that makes it very clear. Thanks a lot for taking the time and
writing it down. I've snipped it for brevity but it is very useful!

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
