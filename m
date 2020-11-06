Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A13C55178
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 22:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6194B20B1F
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 22:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="b4kFv/PZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgKFWb5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:31:57 -0500
Received: from mail.skyhub.de ([5.9.137.197]:39506 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgKFWb4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Nov 2020 17:31:56 -0500
Received: from zn.tnic (p200300ec2f0d1f00529236684d2ef4f5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1f00:5292:3668:4d2e:f4f5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CADC91EC03EA;
        Fri,  6 Nov 2020 23:31:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604701914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1ewQXOpmYrN/0tH7P80+/z4oiDvprGu+iw89oMgvclQ=;
        b=b4kFv/PZq26+dH9DG3Nl2f/WhNzizR5qtcOpwZyJU5r/jYTdT/Ik/ThU0msT3RGI+cOwCi
        p2F78yrerTsnXvH42TGZy+quNCCFOIEVmi/85fGYylsCD2cFm3ombFt7jDYTKIytfv9jqV
        IhhS1cyGCzGOjErpYtQ2MUpQ8p0ny6U=
Date:   Fri, 6 Nov 2020 23:31:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com,
        Michal Hocko <mhocko@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
Message-ID: <20201106223139.GO14914@zn.tnic>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
 <20201106100409.GD3371@techsingularity.net>
 <20201106165107.GA52595@kernel.org>
 <20201106203725.GK14914@zn.tnic>
 <20201106220402.GB55146@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106220402.GB55146@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 07, 2020 at 12:04:02AM +0200, Jarkko Sakkinen wrote:
> There has been a change request to update callback that made perfect
> sense to me. Is there something else that I might have missed? Just
> checking.

With "change requests" I mean the usual going through the replies to a
patchset and working in the changes people requested. Nothing special -
just the usual working in review feedback, that's it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
