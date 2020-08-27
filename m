Return-Path: <SRS0=BSu2=CF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C210C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 16:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23F752087C
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 16:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="AjG26tSd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgH0QPd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:15:33 -0400
Received: from mail.skyhub.de ([5.9.137.197]:42742 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgH0QPc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Aug 2020 12:15:32 -0400
Received: from zn.tnic (p200300ec2f104500059e4b9a4804679d.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:4500:59e:4b9a:4804:679d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1267A1EC036E;
        Thu, 27 Aug 2020 18:15:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598544930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Zos8xr317Mr6fieRUdMgTR11Ta63JVFDYPbNfeN3+Xc=;
        b=AjG26tSdODJnmsurfGgr2dmB/A6Jy4Uyglm8Oq362pBl6mWgj1TJVTlTzQ4hfS1nA8fEdT
        J/KHqgS3TnkHuDJDUgvTHJv1FrR2Hgdyj/esjY1KvoGCuGF6ZuXRdeGclk08BKqf7tZ5xy
        oUs162RR8o1V6h+anzuHdorD3FGkToo=
Date:   Thu, 27 Aug 2020 18:15:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200827161527.GC30897@zn.tnic>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
 <20200826145239.GC22390@zn.tnic>
 <20200827132436.GA4674@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200827132436.GA4674@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 27, 2020 at 04:24:36PM +0300, Jarkko Sakkinen wrote:
> I have not checked if this passes checkpatch.pl yet, but I would
> be surprised if that did not pass (obviously I'll check that).

Right, when you're done with the patchset, just do

checkpatch.pl -g ...

on it before sending and you'll be good to go. Just remember to read the
suggestions checkpatch gives with turned on brain and sanity-check them
instead of blindly following them.

> I'm sorry about that. This was not intentional. I'll revisit them by
> going through all your responses from here:
> 
>   https://patchwork.kernel.org/patch/11581715/

Actually this one:

https://lkml.kernel.org/r/20200617220844.57423-12-jarkko.sakkinen@linux.intel.com

i.e., the v33 version.

Also, make sure you go through the review comments of v34 and v35 in
case you haven't done so yet.

> v34 had the splitting of the big driver patch into multiple patches.
> 
> During that process I've obviously failed to address these.

Yeah, that can happen - I mean, this is not even close to being an easy
patchset so thanks for putting in the effort.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
