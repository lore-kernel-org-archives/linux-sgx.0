Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C778C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 17:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E7372073B
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 17:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="cEy5CSts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405572AbgE1R1a (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 13:27:30 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58696 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405523AbgE1R1a (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 13:27:30 -0400
Received: from zn.tnic (p200300ec2f0be200582218a51ad225b9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e200:5822:18a5:1ad2:25b9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B7AC01EC0322;
        Thu, 28 May 2020 19:27:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590686848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TT6iOUCDTdCEqWX5uOCC84ONMr6eORo4r3zov95wBEY=;
        b=cEy5CStsvFUpS3c8QX8E6GDBXFZozwm56VfXCuDEjedD3oCuJf43tUzWSnT/yqDzbGPolg
        lg9VGXXFMG8CAluTzZ2tynq5fHHOuRiu0AxQNNaAYa1BDHD+pFlqO/IPNIAO/CGKGfW9Z5
        e+qwPlZJSNd+N4yjjfNHkx6IYls5d/w=
Date:   Thu, 28 May 2020 19:27:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200528172724.GC382@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528012319.GA7577@linux.intel.com>
 <20200528013617.GD25962@linux.intel.com>
 <20200528065223.GB188849@linux.intel.com>
 <20200528171635.GB382@zn.tnic>
 <20200528171937.GB30353@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200528171937.GB30353@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 28, 2020 at 10:19:37AM -0700, Sean Christopherson wrote:
> On Thu, May 28, 2020 at 07:16:35PM +0200, Borislav Petkov wrote:
> > * sgx_alloc_page - allocates an EPC page
> 
> Did you want this to be sgx_alloc_epc_page?

Whatever you guys prefer. I'd use "sgx_alloc_page" because it returns
struct sgx_epc_page * but having "epc" in the name makes it even more
explicit so either is just fine.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
