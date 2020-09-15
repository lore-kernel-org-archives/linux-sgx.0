Return-Path: <SRS0=2CfR=CY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97477C43461
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Sep 2020 14:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5ED206B5
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Sep 2020 14:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="oxJmIBKA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgIOOs5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 10:48:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48840 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbgIOOsT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Sep 2020 10:48:19 -0400
Received: from zn.tnic (p200300ec2f0e4200c97bc9af71f47aca.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:4200:c97b:c9af:71f4:7aca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1684E1EC026F;
        Tue, 15 Sep 2020 16:48:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600181297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kzIa3LNAozBKpiuiMtshbaFLPxPLM7rkc586WIRFP0o=;
        b=oxJmIBKA605d5TRgVFFt2B5x3i5wnVT/SgznoUjCJ73pFAz61cbKgLxjmbAq4JgY/IeQNX
        YVTnL8A3yr1w88tK47eMuiF9zmAF7hX9evQpo5XsSmETf9212S5Ua0cn3uWcsMFtNPFhQ0
        ljwofEGMAJkWnbTy04iLaTCqMI9SF40=
Date:   Tue, 15 Sep 2020 16:48:15 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v37 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200915144815.GL14436@zn.tnic>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
 <20200915095716.GI3612@linux.intel.com>
 <20200915132725.a2qbdio3jsu7rsqs@treble>
 <20200915133929.GI14436@zn.tnic>
 <20200915140250.kf2kgfbgzxfvmoiy@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200915140250.kf2kgfbgzxfvmoiy@treble>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 09:02:50AM -0500, Josh Poimboeuf wrote:
> If you getting them (twice?) and vger's not, it sounds like vger is
> dropping them for some reason.

Yes, this has kinda been the case last and this week, for whatever
reason. From the two v38 submissions, I have only this in my LKML mbox
and it looks like someone is dropping mail...

109127 N C Sep 15           Jarkko Sakkinen ( : 35K|) [PATCH v38 00/24] Intel SGX foundations
109128 N C Sep 15           Jarkko Sakkinen ( : 14K|) ├─>[PATCH v38 04/24] x86/sgx: Add SGX microarchitectural data structures
109129 N C Sep 15           Jarkko Sakkinen ( : 10K|) ├─>[PATCH v38 05/24] x86/sgx: Add wrappers for ENCLS leaf functions
109130 N C Sep 15           Jarkko Sakkinen ( :4.5K|) ├─>[PATCH v38 07/24] x86/cpu/intel: Add nosgx kernel parameter
109131   C Sep 15           Jarkko Sakkinen ( :  60|) ├─>[PATCH v38 10/24] mm: Add vm_ops->mprotect()
109132 N C Sep 15           Jarkko Sakkinen ( : 14K|) ├─>[PATCH v38 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
109133 N C Sep 15           Jarkko Sakkinen ( :9.1K|) ├─>[PATCH v38 15/24] x86/sgx: Enable provisioning for remote attestation
109134 N C Sep 15           Jarkko Sakkinen ( : 15K|) ├─>[PATCH v38 18/24] x86/vdso: Add support for exception fixup in vDSO functions
109135 N C Sep 15           Jarkko Sakkinen ( :5.4K|) ├─>[PATCH v38 19/24] x86/fault: Add helper function to sanitize error code
109136 N C Sep 15           Jarkko Sakkinen ( :7.4K|) ├─>[PATCH v38 20/24] x86/traps: Attempt to fixup exceptions in vDSO before signaling
109137 N C Sep 15           Jarkko Sakkinen ( : 34K|) ├─>[PATCH v38 22/24] selftests/x86: Add a selftest for SGX
109138 N C Sep 15           Jarkko Sakkinen ( : 12K|) ├─>[PATCH v38 23/24] docs: x86/sgx: Document SGX micro architecture and kernel internals
109139 N C Sep 15           Jarkko Sakkinen ( :4.0K|) └─>[PATCH v38 24/24] x86/sgx: Update MAINTAINERS

109147 N C Sep 15           Jarkko Sakkinen ( :5.8K|) ┬─>[PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
109148 N C Sep 15           Jarkko Sakkinen ( :5.4K|) ├─>[PATCH v38 19/24] x86/fault: Add helper function to sanitize error code
109149 N C Sep 15           Jarkko Sakkinen ( :7.4K|) ├─>[PATCH v38 20/24] x86/traps: Attempt to fixup exceptions in vDSO before signaling
109150 N C Sep 15           Jarkko Sakkinen ( : 15K|) ├─>[PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX enclave call
109151 N C Sep 15           Jarkko Sakkinen ( : 12K|) └─>[PATCH v38 23/24] docs: x86/sgx: Document SGX micro architecture and kernel internals

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
