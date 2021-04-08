Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D362EC433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A29661132
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDHJBP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:01:15 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52016 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDHJBP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 05:01:15 -0400
Received: from zn.tnic (p200300ec2f095000c11580856fe05acf.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:5000:c115:8085:6fe0:5acf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 172731EC04AD;
        Thu,  8 Apr 2021 11:01:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617872463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mMKQDX46gWFovobhQ6Op7YV74zzVD+ANMpYkTG8izmo=;
        b=bpeEJYP+zVTFhCDj6lkFAJH3ru6YBF4AJvXC+aowJ4QG2GfxqvwN++WSMRDzYyoK8UC3Ck
        BIyqImM7h8S/oLoCKkQCh6Uma1K4LxK+c2c+d6PaxEVpwB6SRtwMaYod/10wICuzQTLwHc
        wfyaMue8NjFX+tmO2ZbR0dvGtOJQx4w=
Date:   Thu, 8 Apr 2021 11:01:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <20210408090107.GE10192@zn.tnic>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
 <YG3ZJyMB+S5LcUso@kernel.org>
 <20210407161533.GJ25319@zn.tnic>
 <YG7EWDXmwC9ai38k@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YG7EWDXmwC9ai38k@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 08, 2021 at 11:52:40AM +0300, Jarkko Sakkinen wrote:
> I think these attributes are quite useful information to have available so
> I'd go actually doing sysfs attributes and create
> Documentation/ABI/stable/sysfs-driver-sgx to document them.

  testing/
        This directory documents interfaces that are felt to be stable,
        as the main development of this interface has been completed.

This sounds better for a start. From Documentation/ABI/README.

> Given that they would go then to the sysfs directory of the driver, then
> probably the legit names for the attributes ought to be:
> 
> - nr_all_epc_pages
> - nr_free_epc_pages
> 
> What do you think?

Sounds ok to me.

> PS. One useful case that I forgot to mention is that I use these to give
> idea what I gave EPC size in the BIOS. Now my EPC is set to 32 MB, and
> these report 20 MB of EPC pages. It's because other metadata (e.g. EPCM
> containing page attributes) is also stored in this area.

Just remember to put yourself in the user's shoes and think whether they
make sense to her/him.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
