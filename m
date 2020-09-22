Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978FAC2D0E2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 08:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4284C23A1E
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 08:30:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="N9/4gG+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIVIaH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 04:30:07 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34978 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgIVIaH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 04:30:07 -0400
Received: from zn.tnic (p200300ec2f0bfb00524dde00a85e5113.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:fb00:524d:de00:a85e:5113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1AD3A1EC047F;
        Tue, 22 Sep 2020 10:30:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600763406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lMW7/Eoiw3PZgWXD71YS/srgG6ZE6LeQcSBpIjlo3Vs=;
        b=N9/4gG+Xj6Ldxt8o5+3U+6c7nM31yz6TD2zi2egYhr9JWY7tvcfvM6554E43S7AKbldOQd
        P817UQxMyQXPrlTUi7pL6BLemF6Ue74g3/2r2gqp3LLCkCklet+UnHcZ2bCi4Ap9eYOhiE
        giE/+Z9RXlGoscZTh5/f9uLM2zWJVpQ=
Date:   Tue, 22 Sep 2020 10:30:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v38 15/24] x86/sgx: Enable provisioning for remote
 attestation
Message-ID: <20200922083005.GD22660@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-16-jarkko.sakkinen@linux.intel.com>
 <20200921180728.GJ5901@zn.tnic>
 <20200921192706.GD53597@linux.intel.com>
 <20200921194156.GM5901@zn.tnic>
 <20200921212638.GB59547@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921212638.GB59547@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 12:26:38AM +0300, Jarkko Sakkinen wrote:
> BTW, probably would make sense to rewrite the short summary as:
> 
> "x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION"
> 
> for the sake of consistency with the three precursoring patches.

Ok.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
