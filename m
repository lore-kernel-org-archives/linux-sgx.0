Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDE4C433DB
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 05:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8675064F9D
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 05:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhBEFJe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 00:09:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:17158 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhBEFJc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Feb 2021 00:09:32 -0500
IronPort-SDR: ccm8DfQLeuRjHZ5nAVIavyiEtW3tUANwxuSMty2b3ol0JpLBlkDmJQrjbdtCbqdTTyQN62iXkA
 Pf6GmtG1NwFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="180604155"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="180604155"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 21:08:50 -0800
IronPort-SDR: koN305Gqr94Z4GLnY5LoMO3p/XMNqW7bb2DorlARIPH9s9Fq9f3cDZ3tQ43DCwl8Jk9hI1t2kn
 jZSheEJyZ5hw==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="397325467"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 21:08:50 -0800
Date:   Thu, 4 Feb 2021 21:08:50 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH V3] x86: Remove unnecessary kmap() from
 sgx_ioc_enclave_init()
Message-ID: <20210205050850.GC5033@iweiny-DESK2.sc.intel.com>
References: <20210202194719.3525076-1-ira.weiny@intel.com>
 <YBnWDTlhE3K26CTp@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBnWDTlhE3K26CTp@kernel.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 03, 2021 at 12:45:33AM +0200, Jarkko Sakkinen wrote:
> On Tue, Feb 02, 2021 at 11:47:19AM -0800, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > kmap is inefficient and we are trying to reduce the usage in the kernel.
> > There is no readily apparent reason why initp_page needs to be allocated
> > and kmap'ed() but sigstruct needs to be page aligned and token
> > 512 byte aligned.
> > 
> > kmalloc() can give us this alignment but we need to allocate PAGE_SIZE
> > bytes to do so.  Rather than change this kmap() to kmap_local_page() use
> > kmalloc() instead.
> > 
> > Remove the alloc_page()/kmap() and replace with kmalloc() to get a
> > kernel address to use.
> > 
> > In addition add a comment to document the alignment requirements so that
> > others like myself don't attempt to 'fix' this again.  Finally, add 2
> > BUILD_BUG_ON's to ensure future changes to sigstruct and token do not go
> > unnoticed and cause a bug.
> > 
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Jethro Beekman <jethro@fortanix.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes from v2[1]:
> > 	When allocating a power of 2 size kmalloc() now guarantees the
> > 	alignment of the respective size.  So go back to using kmalloc() but
> > 	with a PAGE_SIZE allocation to get the alignment.  This also follows
> > 	the pattern in sgx_ioc_enclave_create()
> > 
> > Changes from v1[1]:
> > 	Use page_address() instead of kcmalloc() to ensure sigstruct is
> > 	page aligned
> > 	Use BUILD_BUG_ON to ensure token and sigstruct don't collide.
> > 
> > [1] https://lore.kernel.org/lkml/20210129001459.1538805-1-ira.weiny@intel.com/
> > [2] https://lore.kernel.org/lkml/20210202013725.3514671-1-ira.weiny@intel.com/
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 90a5caf76939..e0c3301ccd67 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -604,7 +604,6 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> >  {
> >  	struct sgx_sigstruct *sigstruct;
> >  	struct sgx_enclave_init init_arg;
> > -	struct page *initp_page;
> >  	void *token;
> >  	int ret;
> >  
> > @@ -615,11 +614,16 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> >  	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
> >  		return -EFAULT;
> >  
> > -	initp_page = alloc_page(GFP_KERNEL);
> > -	if (!initp_page)
> > +	/*
> > +	 * sigstruct must be on a page boundry and token on a 512 byte boundry
> > +	 * kmalloc() gives us this alignment when allocating PAGE_SIZE bytes
> > +	 */
> > +	sigstruct = kmalloc(PAGE_SIZE, GFP_KERNEL);
> > +	if (!sigstruct)
> >  		return -ENOMEM;
> >  
> > -	sigstruct = kmap(initp_page);
> > +	BUILD_BUG_ON(sizeof(*sigstruct) > (PAGE_SIZE/2));
> > +	BUILD_BUG_ON(SGX_LAUNCH_TOKEN_SIZE > (PAGE_SIZE/2));
> 
> Please remove these.

I don't see why these would be a bad thing as they don't have any run time
implications.  But I've removed them for v4 because getting rid of the kmap()
is more important for me right now.

Ira

> 
> >  	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
> >  	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
> >  
> > @@ -645,8 +649,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> >  	ret = sgx_encl_init(encl, sigstruct, token);
> >  
> >  out:
> > -	kunmap(initp_page);
> > -	__free_page(initp_page);
> > +	kfree(sigstruct);
> >  	return ret;
> >  }
> >  
> > -- 
> > 2.28.0.rc0.12.gb6a658bd00c9
> > 
> > 
> 
> /Jarkko
