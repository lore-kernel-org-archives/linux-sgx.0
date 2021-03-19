Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF940C433C1
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 15:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88AB861931
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 15:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCSPXv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCSPXX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 11:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4E66192B;
        Fri, 19 Mar 2021 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616167403;
        bh=Ist7TXJDo//jARL87z+7k11JeR1R03Sp1atlXSKAzgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wlnbysv+K5E3KxSUNkRMFEEFt8SS7kxaiVPNRn0J1Ie/VMX8/XJZiOvbwHiK22aZd
         NOEr3N7Yn86TbPcV6kANYjxfhZZG1US7k1tplItE6aPf/aGsApjnbZUjWAUm9hXVws
         b1nf5NarQwtZfZwhlptBOJ07EQj4jCl4V/3YQnq34SoKOraL5wsVpN1DFIlxh//k1o
         7c9KuSvrBkUCrHkA/5lLOU8tNe2tTxdZ1Ql4j0wHeoA/jrikVogHKg+uhvd2yiG6af
         GfLSK7dKy9sXV3JgkgCw88ddFRmwFBbWjPdiM1LhQBTcZ2Kw5lZxc/S7OqB+JTQVZf
         L4IeeBUTrO4zQ==
Date:   Fri, 19 Mar 2021 17:22:56 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-ID: <YFTB0HD/4Hc0KvT3@kernel.org>
References: <20210319040602.178558-1-kai.huang@intel.com>
 <20210319084523.GA6251@zn.tnic>
 <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
 <YFS6Of4nnDJR+ZFk@kernel.org>
 <20210319145931.GH6251@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319145931.GH6251@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 19, 2021 at 03:59:31PM +0100, Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 04:50:33PM +0200, Jarkko Sakkinen wrote:
> > > > I was on the verge whether to merge that into the original patch since
> > > > it is the top patch on the branch or create a new one but opted for
> > > > former because this way it won't break bisection and people won't have
> > > > to pay attention whether there's a fix patch to the NUMA patch too, in
> > > > case they wanna backport and whatnot.
> 
> ...
> 
> > I understood Boris' comment that the fixes would not be squashed.
> 
> Please read it again and let me know what about it is not clear. It is
> at the beginning of this mail.

I did misread it for the first time.

So let's sanity: you *are* going to squash the patches together because
that way it's factors easier to backport the whole thing?

Is this the correct understanding?

Fair point, I can cope with that.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

/Jarkko
