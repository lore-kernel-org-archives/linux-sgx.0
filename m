Return-Path: <SRS0=PIOK=C3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C168C43463
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 15:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAABD239D1
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600441760;
	bh=IkOqknM/pgGLyHstRYRh+yvQ8FdTpYzJtOj13eKOQoo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=m0rfCcnShVnN7CRHq9I1+o0WnWaUa4pT5ODIMcGDi7VPRC2D4bywJDg7AwuLXxyVQ
	 qgL8y95hoPwiTs5hcsiG/Yfr5kba273j9/tX9DrVt7aaNaMF6U8HMonkcZZj9+5RIN
	 sVEqjjauFi42WppMCabCkifgVZeRGtezPPKIZXnY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgIRPJT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Sep 2020 11:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRPJS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Sep 2020 11:09:18 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F136B23998
        for <linux-sgx@vger.kernel.org>; Fri, 18 Sep 2020 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600441758;
        bh=IkOqknM/pgGLyHstRYRh+yvQ8FdTpYzJtOj13eKOQoo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wQ81rRBmz55lhQkw2ePr88cuYBKO/mwDLRArD0Dl8vrCF5JXRSXioBz0uBj1vbe70
         7ubHe+MaHqxq7vYXgkIa4718PY9E1caLN8k+OyQ/4Lw3jA7BY/kHAtCbuaiqUdqiDw
         K0rCTSxm+b5VRI6PUTZSoBTMiyAMIGCPrMWMoFt4=
Received: by mail-wr1-f43.google.com with SMTP id z1so6002763wrt.3
        for <linux-sgx@vger.kernel.org>; Fri, 18 Sep 2020 08:09:17 -0700 (PDT)
X-Gm-Message-State: AOAM533OE0f67qEJMCYxcBmpVHfylv7EVm7WhqSu4uC38MdbdcIVRmpG
        m8pgkmTdtkDl6hXmgn28cYXqARN/TsMXBck7FQWeaQ==
X-Google-Smtp-Source: ABdhPJxGmXBOztEznChCx1zDcy87QF70YtkyM1AXgQnapl+jEklF6uBqSKjj6yAkDzuf8mO6n3/eki81+OiGt2xlp30=
X-Received: by 2002:a5d:5111:: with SMTP id s17mr37934142wrt.70.1600441756359;
 Fri, 18 Sep 2020 08:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com> <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20200915112842.897265-11-jarkko.sakkinen@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 18 Sep 2020 08:09:04 -0700
X-Gmail-Original-Message-ID: <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
Message-ID: <CALCETrX9T1ZUug=M5ba9g4H5B7kV=yL5RzuTaeAEdy3uAieN_A@mail.gmail.com>
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 4:28 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add vm_ops()->mprotect() for additional constraints for a VMA.
>
> Intel Software Guard eXtensions (SGX) will use this callback to add two
> constraints:
>
> 1. Verify that the address range does not have holes: each page address
>    must be filled with an enclave page.
> 2. Verify that VMA permissions won't surpass the permissions of any enclave
>    page within the address range. Enclave cryptographically sealed
>    permissions for each page address that set the upper limit for possible
>    VMA permissions. Not respecting this can cause #GP's to be emitted.

It's been awhile since I looked at this.  Can you remind us: is this
just preventing userspace from shooting itself in the foot or is this
something more important?

--Andy
