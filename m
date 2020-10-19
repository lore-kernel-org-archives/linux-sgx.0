Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F59DC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 12:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B31F722276
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 12:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="bOIH3nBN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgJSMjr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:39:47 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52750 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgJSMjr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 08:39:47 -0400
Received: from zn.tnic (p200300ec2f07840035f820c6b6854d62.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:8400:35f8:20c6:b685:4d62])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E824B1EC0494;
        Mon, 19 Oct 2020 14:39:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1603111186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Ap1Rc76hWxQheV4kamlLkzjVJEhQ2FA71JYULFMFfck=;
        b=bOIH3nBNi6Ro34Rwc9tx6498/XMGzfgSK32m1NyK/0BVl4g+lpcTnOThevGvIPbPXcSGMa
        A+1H3eWRtIaIFpWB/GuobNRnI4Zrr1infNALqazBlvxUTdfvuOO5t0RyiJETcIPnun5j4J
        S7+wLYx+LcNQVzPMel1y48h5Mabfc/Q=
Date:   Mon, 19 Oct 2020 14:39:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 08/24] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20201019123934.GA24325@zn.tnic>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-9-jarkko.sakkinen@linux.intel.com>
 <20201019084558.GA1155569@kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201019084558.GA1155569@kapsi.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 11:45:58AM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 03, 2020 at 07:50:43AM +0300, Jarkko Sakkinen wrote:
> > +config INTEL_SGX
> 
> Since the directory for this was renamed some iterations ago from
> arch/x86/kernel/cpu/sgx to intel_sgx given the feedback from Boris,
> I'm wondering should this also be renamed as X86_SGX?

I don't think it matters. I hardly doubt there will be anything else
"SGX" besides the Intel one...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
