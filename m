Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79050ECAA24
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 19:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243637AbiHYTWX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Aug 2022 15:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243132AbiHYTWW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Aug 2022 15:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7E9BD1C8;
        Thu, 25 Aug 2022 12:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAEA061DA3;
        Thu, 25 Aug 2022 19:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E7DC433D6;
        Thu, 25 Aug 2022 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661455341;
        bh=cbnjw+nmYBdustDSdUgYDOKhxw2LS64OH7/cKsDUrmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mipFgfRiYf4a0mu8jEr2ykZM3NitOZKoAefxySh0OMIfioMmOZbLk9U3EfyjWgRml
         zJ9jhkoHTLLLzYraB2bi956xVPzc4IZ7JVgYu6QvT4YmZdx9Ml3HeZwvkQ8pePEwGi
         uzBYimNGG77kMiPkEnCYjz2f8UtsD/rIsPqzKhGplWjwstQx2f1Pq3EbkgDC9dBZpx
         7Pqu9s5xQhs7moQ5kmDw3mJiag9gtv8QUjv3U6HLMl40jOog9M7EZvUd919uE6VKNh
         MEUonSBUUg49ipToiZwsOr99beVO2zXq1DWQbtPO1MI+oGluNX5QYoGkFOOb8N8G6U
         h/oe/AFkjhKHg==
Date:   Thu, 25 Aug 2022 22:22:14 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86/sgx: Do not consider unsanitized pages an error
Message-ID: <YwfL5oZ8pjWmten0@kernel.org>
References: <20220825080802.259528-1-jarkko@kernel.org>
 <88d0f48a-d845-b0ca-b34d-5e22ae82b047@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88d0f48a-d845-b0ca-b34d-5e22ae82b047@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 25, 2022 at 11:51:18AM -0700, Dave Hansen wrote:
> On 8/25/22 01:08, Jarkko Sakkinen wrote:
> > +	/* Can happen, when the initialization is retracted: */
> > +	if (verbose && dirty_count > 0)
> > +		pr_info("%d unsanitized pages\n", dirty_count);
> >  }
> >  
> >  static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
> > @@ -394,11 +403,8 @@ static int ksgxd(void *p)
> >  	 * Sanitize pages in order to recover from kexec(). The 2nd pass is
> >  	 * required for SECS pages, whose child pages blocked EREMOVE.
> >  	 */
> > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > -	__sgx_sanitize_pages(&sgx_dirty_page_list);
> > -
> > -	/* sanity check: */
> > -	WARN_ON(!list_empty(&sgx_dirty_page_list));
> > +	__sgx_sanitize_pages(&sgx_dirty_page_list, false);
> > +	__sgx_sanitize_pages(&sgx_dirty_page_list, true);
> 
> This is backwards, IMNHO.
> 
> Make __sgx_sanitize_pages() return the number of pages that it leaves
> dirty.
> 
> 	__sgx_sanitize_pages(&sgx_dirty_page_list)
> 	left_dirty = __sgx_sanitize_pages(&sgx_dirty_page_list);
> 	if (left_dirty)
> 		pr_warn(...);

I like this and my patch has already the counter in place
so why not.

> That rids us of the mystery true/false and puts the pr_warn() in a place
> that makes logical sense.  Then, let's either *not* do the
> 
> 	pr_err_ratelimited(EREMOVE_ERROR_MESSAGE, ret, ret);
> 
> at all, or make it an unconditional pr_warn_ratelimited().  They're not
> going to be common and multiple messages are virtually worthless anyway.
> 
> I actually think a common tracepoint, or out-of-line ENCLS/ENCLU
> functions that can be easily ftraced are a much better idea than a
> one-off pr_whatever().

I like the tracepoint idea more than out-of-line ENCLS/ENCLU
because out-of-line is more "intrusive" change to the code
semantics than a tracepoint.

BR, Jarkko
