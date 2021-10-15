Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D4BC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Oct 2021 23:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C9B6023D
	for <linux-sgx@archiver.kernel.org>; Fri, 15 Oct 2021 23:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbhJOXMp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 Oct 2021 19:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239063AbhJOXMo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 15 Oct 2021 19:12:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D1FC061762
        for <linux-sgx@vger.kernel.org>; Fri, 15 Oct 2021 16:10:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id om14so8201382pjb.5
        for <linux-sgx@vger.kernel.org>; Fri, 15 Oct 2021 16:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oR3LCNmabVt3R+J20wC8aHIgyaKVLMjkgQ5/1xBnfBM=;
        b=SwzeqJEzN9tuw+lfOKLKPhITPNCkjVdSdbgIVfa3RAy9hIPkksKfXLkqTjB3mOY31h
         tEiNu31TiSyYHKxqDy5HyCbqtJWNeJih6BqXYYkJZOXK0cGXoTtDanmy/94r1RynCIgc
         407/2Fmyp+dpsjNRFicwfIkGs7aoKIx+KSpdzMsG6BNBAScwrxRLjhSGbWyP6FTwFyPT
         v7aYXr/P7h99WqcE/YeBM07oCuKU9Xva2MnYG5whSp6q7qBL97G88qE7KL2vGn4Svoc1
         n6qAhBUm130u0ZAcCZMq0rolY7yMN7ZAVWDZS7Py1o0xBwtjIa2VygJtQ5GXkgfEd6wj
         6mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oR3LCNmabVt3R+J20wC8aHIgyaKVLMjkgQ5/1xBnfBM=;
        b=PDuYffiP55LKxAEPlLhLssSVNXMqZOCrYl37XMX8gwhuC5MMWPNxMrj49Nd27Wnz+t
         97p30a7xgPwA/+8fwIiXtDZRCFjEcKrCoMEWdCV4TlxHisGTUhQmK0RWW0t0MuqpMdtD
         bfrE8aLLdvipkyjd9oDCAcYiyu9Vk9AzGnJuSknoP0kNJh/RJZdaYGyfXmLaVJQsflMm
         Q368q0Gb8yX7GzG2ffCXq6sW0FXzbyaQQqaaqk4jIeGPC2d0LLUTebujnlL7uKalNdxE
         dTUXwNPPCrzMx10RbD6zNouLRmYDboXinPjuLXUlr+4uplOBcfXQlLVWDZFiJd36aYEc
         2F4Q==
X-Gm-Message-State: AOAM531F11Ap5i2otZ/r4vmskAwKu5q3dvWEfzyTvRtuVOOnW+8imctB
        /qiGAiijOhkusfRt1g7s3EApHg==
X-Google-Smtp-Source: ABdhPJwRJpfl2xcybfh60dYvU+59Xfc+ZYtjllm6Qmewk7zE1CxBc6njnYyskqxdV2ZXwkCi3QonbQ==
X-Received: by 2002:a17:90b:33c3:: with SMTP id lk3mr16668019pjb.237.1634339436901;
        Fri, 15 Oct 2021 16:10:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x17sm5688323pfa.209.2021.10.15.16.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:10:36 -0700 (PDT)
Date:   Fri, 15 Oct 2021 23:10:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tony Luck <tony.luck@intel.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        naoya.horiguchi@nec.com, Andrew Morton <akpm@linux-foundation.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v9 4/7] x86/sgx: Add SGX infrastructure to recover from
 poison
Message-ID: <YWoKaDtA+EvMyw4v@google.com>
References: <20211001164724.220532-1-tony.luck@intel.com>
 <20211011185924.374213-1-tony.luck@intel.com>
 <20211011185924.374213-5-tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011185924.374213-5-tony.luck@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 11, 2021, Tony Luck wrote:
> +	section = &sgx_epc_sections[page->section];
> +	node = section->node;
> +
> +	spin_lock(&node->lock);
> +
> +	/* Already poisoned? Nothing more to do */
> +	if (page->poison)
> +		goto out;
> +
> +	page->poison = 1;
> +
> +	/*
> +	 * If flags is zero, then the page is on a free list.
> +	 * Move it to the poison page list.
> +	 */
> +	if (!page->flags) {

If the flag is inverted, this becomes

	if (page->flags & SGX_EPC_PAGE_FREE) {

> +		list_del(&page->list);
> +		list_add(&page->list, &sgx_poison_page_list);

list_move(), and needs the same protection for sgx_poison_page_list.

> +		goto out;
> +	}
> +
> +	/*
> +	 * TBD: Add additional plumbing to enable pre-emptive
> +	 * action for asynchronous poison notification. Until
> +	 * then just hope that the poison:
> +	 * a) is not accessed - sgx_free_epc_page() will deal with it
> +	 *    when the user gives it back
> +	 * b) results in a recoverable machine check rather than
> +	 *    a fatal one
> +	 */
> +out:
> +	spin_unlock(&node->lock);
> +	return 0;
> +}
> +
>  /**
>   * A section metric is concatenated in a way that @low bits 12-31 define the
>   * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
> 
> -- 
> 2.31.1
> 
