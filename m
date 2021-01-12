Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B94CC10F04
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 21:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54DE923127
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 21:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438051AbhALVhU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436696AbhALULn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 15:11:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2354222EBE;
        Tue, 12 Jan 2021 20:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610482262;
        bh=dxftOsfFNZ+kUOtlx8vuklb7fxJgIPKcVed4FbyQlLE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=bDsiMi6pHE+zUVeK0NNWR/zbPy2o+WRQngfEgN/VRCXYY0J+wu3ZCZtsg4iYuppEf
         A3DX4MA565bVcWax5jyH9COSRaaumefUXfPkgRM2u4ZEKDsvAjPBtZqSk/J6qqzQ9n
         4teznISEyhAMSVvEZPxZ1T9kQKkJNZyo3lOxKP8xlD6JlcU0SUU4NnP6Pq7Pz6D1rz
         Vy+yyQsDrqGYVqUNkimDiwPLmDftWidEmSiOJA6qZl6gAZCtTerCPWO0PTKxckK5uT
         h24NHjG+o1UCwtpG8t1DNmfhptLgMItXWu7vo4D8V4DRg+2rD7+oiRVHMmCmAKFnde
         1/UOe5W1UhfxA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id BCDC93522AC3; Tue, 12 Jan 2021 12:11:01 -0800 (PST)
Date:   Tue, 12 Jan 2021 12:11:01 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20210112201101.GL2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic>
 <X/zoarV7gd/LNo4A@kernel.org>
 <20210112183550.GK13086@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112183550.GK13086@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 12, 2021 at 07:35:50PM +0100, Borislav Petkov wrote:
> + paulmck.
> 
> On Tue, Jan 12, 2021 at 02:08:10AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 05, 2021 at 03:57:49PM +0100, Borislav Petkov wrote:
> > > On Wed, Dec 16, 2020 at 03:49:20PM +0200, Jarkko Sakkinen wrote:
> > > > Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
> > > > period initiated by sgx_mmu_notifier_release().
> > > > 
> > > > A trivial example of a failing sequence with tasks A and B:
> > > > 
> > > > 1. A: -> sgx_release()
> > > > 2. B: -> sgx_mmu_notifier_release()
> > > > 3. B: -> list_del_rcu()
> > > > 3. A: -> sgx_encl_release()
> > > > 4. A: -> cleanup_srcu_struct()
> > > > 
> > > > The loop in sgx_release() observes an empty list because B has removed its
> > > > entry in the middle, and calls cleanup_srcu_struct() before B has a chance
> > > > to calls synchronize_srcu().
> > > 
> > > Leading to what? NULL ptr?
> > > 
> > > https://lkml.kernel.org/r/X9e2jOWz1hfXVpQ5@google.com
> > > 
> > > already suggested that you should explain the bug better and add the
> > > splat but I'm still missing that explanation.
> > 
> > OK, I'll try to explain it how I understand the issue.
> > 
> > Consider this loop in the VFS release hook (sgx_release):
> > 
> > 	/*
> > 	 * Drain the remaining mm_list entries. At this point the list contains
> > 	 * entries for processes, which have closed the enclave file but have
> > 	 * not exited yet. The processes, which have exited, are gone from the
> > 	 * list by sgx_mmu_notifier_release().
> > 	 */
> > 	for ( ; ; )  {
> > 		spin_lock(&encl->mm_lock);
> > 
> > 		if (list_empty(&encl->mm_list)) {
> > 			encl_mm = NULL;
> > 		} else {
> > 			encl_mm = list_first_entry(&encl->mm_list,
> > 						   struct sgx_encl_mm, list);
> > 			list_del_rcu(&encl_mm->list);
> > 		}
> > 
> > 		spin_unlock(&encl->mm_lock);
> > 
> > 		/* The enclave is no longer mapped by any mm. */
> > 		if (!encl_mm)
> > 			break;
> > 
> > 		synchronize_srcu(&encl->srcu);
> > 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> > 		kfree(encl_mm);
> > 	}
> > 
> > 
> > At this point all processes have closed the enclave file, but that doesn't
> > mean that they all have exited yet.
> > 
> > Now, let's imagine that there is exactly one entry in the encl->mm_list.
> > and sgx_release() execution gets scheduled right after returning from
> > synchronize_srcu().
> > 
> > With some bad luck, some process comes and removes that last entry befoe
> > sgx_release() acquires mm_lock. The loop in sgx_release() just leaves
> > 
> > 		/* The enclave is no longer mapped by any mm. */
> > 		if (!encl_mm)
> > 			break;
> > 
> > No synchronize_srcu().
> > 
> > After writing this, I think that the placement for synchronize_srcu()
> > in this patch is not best possible. It should be rather that the
> > above loop would also call synchronize_srcu() when leaving.
> > 
> > I.e. the code change would result:
> > 
> > 	for ( ; ; )  {
> > 		spin_lock(&encl->mm_lock);
> > 
> > 		if (list_empty(&encl->mm_list)) {
> > 			encl_mm = NULL;
> > 		} else {
> > 			encl_mm = list_first_entry(&encl->mm_list,
> > 						   struct sgx_encl_mm, list);
> > 			list_del_rcu(&encl_mm->list);
> > 		}
> > 
> > 		spin_unlock(&encl->mm_lock);
> > 
> >                 /* 
> >                  * synchronize_srcu() is mandatory *even* when the list was
> >                  * empty, in order make sure that grace periods stays in
> >                  * sync even when another task took away the last entry
> >                  * (i.e. exiting process when it deletes its mm_list).
> >                  */
> > 		synchronize_srcu(&encl->srcu);
> > 
> > 		/* The enclave is no longer mapped by any mm. */
> > 		if (!encl_mm)
> > 			break;
> > 
> > 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> > 		kfree(encl_mm);
> > 	}
> > 
> > What do you think? Does this start to make more sense now?
> > I don't have logs for this but the bug can be also reasoned.
> 
> It does. Now you need to write it up in a detailed form so that it is
> clear to readers months/years from now what exactly can happen. You can
> use a two-column format like
> 
> 	CPU A				CPU B
> 
> Bla
> 					Blu
> 
> This happens now here
> 					But this needs to happen there
> 
> and so on.
> 
> Also, from reading up a bit on this, Documentation/RCU/checklist.rst says
> 
> "Use of the expedited primitives should be restricted to rare
> configuration-change operations that would not normally be undertaken
> while a real-time workload is running."
> 
> so why are you using synchronize_srcu_expedited()? Grepping the tree
> reveals only a couple of call sites only... but I've almost no clue of
> RCU so lemme CC Paul.

The SRCU expedited grace periods are easier on real-time workloads than
synchronize_rcu_expedited(), but the SRCU variant still burns more CPU
time on a given grace period.  But either way, as the document says
further down "However, real-time workloads can use rcupdate.rcu_normal
kernel boot parameter to completely disable expedited grace periods,
though this might have performance implications."

So what are the performance implications in this case?

							Thanx, Paul
