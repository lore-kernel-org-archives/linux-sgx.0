Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3262DC43441
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 20:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D732083E
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 20:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Naia+JBF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9D732083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbeKQGh6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 17 Nov 2018 01:37:58 -0500
Received: from mail.skyhub.de ([5.9.137.197]:54238 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbeKQGh6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 17 Nov 2018 01:37:58 -0500
X-Virus-Scanned: Nedap ESD1 at mail.skyhub.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1542399844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WDPkQp01ntNcLEyrknGHBfLD3qc7HwJrO42WXq+B940=;
        b=Naia+JBFi7RKnYhaASJ5Yf/fg8jHJsB0RlDR+rqMr6mAnPZZS8RoJKmi3hYQr4QJEsHcoi
        2z2U3g7mTibZFcRylXFiGKSG16Ct0F2Yg0MYtnDtnXRZa86WoSFR08gNOOrd9TFGUtTKH6
        iLkMgvxQ8g5ZpVm8aNLSxid6GqhsNjQ=
Received: from mail.skyhub.de ([127.0.0.1])
        by localhost (blast.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gNS7a_zKd9VD; Fri, 16 Nov 2018 21:24:04 +0100 (CET)
Received: from zn.tnic (p200300EC2BD0FE004D130AD2F34E6DE4.dip0.t-ipconnect.de [IPv6:2003:ec:2bd0:fe00:4d13:ad2:f34e:6de4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CF0FC1EC05EB;
        Fri, 16 Nov 2018 21:24:03 +0100 (CET)
Date:   Fri, 16 Nov 2018 21:24:03 +0100
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
Message-ID: <20181116202403.GN20313@zn.tnic>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-2-jarkko.sakkinen@linux.intel.com>
 <20181116142248.GH20313@zn.tnic>
 <20181116150714.GA4244@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181116150714.GA4244@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 05:07:14PM +0200, Jarkko Sakkinen wrote:
> Yes, I think it could be renamed as sgx.c. Should the driver part be
> also called as sgx.ko?

I guess that's your call guys. The reason why I asked is because I like
shorter names and "sgx" is unambiguous enough. AFAICT, there's no one
else doing SGX atm.

:-)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
