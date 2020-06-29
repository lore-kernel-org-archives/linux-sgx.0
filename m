Return-Path: <SRS0=HDiP=AK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C97C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 19:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C066C206F1
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jun 2020 19:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="CBoXxLFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgF2TSE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730984AbgF2TRn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Jun 2020 15:17:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD63C03079B;
        Mon, 29 Jun 2020 08:37:43 -0700 (PDT)
Received: from zn.tnic (p200300ec2f09280085fdc63970f65a73.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:2800:85fd:c639:70f6:5a73])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8A1B31EC0281;
        Mon, 29 Jun 2020 17:37:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593445058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=E2Vy1BjgpL7djeeIafMFG4u5IsZeMp6SGkzpkdddWqk=;
        b=CBoXxLFoMIY5VXcvAjrKeGHkctJgQQ+mpYy95c4ccd0Z87tioA+Bk1XaGXpZgf608oRnP4
        WbzG9rrLcBktAzNOsrOwzcQC8CIKp04tXZlgE2YypfyeekjI8h9hWQpyLus8riMgcX90WB
        iXQ8njrtu3RsCR8dpQkSF0SD2QKnOWs=
Date:   Mon, 29 Jun 2020 17:37:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200629153737.GA32176@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200627174335.GC15585@zn.tnic>
 <20200629152718.GA12312@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200629152718.GA12312@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 08:27:19AM -0700, Sean Christopherson wrote:
> Hmm, I was going to say that SGX_ENCL_INITIALIZED can't be checked until
> encl->lock is held, but that's not true for this path as mutual exclusion
> is provided by the SGX_ENCL_IOCTL flag.  So yeah, this can be checked at
> the same time as SGX_ENCL_CREATED in sgx_ioc_enclave_init().

Right, so my point is to have state checks for flags which make sense in
all ioctl entry points, in order to catch a misuse early. But we're on
the same page.

> ENCLS[EINIT] is interruptible because it has such a high latency, e.g. 50k+
> cycles on success.  If an IRQ/NMI/SMI becomes pending, EINIT may fail with
> SGX_UNMASKED_EVENT so that the event can be serviced.
>
> The idea behind the double loop is to try EINIT in a tight loop, then back
> off and sleep for a while before retrying that tight inner loop.

That gist of that kinda wants to be in a comment over that double-loop for
future on-lookers.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
