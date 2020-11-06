Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E52BC388F2
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 17:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FF82151B
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 17:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Jr00Am4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKFRJg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 12:09:36 -0500
Received: from mail.skyhub.de ([5.9.137.197]:51778 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgKFRJg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Nov 2020 12:09:36 -0500
Received: from zn.tnic (p200300ec2f0d1f00ad832f6a7d59b60b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1f00:ad83:2f6a:7d59:b60b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7D23F1EC026E;
        Fri,  6 Nov 2020 18:09:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604682574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=FzGOHxgdFFeHelsaYOqNWJeYXANMgxE7EbJYo4EdMas=;
        b=Jr00Am4jjEYCfvPjeuttXSa9t8ii+WUvKkBarHZ3oGbFn484LXogzBd/RIK7s+dCsZ6dij
        8LE1ZMvj/dCTH170wk/IuYwOTuKvltfls4p7vPrrePSLzqzzfO4QwmrZs3aKMrhD0Qrf9z
        pq1/XNFGhI3+ry7Z2mxKsi+4zaXKn1I=
Date:   Fri, 6 Nov 2020 18:09:20 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v40 11/24] x86/sgx: Add SGX misc driver interface
Message-ID: <20201106170920.GF14914@zn.tnic>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-12-jarkko.sakkinen@linux.intel.com>
 <20201105011043.GA700495@kernel.org>
 <20201105011615.GA701257@kernel.org>
 <20201105160559.GD25636@zn.tnic>
 <20201105175745.GA15463@kernel.org>
 <20201105181047.GH25636@zn.tnic>
 <20201106160742.GA46523@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106160742.GA46523@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 06:07:42PM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 05, 2020 at 07:10:47PM +0100, Borislav Petkov wrote:
> > On Thu, Nov 05, 2020 at 07:57:45PM +0200, Jarkko Sakkinen wrote:
> > > I'll rather send a full patch set if required.
> > 
> > Why if the changes all belong to this patch and why should I take a
> > patch which clearly needs improving?
> > 
> > Just send the fixed version of this and I can take it now.
> > 
> > Thx.
> 
> Here's an update patch. I kept the name as sgx_encl_find() so and output
> argument instead of return value, so that the change is localized. I
> think this is good enough, i.e. the semantically obsolete stuff has been
> wiped off.

Thanks.

> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> Tested-by: Seth Moore <sethmo@google.com>
> Tested-by: Darren Kenny <darren.kenny@oracle.com>

Btw, you do know that when you change the patch, those tested-by's don't
hold true anymore, right?

The Reviewed-by's too, actually.

I'll zap them.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
