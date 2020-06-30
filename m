Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D129C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 08:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0C9206BE
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 08:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="VO8gB20o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgF3Ilg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 04:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgF3Ilg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 30 Jun 2020 04:41:36 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396CC061755;
        Tue, 30 Jun 2020 01:41:36 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eff00c5d3fc2efff9f4b6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:ff00:c5d3:fc2e:fff9:f4b6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6A5531EC022C;
        Tue, 30 Jun 2020 10:41:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593506494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ue2iecCNcCz8MqiJJqArPW8phjfA3/MN25DhE18wPNM=;
        b=VO8gB20oMAHm26xXaegwffMDcAMXlnx8ejK7HFksmCaogo82YZgyWJ74ELZ5bFMy7jK4Th
        abFvh+rcCg8dG/0WAEHrAAapSphDK6yFXy6HWsFnHeFgAxNp0uLNwusiMYcdMykPGXSwlB
        2IXm1KO57nmFygYwySEO0teHcIiw288=
Date:   Tue, 30 Jun 2020 10:41:28 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200630084128.GA1093@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com>
 <20200629171022.GC32176@zn.tnic>
 <20200630060055.GS12312@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200630060055.GS12312@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 11:00:55PM -0700, Sean Christopherson wrote:
> E.g. the vDSO function should get the fixup even if userspace screws
> up mmap() and invokes __vdso_sgx_enter_enclave() without being tagged
> an SGX task.

I sincerely hope you don't mean this seriously.

Please add a member to task_struct which denotes that a task is an
sgx task, test that member where needed and forget real quickly about
running *any* *fixup* for unrelated tasks.

> No hard dependency, it's normal kernel code.  My reasoning for dropping it
> in .../vdso was largely to co-locate it with vdso/extable.h due to the
> dependency on the format of 'struct vdso_exception_table_entry'.

A struct which you defined instead of simply using struct
exception_table_entry even if it has a handler member which would remain
unused?

Let's not put code in vdso/ if it doesn't really belong there pls.

> Ya, shouldn't be a problem to stub it out for SGX=n.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
