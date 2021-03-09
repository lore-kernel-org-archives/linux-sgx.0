Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152E0C433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 09:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D787465248
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 09:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCIJa5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Mar 2021 04:30:57 -0500
Received: from mail.skyhub.de ([5.9.137.197]:46334 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhCIJan (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Mar 2021 04:30:43 -0500
Received: from zn.tnic (p200300ec2f0d1e00bc8d79f96d00cad4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1e00:bc8d:79f9:6d00:cad4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 81B131EC0441;
        Tue,  9 Mar 2021 10:30:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615282241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=AwjBg1SGZ+DMhaVHgj+dKPlrpMWCDbhJuAdiSO9uB2o=;
        b=V4yvW0XQdyBpMaS0H1USNwDOMpNctjWOinWuFkmxfNr0dttzOwFZQPn+j29vofVnzP2ibC
        orIlApmAm4WJ/nXoHo/87uM10vC8XhdGcWf2U1poSOJK8oA4yQ5wufZTe3r2M8vWWfOman
        BMXLW6Y+hqPOXZX5sMMKtbJtCy3BxsE=
Date:   Tue, 9 Mar 2021 10:30:37 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
Message-ID: <20210309093037.GA699@zn.tnic>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> This series adds KVM SGX virtualization support. The first 14 patches starting
> with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> support KVM SGX virtualization, while the rest are patches to KVM subsystem.

Ok, I guess I'll queue 1-14 once Sean doesn't find anything
objectionable then give Paolo an immutable commit to base the KVM stuff
ontop.

Unless folks have better suggestions, ofc.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
