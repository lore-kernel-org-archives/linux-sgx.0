Return-Path: <SRS0=00MA=DJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6CCC4727E
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 03:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C178208B6
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 03:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgJBDU2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 23:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJBDU2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 23:20:28 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DFD20874;
        Fri,  2 Oct 2020 03:20:26 +0000 (UTC)
Date:   Fri, 2 Oct 2020 06:20:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Flatten and clean up struct sgx_enclave_run
Message-ID: <20201002025218.GA30634@linux.intel.com>
References: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
 <20201001165151.GE7474@linux.intel.com>
 <20201001204027.GA18610@linux.intel.com>
 <20201001225029.GJ7474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001225029.GJ7474@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 01, 2020 at 03:50:29PM -0700, Sean Christopherson wrote:
> On Fri, Oct 02, 2020 at 12:46:11AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 01, 2020 at 09:51:51AM -0700, Sean Christopherson wrote:
> > > > Remove 'exit_reason' as it is really a redundant field to save some space.
> > > > Instead, have just a field called 'leaf' that tells the last seen ENCLU.
> > > 
> > > This justification contradicts the removal of flags.  If you want to shave
> > > bytes, keep flags and enforce that flags is zero so that you don't need to
> > > have reserved bytes at the end of the struct.
> > > 
> > > IMO, having a separate exit reason provides saner code for userspace, e.g. 
> > > 
> > >   if (run->exit_reason == SGX_EXCEPTION_EXIT)
> > > 	<do exception stuff>
> > > 
> > > versus
> > > 
> > >   if (run->leaf == EENTER || run->leaf == ERESUME)
> > >         <do exception stuff>
> > > 
> > > I would prefer to be explicit about why the vDSO is transferring control to
> > > the caller or its handler.  It also gives us line of sight to supporting
> > > exit types other than EEXIT and exceptions.  Maybe we never end up with
> > > another type, but IMO shaving 4 bytes and a MOV isn't worth the risk of
> > > ending up with a mess of an API if another exit reason comes along.
> > 
> > 'exit_reason' is just waste of expensive memory space that we have
> > limited fixed amount of.
> 
> Huh?  4 bytes on the user stack can't possibly be a real concern, the default
> stack size on x86-64 is 8MB.  Golang shaves that down to 2kb but dynamically
> adjusts the stack as needed.  The "allocation" is completely free, the caller
> will already be adjusting RSP to create space for the struct, and it doesn't
> need to be initialized.

It's unnecessary in the space that is chosen for the run structure. 64
bytes takes only one cacheline and the padding is also fast to validate
to contain only zeros (check three qwords).

Maybe I'm just weird but I'd just store all the leafs numbers in the
field that is designated to store leaf numbers.

> > Using the same field in a *guaranteed*
> > non-conflicting manner saves space. There is absolutely no question
> > that what I did should not be done.
> 
> But you can't guarantee that it doesn't conflict with future changes to the
> SGX architecture.  Hell, you can't even guarantee that it doesn't conflict
> with the current SGX architecture, e.g. see Jethro's request to invoke the
> handler on AEX's due to interrupts.

Reserved space can be used for any sort of new fields as long as the
whole structure is validated, including the padding. With or without
'flags' this should be always done.

Then there is no issue to add a new field after the merge. And thus,
there is no issue resolving [*], even if the 'flags' is not added
right now. You don't simply add stuff that is useless before it gets
used. You ensure that your data is in stable state. That's all one
hould do.

[*] https://lore.kernel.org/linux-sgx/0f88f6d7-fa2d-59b0-c90f-4aa9e04d0af5@fortanix.com/

/Jarkko
