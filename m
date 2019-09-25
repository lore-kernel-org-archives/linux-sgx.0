Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C251EC432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 17:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E5D3214D9
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 17:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="OXnHUrqw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634178AbfIYR2Q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 13:28:16 -0400
Received: from mail.skyhub.de ([5.9.137.197]:56926 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634177AbfIYR2Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 13:28:16 -0400
Received: from zn.tnic (p200300EC2F0BA100707709EB32B84CF4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:a100:7077:9eb:32b8:4cf4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 91A391EC0A91;
        Wed, 25 Sep 2019 19:28:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569432494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=f5S/bY3WTvdMzJpiB20pTgPtyAu2kxkvYFmDAMgwzaQ=;
        b=OXnHUrqwhPc94OpC7hb7Ih+XlZTC8O1X9YXCL3iiaaTWVjahCMTuXwLTCQD9WEEYiuSv1y
        T0qSwax77qfeRqnxf96T45UU+s73MEKSn27J8EPXABqiIjDvqA+wsixtVo68bAOwkqIA7L
        r7SxswW0nQTUKsJKsFUXB/kZ1jHH+hQ=
Date:   Wed, 25 Sep 2019 19:28:15 +0200
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
Message-ID: <20190925172815.GG3891@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190925140903.GA19638@linux.intel.com>
 <20190925151949.GE3891@zn.tnic>
 <20190925164932.GE31852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190925164932.GE31852@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 09:49:32AM -0700, Sean Christopherson wrote:
> Correct, only X86_FEATURE_SGX_LC is cleared.  The idea is to have SGX_LC
> reflect whether or not flexible launch control is fully enabled, no more
> no less.

So we do not disable SGX when the MSRs are read-only - we disable only
launch control.

> Functionally, this doesn't impact support for native enclaves as the
> driver will refuse to load if SGX_LC=0.

So why aren't we clearing all feature bits then? What's the purpose for
leaving them set if we're not going to support hardcoded OEM vendor hash
in the MSRs anyway?

> Looking forward, this *will* affect KVM.  As proposed, KVM would expose
> SGX to a guest regardless of SGX_LC support.
> 
> https://lkml.kernel.org/r/20190727055214.9282-17-sean.j.christopherson@intel.com

... which would do what exactly? Guests can execute SGX only
when signed by the Intel key, when LC is disabled?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
