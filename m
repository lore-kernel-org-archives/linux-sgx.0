Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F413C433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 18:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 175A121534
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 18:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbhAMSBT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 13:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbhAMSBT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 13 Jan 2021 13:01:19 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B720C061794;
        Wed, 13 Jan 2021 10:00:39 -0800 (PST)
Received: from zn.tnic (p200300ec2f0b5c0053dfdcdd1c139e2a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5c00:53df:dcdd:1c13:9e2a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9CF011EC0423;
        Wed, 13 Jan 2021 19:00:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610560837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7Dl/NntSxZBgafKSC5tYlc12cqcH/Ru336h2E30gX+0=;
        b=VFmaO4SIugKI65nLpw5NA1V/knDkr51kV3BjJfjTE/PKk32vLaiOvUj2wM2QrhG0KBA9Zm
        EBk/I0xXXOZEMSrYlFtHz/sH6XF97B2UrU9vdf+I+vr2rMctiPBme3iBgKDukMjm29laGx
        KqSyJQBi/diYHa6U5YtW73eJUCOsm/c=
Date:   Wed, 13 Jan 2021 19:00:33 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20210113180033.GG16960@zn.tnic>
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic>
 <X/zoarV7gd/LNo4A@kernel.org>
 <20210112183550.GK13086@zn.tnic>
 <X/8rX1yFxiN79QCn@kernel.org>
 <20210113174602.GV2743@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210113174602.GV2743@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 13, 2021 at 09:46:02AM -0800, Paul E. McKenney wrote:

< Lemme trim that mail fat >

> It seems to me that loading and unloading SGX enclaves qualifies as a
> configuration operation, so use of synchronize_srcu_expedited() should be
> just fine in that case.  This of course implies that SGX enclaves should
> not be loaded or unloaded while an aggressive real-time application
> is running.  Which might well be the case for other reasons.

I believe RT and SGX should be orthogonal to each-other unless someone rolls out
of the woodwork, wanting to run realtime enclaves... Ewww.

> So I believe synchronize_srcu_expedited() should be fine in this case.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
