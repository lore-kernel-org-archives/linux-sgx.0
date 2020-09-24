Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BA9C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 16:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50197238E3
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 16:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="l737tOpB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgIXQbg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXQbf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 24 Sep 2020 12:31:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35D2C0613CE;
        Thu, 24 Sep 2020 09:31:35 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c950018c19313925c730a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:9500:18c1:9313:925c:730a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 26BA81EC0469;
        Thu, 24 Sep 2020 18:31:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600965094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Wyic6RS8dnxuPl9A3GuZuq4BV1OsZd9ESbttja8eKEE=;
        b=l737tOpBpD/V+sYHc+UbPMpWBhNrCvZuUTwN9dgzCEFfYTpJca29PDR0IkjMj//nBl0l18
        /EOgjw8oCmnPEU53HI1xAZWQhyRDGubc6JavDu/5qGDV1lZdHO6cYkF+ri0eQIV/PYEajV
        97+Gd89uv9ly2gsHERD+TFzz4ShQW0A=
Date:   Thu, 24 Sep 2020 18:31:28 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 20/24] x86/traps: Attempt to fixup exceptions in vDSO
 before signaling
Message-ID: <20200924163128.GM5030@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-21-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-21-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:38PM +0300, Jarkko Sakkinen wrote:
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9e5ec861aba0..ebe290a68c36 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -30,6 +30,7 @@
>  #include <asm/cpu_entry_area.h>		/* exception stack		*/
>  #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
>  #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
> +#include <asm/vdso.h>			/* fixup_vdso_exception()	*/
>  
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/exceptions.h>
> @@ -775,6 +776,10 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
>  
>  		sanitize_error_code(address, &error_code);
>  
> +		if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code,
> +		    address))

No need to break that line.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
