Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0231DC433B4
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBFCD61382
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Apr 2021 16:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354044AbhDGQEA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242044AbhDGQD7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Apr 2021 12:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88D161279;
        Wed,  7 Apr 2021 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617811430;
        bh=n/agv0valY0hx6ycipcKyxiZ3nl4xB9w+3C8S6m6t4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5GePytE5LYKwNNQkoJIQXWOzokqQehUi6TINPlqXENTusEIsXOitbXgC9L6Xq7lm
         N/6dFg0VFw/M4/RHath1rl8LZosXWF6I+hjkfm2zkWVLDYOhxTxpz2L/ZgzoqV0U6D
         HkK6kCdUdV87QOjDQEtvzgPI2ZtCGBdBL4fnms344EwYT3gx7kj9jsThsnvfHx3p5p
         43LbIj/cZE/GKnB8AvFdVxLULWSot7DTcuRTOsdhecfmhEk8bAKwrewBFfaK4HjZeu
         k0Mks0To314FbIOjLqFA5ba4naV9+1fW/Lq2VLJu7BxRRWSR5ZIXNzSAjA81GejfaA
         B+aw+qqz4y3EQ==
Date:   Wed, 7 Apr 2021 19:03:47 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in
 sgx_setup_epc_section()
Message-ID: <YG3X454GI4U2BZVU@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210407154934.GF25319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407154934.GF25319@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 07, 2021 at 05:49:34PM +0200, Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 02:26:52AM +0300, Jarkko Sakkinen wrote:
> > Now that the sanitization process will make pages available by calling
> > sgx_free_epc_page(), sgx_setup_epc_section() should not touch to
> > sgx_nr_free_pages. This will result sgx_nr_free_pages to contain 2x the
> > number of actual free pages. Simply, remove the statement.
> > 
> > Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 13a7599ce7d4..7df7048cb1c9 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -657,7 +657,6 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> >  	}
> >  
> > -	sgx_nr_free_pages += nr_pages;
> >  	return true;
> >  }
> >  
> 
> First of all, I don't know how I didn't catch this:
> 
> /* The free page list lock protected variables prepend the lock. */
> static unsigned long sgx_nr_free_pages;
> 
> I need some sort of translator to understand what this comment means. I
> can guess what is trying to tell me.
> 
> Which leads to my question: what is sgx_nr_free_pages supposed to denote?
> 
> Because I understand the callpath
> 
> sgx_page_cache_init
> ...
> for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> 	...
> 	sgx_setup_epc_section
> 	...
> 		sgx_nr_free_pages += nr_pages;
> 
> as adding the number of pages of each new EPC section to the total
> number of the free pages. Unless that variable accounts something else.
> 
> So what does this variable actually mean?

It's used for only to trigger watermark for reclaiming. I.e. causes
ksgxd to trigger. And it gives the number of total free EPC pages in
all NUMA nodes.

/Jarkko
