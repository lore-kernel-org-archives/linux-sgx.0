Return-Path: <SRS0=0h1F=EM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39532C2D0A3
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 22:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2BF920B1F
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Nov 2020 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604700253;
	bh=ieDhYU4bSFd1/vVWlPxscTeA4K/tr1v7M3g5bfv6eOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k9uhzWcBtHqovyiJqQZjSZ/4ay9GI+mWE0VSE6FbmhZgWiBxL8bqLD6R/VF84M0CG
	 yDtqI7AlftcJgVQeZPThrlpsomLRPs3yvWZPUf/FPZ+108IleC08/CKHXvPKkLhmKk
	 oa7WIprY6zkpjn+IgD/ReuHE6GlkDvdwjII9OC9w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgKFWEN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Nov 2020 17:04:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgKFWEN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Nov 2020 17:04:13 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 375B32065D;
        Fri,  6 Nov 2020 22:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604700252;
        bh=ieDhYU4bSFd1/vVWlPxscTeA4K/tr1v7M3g5bfv6eOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I3qy6PVFwmL7t7ItZ7VRZfBLNSepfCPtzAw1UdebRyLjkuKrqI84qS51zrxMieQYb
         BBdeSxUFMI5MbEIqGOgMvDF5ON3hh2f60/XQDIj9qsa2oc+Inl8lhNltULv7H33Zf5
         walgx0begp0qp2lSHjRfutm56RG9xohfH44GJgh8=
Date:   Sat, 7 Nov 2020 00:04:02 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
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
Message-ID: <20201106220402.GB55146@kernel.org>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com>
 <20201106100409.GD3371@techsingularity.net>
 <20201106165107.GA52595@kernel.org>
 <20201106203725.GK14914@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106203725.GK14914@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 09:37:25PM +0100, Borislav Petkov wrote:
> On Fri, Nov 06, 2020 at 06:51:07PM +0200, Jarkko Sakkinen wrote:
> > Both comments make sense to me. I'll refine this patch on Monday and
> 
> And while you're at it, I'd suggest you refine the whole patchset and
> send a full v41 instead:
> 
> - please audit all your Reviewed-by, Acked-by tags as to for what
> versions of the patches they were given. If you've changed those patches
> in the meantime, then all those tags are invalid and need to go.
> 
> - work in all the change requests
> 
> - fix the order of the patches so that each one builds
> 
> so that they can be taken cleanly into tip.
> 
> Thx.

OK, everything else is clear except change requests part I want to
check.

There has been a change request to update callback that made perfect
sense to me. Is there something else that I might have missed? Just
checking.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
