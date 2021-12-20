Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AB6C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Dec 2021 19:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhLTTau (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Dec 2021 14:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhLTTau (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 20 Dec 2021 14:30:50 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CC7C061574
        for <linux-sgx@vger.kernel.org>; Mon, 20 Dec 2021 11:30:49 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6D01A1EC03E3;
        Mon, 20 Dec 2021 20:30:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1640028644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EBSNeu1k3flnbw9llxf5V4ypbAHNJVgfEPk3lZtEWIs=;
        b=X32iW8pUp58p0Cfbsz1NuueCg+/Hk33djvPIU27S02iXKE7Ptn530Bguagf52E3ohg/Wha
        T1h0AFjM96xp3XwlV/iC86KQ/i3EBOfbJ16SnzBTTcgAODjfTV14Xr8BRyvC8sCfgDMsoY
        CmyZhotZWnwP8Pdg+wiOUFw+SCRm/Pw=
Date:   Mon, 20 Dec 2021 20:30:43 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
Message-ID: <YcDZ4++GQN+ODm50@zn.tnic>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211220174640.7542-2-kristen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi wrote:
>  Similar to the core kswapd, ksgxd, is responsible for managing the
>  overcommitment of enclave memory.  If the system runs out of enclave memory,
> -*ksgxd* “swaps” enclave memory to normal memory.
> +*ksgxd* “swaps” enclave memory to normal RAM. This normal RAM is allocated
> +via per enclave shared memory. The shared memory area is not mapped into the
> +enclave or the task mapping it, which makes its memory use opaque - including
> +to the system out of memory killer (OOM). This can be problematic when there
> +are no limits in place on the amount an enclave can allocate.

Problematic how?

The commit message above is talking about what your patch does and that
is kinda clear from the diff. The *why* is really missing. Only that
allusion that it might be problematic in some cases but that's not even
scratching the surface.

> +At boot time, the module parameter "sgx.overcommit_percent" can be used to
> +place a limit on the number of shared memory backing pages that may be
> +allocated, expressed as a percentage of the total number of EPC pages in the
> +system.  A value of 100 is the default, and represents a limit equal to the
> +number of EPC pages in the system. To disable the limit, set
> +sgx.overcommit_percent to -1. The number of backing pages available to
> +enclaves is a global resource. If the system exceeds the number of allowed
> +backing pages in use, the reclaimer will be unable to swap EPC pages to
> +shared memory.

So you're basically putting the burden on the user/sysadmin to
*actually* *know* what percentage is "problematic" and to know what to
supply. I'd bet not very many people would know how much is problematic
and it probably all depends.

So why don't you come up with a sane default, instead, which works in
most cases and set it automatically?

Dunno, maybe some scaled percentage of memory depending on how many
enclaves are run but all up to a sane limit of, say, 90% of total memory
so that there are 10% left for normal system operation.

This way you'll avoid "problematic" and still have some memory left for
other use.

Or something like that.

Adding yet another knob is yuck and the easy way out. And we have waaaay
too many knobs so we should always try to do the automatic thing, if at
all possible.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
