Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB926EB64D7
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Jun 2023 22:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjFPWFn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Jun 2023 18:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjFPWFl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 16 Jun 2023 18:05:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA46E3ABE
        for <linux-sgx@vger.kernel.org>; Fri, 16 Jun 2023 15:05:36 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b506a647feso7381745ad.2
        for <linux-sgx@vger.kernel.org>; Fri, 16 Jun 2023 15:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686953136; x=1689545136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJfAs0Ja6wg7j1Lsl/q0urDOJHKxss9yfKrKlf3/ZDs=;
        b=NI/HlnbL1YiSPVbqWaCjm25RAJT+AERU+0YoKnD4WpZFKHuLBvgtY2P9LGm/ZmMrg2
         hQMKnfL4G2mkLiffnHZdA1eVxhPJHnf2LJW8bA59Ye4ty6P33+a9I5CDO54d8mSPTOf9
         +10e7AEbmPvss5l/ryLuor0i5+Na9FhL+872cQgHq1Q2Ey6ZUOk0dXQiBBa9WTPPFDLx
         dW0mJVcieES03gnmJ/Z0/KZjR/7qiOvSbTvaGFE1ifGbmPSYbOH8/4a3MXsKFyGjhbmG
         mnV/xJUUQodY6IOQpY02N4OWMhCVQnKGkeWywZYXWXbBI7WtJkmqlsgFhEWgOn8trKFn
         oqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686953136; x=1689545136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJfAs0Ja6wg7j1Lsl/q0urDOJHKxss9yfKrKlf3/ZDs=;
        b=l8jrQXi05dMq/52eL5tjgGn8yWmElwFyx09j6U2uAwhZeKtxqwMnsBEkfpapoQFzOr
         DbhCv/EZtu2/77UqAFlUKXvCK7Kd8EpIf2O5SAQCdGBGbeiwpTHKFrJAEOVBT08eb4OD
         nxaDIie2NsMrOXEIi462GxpiMO33/PEkwD+STb+ahxT9riyRusnTzRohhF1EQ6oJagUu
         q73L7arbD9BDhG9cQbUmGckgKgMT3jMJ651MPfJTh7lAm3/mF5aozUcbNf8y4OLiYRb8
         cugBI1hqV7HnhaQNNH7pP5X/2ODv5qudiyi9Hu0pTkuXoOUF7OumDBG/0GAJ/zXDAYyv
         jgZg==
X-Gm-Message-State: AC+VfDzIi6N4GuvSWBU4zXEK4FP2B+k/Igy3qTUpZdUHN9jjGhK/C7qu
        GkRE+98TpGadDV6NKjqd7RGoHia5TfI=
X-Google-Smtp-Source: ACHHUZ5mNilXQUxQdgjyH9E54Tsx9qrTE3nO+X2ndz1AtTI44V2V0P9+AO6wVyYMArpHsekqTW5RuREFQC8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f688:b0:1b3:edae:882b with SMTP id
 l8-20020a170902f68800b001b3edae882bmr587624plg.12.1686953136166; Fri, 16 Jun
 2023 15:05:36 -0700 (PDT)
Date:   Fri, 16 Jun 2023 15:05:34 -0700
In-Reply-To: <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
Mime-Version: 1.0
References: <Y/AAbC/j04aUkd8R@kernel.org> <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/VBOkmi7VbVuzAh@kernel.org> <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com> <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
 <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com> <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
 <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
Message-ID: <ZIzcrmU1RA7oEeQ7@google.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 16, 2023, Kai Huang wrote:
> On Tue, 2023-06-06 at 04:11 +0000, Huang, Kai wrote:
> > On Fri, 2023-05-26 at 19:32 -0500, Haitao Huang wrote:
> > > Hi Kai, Jarkko and Dave
> > > 
> > > On Thu, 09 Mar 2023 05:31:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:
> > > > 
> > > > So I am still a little bit confused about where does "SGX driver uses
> > > > MAP_ANONYMOUS semantics for fd-based mmap()" come from.
> > > > 
> > > > Anyway, we certainly don't want to break userspace.  However, IIUC,
> > > > even  from now on we change the driver to depend on userspace to pass
> > > > the correct  pgoff in mmap(), this won't break userspace, because old
> > > > userspace which doesn't  use fadvice() and pgoff actually doesn't
> > > > matter.  For new userspace which  uses fadvice(), it needs to pass the
> > > > correct pgoff.
> > > > 
> > > > I am not saying we should do this, but it doesn't seem we can break  
> > > > userspace?
> > > > 
> > > 
> > > Sorry for delayed update but I thought about this more and likely to  
> > > propose a new EAUG ioctl for this and for enabling SGX-CET shadow stack  
> > > pages. But regardless, I'd like to wrap up this discussion to just clarify  
> > > this anonymous semantics design in documentation so people won't get  
> > > confused in future.
> > > 
> > > I think we all agree to keep this semantics so no user space would need  
> > > specify 'offset' for mmap with enclave fd. And here is my proposed  
> > > documentation changes.
> > > 
> > > --- a/Documentation/x86/sgx.rst
> > > +++ b/Documentation/x86/sgx.rst
> > > @@ -100,6 +100,23 @@ pages and establish enclave page permissions.
> > >                  sgx_ioc_enclave_init
> > >                  sgx_ioc_enclave_provision
> > > 
> > > +Enclave memory mapping
> > > +----------------------
> > > +
> > > +A file descriptor created from opening **/dev/sgx_enclave** represents an
> > > +enclave object. The mmap() syscall with enclave file descriptors does not
> > > +support non-zero value for the 'offset' parameter.
> > 
> > I think we all need to understand better why SGX driver requires anonymous
> > semantics mmap() against /dev/sgx_enclave, and as a result of that, requires
> > mmap() to pass  0 as pgoff (which looks wasn't even discussed when upstreaming
> > the driver).
> > 
> > I'll do some investigation and try to summerize and report back.  Thanks.
> > 
> 
> + Sean.
> 
> Hi Sean,
> 
> If you see this and have time, please help to comment.  Thanks.
> 
> I've spent plenty of time to look into the discussions around v20/v28/v29 and
> roughly v38/v39 to find out why SGX driver requires MAP_ANONYMOUS semantics,
> AFAICT it turns out it was never explicitly discussed.  Or perhaps the
> "MAP_ANONYMOUS semantics" actually just means "MAP_SHARED | MAP_FIXED + pgoff is
> ignored", and everyone believed there was no need to explain what does "SGX
> driver uses MAP_ANONYMOUS semantics for mmap()" mean.
> 
> Details:
> 
> The v20 story (that I spent most of my time on) mentioned by Haitao was actually
> about how to make SGX and LSM work together but not related to SGX driver mmap()
> semantic. 
> 
> Also Haitao mentioned "the use of anonymous mapping can be traced back to v29"
> but this actually was just about how to use the first mmap() to "reserve the
> ELRANGE before ECREATE".  It wasn't about to changing mmap(/dev/sgx_enclave)
> semantics at all.
> 
> Sean actually suggested to explicitly document "how does SGX driver recommend
> the user to reserve ELRANGE", but Jarkko didn't think we should do:
> 
> https://lore.kernel.org/linux-sgx/20200528111910.GB1666298@linux.intel.com/
> 
> which is a pity IMHO, because I believe for anyone, naturally, the first
> instinct to reserve ELRANGE is to use mmap(/dev/sgx_enclave) but not
> mmap(MAP_ANONYMOUS).  If we suggest user to use the latter then there must be
> some reason and IMHO such suggestion and reason should be documented.

Ya, the use of mmap() on fd=-1 is done in order to find an available, naturally
aligned chunk of virtual memory[*].  IIRC, there was a (very brief) discussion
about enhancing .mmap() so that userspace wouldn't be responsible for doing the
alignment, but I think we didn't pursue that idea very because we had bigger fish
to fry.

But I think this is unrelated to what you really care about, e.g. a userspace that
tightly controls its virtual memory could hardcode enclave placement (IIRC graphene
did/does do that).  I.e. the alignment issue is a completely different discussion.

[*] https://lore.kernel.org/all/20190522153836.GA24833@linux.intel.com

> Also, if I am not missing something, the current driver doesn't prevent using
> mmap(/dev/sgx_enclave, PROT_NONE) to reserve ELANGE.  So having clear
> documentation is helpful for SGX users to choose how to write their apps.
> 
> Go back to the "SGX driver uses MAP_ANONYMOUS semantics for mmap()", I believe
> this just is "SGX driver requires mmap() after ECREATE/EINIT to use MAP_SHARED |
> MAP_FIXED and pgoff is ignored".  Or more precisely, pgoff is "not _used_ by SGX
> driver".
> 
> In fact, I think "pgoff is ignored/not used" is technically wrong for enclave.

Yeah, it's wrong.  It works because, until now apparently, there was never a reason
a need to care about the file offset since ELRANGE base always provided the necessary
information.  It wasn't a deliberate design choice, we simply overlooked that detail
(unless Jarkko was holding back on me all those years ago :-) ).
 
> IMHO we should stop saying SGX driver uses MAP_ANONYMOUS semantics, because the
> truth is it just takes advantage of MAP_FIXED and carelessly ignores the pgoff
> due to the nature of SGX w/o considering from core-MM's perspective.
>   
> And IMHO there are two ways to fix:
> 
> 1) From now on, we ask SGX apps to use the correct pgoff in their
> mmap(/dev/sgx_enclave).  This shouldn't impact the existing SGX apps because SGX
> driver doesn't use vma->pgoff anyway.

Heh, just "asking" won't help.  And breaking userspace, i.e. requiring all apps
to update, will just get you yelled at :-)

> 2) For the sake of avoiding having to ask existing SGX apps to change their
> mmap()s, we _officially_ say that userspace isn't required to pass a correct
> pgoff to mmap() (i.e. passing 0 as did in existing apps), but the kernel should
> fix the vma->pgoff internally.

I recommend you don't do this.  Overwriting vm_pgoff would probably work, but it's
going to make a flawed API even messier.  E.g. you'll have painted SGX into a
corner if you ever want to decouple vma->start/end from encl->base.  I highly
doubt that will ever happen given how ELRANGE works, but I don't think a hack-a-fix
buys you enough to justify any more ugliness.

> I do prefer option 2) because it has no harm to anyone: 1) No changes to
> existing SGX apps; 2) It aligns with the core-MM to so all existing mmap()
> operations should work as expected, meaning no surprise; 3) And this patchset
> from Haitao to use fadvice() to accelerate EAUG flow just works.

I think you can have your cake and eat it too.  IIUC, the goal is to get fadvise()
working, and to do that without creating a truly heinous uAPI, you need an accurate
vm_pgoff.  So, use a carrot and stick approach.

If userspace properly defines vm_pgoff during mmap() and doesn't specify MAP_ANONYMOUS,
then they get to use fadvise() (give 'em a carrot).  But if *any* mmap() on the
enclave doesn't followo those rules, mark the enclave as tainted or whatever and
disallow fadvise() (hit 'em with a stick).

That way there is no ABI breakage and no chance of causing weirdness for existing
userspace applications, while at the same time enabling the fadvise() for userspace
that has been updated to play nice.  And as a bonus, the actual (and sane) semantics
will be shown in userspace apps that are updated to do the right thing.
