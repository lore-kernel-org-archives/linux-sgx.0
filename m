Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7E3C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 17:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D1A20721
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 17:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="A12Xbmgh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405458AbgE1RQo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 13:16:44 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57220 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405457AbgE1RQn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 13:16:43 -0400
Received: from zn.tnic (p200300ec2f0be200582218a51ad225b9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e200:5822:18a5:1ad2:25b9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6D9BB1EC0322;
        Thu, 28 May 2020 19:16:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590686201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZNr0IDntGq8ur8PPJ/WrGD6KrFQNJVMW6uUhI0U95uc=;
        b=A12XbmghbKPESrxwJZ4V0xep9hQF80ZpG8sb8lmFJKwhbN/zk+76PjEGyZbWJkYQACd+sN
        uG8cp96TpKWC9aCXwVIjxlaXamzouGQ1QhfLC2m99PO9zhc1or42g6GmaMZ/nXNbNT9+v/
        JCGiPLKkDfU7NkXQW/XWlIMfXjcUC8g=
Date:   Thu, 28 May 2020 19:16:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200528171635.GB382@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528012319.GA7577@linux.intel.com>
 <20200528013617.GD25962@linux.intel.com>
 <20200528065223.GB188849@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200528065223.GB188849@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Lemme reply to all mails with one. :-)

I think Sean almost had it:

>  sgx_alloc_epc_section -> sgx_map_epc_section
>  sgx_free_epc_section  -> sgx_unmap_epc_section

Or even

  sgx_setup_epc_section()
  sgx_free_epc_section()

>  sgx_alloc_page        -> sgx_alloc_epc_page
>  sgx_free_page         -> sgx_free_epc_page
>
>  sgx_try_alloc_page    -> sgx_alloc_epc_page_node
>  __sgx_try_alloc_page  -> sgx_alloc_epc_page_section

And except those last two. Those are allocating a page from the EPC
sections so I'd call them:

sgx_try_alloc_page    -> sgx_alloc_epc_page_section
__sgx_try_alloc_page  -> __sgx_alloc_epc_page_section

former doing the loop, latter doing the per-section list games.

> I'm not sure I follow fully Sean's reasoning but the way alloc is used
> mostly in Linux is to ask through some API the used kernel memory
> allocator to give memory for some kernel data structures.
>
> Agreed that it is not the best match on what we are doing.

Yes, ok, let's stay with "alloc". Agreed.

> I'm going with sgx_grab_page() and sgx_try_grab_page().

And let's simply forget the "try" - all the functions that can fail and
return an error code, they all try. :-)

> So sgx_alloc_epc_section() is most likely going to be read as "SGX,
> allocate an EPC section".

Or, allocate *from* the EPC section if it returns a pointer to a page
and the comment above it says so...

So to sum up:

* sgx_{alloc,setup}_epc_section - sets up the EPC section and the pages
which belong to it.

* sgx_alloc_page - allocates an EPC page

* sgx_alloc_epc_page_section - allocates a page from any EPC section

I think that makes it pretty clear what each function does...

> I'm thinking that you are over-engineering something this :-) Naming is
> never perfect.

I know, but naming stuff right will pay off later.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
