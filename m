Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E45C4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 21:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852BD207DE
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 21:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgJAVqP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 17:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgJAVqP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 17:46:15 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014CC20796;
        Thu,  1 Oct 2020 21:46:13 +0000 (UTC)
Date:   Fri, 2 Oct 2020 00:46:11 +0300
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
Message-ID: <20201001204027.GA18610@linux.intel.com>
References: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
 <20201001165151.GE7474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001165151.GE7474@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 01, 2020 at 09:51:51AM -0700, Sean Christopherson wrote:
> Can you split this into a proper series?  There are many different things
> going on here, reviewing everything at once is difficult.
> 
> On Thu, Oct 01, 2020 at 07:16:42PM +0300, Jarkko Sakkinen wrote:
> > Reduce the struct size to 64 bytes. It makes sense to have a naturally
> > aligning struct size and it leaves 24 bytes of spare space for possible
> > future expansion. Having 256 bytes is over the top without any reasonable
> > explanation, which does not exist in the commit for the SGX vDSO.
> 
> I'm all for dropping the padding, but we should drop reserved fields
> altogether and instead reserve space for future features by keeping 'flags',
> enforcing it to be zero, and conditioning consumption of future fields on
> opt-in flags being set.

I do not want to maintain ABI where structs change their size based on
some field. It is way way too flakky. I fullly get some padding. I
rather keep the padding as large as it was than do that.

But you did catch a critical bug in my patch: the padding must be zero
checked through, and return -EINVAL if not all bytes are zero. Then that
space is a future playground.

I scaled down to 64 bytes because it is the rounding to the next nicely
alignable size (40 -> 64) and because three qwords is a lot of space
to play for future expansion.

'flags' wastes qword of space if we end up not needing such field.

With a good argument I can grow the struct to 128 or 256 bytes but
it has to be a constant. Without argument nearest 2**n is the most
logical choice.

What I should add vsgx.S, is a zero validation of the reserved area.

> > Drop struct sgx_exception. It does not serve any semantic purpose in the
> > context of this vDSO. Doing this is also consistent with user_handler and
> 
> IMO it does serve a purpose, it helps convey that it's a package deal, i.e.
> either all fields are valid or none are valid.

If there is no semantics that require such structure, then it is not
important enough to exist.

The 'leaf' will tell you whether you need to ignore exception fields or
not.

And not all fields are valid for all expections (e.g. the info put into
stack).

> > user_data fields, as neither are they encapsulated in an embedded data
> > structure.
> > 
> > Drop 'flags' from sgx_enclave_run as it is an unused value.'vsgx.S'
> > literally states this in an inline comment.
> 
> It's not unused, it's reserved to zero.

My response above.

> > Pick more reasonable names for the four fields of the exception. For
> > example, 'trapnr' should rather be just 'number' because in practice we
> > deliver only trap and the rest are faults.
> 
> No, in Intel terminology both faults and traps are delivered.  E.g. #DBs
> are traps (except for code breakpoints and INT1), #PF and #GP are faults.
> 
> That being said, I'm all for changing the 'trapnr' name.  I grabbed it from
> from the kernel's exception fixup, it wasn't deliberately chosen to imply
> that only trap-like exceptions are reported to userspace.

I based my information to Table 6-1 in Intel SDM volume 3A.

Unfortunately, the quoted sentence above is missing one word, overflow,
it is a typo. It should have been:

"... we deliver only #OD trap and the rest are faults"

The other traps, I think, were not fixed up but I could be wrong if I
misread something from the table (was quite tired at that point).

If I recheck that table in the SDM, the majority of stuff is categorized
as "Fault". From this I deduced that trapnr is not aligned with the SDM
terminology too well (being fully aware that kernel uses this
internally).

Anyway, I guess we go with 'vector', right? Probably there is some
miunderstanding but with the name 'vector' we are in the same page :-)

> > Also 'vector' would be an
> > adequate name for this field. Document the fields properly in order to
> > better explain the values that they have inherited.
> 
> My vote is for 'vector'.
> 
> > Remove 'exit_reason' as it is really a redundant field to save some space.
> > Instead, have just a field called 'leaf' that tells the last seen ENCLU.
> 
> This justification contradicts the removal of flags.  If you want to shave
> bytes, keep flags and enforce that flags is zero so that you don't need to
> have reserved bytes at the end of the struct.
> 
> IMO, having a separate exit reason provides saner code for userspace, e.g. 
> 
>   if (run->exit_reason == SGX_EXCEPTION_EXIT)
> 	<do exception stuff>
> 
> versus
> 
>   if (run->leaf == EENTER || run->leaf == ERESUME)
>         <do exception stuff>
> 
> I would prefer to be explicit about why the vDSO is transferring control to
> the caller or its handler.  It also gives us line of sight to supporting
> exit types other than EEXIT and exceptions.  Maybe we never end up with
> another type, but IMO shaving 4 bytes and a MOV isn't worth the risk of
> ending up with a mess of an API if another exit reason comes along.

'exit_reason' is just waste of expensive memory space that we have
limited fixed amount of. Using the same field in a *guaranteed*
non-conflicting manner saves space. There is absolutely no question
that what I did should not be done.

And the semantics are intuitive: it will tell what the latest E-thing
before arriving here (or subset of E's that transfrom from context to
context).

Maybe it should be prefixed with something like 'latest_', 'prev_'
or perhaps 'last_', Not sure which would be the most adequate prefix.

> > The documentation, selftest and the kernel source code use the terms "user
> > handler" and "exit handler" in somewhat inconsistent manner. Start using
> > "AEX handler" consistently as this is the term that Intel SDM volume D uses
> > for these events.
> 
> No, AEX is specifically for "asynchronus" exits.  In this context, that is
> limited to the exception path.  The vDSO invokes the user handler for EEXIT,
> i.e. the synchrous path, which is not an AEX.

OK, I but this one.

I got gray hairs because:

- API called it user handler.
- Documentation called it exit handler.
- Selftest called it exit handler.

I think user_handler is too generic and abstract but I'm happy to hear
other proposals than 'exit_' to which I will change given your feedback.

I think my flattening patch is doing the right thing overally. E.g.
packing exception and eexit to leaf came obvious when I did it. It also
makes doing all sorts of bindings to all sorts of languages a bit
easier, especially if you generate the bindings. It's simply the right
thing to do.

I only did this patch because I really now concertrated what I'm seeing
because of documenting things and came into conclusion that the existing
API was such that I simply cannot commit to maintain for years ahead.

/Jarkko
