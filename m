Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCCAC49ECB
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 08:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94AB61437
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 08:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFYIZL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Jun 2021 04:25:11 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45564 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFYIZL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Jun 2021 04:25:11 -0400
Received: from zn.tnic (p200300ec2f0dae006074d507cc15d98f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:ae00:6074:d507:cc15:d98f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 03A561EC0595;
        Fri, 25 Jun 2021 10:22:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1624609370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ngS9/xaOq2j9sm1ukqlh8eLbQuE4QtBlvWHyCPVz8dI=;
        b=iX4RN6cZLg7J2WFIMFVdMsLrQoyzrM/Ee5qR4P2+kPelgQhM7p3KbaT2Bx+Nd1lhfEQLu3
        BAeTPvFAuZByhchV4/7TJQ2Y+Vdnf7ZtHxZU/lt2YtVNrX+Wh/Dzovb8isWjCd+0xaxTxy
        Q17KzUD+CBDOQ3z3KitW1UXlqRbk4bY=
Date:   Fri, 25 Jun 2021 10:22:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Subject: Re: [PATCH v2] x86/sgx: Add missing xa_destroy() when virtual EPC is
 destroyed
Message-ID: <YNWR+oSGfulOWziI@zn.tnic>
References: <20210616003634.320206-1-kai.huang@intel.com>
 <20210623132844.heleuoxogrpz3cpm@kernel.org>
 <925090f035b8e749ea7aca8c857690c8afba7349.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <925090f035b8e749ea7aca8c857690c8afba7349.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 25, 2021 at 01:45:35PM +1200, Kai Huang wrote:
> Should we consider to get this into 5.13, since it is a fix?

We have considered it, have queued it, you're on Cc on the tip-bot
notification:

https://lkml.kernel.org/r/162377378414.19906.6678244614782222506.tip-bot2@tip-bot2

In the meantime, that fix landed upstream and will be in 5.13:

4692bc775d21 ("x86/sgx: Add missing xa_destroy() when virtual EPC is destroyed")

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
