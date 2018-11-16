Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E255CC04EBC
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 14:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E59208E3
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 14:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="DlPkagec"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7E59208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbeKQAfc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 19:35:32 -0500
Received: from mail.skyhub.de ([5.9.137.197]:42714 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbeKQAfc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 19:35:32 -0500
X-Virus-Scanned: Nedap ESD1 at mail.skyhub.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1542378175; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VSZltSZO1vLhFBI68E8EzhZKIw88eqIpQ6DKSMmPb0U=;
        b=DlPkagecS8Kufgnn6/v0t/dM4pUd8qFbwcA1LkZ/PNtgRAO7PeInHGurf1evguy8ILFf9E
        qwkCWyuKdIrzuOU6jfo4Id3L6WfrqmXfYBkAj7plxEKoOI8CFu8DyWGMUfDhJCbei7JAT+
        TNF8UC7T2dceAS05ny3fS4jJGen0h4I=
Received: from mail.skyhub.de ([127.0.0.1])
        by localhost (blast.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id y7Gd51o6UDD7; Fri, 16 Nov 2018 15:22:55 +0100 (CET)
Received: from zn.tnic (p200300EC2BD0FE004D130AD2F34E6DE4.dip0.t-ipconnect.de [IPv6:2003:ec:2bd0:fe00:4d13:ad2:f34e:6de4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A2DC61EC072C;
        Fri, 16 Nov 2018 15:22:54 +0100 (CET)
Date:   Fri, 16 Nov 2018 15:22:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 01/23] x86/sgx: Update MAINTAINERS
Message-ID: <20181116142248.GH20313@zn.tnic>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181116010412.23967-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:01:08AM +0200, Jarkko Sakkinen wrote:
> Add the maintainer information for the SGX subsystem.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0abecc528dac..aaf56b544858 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7676,6 +7676,13 @@ L:	linux-gpio@vger.kernel.org
>  S:	Maintained
>  F:	drivers/gpio/gpio-intel-mid.c
>  
> +INTEL SGX
> +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> +L:	linux-sgx@vger.kernel.org
> +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
> +F:	drivers/platform/x86/intel_sgx/

Looking at your diffstat, this doesn't cover it all.

One example: arch/x86/kernel/cpu/intel_sgx.c

Also, was there any particular reasoning for calling the file
intel_sgx.c instead of simply sgx.c ?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
