Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16606C433DB
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 19:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DE364F30
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 19:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhCRTCE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbhCRTBl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 18 Mar 2021 15:01:41 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41014C06174A;
        Thu, 18 Mar 2021 12:01:41 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0fad0097421b4cbe68ffd9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:ad00:9742:1b4c:be68:ffd9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A779A1EC04D3;
        Thu, 18 Mar 2021 20:01:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616094099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TQpOk5Dm8ZoP30gwc+SscQpNxBorTjF21sskVywJuDY=;
        b=sF9CRZ/E1HVk9QHNUZ9YT6vs06BrgUuSyFGhZIr+jC7RbQ5jfBmPLTC2tYmoZ9+okxCWJT
        68c8nT0pQYIzFnPIf2iQS9kf1jLNhu2BSora+QyW0FX/MF2NAzyXKmrQQ7qsUaZLrTa63r
        pgAWDdNHP+nX9mFO8OI8RZG6TGkvJWE=
Date:   Thu, 18 Mar 2021 20:01:38 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sgx: Replace section->init_laundry_list with
 sgx_dirty_page_list
Message-ID: <20210318190138.GJ19570@zn.tnic>
References: <20210317235332.362001-1-jarkko.sakkinen@intel.com>
 <20210318174032.GI19570@zn.tnic>
 <1269283f-ddad-9049-dcf5-818a6ecbbc53@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1269283f-ddad-9049-dcf5-818a6ecbbc53@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 18, 2021 at 11:34:10AM -0700, Dave Hansen wrote:
> I usually get that after I reboot.  I have to do this:
> 
> 	chmod 755 /dev/sgx_enclave
> 	mount -o remount,exec /dev

Yap, that did it:

0x0000000000000000 0x0000000000002000 0x03
0x0000000000002000 0x0000000000001000 0x05
0x0000000000003000 0x0000000000003000 0x03
SUCCESS

> BTW, that *IS* going to get tripped over all the time.

Yap, and I saw it last time and we talked about it and I forgot again.
Conveniently.

> The selftest needs a better error message.  I'll send a patch.

Please do.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
