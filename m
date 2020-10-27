Return-Path: <SRS0=uhim=EC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41272C83008
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 16:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E09B822258
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 16:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="GojwaP5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801854AbgJ0Pob (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Oct 2020 11:44:31 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40380 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801045AbgJ0Phf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:35 -0400
Received: from zn.tnic (p200300ec2f0dae00b4f0c54a66f17858.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:ae00:b4f0:c54a:66f1:7858])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2E3CB1EC0286;
        Tue, 27 Oct 2020 16:37:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1603813054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+Mz0khoA2HDePr5jB3u1RCURzzcXAN9GwneqwZvpIVA=;
        b=GojwaP5ZPBTydw3a4oSNELmObKrhpqRECU+wksLpzDBfLu0Qncr/mQpm+UOzl1dcRjZjkV
        wTxVxQidE7ch4fDDDfr7SvC/rfX6G2PNuXWSy4KX/Fy4SeUfi7GR6i0Id4DmceeOwp3Xfa
        eLepTFKo0HwnDXVOKd0oUGFPQPFL2Ek=
Date:   Tue, 27 Oct 2020 16:37:27 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, josh@joshtriplett.org, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20201027153727.GI15580@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626153400.GE27151@zn.tnic>
 <1ada871a-2350-1007-c625-a00bdb0d439b@intel.com>
 <20201027100515.GA15580@zn.tnic>
 <d7bee9a1-256b-d4ea-c146-ad353a913ae0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d7bee9a1-256b-d4ea-c146-ad353a913ae0@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 27, 2020 at 08:20:00AM -0700, Dave Hansen wrote:
> I can't think of a *lot* of spots where we have sanity checks like this
> for memory.  We have cgroups and the overcommit limits.  But, in
> general, folks can allocate as much memory as they want until
> allocations start to fail.
>
> Should SGX be any different?
> 
> If we had a sanity check that said, "you can only allocate 1/2 of
> enclave memory", wouldn't that just make somebody mad because they want
> one big enclave?
>
> Or, do you just want a sanity check to see if, up front, the user is
> asking for more enclave memory than there is on the *whole* system?
> That's also sane, but it doesn't take overcommit into account.  That's
> why, for instance, we have vm.overcommit_ratio for normal memory.

Yeah, you're making sense and there's really no need for SGX to be any
different. Especially since users are already familiar the "policy" of
failing allocations when too much memory requested. :-)

> BTW, I think we all agree that a cgroup controller for enclave memory is
> going to be needed eventually.

Right.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
