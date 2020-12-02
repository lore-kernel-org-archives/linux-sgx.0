Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898D8C71156
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 17:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 330CB2225B
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 17:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbgLBR1r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387594AbgLBR1r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Dec 2020 12:27:47 -0500
Date:   Wed, 2 Dec 2020 19:27:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606930026;
        bh=nOgJqMBakIAzCJTEUHZ2n7On93dGb/6yzNTQjUzTPLM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrLKKz31IjyfmrVHsgLf6iCqb2OAUFlipZA6vf4wWPzA16wRlACPMlNYFd77hkH/P
         /yFFVppCHJwbWYeofStIzz5V7IQgueBoIgg/RDdxK7s63dbEraEGMaztzL8sW7aPvB
         9DjhoCB5dX7lWNcdH0yeK5UGzuLSbTYas95iAstY=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc:     "Alejandro Colomar (mailing lists, readonly)" 
        <alx.mailinglists@gmail.com>, linux-man@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        x86@kernel.org
Subject: Re: [PATCH] sgx.7: New page with overview of Software Guard
 eXtensions (SGX)
Message-ID: <20201202172701.GC91954@kernel.org>
References: <20201202071543.74866-1-jarkko@kernel.org>
 <f6eb74cf-0cb6-0549-9ed3-3e3b2af23ad1@gmail.com>
 <c698b115-2daa-c92b-da92-abe261a37222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c698b115-2daa-c92b-da92-abe261a37222@gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 02, 2020 at 03:20:09PM +0100, Michael Kerrisk (man-pages) wrote:
> Hi Jarkko,
> 
> By the way, is this feature already merged into the kernel? (It
> appears not.)

No, it's not yet. Right now it's sitting in x86 tip master branch. I
thought that this is a good time to start preparing a man page given
that it's nearing completion, and also because writing man pages is new
territory for me.

I should have remarked this in the commit message. Sorry about that.

/Jarkko
