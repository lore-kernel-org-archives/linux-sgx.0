Return-Path: <SRS0=ycpU=5Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE56C2BA19
	for <linux-sgx@archiver.kernel.org>; Thu,  9 Apr 2020 19:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9AE0206F5
	for <linux-sgx@archiver.kernel.org>; Thu,  9 Apr 2020 19:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgDITNz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 9 Apr 2020 15:13:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:27227 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbgDITNx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 9 Apr 2020 15:13:53 -0400
IronPort-SDR: x9XnF7DQO8EesCQtnhBzMQ/72qbf6vBCht/Iv/wGT3bWqnz/PUDevdu1bMS/OalYZk4jY3v1po
 NrsunOp+iEAw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 12:13:53 -0700
IronPort-SDR: RDXse5W8JfW4uIUBtChl+fWA7DUv7qFxjvZd4l9oKYd0TMnK1OpzKY9dLczkk9s21ib1ULG37D
 ZlDTDDi6Gudg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="242736798"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 09 Apr 2020 12:13:53 -0700
Date:   Thu, 9 Apr 2020 12:13:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200409191353.GB8919@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
 <20200403234239.GJ2701@linux.intel.com>
 <20200404010948.GA24717@linux.intel.com>
 <20200406143638.GB21330@linux.intel.com>
 <20200406171027.GA20105@linux.intel.com>
 <20200406171556.GB20105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406171556.GB20105@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 08:15:56PM +0300, Jarkko Sakkinen wrote:
> On Mon, Apr 06, 2020 at 08:10:29PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Apr 06, 2020 at 07:36:38AM -0700, Sean Christopherson wrote:
> > > On Sat, Apr 04, 2020 at 04:12:02AM +0300, Jarkko Sakkinen wrote:
> > > > On Fri, Apr 03, 2020 at 04:42:39PM -0700, Sean Christopherson wrote:
> > > > > On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> > > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > > @@ -221,12 +224,16 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
> > > > > >  		return ret;
> > > > > >  	}
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * The page reclaimer uses list version for synchronization instead of
> > > > > > +	 * synchronize_scru() because otherwise we could conflict with
> > > > > > +	 * dup_mmap().
> > > > > > +	 */
> > > > > >  	spin_lock(&encl->mm_lock);
> > > > > >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > > > > 
> > > > > You dropped the smp_wmb().
> > > > 
> > > > As I said to you in my review x86 pipeline does not reorder writes.
> > > 
> > > And as I pointed out in this thread, smp_wmb() is a _compiler_ barrier if
> > > and only if CONFIG_SMP=y.  The compiler can reorder list_add_rcu() and
> > > mm_list_version++ because from it's perspective there is no dependency
> > > between the two.  And that's entirely true except for the SMP case where
> > > the consumer of mm_list_version is relying on the list to be updated before
> > > the version changes.
> > 
> > I see.
> > 
> > So why not change the variable volatile given that x86 is the only
> > arch that this code gets used?
> 
> Please note that I'm fully aware of
> 
> https://www.kernel.org/doc/html/latest/process/volatile-considered-harmful.html
> 
> Just wondering. Anyway, I'll add smp_wmb() back since it is safe play
> in terms of acceptance.

Because volatile is overkill and too heavy-handed for what is needed here.
E.g. if SMP=n, then there are no barriers needed whatsover, as a CPU can't
race with itself.

Even for SMP=y, volatile is too much as it prevents optimization that would
otherwise be allowed.  For the smp_wmb() it doesn't matter much, if at all,
since the list and version are updated inside of a critical section, i.e.
barriered on both sides so the compiler can't do much optimization anyways.

But for the smp_rmb() case, the compiler is free to cache the version in a
register early on in the function, it just needs to make sure that the
access is done before starting the list walk.  If encl->mm_list_version
were volatile, the compiler would not be allowed to do such an optimization
as it'd be required to access memory exactly when it's referenced in code.

This is easily visible in the compiled code, as encl->mm_list_version is
only read from memory once per iteration (in the unlikely case that there
are multiple iterations).  It takes the do-while loop, which appears to
read encl->mm_list_version twice per iteration:

  do {
        mm_list_version = encl->mm_list_version;

        <walk list>

  } while (unlikely(encl->mm_list_version != mm_list_version));


And turns it into an optimized loop that loads encl->mm_list_version the
minimum number of times.  If encl->mm_list_version list were volatile, the
compiler would not be allowed to cache it in %rax.

        mov    0x58(%r12),%rax          // Load from encl->mm_list_version
        lea    0x40(%r12),%rbx          // Interleaved to optimize ALU vs LD
        and    $0xfffffffffffff000,%rbp // Interleaved to optimize ALU vs LD
        mov    %rax,0x8(%rsp)           // mm_list_version = encl->mm_list_version


  walk_mm_list:
        <blah blah blah>

        mov    0x58(%r12),%rax          // Load from encl->mm_list_version
        cmp    0x8(%rsp),%rax           // Compare against mm_list_version
        jne    update_mm_list_version

        <happy path>
        ret

  update_mm_list_version:
        mov    %rax,0x8(%rsp)           // mm_list_version = encl->mm_list_version
        jmpq   0xffffffff8102e460 <walk_mm_list>
