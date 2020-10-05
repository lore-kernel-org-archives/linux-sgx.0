Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB8EC4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 08:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2532078D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 08:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="be0vEecm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgJEIqB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIqB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 5 Oct 2020 04:46:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DCEC0613CE;
        Mon,  5 Oct 2020 01:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bPm+NXaF58oJ4pjj4kj4P9hwCIv8anAVYU31I1Ay3xI=; b=be0vEecmIPJUInhqujERdVjiSw
        slWf5EO2sCfw41bwcU9ciclcTkqSrJ0VfD0OYwwi7lxu3zLvjDfsDjvsdssh1lo1KjP9PQIlCEWXi
        cnCKvReenjphE6Y3kY0Ns7UnmKUpBom+XgoqzWsF1XIah9qN3rW4c4yYrlbg2UvYwgg59/oDX0ATE
        4lBnzfitFtYJpY9MImEf15N8pAP3nc09m7dhoT6a4eHzujyUUUW62091GddUvyAE+NoqREw0drYHI
        ZML1gTsEnixC3/hXFtpamePthAtxcHyH1MM8IJif1UKn6+v+GZYmdmA6vgtX/stzX3szmHfdWm64f
        FxSICqZA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM82-00014G-E5; Mon, 05 Oct 2020 08:45:54 +0000
Date:   Mon, 5 Oct 2020 09:45:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201005084554.GA3403@infradead.org>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003143925.GB800720@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 04:39:25PM +0200, Greg KH wrote:
> > @@ -0,0 +1,173 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> 
> You use gpl-only header files in this file, so how in the world can it
> be bsd-3 licensed?
> 
> Please get your legal department to agree with this, after you explain
> to them how you are mixing gpl2-only code in with this file.
> 
> > +// Copyright(c) 2016-18 Intel Corporation.
> 
> Dates are hard to get right :(

As is comment formatting apparently.  Don't use // comments for anything
but the SPDX header, please.
