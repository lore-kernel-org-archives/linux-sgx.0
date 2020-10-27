Return-Path: <SRS0=uhim=EC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5EBC55179
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 10:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA162225C
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 10:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="JOIotLan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437230AbgJ0KFb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Oct 2020 06:05:31 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41170 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896062AbgJ0KF2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Oct 2020 06:05:28 -0400
Received: from zn.tnic (p200300ec2f0dae00bd0b3d5f265e51fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:ae00:bd0b:3d5f:265e:51fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 31B591EC02D2;
        Tue, 27 Oct 2020 11:05:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1603793122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oy9OJv4Ilp2FbiIIfueFPPqXC41PLYQruI/S1Nee75g=;
        b=JOIotLanp8LQC81i6KLOL7OPwsvB6Ipaf6g2wcUL//ENzojc9Ei2180xRAPlgltTWMhf6U
        smKBTdNcj9G+kieuQ/+1kgtqrHzVE1egMdrJKjDSTW2hmYyyPMde6bgz51dblA8d7zEYhq
        naAgnvInCGouvjein6HyDNd618O5nCE=
Date:   Tue, 27 Oct 2020 11:05:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, josh@joshtriplett.org, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20201027100515.GA15580@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626153400.GE27151@zn.tnic>
 <1ada871a-2350-1007-c625-a00bdb0d439b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1ada871a-2350-1007-c625-a00bdb0d439b@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 26, 2020 at 02:26:13PM -0700, Dave Hansen wrote:
> What were you concerned about here?  Was it how long the syscall could
> take, or that one user could exhaust all the enclave memory in one call?

More the latter. And generally, to have a sanity-check on all requests
coming from luserspace.

> Some later versions of this patch have a 1MB limit per to reduce how
> long each SGX_IOC_ENCLAVE_ADD_PAGES call spends in the kernel.  But, I'm
> not _sure_ that's what you were intending.

Yeah, that was not my main goal - rather to sanity-check user input and
impose a sane limit.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
