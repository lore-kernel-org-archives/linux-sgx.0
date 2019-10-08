Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19C1C10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 14:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B38C720659
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 14:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="bT46D5rO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfJHO4p (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 10:56:45 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54014 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfJHO4p (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 10:56:45 -0400
Received: from zn.tnic (p200300EC2F0B5100B1AE7F6CCC5C3495.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5100:b1ae:7f6c:cc5c:3495])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E03011EC067D;
        Tue,  8 Oct 2019 16:56:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1570546604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=l5tpSpjsdY7nwNni2u60uo4lJ8beDF5BTwe0zYQ7m2w=;
        b=bT46D5rOzFSUgRo72uVwNeaPA2xy+on9lfXLxoLQ02X2harSS80T+5SpScgJw1XvH6KiHb
        AMhtgNfWITIP587uSk4beQxAOJM2teRl5MNu7ziSVElP91kXY2g1omdnYx+nWggiiDYtEK
        I/C14n/GByC/uzEIhvSJ28T7sO/pwH8=
Date:   Tue, 8 Oct 2019 16:56:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 07/24] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20191008145642.GH14765@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-8-jarkko.sakkinen@linux.intel.com>
 <20191004094513.GA3362@zn.tnic>
 <20191008040405.GA1724@linux.intel.com>
 <20191008071845.GA14765@zn.tnic>
 <20191008133511.GB14020@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191008133511.GB14020@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 08, 2019 at 06:35:11AM -0700, Sean Christopherson wrote:
> Hmm, I get assembler errors using gcc 5.4.0

Crap. 8.3 eats this just fine. And I guess we can accomodate old gccs
by having BIT() evaluate the enclosing UL() macro into its __ASSEMBLY__
variant but it ain't worth the trouble.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
