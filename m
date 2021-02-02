Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A151FC43381
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 17:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A5564F6C
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 17:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhBBRlB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237626AbhBBRh4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Feb 2021 12:37:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700A164F6B;
        Tue,  2 Feb 2021 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612287435;
        bh=Q5IXGz4agDy9l+eqDqusJEsm5r3+bp1i2JQICg3Sb68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOR49h7ioJoHRRu5wIYcUXazOLckzJoNzfEV3hbml47dbWe4z0657cijt/Nz8JJ/W
         Y68M2Y+uig8GpuIQD4jZlGffvlPWh1ZtJbBT+hc4yVpBRtghugXe7Vj++SNtaGTp3s
         RE0W636qwLqAeLeLVzfpwcLVrufiWqk0JCbXPZJr63Fy11w2ARUqiSdwsWN+JZepsa
         JbKzoIEx81P8nPMS3PH6Cbs6llixrsMMnmmne4hBl9v5IwYZDcd0ljqoyNROCDF/Ta
         NziQUEJ7C4SG2uK2SChu3+Qj7huntndezUE63PkmYT9XdGc41SNf/9hBINN70P3A2+
         xLv20C+mkmmpg==
Date:   Tue, 2 Feb 2021 19:37:08 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>, ira.weiny@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86: Remove unnecessary kmap() from
 sgx_ioc_enclave_init()
Message-ID: <YBmNxAW8jYTqg/IF@kernel.org>
References: <20210129001459.1538805-1-ira.weiny@intel.com>
 <YBRH2jfPKS8ZofMZ@google.com>
 <20210201084812.GA3229269@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201084812.GA3229269@infradead.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 01, 2021 at 08:48:12AM +0000, Christoph Hellwig wrote:
> On Fri, Jan 29, 2021 at 09:37:30AM -0800, Sean Christopherson wrote:
> > On Thu, Jan 28, 2021, ira.weiny@intel.com wrote:
> > > From: Ira Weiny <ira.weiny@intel.com>
> > > 
> > > There is no reason to alloc a page and kmap it to store this temporary
> > > data from the user. 
> > 
> > Actually, there is, it's just poorly documented.  The sigstruct needs to be
> > page aligned, and the token needs to be 512-byte aligned.  kmcalloc doesn't
> > guarantee alignment.  IIRC things will work until slub_debug is enabled, at
> > which point the natural alignment behavior goes out the window.
> 
> Well, there still is absolutely no need for the kmap as you can use
> page_address for a GFP_KERNEL allocation.

Yeah, we do that in sgx_ioc_enclave_create already based on feedback:

        secs = kmalloc(PAGE_SIZE, GFP_KERNEL);
        if (!secs)
                return -ENOMEM;
        
The kmap() in sgx_ioc_enclave_init() is an unfortunate miss. Let's just
follow the pre-existing pattern.

/Jarkko
