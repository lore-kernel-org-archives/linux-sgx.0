Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE40EC4361B
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Dec 2020 12:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8155B230FA
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Dec 2020 12:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgLPM0S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Dec 2020 07:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgLPM0Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Dec 2020 07:26:16 -0500
Date:   Wed, 16 Dec 2020 14:25:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608121535;
        bh=t7yfplYMuRYoqsFFzH9PaQsx/k+qdAuQP8arAi9a33Q=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=pN7JJEQFoiwuUvkJWJzVzRGBz/EcOEi2kxDJhHUtegsSm91KqTgggX+5jbIVUSVpC
         w1fn88GuiyppojU6XU6eLsJtSGY4YrmGKx1ENkJIHsh4IeZ62jA2dyfNAy2HUvO8V8
         32Y6hLm2YkYAIMaLWevylU+ONRVYtMLxyQWDEOTw7W72EUiluDUbsINuik0Fj1XQzG
         ZU7SeF25ed5UWGdetcgCmaxm/O9WenuAuqXiZImJrNzOjqiggERhMpKp6j12YuZ8em
         Iw6JwxS9kYIS7LJbb9+U1y/ajnxAE2LPY4+OA1Tp7gXbbdr50ikAWkzartmdy4E5ho
         kThcbSRnOjSkw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20201216122530.GA14421@kernel.org>
References: <20201211113230.28909-1-jarkko@kernel.org>
 <X9e2jOWz1hfXVpQ5@google.com>
 <20201215055556.GA28278@kernel.org>
 <X9ky2n7VcGEGmODx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9ky2n7VcGEGmODx@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 15, 2020 at 02:04:10PM -0800, Sean Christopherson wrote:
> On Tue, Dec 15, 2020, Jarkko Sakkinen wrote:
> > On Mon, Dec 14, 2020 at 11:01:32AM -0800, Sean Christopherson wrote:
> > > Haitao reported the bug, and for all intents and purposes provided the fix.  I
> > > just did the analysis to verify that there was a legitimate bug and that the
> > > synchronization in sgx_encl_release() was indeed necessary.
> > 
> > Good and valid point. The way I see it, the tags should be:
> > 
> > Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > 
> > Haitao pointed out the bug but from your analysis I could resolve that
> > this is the fix to implement, and was able to write the long
> > description for the commit.
> > 
> > Does this make sense to you?
> 
> Yep, works for me.

I'll just add two suggested-by's. Process guide does not forbid that
and it best describes matters.

/Jarkko
