Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B90C4346E
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC41020758
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 18:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="icOpOtF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgIUS2B (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgIUS2B (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 21 Sep 2020 14:28:01 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8FAC061755;
        Mon, 21 Sep 2020 11:28:01 -0700 (PDT)
Received: from zn.tnic (p200300ec2f07e30076607a950172f225.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:e300:7660:7a95:172:f225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B02F41EC0281;
        Mon, 21 Sep 2020 20:27:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600712879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3cmmzkdRj3CTCc9fQg54iNBZbfaxEFaEzbuaRutT7SU=;
        b=icOpOtF+LzqLL19ufTlDbtbRhNMihdfON08IuW/+S3bMBjHFCh8ar6QbiqxYd+WxaMS8G6
        wpDpWR0Am94HmezGud2tKUF4hZpjooRtT1qIyy9Ghnx3F7DxE7DM88p9NSkLaI9jSLqe5h
        GvQc7vA9wafbZKb15dGyRoEAWRL9DaY=
Date:   Mon, 21 Sep 2020 20:27:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Message-ID: <20200921182753.GK5901@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921181021.GA24481@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 11:10:21AM -0700, Sean Christopherson wrote:
> The LE pubkey hash MSRs are special snowflakes.  They get reset to Intel's
> default key on any loss of EPC, e.g. if the system does a suspend/resume
> cycle.  The approach we took (obviously) is to assume the kernel's cache can
> be stale at any given time.  The alternative would be to try and track loss
> of EPC conditions and emulate the reset, but that's a bit dicey on bare
> metal as any missed case would hose SGX, and in a VM it's theoretically
> impossible to handle as a particularly unhelpful VMM could emulate loss of
> EPC at will.

Lemme try to understand this: the system could suspend/resume right
here:

        sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);

<--- suspend/resume

        ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));

and thus the MSRs would have the default key so you'd need the second
__einit() call?

But what happens if the system suspends before the second __einit()
call?

Why don't you simply drop that @enforce param and let the caller handle
any retries?

Or is the scenario something different?

Or you could perhaps disable suspend/resume around it, maybe something
like lock_system_sleep() or so, from a quick grep...

> Yes, this need a big fat comment.

Oh yeah.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
