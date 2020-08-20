Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9764AC433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 15:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727B52075E
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 15:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="SUYH0F/B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHTPbY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 11:31:24 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51070 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgHTPbX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 11:31:23 -0400
Received: from zn.tnic (p200300ec2f0c060044fc628f6f806d19.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:600:44fc:628f:6f80:6d19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2E1271EC0281;
        Thu, 20 Aug 2020 17:31:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1597937481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=54AtJ/Z+1wgzVKTU0mKW+7cYlSiorqqUjGWxJ5bBDmI=;
        b=SUYH0F/BgHK+Zray8T/gBWoF8HjiAYbQa5ZymCVvGslwRo9zc3xIsy7apDyBb/J0JukQ8n
        5HOVja4BXYL+ALUEAWDUFcnD8uUfKEUa3RtvmxDSyWCCwoq/RwsEajIsaSVM/OdBtR4+dg
        2tmax/x94xs2xHeWRU2kdKMvLdNFncM=
Date:   Thu, 20 Aug 2020 17:31:14 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200820153114.GA17271@zn.tnic>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200716135303.276442-4-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 16, 2020 at 04:52:42PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
> a #PF with SGX set happens.
> 
> CPU throws a #PF with the SGX set in the event of Enclave Page Cache Map
> (EPCM) conflict. The EPCM is a CPU-internal table, which describes the
> properties for a enclave page. Enclaves are measured and signed software
> entities, which SGX hosts. [1]
> 
> Although the primary purpose of the EPCM conflict checks  is to prevent
> malicious accesses to an enclave, an illegit access can happen also for
> legit reasons.
> 
> All SGX reserved memory, including EPCM is encrypted with a transient key
> that does not survive from the power transition. Throwing a SIGSEGV allows
> user space software to react when this happens (e.g. recreate the enclave,
> which was invalidated).
> 
> [1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)
> 
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/asm/traps.h | 14 ++++++++------
>  arch/x86/mm/fault.c          | 13 +++++++++++++
>  2 files changed, 21 insertions(+), 6 deletions(-)

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
