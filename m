Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DCDC2B9F4
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Jun 2021 20:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634F06134F
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Jun 2021 20:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhFNUud (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Jun 2021 16:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhFNUuc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Jun 2021 16:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B23761153;
        Mon, 14 Jun 2021 20:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623703709;
        bh=n2OFFQx9/ydjvqumVmCWg3DZXZ6Ticc3D4Y5Q2AbkSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gqwUGoAbI1cSCP9Zq8T7/9ZEhgoKePIljmEKqAH2mIcZbdq5WLOKQAKQnEtkhYzP1
         iUPk4XlWh9o6J0X7GgeD7ezKlZ9WKErtGI9Razp5OJiEO/YOO0JEVGS8phwoBGpx3Z
         oZApLPNGbOEr0qMXO56UaguK1LnKu/FqPLWzEnbvg4IwfykrHkvbRzToUtoLh+qHA2
         MgEovvU4cnksdBQNGBUFMGVi09u/Pzd9hzYYYFJ5upHIGGp96i8Lz/yc9TgaMO7M2m
         HgNW4epIMJjXo1vLIGK0M5q3iymcggeWgexJ1gu7tvUVPghtMvmTbKzB/feCAJFjJP
         0c1FADxGVlr0Q==
Date:   Mon, 14 Jun 2021 23:48:27 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Add SGX_PAGE_REPEAT flag for
 SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20210614204827.ero7lzuhyaj3etku@kernel.org>
References: <20210610072117.76987-1-jarkko@kernel.org>
 <20210610090134.xetwllckm4dugg5c@kernel.org>
 <a5d4b6e4-7caa-06b3-a73b-b3869a92dbb5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d4b6e4-7caa-06b3-a73b-b3869a92dbb5@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 10, 2021 at 07:11:53AM -0700, Dave Hansen wrote:
> On 6/10/21 2:01 AM, Jarkko Sakkinen wrote:
> > On Thu, Jun 10, 2021 at 10:21:17AM +0300, Jarkko Sakkinen wrote:
> >> For uninitialized data, there's a need to add the same page multiple times,
> >> e.g. a zero page, instead of traversing the source memory forward. With the
> >> current API, this requires to call SGX_IOC_ENCLAVE_ADD_PAGES multiple
> >> times, once per page, which is not very efficient.
> >>
> >> Add a new SGX_PAGE_REPEAT flag to resolve the issue. When this flag is set
> >> to the 'flags' field of struct sgx_enclave_pages, the ioctl will apply the
> >> page at 'src' multiple times, instead of moving forward in the address
> >> space.
> >>
> >> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > After sending this, I started to think that maybe it would actually better
> > to just add SGX_PAGE_ZERO flag, i.e. add zero pages and ignore src. That's
> > the main use case right now, and saves the user space from extra trouble of
> > having to do such page by hand.
> > 
> > That neither does prevent adding SGX_PAGE_REPEAT later on. I just see no
> > point of that generic functionality right now. It only makes simple use
> > case more complex.
> 
> Is the main argument behind this new ABI that it increases efficiency?
> 
> Let's say I want to add 1MB of 0'd pages to an enclave.  Won't this do it?
> 
> 	zeros = mmap(NULL, size, PROT_READ, MAP_ANONYMOUS|MAP_PRIVATE,
> 		     -1, 0);
> 	ioctl(SGX_IOC_ENCLAVE_ADD_PAGES, zeros, size);

Later, with LSM's, it's better to mmap /dev/null.

> Sure, you'll pay the cost of faulting in the zero page size/PAGE_SIZE
> times.  But, that's pretty minuscule.  This zeros buffer can also be
> reused without faulting again.  It can be as big or small as you want.
> Heck, it could even be 2MB in size and use the transparent huge page.
> 
> I agree that there's definitely some optimization work to do.  But, I'm
> a bit hesitant to turn to new ABI to do it.

I realized that it's good to create heap memory like in your example
because then any possible SGX_IOC_ENCLAVE_ADD_PAGES invocation map to LSM
rules, i.e. every call has a well-defined source.

/Jarkko
