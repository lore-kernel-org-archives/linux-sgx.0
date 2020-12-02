Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B52C83019
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 16:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 840DE21D81
	for <linux-sgx@archiver.kernel.org>; Wed,  2 Dec 2020 16:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgLBQZY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgLBQZY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 2 Dec 2020 11:25:24 -0500
Date:   Wed, 2 Dec 2020 18:24:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606926283;
        bh=IR2QsgOFqOIz1Qx4n7Emw+Gxybf+6uQBeV594hWetgU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=nVtO0NncsX9v5OONsuj0Dw2Pr5VNTe1nQy64bNQXcEjF3PkDFwLlviuriB5OKH30r
         rUWw5GFn2nMbbcyaOd0iJhZoPRTF9xRJSRx3J8Fhsb9dv4Ee3zdI3I0/hiW8rExwhm
         mmXaJDvrh3LPSxHc3SHxJTXeHof8MFuATVges/tg=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 1/2] asm: sgx.h: fix a typo on a kernel-doc markup
Message-ID: <20201202162437.GA89637@kernel.org>
References: <cover.1606897462.git.mchehab+huawei@kernel.org>
 <ca11a4540d981cbd5f026b6cbc8931aa55654e00.1606897462.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca11a4540d981cbd5f026b6cbc8931aa55654e00.1606897462.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 02, 2020 at 09:27:14AM +0100, Mauro Carvalho Chehab wrote:
> As warned by kernel-doc:
> 	arch/x86/include/uapi/asm/sgx.h:19: warning: expecting prototype for enum sgx_epage_flags. Prototype was for enum sgx_page_flags instead
> 
> There is a typo at the kernel-doc markup:
> 
> 	sgx_epage_flags -> sgx_page_flags
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Thank you.

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko
