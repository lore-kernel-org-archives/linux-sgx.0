Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51091C2BB9A
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 05:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D51E20791
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 05:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgLOF4v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 00:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgLOF4m (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Dec 2020 00:56:42 -0500
Date:   Tue, 15 Dec 2020 07:55:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608011761;
        bh=29DhGnONxd3yOTjMJ+gkCB6gIxRn2Yv71AJpDeVqDXs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=rqB9tWg6o/Aejc5yFI3FCsc0OI48RWQX2KjbpbgB8ti14i5UeH1/vSSut2AQ4rpJa
         WlAHIBK9+AUsQXELV4ERIyd8WH0odau0/f3H4kKabpLQYFbASM5VYDSCIiz8TWgsGP
         aoCO6K/nIHPImw4lJhzb6KEPvthlwXAbK1ndVbHsBkvnDJ5nov72EvhEOm/MSUm+8D
         7dHdai9qltW2R4us+T6xK/1BwBpo4t//RUIzBZRoWhrT9RU0gRsZdcq3nkjeh85AAO
         GnaxpXZTnrT3AO9mvIdYjeRTR5agD8aZLBlx5XYfhBvJRGV0RFCK/Fm4MyzvGICheJ
         nsGliDfFeGHhw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20201215055556.GA28278@kernel.org>
References: <20201211113230.28909-1-jarkko@kernel.org>
 <X9e2jOWz1hfXVpQ5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9e2jOWz1hfXVpQ5@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 14, 2020 at 11:01:32AM -0800, Sean Christopherson wrote:
> On Fri, Dec 11, 2020, Jarkko Sakkinen wrote:
> > Each sgx_mmun_notifier_release() starts a grace period, which means that
> 
> Should be sgx_mmu_notifier_release(), here and in the comment.

Thanks.

> > one extra synchronize_rcu() in sgx_encl_release(). Add it there.
> > 
> > sgx_release() has the loop that drains the list but with bad luck the
> > entry is already gone from the list before that loop processes it.
> 
> Why not include the actual analysis that "proves" the bug?  The splat that
> Haitao reported would also be useful info.

True. I can include a snippet of dmesg to the commit message.

> > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Reported-by: Sean Christopherson <seanjc@google.com>
> 
> Haitao reported the bug, and for all intents and purposes provided the fix.  I
> just did the analysis to verify that there was a legitimate bug and that the
> synchronization in sgx_encl_release() was indeed necessary.

Good and valid point. The way I see it, the tags should be:

Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>

Haitao pointed out the bug but from your analysis I could resolve that
this is the fix to implement, and was able to write the long
description for the commit.

Does this make sense to you?

/Jarkko
