Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DA4C433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C50522209
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="qx3bYOzq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgIPUdN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgIPUdG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Sep 2020 16:33:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FBFC061756;
        Wed, 16 Sep 2020 13:33:06 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c3e00fd1c4c3dc2a42d43.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:3e00:fd1c:4c3d:c2a4:2d43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 569C01EC026F;
        Wed, 16 Sep 2020 22:33:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600288384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2boFix6LG8HpStw2voLaFUD6dySJr24aMaETXIdc5Xw=;
        b=qx3bYOzqESzGZZwSeyTbxuG9orWxe+vudCx+iD/vte8TigDFb3kkht68snonY4sUQw60wa
        mjkIN1F/6YX+8q/pDH9/sl1R1O0hp8NUXsF21/AlceNthHHHG1hu195fMj7v3IlEwaVKYf
        aNFBkrjrt3UumRkKHV8VgwL/dQ3LgF4=
Date:   Wed, 16 Sep 2020 22:32:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Message-ID: <20200916203257.GT2643@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-4-jarkko.sakkinen@linux.intel.com>
 <20200916114448.GI2643@zn.tnic>
 <20200916203008.GE25541@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200916203008.GE25541@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 16, 2020 at 11:30:08PM +0300, Jarkko Sakkinen wrote:
> Zero conflicts and there is no trap_pf.h yet. So this is not yet in
> Linus' tree?

tip tree: https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/seves

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
