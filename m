Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D957DC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 15:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A214164F60
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 15:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhCJPMB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhCJPLf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 10:11:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79FB364F4C;
        Wed, 10 Mar 2021 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615389095;
        bh=GrnU7hctx6M3VdWoZiGqdmasQZGYP8izzqK/3P5/BYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kSQVsW7ohF2rlCLhswvfcBGIb8wDMAngSd4+oMyCLngilh5Mfddkh2PvC65FniR1P
         YHNSUyllKFGbTdug0H0NcB5LmXhYW3YJhu/1MwDgaB850ho9Jjg33QrHMyknYuEjQW
         6RkxoWpFc185+C5VpkVhcQnfX+Dms6GQKOftBenzeYxLlN95srjMlQop0GXzVNUnk2
         SQC59UYLMZTfCg4YAyADctetIa9sHcIisk93RUtUWFAjrjlyhpvWtPsZEFuH4f6TI+
         dSKbMQnvNvXee5KTerjyNWAQPFhd7F8pUuuj//cOOPXPYja6P8ncB7Gnyqy572t85U
         +Vzcd5cS/KlEQ==
Date:   Wed, 10 Mar 2021 17:11:10 +0200
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
Message-ID: <YEjhjhBpYJ6i6EFD@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
 <20210303150323.433207-3-jarkko@kernel.org>
 <b223ea92-8b20-def3-7bd0-2cc44474bd78@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b223ea92-8b20-def3-7bd0-2cc44474bd78@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 03, 2021 at 08:59:17AM -0800, Dave Hansen wrote:
> On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 52d070fb4c9a..ed99c60024dc 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -305,7 +305,6 @@ static void sgx_reclaim_pages(void)
> >  {
> >  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
> >  	struct sgx_backing backing[SGX_NR_TO_SCAN];
> > -	struct sgx_epc_section *section;
> >  	struct sgx_encl_page *encl_page;
> >  	struct sgx_epc_page *epc_page;
> >  	pgoff_t page_index;
> > @@ -378,11 +377,7 @@ static void sgx_reclaim_pages(void)
> >  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> >  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> >  
> > -		section = &sgx_epc_sections[epc_page->section];
> > -		spin_lock(&section->lock);
> > -		list_add_tail(&epc_page->list, &section->page_list);
> > -		section->free_cnt++;
> > -		spin_unlock(&section->lock);
> > +		sgx_free_epc_page(epc_page);
> >  	}
> >  }
> 
> In current upstream (3fb6d0e00e), sgx_free_epc_page() calls __eremove().
>  This code does not call __eremove().  That seems to be changing
> behavior where none was intended.

EREMOVE does not matter here, as it doesn't in almost all most of the sites
where sgx_free_epc_page() is used in the driver. It does nothing to an
uninitialized pages.

The two patches that I posted originally for Kai's series took EREMOVE out
of sgx_free_epc_page() and put an explicit EREMOVE where it is actually
needed, but for reasons unknown to me, that change is gone.

Replacing the ad-hoc code with sgx_free_epc_page() is absolutely the right
action to take because it follows the pattern how sgx_free_epc_page() is
used in the driver.

For reference:

https://lore.kernel.org/linux-sgx/20210113233541.17669-1-jarkko@kernel.org/

> Was this, perhaps, based on top of Kai's series that changes the
> behavior of sgx_free_epc_page()?

I did not refer to that patch series.

/Jarkko
