Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879A0C433C1
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 09:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D18619FF
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 09:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhCXJsk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhCXJse (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 24 Mar 2021 05:48:34 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361EC061763;
        Wed, 24 Mar 2021 02:48:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a0800e1aaf92fe048fc85.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:800:e1aa:f92f:e048:fc85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 48E221EC03A0;
        Wed, 24 Mar 2021 10:48:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616579312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8+70UuYHrtyf1Q7By3CWyV+t024qxcDPftRTd1uPvT0=;
        b=BXKECoTRJNUBrYHbGX5r/1TpodODEQBNNI6ReInhSttxqc3N1iC5tkTzYqoA02QLRGiAaR
        LguhSARgiPFSj6zm8Hrr7tAST5TS3Ifwr8R0PdSZVSB6VmlUrEL+n3nTLuKg6uHeU2vd0K
        Do/3O8MY+cEtaiPt+DadaQ3JaWOeHnA=
Date:   Wed, 24 Mar 2021 10:48:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v6] selftests/x86: Use getauxval() to simplify the code
 in sgx
Message-ID: <20210324094835.GB5010@zn.tnic>
References: <20210314111621.68428-1-tianjia.zhang@linux.alibaba.com>
 <YE9ayBnFIpwGiVVr@kernel.org>
 <53c94119-bdc3-a24c-91be-6d0444c46d64@linux.alibaba.com>
 <20210323185125.GF4729@zn.tnic>
 <54c62bc7-f52b-0a77-f0f9-974605ade55d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54c62bc7-f52b-0a77-f0f9-974605ade55d@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 24, 2021 at 05:18:03PM +0800, Tianjia Zhang wrote:
> I'm very sorry that my mistake caused your hurt.

You'd have to do a lot more to cause hurt. :-)

> Please take time to look at this, which tree this should be picked?

Sure.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
