Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F24C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 19:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7639161168
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 19:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhDBTUG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 15:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhDBTUF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Apr 2021 15:20:05 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DFCC0613E6;
        Fri,  2 Apr 2021 12:20:04 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a2000165287017d4f49d2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:1652:8701:7d4f:49d2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E6F1B1EC04C2;
        Fri,  2 Apr 2021 21:19:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617391200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=BBb1WFTTL1Y0lhiyA/54Ap1qMu86ye47+4aQrqQz0uk=;
        b=VR1KOLwAW2D5e1sm93ntpGCzVUxIwm1OAZV4s4hwIN2+KprPvS3OkXNSV38pTBfNgWxYM5
        nmkRIND+04d00MEqJsH40catVPs4tkph7ePmokb769pAs1f8/gHkHW0aC5e7VzSLWf1p0+
        KJBWUTzzu5wWrgOoNVezgSgJXI914sA=
Date:   Fri, 2 Apr 2021 21:19:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <20210402191946.GL28499@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
 <20210402094816.GC28499@zn.tnic>
 <YGc7ezLWEu/ZvUOu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGc7ezLWEu/ZvUOu@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 02, 2021 at 03:42:51PM +0000, Sean Christopherson wrote:
> Nope!  That's wrong, as sgx_epc_init() will not be called if sgx_drv_init()
> succeeds.  And writing it as "if (sgx_drv_init() || sgx_vepc_init())" is also
> wrong since that would kill SGX when one of the drivers is alive and well.

Bah, right you are.

How about:

	/* Error out only if both fail to initialize. */
        ret = sgx_drv_init();

        if (sgx_vepc_init() && ret)
                goto err_kthread;

And yah, this looks strange so it needs the comment to explain what's
going on here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
