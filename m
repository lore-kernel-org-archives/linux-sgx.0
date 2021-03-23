Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAE7C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Mar 2021 18:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D48619C6
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Mar 2021 18:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhCWSvk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Mar 2021 14:51:40 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45666 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231265AbhCWSv2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Mar 2021 14:51:28 -0400
Received: from zn.tnic (p200300ec2f0be100bd101061d9ae0c74.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e100:bd10:1061:d9ae:c74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1191A1EC0328;
        Tue, 23 Mar 2021 19:51:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616525486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=kwxGXmV5DUzye7Q+/ASBzb++cb+UludyLaELslwKpxA=;
        b=FZcffufRT1ebKYumdN9qVgDR9OaapbTVLQ6Mpw2ZkWLIT7jQ7Bblw6OXdTkgNvVbvTHma5
        5Ur2eTZYjf8KSarUwUSPU7VO+SaGNITvkuNfaWvIgFkHrCryPiXVjZUtaFzegyUV+nRO2k
        F3OPH//PTYw+7GA+WPzqo+j63AeVt24=
Date:   Tue, 23 Mar 2021 19:51:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v6] selftests/x86: Use getauxval() to simplify the code
 in sgx
Message-ID: <20210323185125.GF4729@zn.tnic>
References: <20210314111621.68428-1-tianjia.zhang@linux.alibaba.com>
 <YE9ayBnFIpwGiVVr@kernel.org>
 <53c94119-bdc3-a24c-91be-6d0444c46d64@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53c94119-bdc3-a24c-91be-6d0444c46d64@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 23, 2021 at 11:08:25AM +0800, Tianjia Zhang wrote:
> Take time to look at this.

A "please" wouldn't hurt.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
