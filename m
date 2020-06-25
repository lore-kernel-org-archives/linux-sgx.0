Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E24FC433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652C820C09
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 17:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="EBvs8dVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404415AbgFYRG4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404317AbgFYRGz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Jun 2020 13:06:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE21DC08C5C1;
        Thu, 25 Jun 2020 10:06:55 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ed10035c3b797f40e07e6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:35c3:b797:f40e:7e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0DE871EC0105;
        Thu, 25 Jun 2020 19:06:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593104814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Mz+5XiJg/4gIbNnFRXTUvB5IcOGglq3P9cG4urMJ7vU=;
        b=EBvs8dVZOaWaDuc/gmJa2Bc0TxHA4tvP0dlRrrmW8TvNyIt6SjeMoWS3Pea6bE0zAXaiGN
        DUqHYuo4KMyxvUedS9DfQn3hzSPQwTINHJ3HO/puwU8P3cUbx8PBp518oDjvxLWdy8S6/b
        p0jtl3j9Ri4qysa/tgRLeq0mXif4RBk=
Date:   Thu, 25 Jun 2020 19:06:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 09/21] x86/sgx: Add __sgx_alloc_epc_page() and
 sgx_free_epc_page()
Message-ID: <20200625170648.GH20319@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-10-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-10-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:31AM +0300, Jarkko Sakkinen wrote:
> Add __sgx_alloc_epc_page(), which iterates through EPC sections and borrows
> a page structure that is not used by anyone else. When a page is no longer
> needed it must be released with sgx_free_epc_page(). This function
> implicitly calls ENCLS[EREMOVE], which will return the page to the
> uninitialized state (i.e. not required from caller part).
> 
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 61 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c5831e3db14a..b776d249289f 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -83,6 +83,67 @@ static bool __init sgx_page_reclaimer_init(void)
>  	return true;
>  }
>  
> +static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
> +{
> +	struct sgx_epc_page *page;
> +
> +	if (list_empty(&section->page_list))
> +		return NULL;
> +
> +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> +	list_del_init(&page->list);

<---- newline here.

> +	return page;
> +}

Otherwise looks good; nice comments.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
