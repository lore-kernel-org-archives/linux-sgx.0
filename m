Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DB3C433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Jan 2021 10:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E6E23603
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Jan 2021 10:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbhAOKJe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 Jan 2021 05:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbhAOKJe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 15 Jan 2021 05:09:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D6423718;
        Fri, 15 Jan 2021 10:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610705334;
        bh=4bA6GndVt9Ys9vozNIeCGsjW8PrQRcgNiOVY7rhCAYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UFP80eE+AJxfKpDSYZ6r2qNXWVRIClCWSJl0Zq2eg1QNuXiDE1XHWzvXpXYrXkF4E
         EjFv4zFlF9ejcUhEjG4v3Xq57mqFyG8oZWo5VUU55WIpb9hCy/7fjISwScbA1+XVvc
         zA/G8aVmmgqd3d6BZwAgdOOlvsBreU9XHM3eN2Annfh0oomiBMN0zkXrA89of8E8AW
         SJCzL9FI1e6uuWQpV3ugfE2sdHHxyx7+Rq5/V/4nbfD2qlXXWjaiFhx0W4JigrZnKB
         v4mNl67Vbp8agPa3KSJBQndXsNtXnL2FJZuBvOaEuGAfUwwZ+Co/GedJL1jIAeix0x
         CqC6x4gqIfYig==
Date:   Fri, 15 Jan 2021 12:08:48 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Darren Kenny <darren.kenny@oracle.com>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Kees Cook <keescook@chromium.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: fix the return type of sgx_init
Message-ID: <YAFpsK6+4qC04bjF@kernel.org>
References: <20210113232311.277302-1-samitolvanen@google.com>
 <m2zh1bvhsz.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2zh1bvhsz.fsf@oracle.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 14, 2021 at 12:12:12PM +0000, Darren Kenny wrote:
> On Wednesday, 2021-01-13 at 15:23:11 -08, Sami Tolvanen wrote:
> > device_initcall() expects a function of type initcall_t, which returns
> > an integer. Change the signature of sgx_init() to match.
> >
> > Fixes: e7e0545299d8c ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> 
> Makes sense.
> 
> Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

I appended this. Thank you.

/Jarkko
