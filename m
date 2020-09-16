Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8515BC43461
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC99D20665
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="WZdSnuQv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgIPUJH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgIPReN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Sep 2020 13:34:13 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5BC0698D6;
        Wed, 16 Sep 2020 04:44:51 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c3e000ee699b54c433a91.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:3e00:ee6:99b5:4c43:3a91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A31221EC0136;
        Wed, 16 Sep 2020 13:44:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600256689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NPzVMHj3XVHq963E2HNb7nFJ33J0AKwoKhJxk7Xuz2M=;
        b=WZdSnuQv5G/ql6BEEZrnr7cd8xh9dzmCiijvQyUtmizQf9eVTzkuUIskLZn0iq2DMUyGCm
        +mqh9VCWUzdcpJFi63w4IbKWRk8a8coABoamUsG1V1jGhCdKQUFypgux0aj1VUXZ5v55l5
        RqLB5j9QElE/Tg0L2iTha0kc+nsM6b4=
Date:   Wed, 16 Sep 2020 13:44:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Borislav Petkov <bp@suse.de>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200916114448.GI2643@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200915112842.897265-4-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:28:21PM +0300, Jarkko Sakkinen wrote:
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
> Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/asm/traps.h | 14 ++++++++------

The SEV-ES patchset moved that to arch/x86/include/asm/trap_pf.h but
fixing that up is real easy. Simply do this search-replace

s!arch/x86/include/asm/traps.h!arch/x86/include/asm/trap_pf.h!

on this patch.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
