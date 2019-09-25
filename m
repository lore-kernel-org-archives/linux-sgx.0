Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C639C432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 15:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D48A221D7F
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 15:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="MJZLpmUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbfIYPTu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 11:19:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:38494 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfIYPTu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 11:19:50 -0400
Received: from zn.tnic (p200300EC2F0BA100A072A5F5D97AACB9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:a100:a072:a5f5:d97a:acb9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2DBA21EC0416;
        Wed, 25 Sep 2019 17:19:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569424788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lIRklpKdSpXuciM7ok3hLglDdun8vq52/9cpIQ737k0=;
        b=MJZLpmUvhgZlxwdhAxNKJqYc4wVa04bl3UlQOGJKKMtxnMcUtBfvYV8JRR5NMRHV84n2op
        txP7POVSKqjMUHTeD195NAWuMkOB7TxFm3PaWzqzeApsJxO1eE78QJci3uVXm7C4fgpiq+
        xtNvYZR6hCBYqFRzJNOMz4m226JCMyk=
Date:   Wed, 25 Sep 2019 17:19:49 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190925151949.GE3891@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190925140903.GA19638@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190925140903.GA19638@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 05:09:03PM +0300, Jarkko Sakkinen wrote:
> The driver will support only the case where the bit is set i.e. that
> it can freely write to the MSRs MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}.
> It will refuse to initialize otherwise.

See this:

https://lkml.kernel.org/r/20190925085156.GA3891@zn.tnic

AFAICT, when FEATURE_CONTROL_SGX_LE_WR is not set, you're not clearing
all SGX feature bits. But you should, methinks.

> The next version will thus have only my SOB and author information will
> be changed. I doubt anyone will complain if I do that.

Ok.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
