Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852DDC433B4
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61FBC611BE
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbhDGQSS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbhDGQSS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 7 Apr 2021 12:18:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45D5C061756;
        Wed,  7 Apr 2021 09:18:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08fb00aad493ab6ea3c721.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:aad4:93ab:6ea3:c721])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0A5C11EC0246;
        Wed,  7 Apr 2021 18:18:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617812287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=P6gQYKkldKmbml2f//Bn0ffqA/H6YjvWzQ/vYVm3/rE=;
        b=YyAtkpwNG1UWHqg4KKkM8cmIV8H2qcpl18kyRutrcfm+dmXXYpeKeocNodr1o/VKBz6TUk
        539RXtP959l5MYry6w3qzFr/OqO41vmNFFad/mooFzHhsSIKPvhxHdzt6NWHkVa6KoQrlu
        d5jKmWQ+t5gXq5P8FIMbStau6bl9nXo=
Date:   Wed, 7 Apr 2021 18:18:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in
 sgx_setup_epc_section()
Message-ID: <20210407161811.GK25319@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210407154934.GF25319@zn.tnic>
 <YG3X454GI4U2BZVU@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YG3X454GI4U2BZVU@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 07, 2021 at 07:03:47PM +0300, Jarkko Sakkinen wrote:
> > Which leads to my question: what is sgx_nr_free_pages supposed to denote?
> > 
> > Because I understand the callpath
> > 
> > sgx_page_cache_init
> > ...
> > for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> > 	...
> > 	sgx_setup_epc_section
> > 	...
> > 		sgx_nr_free_pages += nr_pages;
> > 
> > as adding the number of pages of each new EPC section to the total
> > number of the free pages. Unless that variable accounts something else.
> > 
> > So what does this variable actually mean?
> 
> It's used for only to trigger watermark for reclaiming. I.e. causes
> ksgxd to trigger. And it gives the number of total free EPC pages in
> all NUMA nodes.

So the callpath I laid out above is adding the number of pages of each
section to the total free EPC pages number.

Why is that wrong and why is your patch needed?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
