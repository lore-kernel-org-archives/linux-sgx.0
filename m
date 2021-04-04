Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F0EC433B4
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Apr 2021 15:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7A561222
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Apr 2021 15:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhDDPx7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Apr 2021 11:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhDDPx7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Apr 2021 11:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A98A6137B;
        Sun,  4 Apr 2021 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617551634;
        bh=yqUA8RTq36lWl0AnBFKVNcM7kQEDtUb9H/sehA8uhWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cumZycPcIFZmAd7OskLRiDMQl0PQhobODNr+xtAenR5jy1NghCLM+hodLr7Bf5s5N
         CjwJLoKgG1O6FHtN/MOQI+c2OIhV8mIMoT4iN0dgv7s6RzvUMXOz5zuSL4FKsaphy5
         7Rji+7zA7+8s8LQByXV5zx1HYQuGCEQcwY/9AxhXlrs5QgQkxQzdVXRNv03ORgqPNp
         5pNDXIEKQ/l23+Z+HPfioUdyJr4c2uRAEvnMhlH5q0IVvdj4H227R0lOy5rGCUXUtI
         VB0ulQY6d5pE8jHaGXbPyDSFf6wNV/3H+hrI7CH9+oFsCqZOJ3jTZaEUidPPje7VBw
         DClCqeAjAZpZw==
Date:   Sun, 4 Apr 2021 18:53:52 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the debugfs
Message-ID: <YGnhEEwMD4qAtPaK@kernel.org>
References: <20210401052114.697432-1-jarkko@kernel.org>
 <20210401052114.697432-2-jarkko@kernel.org>
 <57c18e08-3e36-b5b3-aaba-9a21b75a1613@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c18e08-3e36-b5b3-aaba-9a21b75a1613@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 01, 2021 at 12:32:58PM -0700, Dave Hansen wrote:
> On 3/31/21 10:21 PM, Jarkko Sakkinen wrote:
> > +#ifdef CONFIG_DEBUG_FS
> > +	debugfs_create_file("sgx_nr_all_pages", 0400, arch_debugfs_dir, NULL,
> > +			    &sgx_nr_all_pages_fops);
> > +	debugfs_create_file("sgx_nr_free_pages", 0400, arch_debugfs_dir, NULL,
> > +			    &sgx_nr_free_pages_fops);
> > +#endif /* CONFIG_DEBUG_FS */
> 
> 
> Why not make the types u64's and use debugfs_create_u64()?  That would
> save a ton of code.  There's also debugfs_create_ulong().

Because I was not aware of that. For sure can be used.

/Jarkko
