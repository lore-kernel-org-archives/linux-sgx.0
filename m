Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B682C433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 08:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E187061165
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 08:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHI4u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:56:50 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51328 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDHI4s (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 04:56:48 -0400
Received: from zn.tnic (p200300ec2f095000c11580856fe05acf.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:c115:8085:6fe0:5acf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 367371EC0345;
        Thu,  8 Apr 2021 10:56:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617872196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bR6sO7aZv70NKvrw7GL6QC8xUDg7+C/2quZgMqO/UOo=;
        b=ZRcO1vNpAdHwoHc+jTo8ih5ghRCzcYm+Kfxu4D5Xu0x6wGAuK1LPEf12Ie9BSL9cbM7cXH
        cGuwVLB6FQ61HmMatoBm2KLIi0UCTgzXlvaTSRvB++cDkA5LdRPJDlAgSKVLCdPNa5uUkF
        8yjPt8FaUYl5EHFv+DnrF+GCOEXONNg=
Date:   Thu, 8 Apr 2021 10:56:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in
 sgx_setup_epc_section()
Message-ID: <20210408085640.GD10192@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210407154934.GF25319@zn.tnic>
 <YG3X454GI4U2BZVU@kernel.org>
 <20210407161811.GK25319@zn.tnic>
 <YG7DbunDoPocsEzZ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YG7DbunDoPocsEzZ@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021 at 11:48:46AM +0300, Jarkko Sakkinen wrote:
> The regression is that the sgx_nr_free_pages is also incremented by
> sgx_free_epc_pages(), and thus it ends up having double the number of
> pages available.

So when you add a new EPC section with sgx_setup_epc_section(), those
new pages in "nr_pages" are initially not going to be accounted
anywhere? Or is that sgx_nr_all_pages? And you do that in your second
patch...

But those new pages coming in *are* free pages so they should be in the
free pages count too, IMHO.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
