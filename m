Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180FDC64E90
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 19:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7928221FC
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Nov 2020 19:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xPSTsPq8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgKQTVM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728984AbgKQTUm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Nov 2020 14:20:42 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F364224248;
        Tue, 17 Nov 2020 19:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605640842;
        bh=AKihFwRJCZZWXGwXaAxY3JSzSDgAj4J55BVPy5dt1CA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xPSTsPq8T7Tkh3Bu/Ey77epGKfsByhCm66mY6AMeRSlmxAoECCrNrYFMETwwlZlmX
         5TbDOcs6VdbFfkvz6xvTuPLnf25Ipot9ADO5FqL+lHlAIsYB5X4em/OYW7dydmiWXZ
         PvNWJ3CjNMRZmjg3ZKzp+HhY9AetZ2ln7PxhQxSA=
Date:   Tue, 17 Nov 2020 21:20:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v41 00/24] Intel SGX foundations
Message-ID: <20201117192033.GC10393@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201116165544.GC1131@zn.tnic>
 <eb8100e8-1439-4dd3-ba7b-68e8919ab5b7@intel.com>
 <20201116172840.GD1131@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116172840.GD1131@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 16, 2020 at 06:28:40PM +0100, Borislav Petkov wrote:
> On Mon, Nov 16, 2020 at 09:21:16AM -0800, Dave Hansen wrote:
> > That works when there is something universal across the set, like if
> > Sean Signed-off-by on each patch and we didn't have any other SoB's.
> > Sean is also mentioned in at least one of five different tags:
> 
> So?
> 
> You git-format-patch, build the CC-list and supply it with --cc-cmd or
> whatever scripting you have and do --suppress-cc=all as the last switch.
> 
> > The bounces aren't the end of the world, they're just annoying.
> 
> And I have to go edit every patch by hand to remove those comments
> again. No, bounces happen all the time and we ignore them simply. Can't
> fix them all.

I'm fine with either way.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
