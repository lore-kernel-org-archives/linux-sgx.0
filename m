Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C296FC433DB
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Feb 2021 17:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8279764EA9
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Feb 2021 17:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBARYG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBARYF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Feb 2021 12:24:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD3C0613D6
        for <linux-sgx@vger.kernel.org>; Mon,  1 Feb 2021 09:23:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e9so10383019plh.3
        for <linux-sgx@vger.kernel.org>; Mon, 01 Feb 2021 09:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9E0GZTfD0OA02q73XXsHXPjWkg/VrnXV/UimqNs2u/E=;
        b=gD0R+WWEXz93nBxxqPBDVQT6VZbWF3Vv2AWFZvd6W9pd+B1ZaM4BGwle4Pk7bOF8+2
         stK3J3hDPr6/aBUPPT4cl7IM0VwDMrX4upH4rVJHdGqoJC9Tm581hivIMePcLze2jGNM
         6pmxfOCJI1jMM1aniPHomJd6y3IOULNVturxxiEoCE0K9y/iJjanCpS9mNNYi2YvEYuu
         R5b+YA21oFlyGwVmOB5qUN0Ph5WtluSj6+FRGl8ktvIMRv1XJjhtegwT4iTw1jnV/J+A
         QHXrBIjTVTRu5KYBBzK/ELZqLdW1PZRvcC08xOoURS41hoVl0WXAXcpZtB35xax/al2C
         eWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9E0GZTfD0OA02q73XXsHXPjWkg/VrnXV/UimqNs2u/E=;
        b=e5wKhnf0upqdb/Zf2wer+c4Wg7RfqD47Sd+nPF3dAoEWGXaI60T5yG1tG2/Hg/vcJO
         HX9fmCwTyRE95byD5qFM4lkIl3OzasrJe5fjU1xFImK4SqeFrN51Jqi1VkSIsf9XOPN6
         3C7HrMKgSiErcXz2S8PE2oLcxb+uMAr/OEY5lPl4OEGIRpA1Bgq1FlOj8mv7XxYvlPYH
         Swb7xGuXstOPMAuYI5VA7aB1oHO9f/BO4bfKBbb+0nvoxBrZYxy7K/4q5W8n4zRbhNOe
         Gg8IWbboczGUxBC1Z+oMI5EAmNXe7/u45lZW804WJmWeCdz1jTqzZfxBPGQSY9HG6P4Z
         vM2Q==
X-Gm-Message-State: AOAM5312DbqJ3eKcy73XLOKQxR6u/QGuqN4IGuVgqscxf1RMSv6EJ+PK
        IU21PBXpcO+ovna5d5o1JSm2fJKyO5euhA==
X-Google-Smtp-Source: ABdhPJyG6qMXCDzBhJ1M0vVcr+ePuvV5kkvchzwtbizMAl9r4GNA0R6P5SlGZ7XjJH/oeWz81Md4uA==
X-Received: by 2002:a17:90b:1955:: with SMTP id nk21mr12832220pjb.206.1612200205533;
        Mon, 01 Feb 2021 09:23:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:829:fccd:80d7:796f])
        by smtp.gmail.com with ESMTPSA id m11sm16404799pjz.44.2021.02.01.09.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:23:24 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:23:18 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBg5BradIvA4jNGw@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 01, 2021, Dave Hansen wrote:
> On 1/31/21 9:40 PM, Kai Huang wrote:
> >>> -	ret = sgx_drv_init();
> >>> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> >>> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> >> If would create more dumb code and just add
> >>
> >> ret = sgx_vepc_init()
> >> if (ret)
> >>         goto err_kthread;
> 
> Jarkko, I'm not sure I understand this suggestion.
> 
> > Do you mean you want below?
> > 
> > 	ret = sgx_drv_init();
> > 	ret = sgx_vepc_init();
> > 	if (ret)
> > 		goto err_kthread;
> > 
> > This was Sean's original code, but Dave didn't like it.

The problem is it's wrong.  That snippet would incorrectly bail if drv_init()
succeeds but vepc_init() fails.

The alternative to the bitwise AND is to snapshot the result in two separate
variables:

	ret = sgx_drv_init();
	ret2 = sgx_vepc_init();
	if (ret && ret2)
		goto err_kthread;

or check the return from drv_init() _after_ vepc_init():

	ret = sgx_drv_init();
	if (sgx_vepc_init() && ret)
		goto err_kthread;


As evidenced by this thread, the behavior is subtle and easy to get wrong.  I
deliberately chose the option that was the weirdest specifically to reduce the
probability of someone incorrectly "cleaning up" the code.

> Are you sure?  I remember the !!&!! abomination being Sean's doing. :)

Yep!  That 100% functionally correct horror is my doing.

> > Sean/Dave,
> > 
> > Please let me know which way you prefer.
> 
> Kai, I don't really know you are saying here.  In the end,
> sgx_vepc_init() has to run regardless of whether sgx_drv_init() is
> successful or not.  Also, we only want to 'goto err_kthraed' if *BOTH*
> fail.  The code you have above will, for instance, 'goto err_kthread' if
> sgx_drv_init() succeeds but sgx_vepc_init() fails.  It entirely
> disregards the sgx_drv_init() error code.

