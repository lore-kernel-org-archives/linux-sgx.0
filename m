Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFCCC432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 18:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5219A21D7C
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 18:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="ah771nNP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443167AbfIYSbl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 14:31:41 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37408 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439908AbfIYSbl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 14:31:41 -0400
Received: from zn.tnic (p200300EC2F0BA1001505152129274373.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:a100:1505:1521:2927:4373])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 556EE1EC0819;
        Wed, 25 Sep 2019 20:31:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569436300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3QfFS2ZQFwfxWdjPq1OeHWQJP197ng9zSn2q1XLLNu0=;
        b=ah771nNPSYiOHXMqGtMunD6K5us7xXZR28EuO7un73LDKur3wAxX5o8yNrI8WdbX333A4x
        7bEe1A53mYAxQPkfPutBU/4KZj2UkUtP0ZdEhNJTV4EoEBUdThUdqq2v8vSVpuDd+u39Ym
        Z2dpdYi9fZUcm/0WsfGwtXX0A3jASFc=
Date:   Wed, 25 Sep 2019 20:31:36 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190925183136.GH3891@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190924202210.GC16218@linux.intel.com>
 <20190925085156.GA3891@zn.tnic>
 <20190925171824.GF31852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190925171824.GF31852@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 10:18:24AM -0700, Sean Christopherson wrote:
> Realistically, there will likely be a non-trivial number of systems with
> SGX_LE_WR=0 but SGX enabled.

Well no. We won't support those. I remember very vividly at Tech Days a
couple of years ago where we said we won't support locked down systems.

> Given the number of steps BIOS needs to take to enable SGX, that'd be one
> "inventive" BIOS. :-)

Oh, you have no idea the amount of BIOS shit I've experienced.

> It's inevitable that some systems will lock down the LE hash MSRs, either
> intentionally or due to lack of support for SGX_LE_WR.  The latter is
> probably going to be more common than OEMs intentionally locking the MSRs,
> because some Intel reference BIOSes simply don't support SGX_LE_WR, e.g. I
> have a Coffee Lake SDP that has hardware support for SGX_LC, but the BIOS
> doesn't provide any way to set SGX_LE_WR or leave FEATURE_CONTROL unlocked.

We won't support those too. Nothing changes since a couple of years ago.
We won't support locked down systems and unfinished BIOS systems.

... reading your other mail about KVM...

I guess KVM could be an exception here if people wanna run different
OSes in the guest. IMHO.

For that, though, we should still clear all SGX feature bits in the
host, I'd say, and let the kvm module rediscover everything itself
through CPUID directly and not using *cpu_has*

Why, you ask? Because otherwise users will start asking why do they have
"sgx" in /proc/cpuinfo but they can't run their own enclaves.

But maybe someone has a better idea.

In any case, I think it would be bad idea to show only a subset of
features in /proc/cpuinfo of a locked-down system and have to explain it
to users why they can't do own enclaves.

But again, someone might have a better idea.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
