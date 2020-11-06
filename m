Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1ACC2D0A3
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 20:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A044121556
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 20:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="V0CeEBrJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgKFUhl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 15:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgKFUhl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 6 Nov 2020 15:37:41 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143BBC0613CF;
        Fri,  6 Nov 2020 12:37:41 -0800 (PST)
Received: from zn.tnic (p200300ec2f0d1f00ae349cded07ea856.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1f00:ae34:9cde:d07e:a856])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E6DEE1EC03EA;
        Fri,  6 Nov 2020 21:37:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1604695059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=gV/gplrtZo1pZxo5S7CaFbGDofL7UQTd659Y+mF7QVg=;
        b=V0CeEBrJBOy/Wq/uwg49fFngZ95S56AU9Xd9U8xvpdgyV6wca37kWuYrquQPZTwmTo5JEa
        jzS0zJNtwEKosJ9/lnvNkNXFAKzhE3BM7wY6gZwDQ5FcdZ6On5mPFPzpKV1zlXo9qQdsST
        TpckgcLNVlqoj3mA+DtDKkBwr7Gk9Ho=
Date:   Fri, 6 Nov 2020 21:37:25 +0100
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
Message-ID: <20201106203725.GK14914@zn.tnic>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
 <20201106100409.GD3371@techsingularity.net>
 <20201106165107.GA52595@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201106165107.GA52595@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 06:51:07PM +0200, Jarkko Sakkinen wrote:
> Both comments make sense to me. I'll refine this patch on Monday and

And while you're at it, I'd suggest you refine the whole patchset and
send a full v41 instead:

- please audit all your Reviewed-by, Acked-by tags as to for what
versions of the patches they were given. If you've changed those patches
in the meantime, then all those tags are invalid and need to go.

- work in all the change requests

- fix the order of the patches so that each one builds

so that they can be taken cleanly into tip.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
