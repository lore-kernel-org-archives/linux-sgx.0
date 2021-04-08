Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D606FC433ED
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 08:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9735E61176
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 08:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDHIwz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhDHIwy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 04:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A4176113A;
        Thu,  8 Apr 2021 08:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617871963;
        bh=MYMnMOl8XRwaeMn7oYUI3S8PUiMUgCGtoY6/t9GkuTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QGuE1cVGIsBT4Fp8CzAnU4HchMwCsBjgEi9big/zO4pAlexrojWJv/0ByiXDQ64QP
         erRqAaCNyPip776bwthQZP0pg0N5WEiBF8snNJxLvAcOUk5ljKaehmN0tgEx20ykM8
         EhLwSEytbLydUvoced/8Qd47ENJ3/PIrF8jd24oUi0sPyajO3gCj+7jOg30JOWb+y1
         5b/8zoiAG4LlqdD/7wHC75ARUxogcJCxM87HPcqcKIpfjAcow/jOxI05tHe/rkLG8L
         LwnpVYd/lq2y3S6MXNYh+/Ld4W8bSilRP6XRB97FGx2G+TSzcFGFkQHmvW33vR91sZ
         WSzVJOOAQK6iA==
Date:   Thu, 8 Apr 2021 11:52:40 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the
 debugfs
Message-ID: <YG7EWDXmwC9ai38k@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210405232653.33680-2-jarkko@kernel.org>
 <20210407155636.GG25319@zn.tnic>
 <YG3ZJyMB+S5LcUso@kernel.org>
 <20210407161533.GJ25319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407161533.GJ25319@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 07, 2021 at 06:15:33PM +0200, Borislav Petkov wrote:
> On Wed, Apr 07, 2021 at 07:09:11PM +0300, Jarkko Sakkinen wrote:
> > I left out "epc" because they are already prefixed with "sgx_".
> 
> Are there any other "page" types which are going to be figurating in
> some pseudofs or is "sgx" == "epc" in this case?
> 
> > debugfs was my first shot, but for sure these could be sysfs.
> 
> Ok, let's keep it in debugfs for now, it can always be made an ABI later
> and moved to sysfs. But pls document what those are and what they do and
> that when in debugfs, there are no guarantees that these interfaces will
> be there in the future.

I think these attributes are quite useful information to have available so
I'd go actually doing sysfs attributes and create
Documentation/ABI/stable/sysfs-driver-sgx to document them.

Given that they would go then to the sysfs directory of the driver, then
probably the legit names for the attributes ought to be:

- nr_all_epc_pages
- nr_free_epc_pages

What do you think?

PS. One useful case that I forgot to mention is that I use these to give
idea what I gave EPC size in the BIOS. Now my EPC is set to 32 MB, and
these report 20 MB of EPC pages. It's because other metadata (e.g. EPCM
containing page attributes) is also stored in this area.

/Jarkko
