Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0636C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC9E206E2
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z0lkxMWr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGGDOe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGGDOe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Jul 2020 23:14:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CE3C061755;
        Mon,  6 Jul 2020 20:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k2H5pw9kHnNESZiVTxJwRsMN7ovCdLveDhlOoJi8yRQ=; b=Z0lkxMWrLAxUpGYZp5T/v/cp0Z
        vfU6I5Hiepp8MihVc94LGSIXM4y7JGqUZgO41J7helz5zL44ACTHVTS7w5FP2PqhPGHSDG28hGdAC
        /bMT+yN348fa69Llrpv6no1PjQGaG7f+kxf/P+FS7Boj0xSMbFHEcLnh2KqLaul93dUf4fS54h3gd
        87BjnIyHUk5fBb4/RDAtkt0WY74FUcJjUyCsIQXMpDaNy0QYjsyOvn4GZlpQoV2e6/sGX5yDvyuHg
        ymc9UP2PXnjxvEIGzg/QpFdjBB9xo6iBrlWsP/QqM3uIHEqZjU3NPd4i+4U1bDYsgbNbVfXoYJRb2
        o6zossfA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jse3s-000340-9t; Tue, 07 Jul 2020 03:14:24 +0000
Date:   Tue, 7 Jul 2020 04:14:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200707031424.GD25523@casper.infradead.org>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 06:01:50AM +0300, Jarkko Sakkinen wrote:
> +++ b/mm/mprotect.c
> @@ -603,13 +603,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  			goto out;
>  		}
>  
> +		tmp = vma->vm_end;
> +		if (tmp > end)
> +			tmp = end;
> +
>  		error = security_file_mprotect(vma, reqprot, prot);
>  		if (error)
>  			goto out;
>  
> -		tmp = vma->vm_end;
> -		if (tmp > end)
> -			tmp = end;

You don't need to move this any more, right?

> +		if (vma->vm_ops && vma->vm_ops->mprotect) {
> +			error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> +			if (error)
> +				goto out;
> +		}
> +
>  		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
>  		if (error)
>  			goto out;
> -- 
> 2.25.1
> 
