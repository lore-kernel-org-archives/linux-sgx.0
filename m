Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350EEC433ED
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Apr 2021 09:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D72613C2
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Apr 2021 09:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbhDFJJU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Apr 2021 05:09:20 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51016 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240594AbhDFJJQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Apr 2021 05:09:16 -0400
Received: from zn.tnic (p200300ec2f0a0d00691dbdb0de837383.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:691d:bdb0:de83:7383])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 825781EC01B5;
        Tue,  6 Apr 2021 11:09:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617700143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Qa0a6ab+QxcVVwxQ8YwF9KmRYF6h64yneFdpQwu0kw4=;
        b=BUFK03LZcwy//hNig/HyM/DtzMWPStNUrstmHcRMMU7yMV0dB5p2p8K0UCj6S1sol/MGKO
        xGYWORxVLmPLpRRsTKY/n+eM2nULpjtP86qnL/Vh/cSY/sbGGleIo+c/6a/4sP+hSDpqDK
        6AXhxV8VfccRc/x5xOj5h3k+TjAaYsU=
Date:   Tue, 6 Apr 2021 11:09:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <20210406090901.GH17806@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
 <20210405090759.GB19485@zn.tnic>
 <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
 <20210406073917.GA17806@zn.tnic>
 <20210406205958.084147e365d04d066e4357c1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406205958.084147e365d04d066e4357c1@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 06, 2021 at 08:59:58PM +1200, Kai Huang wrote:
> OK. My thinking was that, returning negative error value basically means guest
> will be killed.

You need to define how you're going to handle invalid input from the
guest. If that guest is considered malicious, then sure, killing it
makes sense.

> For the case access_ok() fails for @secs or other user pointers, it
> seems killing guest is a little it overkill,

So don't kill it then - just don't allow it to create an enclave because
it is doing stupid crap.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
