Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7501C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 21:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30F864FC9
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 21:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhCJV5W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 16:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhCJV44 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 16:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B69164FC4;
        Wed, 10 Mar 2021 21:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615413416;
        bh=tP/5Qrb7ICdaCHD18+vh3j4mu8gOrW1enp0pS0/Z3gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s6E7aohD8ra4z7/zLUBgXBX/WYF8At7b9oycxE0a/Z+F05SKTvCeSvle2AdtAavZo
         nLyuNZcDvL4Zl7fv2SKaS3mo7IkXDDLxkfXr78ZRFhcyNFMxLQYbpEZNhj/Cbm+rQy
         chPWmeZxTBKhu1G2fXXOgjylHkoz8AO2LoR76sUrKfj0InQIkpygCfUjgdCMOjkJSH
         RA+OSfALJ5PDjMmKN99U+m1X6k8+Ml2F1fogFcjuPT8BiIctzlVYXZZRCCD01WrTsO
         HT0XcZAyLMSJobnalBPIqvK6n7kgHLTFgpXuyCORvwY2VQT5JuQuexlq9fpp39hajT
         KiTERRsAbS8nA==
Date:   Wed, 10 Mar 2021 23:56:31 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] x86/sgx: Use sgx_free_epc_page() in
 sgx_reclaim_pages()
Message-ID: <YElAj2zgismExjjM@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-3-jarkko@kernel.org>
 <b223ea92-8b20-def3-7bd0-2cc44474bd78@intel.com>
 <YEjhjhBpYJ6i6EFD@kernel.org>
 <b1b11501-805d-fcfd-4978-18d4b252510a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b11501-805d-fcfd-4978-18d4b252510a@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 10, 2021 at 07:55:35AM -0800, Dave Hansen wrote:
> On 3/10/21 7:11 AM, Jarkko Sakkinen wrote:
> >>> -		section = &sgx_epc_sections[epc_page->section];
> >>> -		spin_lock(&section->lock);
> >>> -		list_add_tail(&epc_page->list, &section->page_list);
> >>> -		section->free_cnt++;
> >>> -		spin_unlock(&section->lock);
> >>> +		sgx_free_epc_page(epc_page);
> >>>  	}
> >>>  }
> >> In current upstream (3fb6d0e00e), sgx_free_epc_page() calls __eremove().
> >>  This code does not call __eremove().  That seems to be changing
> >> behavior where none was intended.
> > EREMOVE does not matter here, as it doesn't in almost all most of the sites
> > where sgx_free_epc_page() is used in the driver. It does nothing to an
> > uninitialized pages.
> > 
> > The two patches that I posted originally for Kai's series took EREMOVE out
> > of sgx_free_epc_page() and put an explicit EREMOVE where it is actually
> > needed, but for reasons unknown to me, that change is gone.
> > 
> > Replacing the ad-hoc code with sgx_free_epc_page() is absolutely the right
> > action to take because it follows the pattern how sgx_free_epc_page() is
> > used in the driver.
> 
> That sounds generally fine.  But, this is a functional change.  Where
> there are functional changes, I always hope to see some mention of the
> change in the changelog.
> 
> Could you add some of this to the next changelog, please?

This appears for the first time in this patch set version, which means that
there is no patch changelog for this.

Maybe a better idea would be to explain the functional change in the commit
message (which of course implies also entry to the patch change log)?

/Jarkko
