Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC310C4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 21:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6544122D07
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 21:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgLOVhz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 16:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730925AbgLOVht (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Dec 2020 16:37:49 -0500
Date:   Tue, 15 Dec 2020 23:35:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608068122;
        bh=daQ7JY6RGAinkPHSEdtUu/joFw7XtCW9w4kbcG7I978=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=KuRH7cU+01g2lLwopcJkGnjGD2697P2LEYQ8b19K4VIsz976zjHLqwh6YGVnM6/RJ
         tCN2UkH1sSOqIM+vudhyF5kI0GSjqRbcIey22k63GKu/KzWKyEsFELCKieulPvts8P
         dZXqqbHXO0Z1w5dT0CFbsgS69pB/fRMf54SpA2M+x/L9MFXogQLeeSdGo6ZClXpgz4
         YNLSEfp79j+5qbUGfFMX2Pp7BBje09ML9+DRM5kmQnRREiBi0V6sThk1r3RIqF4kZz
         yPvJ4/8P4jcaNF3u3kzaoKjcFTDcTUlukjvf3su4bP2IWWOZvns0N/TTS0TdwRZh1b
         UHatDNUqtQIRA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20201215213517.GA34761@kernel.org>
References: <20201211113230.28909-1-jarkko@kernel.org>
 <X9e2jOWz1hfXVpQ5@google.com>
 <20201215055556.GA28278@kernel.org>
 <20201215055955.GA28511@kernel.org>
 <op.0vogfzwvwjvjmi@fgctuval.land.test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0vogfzwvwjvjmi@fgctuval.land.test>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 15, 2020 at 11:34:37AM -0600, Haitao Huang wrote:
> On Mon, 14 Dec 2020 23:59:55 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> > On Tue, Dec 15, 2020 at 07:56:01AM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Dec 14, 2020 at 11:01:32AM -0800, Sean Christopherson wrote:
> > > > On Fri, Dec 11, 2020, Jarkko Sakkinen wrote:
> > > > > Each sgx_mmun_notifier_release() starts a grace period, which
> > > means that
> > > >
> > > > Should be sgx_mmu_notifier_release(), here and in the comment.
> > > 
> > > Thanks.
> > > 
> > > > > one extra synchronize_rcu() in sgx_encl_release(). Add it there.
> > > > >
> > > > > sgx_release() has the loop that drains the list but with bad
> > > luck the
> > > > > entry is already gone from the list before that loop processes it.
> > > >
> > > > Why not include the actual analysis that "proves" the bug?  The
> > > splat that
> > > > Haitao reported would also be useful info.
> > > 
> > > True. I can include a snippet of dmesg to the commit message.
> > > 
> > > > > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > > > > Cc: Borislav Petkov <bp@alien8.de>
> > > > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > > > Reported-by: Sean Christopherson <seanjc@google.com>
> > > >
> > > > Haitao reported the bug, and for all intents and purposes provided
> > > the fix.  I
> > > > just did the analysis to verify that there was a legitimate bug
> > > and that the
> > > > synchronization in sgx_encl_release() was indeed necessary.
> > > 
> > > Good and valid point. The way I see it, the tags should be:
> > > 
> > > Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > Haitao pointed out the bug but from your analysis I could resolve that
> > > this is the fix to implement, and was able to write the long
> > > description for the commit.
> > > 
> > > Does this make sense to you?
> > 
> > I'm sending v2 next week (this week on vacation).
> > 
> > /Jarkko
> 
> I don't mind either how tags are assigned. But our testing reveals
> significant latency introduced in scenarios of heavy loading/unloading
> enclaves. synchronize_srcu_expedited fixed the issue. Please analyze and
> confirm if that's more appropriate than synchronize_srcu here.

I don't see any obvious reason why *_expedited could not be used here,
as most of the time sync's are taken care of sgx_release() loop, and the
final sync is with sgx_mmu_notifier_release(). More aggressive spinning
should not do any harm here.

About the tags. I just try to get them right, and it is sometimes not
straight-forward. So I guess, with all things considered, I'll put
suggested-by from you. Once I get a refined patch out, try it out with
your workloads and provide me tested-by, if it is working for you.

/Jarkko
