Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F517C4320A
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 13:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6658E6108F
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 13:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhHRNlg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238611AbhHRNlD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Aug 2021 09:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF83D60238;
        Wed, 18 Aug 2021 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629294029;
        bh=80IaIFDHGWp7QnPlslmoBONoY+Zu3mlFuG4CYvGNkRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j9bfDo033NsQwUiEzHOU9Px4wj9HNOad/7sRDzXkX1HcRJQtiBwM/PZ47Bxwihbtu
         J/l6NvO92buF2SRsR/itWFowe3/geUXGTHkPwAJLmff4e2l6XcgrTj0ZKS3rJuSXv5
         6uDKVLvqvIrkvIqoIb3vvHH2V2VR/zddJ1QlyIJx+0+OaHf6SuW2hdLJFYsH3HuS+f
         z+71YvHeJSWJq5p686UecVrug5ZP+X1CHFkrW0Lm3rcCMKlxJvzKG13w+w0TyR2cHI
         2NwRHkyWiDmB6UQ7ESrkxvuCY9DuVzIhrJW9U3DYzGVw9M7x3P2Op8mBDTdjhYrt9V
         kUfW4hbmhMHNQ==
Date:   Wed, 18 Aug 2021 16:40:26 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     linux-sgx@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Saravanan D <saravanand@fb.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Message-ID: <20210818134026.GA7967@iki.fi>
References: <20210818132509.545997-1-jarkko@kernel.org>
 <acd5a925-ce86-9934-5e1c-d0bcee3f606b@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd5a925-ce86-9934-5e1c-d0bcee3f606b@fortanix.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 18, 2021 at 03:29:59PM +0200, Jethro Beekman wrote:
> On 2021-08-18 15:25, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on desktops
> > or VM's, up to many GB's on servers.  Just like for regular memory, it is
> > sometimes useful to know the amount of usable SGX memory in the system.
> > 
> > Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
> > usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> > BIOS, the printout would be:
> > 
> > SGX_MemTotal:      22528 kB
> > 
> > It is less than 32 MB because some of the space is reserved for Enclave
> > Page Cache Metadata (EPCM), which contains state variables for all the
> > pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> > which applications can use to create enclaves.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  Documentation/x86/sgx.rst      |  6 ++++++
> >  arch/x86/include/asm/sgx.h     | 10 +++++++---
> >  arch/x86/kernel/cpu/sgx/main.c |  7 ++++++-
> >  arch/x86/mm/pat/set_memory.c   |  5 +++++
> >  4 files changed, 24 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> > index dd0ac96ff9ef..68ee171e1d8f 100644
> > --- a/Documentation/x86/sgx.rst
> > +++ b/Documentation/x86/sgx.rst
> > @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the host and in guests
> >  on the same machine, the user should reserve enough EPC (by taking out
> >  total virtual EPC size of all SGX VMs from the physical EPC size) for
> >  host SGX applications so they can run with acceptable performance.
> > +
> > +Supplemental fields for /proc/meminfo
> > +=====================================
> > +
> > +SGX_MemTotal
> > +	The total usable SGX protected memory in kilobytes.
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index 05f3e21f01a7..2ae9dc8c9411 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -365,6 +365,13 @@ struct sgx_sigstruct {
> >   * comment!
> >   */
> >  
> > +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
> > +extern unsigned long sgx_nr_all_pages;
> > +
> > +int sgx_set_attribute(unsigned long *allowed_attributes,
> > +		      unsigned int attribute_fd);
> > +#endif
> > +
> >  #ifdef CONFIG_X86_SGX_KVM
> >  int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> >  		     int *trapnr);
> > @@ -372,7 +379,4 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
> >  		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
> >  #endif
> >  
> > -int sgx_set_attribute(unsigned long *allowed_attributes,
> > -		      unsigned int attribute_fd);
> > -
> 
> This change seems unrelated?

It's just a good practice not to define symbols that do not exist, so that
if the symbol is ever used, we get a compilation error, not linking error.

Since this is included to set_memory.c, based on this conclusion, I added
the check.

/Jarkko
