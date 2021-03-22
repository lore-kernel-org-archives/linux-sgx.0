Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4701AC433DB
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 18:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BB0461990
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Mar 2021 18:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhCVS5S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCVS4q (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 22 Mar 2021 14:56:46 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60B2C061574
        for <linux-sgx@vger.kernel.org>; Mon, 22 Mar 2021 11:56:45 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c204so11640941pfc.4
        for <linux-sgx@vger.kernel.org>; Mon, 22 Mar 2021 11:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=meEW8j4RJB41y0aX/BJ31GvzjYBgkYNc3Bk1g56lS4c=;
        b=FYmy8/b9CYLzWuaCW800x0BLr+B35vF+M0Wn/b6s6DoGAhFqP0wmC9sMN8clixXNOo
         YpnnM9O8JHfSQ0O1sMRNIoLwYxkeS3xqyrQgefQwaxgn5zEuQio774WS6/rbxTgrISB3
         Y7GHo0MzN1lhWqMvBYZ/z5/T5rscgDFOd11Qo7RHaAbBLSopLzxjGyQY/oPBaBROzAAF
         qWhhDFkTwvcemMmgYzkbd3bzIEjb8jvdhFenNfjD8bSRm34h8h/0w9h/6js8wPV7A/R/
         T/mYAY/yNGNgBvwJ98yIWbJEqxZgw3nhMit2cxBc28EmvynZSe02lZATQ/4uUENcQG05
         Mcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=meEW8j4RJB41y0aX/BJ31GvzjYBgkYNc3Bk1g56lS4c=;
        b=piWwUIZyNfg9ryaphk8o4XV9Q2BCKoFTihlwdGIa4fgXKfPchTe0bIxtD1uz6ew5ut
         PxDOpMcid9bniA6IAdF+2WrThYs1x+LCMEEarhIKEjcWIXax3jiZfz5+I/c3KE9ahgId
         7UFvdspbGqbtd/BGqPUOexyjoxBMqbGyui59RxvCsyXqC6jI7wJgvwAUzXLcryaAsIbN
         8XZHnyju0nztOWQ4VnV1k0IVLfbhkfJiG5TgYCUmGHffVhwD2gJ/GjC2cCzeeUYui67n
         XhBqO0UTQ2VKKVXVO5IXLuU6HQHXcCOOgmaPmrPSFN3+rbso5ZVIwzGAYyTxC0L5TzaP
         zNlw==
X-Gm-Message-State: AOAM530EJvCajhYn73og4iuEKrxvCcuPrCdaa6iuP3/gyZ5HByvmGw8H
        eWZtVp1dbVKG4ZYCORrRP2gUhg==
X-Google-Smtp-Source: ABdhPJzlx7ODCtnwxOp81NiIrkrB0U3rG9st5XhGj7tk9HWPo8fcJAB/pG4keSmRYjCwKoAN0krdHg==
X-Received: by 2002:a17:902:7407:b029:e4:9645:fdf6 with SMTP id g7-20020a1709027407b02900e49645fdf6mr1085992pll.19.1616439405020;
        Mon, 22 Mar 2021 11:56:45 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:f8cd:ad3d:e69f:e006])
        by smtp.gmail.com with ESMTPSA id a30sm14514984pfr.66.2021.03.22.11.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:56:44 -0700 (PDT)
Date:   Mon, 22 Mar 2021 11:56:37 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFjoZQwB7e3oQW8l@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
 <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322181646.GG6481@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 22, 2021, Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:22:19PM +1300, Kai Huang wrote:
> > +/**
> > + * sgx_encl_free_epc_page - free EPC page assigned to an enclave
> > + * @page:	EPC page to be freed
> > + *
> > + * Free EPC page assigned to an enclave.  It does EREMOVE for the page, and
> > + * only upon success, it puts the page back to free page list.  Otherwise, it
> > + * gives a WARNING to indicate page is leaked, and require reboot to retrieve
> > + * leaked pages.
> > + */
> > +void sgx_encl_free_epc_page(struct sgx_epc_page *page)
> > +{
> > +	int ret;
> > +
> > +	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> > +
> > +	/*
> > +	 * Give a message to remind EPC page is leaked when EREMOVE fails,
> > +	 * and requires machine reboot to get leaked pages back. This can
> > +	 * be improved in future by adding stats of leaked pages, etc.
> > +	 */
> > +#define EREMOVE_ERROR_MESSAGE \
> > +	"EREMOVE returned %d (0x%x).  EPC page leaked.  Reboot required to retrieve leaked pages."
> 
> A reboot? Seriously? Why?
> 
> How are you going to explain to cloud people that they need to reboot
> their fat server? The same cloud people who want to make sure Intel
> supports late microcode loading no matter the effort just so to avoid
> rebooting the machine.
> 
> But now all of a sudden, if they wanna have SGX enclaves in guests, they
> need to get prepared for potential rebooting.

Not necessarily.  This can only trigger in the host, and thus require a host
reboot, if the host is also running enclaves.  If the CSP is not running
enclaves, or is running its enclaves in a separate VM, then this path cannot be
reached.

> I sure hope I'm missing something...

EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
running as a guest).  IME, nearly every kernel/KVM bug that I introduced that
led to EREMOVE failure was also quite fatal to SGX, i.e. this is just the canary
in the coal mine.

It's certainly possible to add more sophisticated error handling, e.g. through
the pages onto a list and periodically try to recover them.  But, since the vast
majority of bugs that cause EREMOVE failure are fatal to SGX, implementing
sophisticated handling is quite low on the list of priorities.

Dave wanted the "page leaked" error message so that it's abundantly clear that
the kernel is leaking pages on EREMOVE failure and that the WARN isn't "benign".
