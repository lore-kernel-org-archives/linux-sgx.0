Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4096EC433ED
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 08:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD2E61168
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 08:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhDHItC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDHItA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 04:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F27610CF;
        Thu,  8 Apr 2021 08:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617871729;
        bh=P19ARu+VzLED5pOwAOMynXeUE5WCD1NGG6yt2KArmgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jCeBV5SLTxof87P9PyTbveiHBTCRyqv22JLar956SDI81PsqG2uHXTiCRqlcjZTZ7
         U3aAxEDwWCRRnFeLpvCnSsLz3bpLrSWgSfkqgHvBSJYivJ99Q0b9asFFV2fHx270Hk
         zFucLLf/zgqzwZSwkp6If1ejFudDWpodIAvfsOKwvW4NlUXu3dckWhLz5cPmpeSSHJ
         CizYHlPbifWNQgoiJf3HUxJ0ceOTSI7jUvqZmjyqCeqZpqaZe1boRXb/S/aZXN/X7S
         DFys/3xYPMHkvQwWyMcEJwep/AjAjDNg8OKASrN8xZBjBlD9vfv/rpp5u95laNTDMU
         3K3K14u3ABtWw==
Date:   Thu, 8 Apr 2021 11:48:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in
 sgx_setup_epc_section()
Message-ID: <YG7DbunDoPocsEzZ@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
 <20210407154934.GF25319@zn.tnic>
 <YG3X454GI4U2BZVU@kernel.org>
 <20210407161811.GK25319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407161811.GK25319@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 07, 2021 at 06:18:11PM +0200, Borislav Petkov wrote:
> On Wed, Apr 07, 2021 at 07:03:47PM +0300, Jarkko Sakkinen wrote:
> > > Which leads to my question: what is sgx_nr_free_pages supposed to denote?
> > > 
> > > Because I understand the callpath
> > > 
> > > sgx_page_cache_init
> > > ...
> > > for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
> > > 	...
> > > 	sgx_setup_epc_section
> > > 	...
> > > 		sgx_nr_free_pages += nr_pages;
> > > 
> > > as adding the number of pages of each new EPC section to the total
> > > number of the free pages. Unless that variable accounts something else.
> > > 
> > > So what does this variable actually mean?
> > 
> > It's used for only to trigger watermark for reclaiming. I.e. causes
> > ksgxd to trigger. And it gives the number of total free EPC pages in
> > all NUMA nodes.
> 
> So the callpath I laid out above is adding the number of pages of each
> section to the total free EPC pages number.
> 
> Why is that wrong and why is your patch needed?
 
As part of "x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list"
pages are processed from a global list by ksgxd.

This in turn introduces change to sanitization:

-		if (!ret)
-			list_move(&page->list, &section->page_list);
-		else
+		if (!ret) {
+			/*
+			 * page is now sanitized.  Make it available via the SGX
+			 * page allocator:
+			 */
+			list_del(&page->list);
+			sgx_free_epc_page(page);
+		} else {
+			/* The page is not yet clean - move to the dirty list. */
 			list_move_tail(&page->list, &dirty);
-
-		spin_unlock(&section->lock);
+		}

This is done for the reason that it is best to keep the logic to assign
available-for-use EPC pages to correct NUMA lists in a single location.

The regression is that the sgx_nr_free_pages is also incremented by
sgx_free_epc_pages(), and thus it ends up having double the number of
pages available.

/Jarkko
