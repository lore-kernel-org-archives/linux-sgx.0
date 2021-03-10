Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2278EC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 13:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE5A64FFA
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 13:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhCJNa3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 08:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbhCJNaA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Mar 2021 08:30:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB15C061760;
        Wed, 10 Mar 2021 05:30:00 -0800 (PST)
Received: from zn.tnic (p200300ec2f0a9900288f756052865d4a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9900:288f:7560:5286:5d4a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9A7661EC0324;
        Wed, 10 Mar 2021 14:29:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615382998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xXkvh9pNw7/Mx24TDR3vMVMWkIB3Ep8+dOHPbr4oHyA=;
        b=kz5zgJwdrx7KeFAw4ZfBJeEXjUUKR6exhF6zsx9S1bZUdNbqHesEOcCp4Ht26DdQzlAJTl
        mlcX/7K1TiVM1EdBNexaOq0VF4YYnZT4LOhGN5iqBVopmlNa7/kE9sXp8DL0VoFUMgO+DS
        2MB+bAsA5W3cHVGE/zWTN8GAhzvw7sw=
Date:   Wed, 10 Mar 2021 14:29:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
Message-ID: <20210310132948.GE23521@zn.tnic>
References: <cover.1615250634.git.kai.huang@intel.com>
 <20210309093037.GA699@zn.tnic>
 <76cb4216a7a689883c78b4622c86bd9c3faaa465.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76cb4216a7a689883c78b4622c86bd9c3faaa465.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 10, 2021 at 10:27:05PM +1300, Kai Huang wrote:
> Sorry for the mistake. I will send out another version with that fixed.

If patch 3 is the only one which needs to change, you can send only that
one as a reply to the original patch 3 message...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
