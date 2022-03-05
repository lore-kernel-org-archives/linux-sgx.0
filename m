Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E91FC433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  5 Mar 2022 01:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiCEB1v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Mar 2022 20:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiCEB1u (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Mar 2022 20:27:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E27924891F;
        Fri,  4 Mar 2022 17:27:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 598D1B82B64;
        Sat,  5 Mar 2022 01:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2628C340E9;
        Sat,  5 Mar 2022 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646443619;
        bh=O2t5cstrad8YH4XMqpJzo/2cG6IQjd2OC+YQBg1gwjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AyKcCHDn/r9ub05vihRHvw5HbD+I+NlxvvPBFkrx9Y12SKZU/8gXEM4+XB6e9aN5B
         snAlThJXJGM0uJajsNOEEDC4jBfZ0P+2zS2Gj/J4pOWmlQdVkbxtCxwcIfJZ7yqqiS
         29cCPAszFqGeOV98wWeoDkbNVWypHk0BhT2roeohAkVrdmNWOSLPADb0BJZCogAAzp
         hsshrXYjYn+NJM5qTR+hGdskNKDUQbmzkAwXY9xf2+wXoaOFdPa204bkioGcDL5pJg
         JxWdKnBXjExjBQSvq10RbhSgcOWOptTdIuKLWtiKkgkiouFrhYXVdYdbFgo/teGIR1
         fsy7Oc0vz9sNQ==
Date:   Sat, 5 Mar 2022 03:26:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Nathaniel McCallum <nathaniel@profian.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: Add SGX_IOC_ENCLAVE_AUGMENT_PAGES
Message-ID: <YiK8NEnvgPerEdFB@iki.fi>
References: <20220304122852.563475-1-jarkko@kernel.org>
 <op.1iilcwhywjvjmi@hhuan26-mobl1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1iilcwhywjvjmi@hhuan26-mobl1.mshome.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 04, 2022 at 10:27:58AM -0600, Haitao Huang wrote:
> On Fri, 04 Mar 2022 06:28:52 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
> 
> > With SGX1 an enclave needs to be created with its maximum memory demands
> > allocated. Pages cannot be added to an enclave after it is initialized.
> > SGX2 introduces a new function, ENCLS[EAUG], that can be used to add
> > pages
> > to an initialized enclave. With SGX2 the enclave still needs to set aside
> > address space for its maximum memory demands during enclave creation, but
> > all pages need not be added before enclave initialization. Pages can be
> > added during enclave runtime.
> > 
> > Add support for dynamically adding pages to an initialized enclave with
> > SGX_IOC_ENCLAVE_AUGMENT_PAGES, which performs EAUG's to a given range of
> > pages. Do not enforce any particular permissions from kernel, like is
> > done
> > for the pages added during the pre-initialization phase, as enclave
> > controls the final permissions and content for these pages by issuing
> > either ENCLU[EACCEPT] (empty RW) or ENCLU[EACCEPTCOPY] (arbitrary data
> > and
> > permissions).
> > 
> > Explicit EAUG ioctl is a better choice than an implicit EAUG from a page
> > fault handler because it allows to have O(1) number of kernel-enclave
> > round
> > trips for EAUG-EACCEPT{COPY} process, instead of O(n), as it is in the
> > case
> > when a page fault handler EAUG single page at a time.
> > 
> > Cc: Reinette Chatre <reinette.chatre@intel.com>
> > Cc: Nathaniel McCallum <nathaniel@profian.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > Is contained in sgx2-v2.1 branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git
> > ---
> >  arch/x86/include/uapi/asm/sgx.h |  14 +++
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 159 ++++++++++++++++++++++++++++++++
> >  2 files changed, 173 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/sgx.h
> > b/arch/x86/include/uapi/asm/sgx.h
> > index c4e0326d281d..2b3a606e78fe 100644
> > --- a/arch/x86/include/uapi/asm/sgx.h
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -35,6 +35,8 @@ enum sgx_page_flags {
> >  	_IOWR(SGX_MAGIC, 0x06, struct sgx_enclave_modt)
> >  #define SGX_IOC_ENCLAVE_REMOVE_PAGES \
> >  	_IOWR(SGX_MAGIC, 0x08, struct sgx_enclave_remove_pages)
> > +#define SGX_IOC_ENCLAVE_AUGMENT_PAGES \
> > +	_IOWR(SGX_MAGIC, 0x09, struct sgx_enclave_augment_pages)
> > /**
> >   * struct sgx_enclave_create - parameter structure for the
> > @@ -138,6 +140,18 @@ struct sgx_enclave_remove_pages {
> >  	__u64 count;
> >  };
> > +/**
> > + * struct sgx_enclave_augment_pages - parameter structure for the
> > %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> > + * @offset:	starting page offset
> > + * @length:	length of the data (multiple of the page size)
> > + * @count:	number of bytes added (multiple of the page size)
> > + */
> > +struct sgx_enclave_augment_pages {
> > +	__u64 offset;
> > +	__u64 length;
> > +	__u64 count;
> > +};
> > +
> 
> As I stated in another thread, we need a mechanism to allow EAUG page
> lazily, e.g., on #PF. Can we add a field here to indicate that?

ioctl *does not* prevent lazy behaviour where, or if, it makes sense.

For growing memory (e.g. MAP_GROWSDOWN) you should just take advantage of
the vDSO's exception handling mechanism and call the ioctl on demand.

For a high-performance user space you still want to be also do minimum
round trip "batch jobs" where they are possible.

We exactly have the whole vDSO framework to service the on-demand needs
while still having full control of the execution. EAUG in the #PF handler
is all about being flakky and loosing all robustness.

BR, Jarkko
