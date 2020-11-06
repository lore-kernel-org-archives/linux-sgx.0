Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E055AC2D0A3
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 22:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C7A208C7
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 22:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604700114;
	bh=laNmFX4CdLt/FOLsmbcIZF0mnZLt8LMC0wveAkASVv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=v+gURbXZDMNnAASjcQr+y6iRH1Yc9b2/9AOm3lWvNNxBz/0XicmiO26kP8OHIoVft
	 v9YtomTQ0eGcJN8Cd6sBRfclqGoXhnsOEDruhOJ1Fh4lfmsOTc03fZxk/Jeijxdz4m
	 PzhIRc/5xcaC1haqM23hbjvMmHAD2Ovy/qTTOznk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgKFWBy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgKFWBy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Nov 2020 17:01:54 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D197F2065D;
        Fri,  6 Nov 2020 22:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604700113;
        bh=laNmFX4CdLt/FOLsmbcIZF0mnZLt8LMC0wveAkASVv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNulqwYRmFPdCtgMjr4BZUbJ39TOXb+0HcXSHjMTJTGt34sf8UtzGBvJtgRh0R5Es
         OhuPqNTTkVAde8HHtXg54qMpDE+VzS2tcaN2ARasiF9Shn+HgB2P8GeaKgbcfYlVyi
         QPRyg8ilf/Diq8vPWYZBcrqvHD5h8WY3S6g1hBuI=
Date:   Sat, 7 Nov 2020 00:01:42 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
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
Message-ID: <20201106220142.GA55146@kernel.org>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-12-jarkko.sakkinen@linux.intel.com>
 <20201105011043.GA700495@kernel.org>
 <20201105011615.GA701257@kernel.org>
 <20201105160559.GD25636@zn.tnic>
 <20201105175745.GA15463@kernel.org>
 <20201105181047.GH25636@zn.tnic>
 <20201106160742.GA46523@kernel.org>
 <20201106170920.GF14914@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106170920.GF14914@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 06:09:20PM +0100, Borislav Petkov wrote:
> On Fri, Nov 06, 2020 at 06:07:42PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Nov 05, 2020 at 07:10:47PM +0100, Borislav Petkov wrote:
> > > On Thu, Nov 05, 2020 at 07:57:45PM +0200, Jarkko Sakkinen wrote:
> > > > I'll rather send a full patch set if required.
> > > 
> > > Why if the changes all belong to this patch and why should I take a
> > > patch which clearly needs improving?
> > > 
> > > Just send the fixed version of this and I can take it now.
> > > 
> > > Thx.
> > 
> > Here's an update patch. I kept the name as sgx_encl_find() so and output
> > argument instead of return value, so that the change is localized. I
> > think this is good enough, i.e. the semantically obsolete stuff has been
> > wiped off.
> 
> Thanks.
> 
> > Tested-by: Jethro Beekman <jethro@fortanix.com>
> > Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> > Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> > Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> > Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> > Tested-by: Seth Moore <sethmo@google.com>
> > Tested-by: Darren Kenny <darren.kenny@oracle.com>
> 
> Btw, you do know that when you change the patch, those tested-by's don't
> hold true anymore, right?
> 
> The Reviewed-by's too, actually.
> 
> I'll zap them.

Yes, I know that. That was something that I should have done for this
version. I was too busy turning every rock to make everything as clean
as possible, sorry about that. I'll also update my tree accordingly.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
