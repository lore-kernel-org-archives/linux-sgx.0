Return-Path: <SRS0=bk6Q=2J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8AEC43603
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 06:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4751124683
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 06:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Hge65a3Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfLSGPS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Dec 2019 01:15:18 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58084 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbfLSGPR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Dec 2019 01:15:17 -0500
Received: from zn.tnic (p200300EC2F0B1C00F1A577DA89A48CEF.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:1c00:f1a5:77da:89a4:8cef])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 77AFB1EC0591;
        Thu, 19 Dec 2019 07:15:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1576736116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bh0Tsz0FRFkz1g+d7rZD2Gj7EaunA+7nFMVCPMVS/JQ=;
        b=Hge65a3Zh8iRt4cP+h6hCWyCpK8fi+9bWdFUQb5P4C8Ca5I7lbf8FE2xhhmiE02iotkguB
        BXClpzWQo2tjIQzsvRzTJx4NvNCeUOSLJ+iCKqL/MaYOMzxjkhx3/sNVxKawih+AZl1ahu
        0UfBAbnLC5NdYx/oVXNl9a/y/1ANZHY=
Date:   Thu, 19 Dec 2019 07:15:10 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v24 07/24] x86/cpu/intel: Detect SGX supprt
Message-ID: <20191219061510.GA32039@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-8-jarkko.sakkinen@linux.intel.com>
 <20191217151744.GG28788@zn.tnic>
 <c956ba52a9f0b54cd8ab3ec034246662e792ac14.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c956ba52a9f0b54cd8ab3ec034246662e792ac14.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 19, 2019 at 02:42:20AM +0200, Jarkko Sakkinen wrote:
> It is used in bunch of places in the kernel. I'm a bit confused
> when using it is a right thing and when it should be avoided.

Yeah, we try to avoid ifdeffery as much as possible. Even if it means
pushing it into the called function and hiding it there. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
