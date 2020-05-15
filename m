Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93791C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 09:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F632073E
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 09:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="AZZYZviL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgEOJmg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 May 2020 05:42:36 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47894 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgEOJmf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 15 May 2020 05:42:35 -0400
Received: from zn.tnic (p200300EC2F0D67007C15A407D89B0951.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:6700:7c15:a407:d89b:951])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 438BA1EC01CE;
        Fri, 15 May 2020 11:42:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589535754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5gkrZq/IEhDDuR+s/yBh+vMl5WPtO3zfU2c3ocaZwdU=;
        b=AZZYZviL9qURA7ZhT50uva1ykwPTjizYJ3zU3ijygI2fX3r/NpSuGdJUCF66K1LLs/pRJ6
        euG/SZaqwZxiN8Qu+PNAaUunQLNB1/qVJ+hQhJGOKf7Ex/nymTUOXl7WzPpGerNNbEVhGM
        qIZAQYt9zPSvcF+1IF1vehKpxd+1+yQ=
Date:   Fri, 15 May 2020 11:42:30 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr. Greg" <greg@enjellic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200515094230.GA19017@zn.tnic>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
 <87d07gk24l.fsf@nanos.tec.linutronix.de>
 <20200508190226.GA31465@wind.enjellic.com>
 <20200508195635.GR27052@linux.intel.com>
 <20200514091637.GA25156@wind.enjellic.com>
 <20200514161559.GA15603@linux.intel.com>
 <20200514162054.GE9266@zn.tnic>
 <666f4c3865fcd92e7d5c8437e69399cb55fb88a9.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <666f4c3865fcd92e7d5c8437e69399cb55fb88a9.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 15, 2020 at 12:28:54PM +0300, Jarkko Sakkinen wrote:
> Uh oh, should probably address this. Should I send v31 today with a "nosgx"
> patch added? Sorry for missing this one :-/

Not the whole thing - just the one patch as a reply to your thread pls.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
