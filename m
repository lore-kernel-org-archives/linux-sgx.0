Return-Path: <SRS0=YYkI=AF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83726C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 13:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 618CB20786
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 13:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="lLeMpYEX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403900AbgFXNEm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403866AbgFXNEl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 24 Jun 2020 09:04:41 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C57FC061573;
        Wed, 24 Jun 2020 06:04:41 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a9300e8dfe5a6becb2235.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9300:e8df:e5a6:becb:2235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F36A01EC00EE;
        Wed, 24 Jun 2020 15:04:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593003880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/C/W561eGDNwdzQAOazYjWoWMNqLg8ctKgr5YGGFXDk=;
        b=lLeMpYEXGEt6ZSSdBtwKbVAJThB2auNARk/lWnKB7z0MFjEtle6nqzAVj0krT7MlVr6yGJ
        vzbqSO5crI1E4ExU/LGspFOcoCKEd5B5z+lBp+UQORUwsTE6+SO5sACmftNG1OUu01PHNz
        /rDSSns9qQ6a1v389YDI9QrOKrZ/YuA=
Date:   Wed, 24 Jun 2020 15:04:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 02/21] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200624130434.GC8492@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-3-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220844.57423-3-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 18, 2020 at 01:08:24AM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> Launch Control.
> 
> Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> called enclaves, are always signed. All enclaves signed with the public key
> are unconditionally allowed to initialize. [1]
> 
> Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs

LE_WR or LC_ENABLED?

With that addressed:

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
