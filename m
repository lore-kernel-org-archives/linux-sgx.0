Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FCBC4320A
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB55961026
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 16:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhHZQf4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242725AbhHZQf4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Aug 2021 12:35:56 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC6EC0613C1;
        Thu, 26 Aug 2021 09:35:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f131000dba9b80c472eda01.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:1000:dba9:b80c:472e:da01])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9F43D1EC05A0;
        Thu, 26 Aug 2021 18:35:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1629995702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PKgKlf96DymBxVz2t9hvAbLAOKR28yTAQSVMuiOKTpY=;
        b=eqKm96j3cf+A7XmjBWU3zEWxtx+7zaJQ7JZzNFNMKQju6KSjq0sh4vXYVFsIZqQUeCyaXe
        LZlSR6cCAkvbbUkc+jCij3zK06kLPBcCVirFrBPTjX1ImHnmhxTsFHP2ADWy2u9FIi/feN
        85dnAQT0kldyEdXy4Hs97aaFjgwnqss=
Date:   Thu, 26 Aug 2021 18:35:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] x86/sgx: Add the missing ifdef for
 sgx_set_attribute()
Message-ID: <YSfC2vhMxaUY2j/H@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
 <YSdl16MFt/GVNGDq@zn.tnic>
 <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 26, 2021 at 07:08:07PM +0300, Jarkko Sakkinen wrote:
> I made this change because I'm including the header to set_memory.c, and

This is something you're doing locally, I presume. If so, you can keep
this patch local too.

> It's also incoherent that KVM specific functions are compilation flagged

They don't really have to be - they're just declarations.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
