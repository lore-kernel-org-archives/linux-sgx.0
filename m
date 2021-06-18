Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD0AC48BDF
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jun 2021 05:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1B5A61245
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jun 2021 05:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhFRFRz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Jun 2021 01:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbhFRFRy (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 18 Jun 2021 01:17:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268FCC061574;
        Thu, 17 Jun 2021 22:15:42 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0dd800c1c0f109d0ca36f4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:d800:c1c0:f109:d0ca:36f4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 25E2F1EC054F;
        Fri, 18 Jun 2021 07:15:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1623993338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3LhMeMwTtpbDI2KT9uOpkZEiNfn65D72VUhwV0Ssmqw=;
        b=i1LUcSwc3otnx7wma6kWyGTtZF1RnaoMbctvhAymN7TPxb3I/rqhVaevTKGvUjHIziha47
        wpmjOMzYn9JzdInpItJBFhvbIUjR0lhwZI1f7Tn5DNvmN+ular6ys4hiV7QtPKwohXYp7D
        Zb8G1aeuyAProPkUIhqwAp5ZgEi1lc4=
Date:   Fri, 18 Jun 2021 07:15:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Subject: Re: [PATCH] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
Message-ID: <YMwr7xTBMUs60A9Q@zn.tnic>
References: <20210615101639.291929-1-kai.huang@intel.com>
 <20210615132001.kd6cuktq37dvoq3l@kernel.org>
 <618b42d66a4f2087ef4c54cc50fd56d01233eab1.camel@intel.com>
 <YMtdWduyALHxggoP@zn.tnic>
 <88eb26df062c473a6bffe5a0e1299f75e6a3cb78.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88eb26df062c473a6bffe5a0e1299f75e6a3cb78.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 18, 2021 at 12:04:55PM +1200, Kai Huang wrote:
> Thanks for suggestion. Yes I actually did the checkpatch.pl, but it
> didn't report typo in commit message. A little bit strange.

Yah, and I know it does catch typos. It seems it does so only sometimes:

$ ./scripts/checkpatch.pl --strict /tmp/kai.01
total: 0 errors, 0 warnings, 0 checks, 7 lines checked

/tmp/kai.01 has no obvious style problems and is ready for submission.

Someday soon we'll have a better way to deal with this.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
