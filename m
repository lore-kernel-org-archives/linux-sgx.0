Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D033BC433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Jan 2021 14:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A17EC22C9D
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Jan 2021 14:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbhAEO6f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Jan 2021 09:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbhAEO6e (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 5 Jan 2021 09:58:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A44C061574;
        Tue,  5 Jan 2021 06:57:54 -0800 (PST)
Received: from zn.tnic (p200300ec2f103700fcad5495733b9c88.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:3700:fcad:5495:733b:9c88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 132071EC03C1;
        Tue,  5 Jan 2021 15:57:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609858671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=L0p013t6oFM6rcNLv48g180+KC0j1cgEpItZ13D4/5Y=;
        b=iJ8HvaYnIG/gE4o2HHaoJ9Mx8lMaV0jLV4uIz99/ARXikVBKdOZXO4qdHFKbpX45hPutuB
        IMypX8Rufi9LFHDOkPWZDejvDLSWBZo5ZNQLJIR79WMg3cwHZs5LhHypdcJ06GKUGXK7SE
        E+uDYkGv5ItzqHB0gTVLMvYmrYUGwAc=
Date:   Tue, 5 Jan 2021 15:57:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20210105145749.GF28649@zn.tnic>
References: <20201216134920.21161-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201216134920.21161-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 16, 2020 at 03:49:20PM +0200, Jarkko Sakkinen wrote:
> Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
> period initiated by sgx_mmu_notifier_release().
> 
> A trivial example of a failing sequence with tasks A and B:
> 
> 1. A: -> sgx_release()
> 2. B: -> sgx_mmu_notifier_release()
> 3. B: -> list_del_rcu()
> 3. A: -> sgx_encl_release()
> 4. A: -> cleanup_srcu_struct()
> 
> The loop in sgx_release() observes an empty list because B has removed its
> entry in the middle, and calls cleanup_srcu_struct() before B has a chance
> to calls synchronize_srcu().

Leading to what? NULL ptr?

https://lkml.kernel.org/r/X9e2jOWz1hfXVpQ5@google.com

already suggested that you should explain the bug better and add the
splat but I'm still missing that explanation.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
