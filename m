Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD1BC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 18:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE41023436
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 18:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbhAMSXL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 13:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbhAMSXL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 13:23:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D339C23436;
        Wed, 13 Jan 2021 18:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610562150;
        bh=iK8AjaaHGIiJ9i+TeVQSPUieb19cZBdeTyeBkfu36ow=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=i+m51nzP9e63eTlV9lipx5hJelgXy/KvB197nbjaxGzLHLhq2r4Ubz1qLCG/hDjGG
         qR1h2yOZTKrrx6hdydA4X4ePWrpMFPsGHIVMBRNgq0m8mj4xxNu9HgjmQxQanIndda
         n7cqcGZy5LNGq2yqYhD4y/jpVVJwgnCAW6BWlScmVMrCUDHTIYTkaVZFXs18kjwABr
         oSPmg8cV56qC6uG3UhQF8J85aHDYXtKStr6kNPZWgeP2r5m7pXOrBAGBvMFfDM/Sty
         P5m2RyFl+ymOKMZVyi7Ij4vfrp6D7atGgSMP/EMjdI/r1HQZofoARKkBotd7SBKw8D
         6KpyVEQXhPbyw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 90F1B3522AC3; Wed, 13 Jan 2021 10:22:30 -0800 (PST)
Date:   Wed, 13 Jan 2021 10:22:30 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20210113182230.GX2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic>
 <X/zoarV7gd/LNo4A@kernel.org>
 <20210112183550.GK13086@zn.tnic>
 <X/8rX1yFxiN79QCn@kernel.org>
 <20210113174602.GV2743@paulmck-ThinkPad-P72>
 <20210113180033.GG16960@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113180033.GG16960@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 13, 2021 at 07:00:33PM +0100, Borislav Petkov wrote:
> On Wed, Jan 13, 2021 at 09:46:02AM -0800, Paul E. McKenney wrote:
> 
> < Lemme trim that mail fat >
> 
> > It seems to me that loading and unloading SGX enclaves qualifies as a
> > configuration operation, so use of synchronize_srcu_expedited() should be
> > just fine in that case.  This of course implies that SGX enclaves should
> > not be loaded or unloaded while an aggressive real-time application
> > is running.  Which might well be the case for other reasons.
> 
> I believe RT and SGX should be orthogonal to each-other unless someone rolls out
> of the woodwork, wanting to run realtime enclaves... Ewww.

I could speculate about an RT workload running on a system that also
ran non-realtime SGX workloads, but who knows?  Stranger things have
happened.  ;-)

							Thanx, Paul
