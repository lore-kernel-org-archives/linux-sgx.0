Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F5CC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 07:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AB2921721
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 07:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="euxJ+Yol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfJHHS7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:18:59 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39400 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730057AbfJHHS6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 03:18:58 -0400
Received: from zn.tnic (p200300EC2F0B5100ADAB1EC08AC9DA5D.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5100:adab:1ec0:8ac9:da5d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BCFFB1EC0B7A;
        Tue,  8 Oct 2019 09:18:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570519132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=wx1cOnnVFS4hMKnGzGJe6GMOySd+wRTySitm/NxFdFQ=;
        b=euxJ+Yolh9xFp4wVjwNMAcj5xQNV3AVY77j1eUBM6KX+xsuv0UxaHHzMkIUhLFgcZtdYaR
        NIpv5XHDDrBMxkWnRiK8kzTP2v0210UJbsVwzxgAuAjvYMgsq+fPzFHso4dzLpu3VV6G9X
        UwpXvctFwkVJ+EvOAWM+stXiswuHnOA=
Date:   Tue, 8 Oct 2019 09:18:45 +0200
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
        cedric.xing@intel.com
Subject: Re: [PATCH v22 07/24] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20191008071845.GA14765@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-8-jarkko.sakkinen@linux.intel.com>
 <20191004094513.GA3362@zn.tnic>
 <20191008040405.GA1724@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191008040405.GA1724@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 09:04:05PM -0700, Sean Christopherson wrote:
> > BIT(30)
> 
> This is intentionally open coded so that it can be stringified in asm.

It stringifies just fine with the BIT() macro too:

# 187 "arch/x86/kernel/cpu/sgx/encls.h" 1
        1: .byte 0x0f, 0x01, 0xcf;
        2:
.section .fixup,"ax"
3: orl $((((1UL))) << (30)),%eax
   jmp 2b
.previous

and the resulting object:

Disassembly of section .fixup:

0000000000000000 <.fixup>:
   0:   0d 00 00 00 40          or     $0x40000000,%eax
   5:   e9 00 00 00 00          jmpq   a <__addressable_sgx_free_page107+0x2>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
