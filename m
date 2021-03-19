Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E50FC433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 16:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 104DE61982
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 16:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCSQJ2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhCSQJX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 19 Mar 2021 12:09:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E63C06174A;
        Fri, 19 Mar 2021 09:09:23 -0700 (PDT)
Received: from zn.tnic (p200300ec2f091e0083683e716a2b863f.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:1e00:8368:3e71:6a2b:863f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D11201EC0324;
        Fri, 19 Mar 2021 17:09:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616170161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5dAgGWK+Y2LcvFsD3i6PPcacA8q1iTV8fKgdu0ksepQ=;
        b=Ls2iZgbYCtZyuqFiQX2w6Io6wfCjVuJguLEy5lgYGv8NBZDs8kj0M1M6x0ATzQHB98voAQ
        6ujOLF5A2u6OsXb0Vg2zHnHMNUvOwG6dmcswbbZsoONdUr33j5N00ggmSXn6DWqSMg1HXt
        RnB5pH7yJrRdIEBmFkyCNLLvuXkr+bs=
Date:   Fri, 19 Mar 2021 17:09:20 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <20210319160920.GM6251@zn.tnic>
References: <20210319040602.178558-1-kai.huang@intel.com>
 <20210319084523.GA6251@zn.tnic>
 <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
 <YFS6Of4nnDJR+ZFk@kernel.org>
 <20210319145931.GH6251@zn.tnic>
 <YFTB0HD/4Hc0KvT3@kernel.org>
 <20210319155249.GK6251@zn.tnic>
 <eea239f3-720d-0f53-6c8a-85050f44be53@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eea239f3-720d-0f53-6c8a-85050f44be53@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 08:59:46AM -0700, Dave Hansen wrote:
> It's probably best to squash my patch in.  The uninitialized value could
> *theoretically* cause the search to start at the wrong node and then end
> before every node has been visited.  That could cause premature
> allocation failures.
> 
> But, I seriously doubt anyone will notice either way.

Yeah, I think too that we should be on the safe side, just in case.
Lemme redo the branch with the new changes and test.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
