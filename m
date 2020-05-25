Return-Path: <SRS0=4dFz=7H=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8E8C433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 25 May 2020 08:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8317A2068D
	for <linux-sgx@archiver.kernel.org>; Mon, 25 May 2020 08:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="PyTo25j1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgEYIUV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 May 2020 04:20:21 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48542 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgEYIUU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 May 2020 04:20:20 -0400
Received: from zn.tnic (p200300ec2f06f30089d08c3691e46ece.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:f300:89d0:8c36:91e4:6ece])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 512DE1EC0116;
        Mon, 25 May 2020 10:20:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590394819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=omRLYnyE9Ggja9M7/4gjPm4celUM+0shYhwKnAB0XUk=;
        b=PyTo25j1KlkLw73HQWaVMKI6LnA2AOipXZqxoInK68eV9tl44jIgafJgAgy408JDdFzMiA
        eMdVN7u7uSTX3ky65sWXX9b1fOPYDPo9nMHhxarcgPslp3TecVAYEpbJg8lv+mIt/3R7DN
        adTtk/ZQmrIAjn1hD5NHANxI3oJmqEg=
Date:   Mon, 25 May 2020 10:20:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 04/20] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20200525082013.GC25636@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-5-jarkko.sakkinen@linux.intel.com>
 <20200520184745.GJ1457@zn.tnic>
 <20200522155405.GA8377@linux.intel.com>
 <20200522161326.GC25128@linux.intel.com>
 <20200522195017.GA121470@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200522195017.GA121470@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 22, 2020 at 10:50:17PM +0300, Jarkko Sakkinen wrote:
> If other values except two are never going to be used it is more than a
> legit point to validate this field.
> 
> It also the potential to use ~0x8086 bits to be defined later if ever
> needed lets say for some kernel specific purpose.

Yah, let's cover our ass for the future. We have all seen the "this
won't be used" but then "we're using it" change of heart. IOW, let's
align with what the hw checks and we can always relax that in the future
but not the other way around.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
