Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1B9C43465
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 13:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E8A20866
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 13:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="aPrbgGc5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgIUNvQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 09:51:16 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37254 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIUNvQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 09:51:16 -0400
X-Greylist: delayed 13631 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 09:51:16 EDT
Received: from zn.tnic (p200300ec2f07e300be7bcf3e7fc25083.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:e300:be7b:cf3e:7fc2:5083])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 68D571EC0350;
        Mon, 21 Sep 2020 15:51:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600696274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TXGxYzaYTYZyuhzUi0yldlks/2ZvxroQx1yLqik1Vw4=;
        b=aPrbgGc5TcixC6fhqyg4myfOG3zNKOi74WHnEnWwB17ooWGZ4vzVrFCADKqOGe7dalPlQq
        Z1IE1r2JlaeumW5tMGfj27CHaXUlGB6ZDw2zBAqPKn97Bl5bvrkI0FETrbFHs5kzARS4IB
        a+5IXIlaq4K8d8PsFuDMoQcZb4tK3KI=
Date:   Mon, 21 Sep 2020 15:51:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200921135107.GG5901@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-13-jarkko.sakkinen@linux.intel.com>
 <20200921100356.GB5901@zn.tnic>
 <20200921122823.GE6038@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921122823.GE6038@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 03:28:23PM +0300, Jarkko Sakkinen wrote:
> Is this appropriate:
> 
> 	/* The extra page in swap space goes to SECS. */
> 	encl_size = secs->size + PAGE_SIZE;
> 
> 	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
> 				   VM_NORESERVE);
> 	if (IS_ERR(backing)) {
> 		ret = PTR_ERR(backing);
> 		goto err_out_shrink;
> 	}
>

Yap, thanks.

> I agree with this but I also think it would make sense to rephrase
> "verifying the correctness of the provided SECS" with something more
> informative.
> 
> I would rephrase as:
> 
> "... after checking that the provided data for SECS meets the expectations
> of ENCLS[ECREATE] for an unitialized enclave and size of the address
> space does not surpass the platform expectations. This validation is
> executed by sgx_validate_secs()."

s/executed/done/

> Is this sufficient for you, or do you have further suggestions?

Yes, no further suggestions.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
