Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC6FC433E0
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Jan 2021 22:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B21E82313A
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Jan 2021 22:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbhAFWQN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Jan 2021 17:16:13 -0500
Received: from mail.skyhub.de ([5.9.137.197]:36148 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbhAFWQN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 Jan 2021 17:16:13 -0500
Received: from zn.tnic (p200300ec2f0969000c9608407819d21e.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:6900:c96:840:7819:d21e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7BE61EC04EE;
        Wed,  6 Jan 2021 23:15:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609971331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=W0U8usJzih0juiazb3M3hkDhk8oDReLRTV2GpTPwlqY=;
        b=mSjUdvtEqVO0xwIdI15W6h3jM7e1+VdOfIf85LXiNceOiJcJ4UO9Dg5151nFCshAcpU2co
        j+DFn1PshSMtiqKL90n1yA5YHjCnCKtrdetH0iHb+gNmXcau2HUQn5syHCPJPy13vd/8H2
        tahYneKaA6BZtHv0sn9TE+x5RIiaICs=
Date:   Wed, 6 Jan 2021 23:15:27 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <20210106221527.GB24607@zn.tnic>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 06, 2021 at 02:55:21PM +1300, Kai Huang wrote:
> +/* Intel-defined SGX features, CPUID level 0x00000012:0 (EAX), word 19 */
> +#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */

Is anything else from that leaf going to be added later? Bit 5 is
"supports ENCLV instruction leaves", 6 is ENCLS insn leaves... are those
going to be used in the kernel too eventually?

Rest of them is reserved in the SDM which probably means internal only
for now.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
