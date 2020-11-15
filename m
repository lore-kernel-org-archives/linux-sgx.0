Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1F5C2D0E4
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Nov 2020 17:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CEA222240
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Nov 2020 17:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MTvsTJZV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgKORcO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 Nov 2020 12:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgKORcO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 15 Nov 2020 12:32:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1785FC0613D1;
        Sun, 15 Nov 2020 09:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vDL/oO7RpaDTk6A1VW5fgkN8Qlv2jQ1JvN76B37zdfE=; b=MTvsTJZV1uoinRDVag+EO2Jzlf
        qCdVZ2tFlHK66/+PHeZlNuM4ToJHUnh64v8jGVUk6SnKhXEM/F7/qjJTlW8yFlvIyf9zMxkdIDW6s
        33oh08rlPTajsb+MSn/ZQBghwo45AKx4q0KP1/nlNFf3NMSBunMcIcoMt4w0RlZqF4U8sluIg/FMX
        F+B0oPyXpA+BqZNIFHrFf0dDamNy2fJFxpknJP2mT8uwUWoYjpIk3+ZGeZ29PuK7pRM5TQOGsqrXg
        t61oNzjl668B0dlpnR6/4unenQjaB+R41sn0zvCfDparG8wAYQVtgv8CdhNw/rXKmXoW72VpEcx6p
        cnoHr9ZA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keLsm-0002fV-4n; Sun, 15 Nov 2020 17:32:08 +0000
Date:   Sun, 15 Nov 2020 17:32:08 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v41 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
Message-ID: <20201115173208.GR17076@casper.infradead.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201112220135.165028-11-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112220135.165028-11-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 13, 2020 at 12:01:21AM +0200, Jarkko Sakkinen wrote:
> +++ b/include/linux/mm.h
> @@ -559,6 +559,13 @@ struct vm_operations_struct {
>  	void (*close)(struct vm_area_struct * area);
>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
>  	int (*mremap)(struct vm_area_struct * area);
> +	/*
> +	 * Called by mprotect() to make driver-specific permission
> +	 * checks before mprotect() is finalised.   The VMA must not
> +	 * be modified.  Returns 0 if eprotect() can proceed.
> +	 */

This is the wrong place for this documentation, and it's absurdly
specific to your implementation.  It should be in
Documentation/filesystems/locking.rst.

> +	int (*mprotect)(struct vm_area_struct *vma, unsigned long start,
> +			unsigned long end, unsigned long newflags);
> +
> +		if (vma->vm_ops && vma->vm_ops->mprotect)
> +			error = vma->vm_ops->mprotect(vma, nstart, tmp, newflags);
> +		if (error)
> +			goto out;
> +
>  		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
>  		if (error)
>  			goto out;
> +
>  		nstart = tmp;

Spurious newline added.
