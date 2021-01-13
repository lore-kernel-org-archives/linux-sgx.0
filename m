Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41D2C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 17:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8144023434
	for <linux-sgx@archiver.kernel.org>; Wed, 13 Jan 2021 17:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbhAMRqo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 12:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbhAMRqo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 12:46:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291E92337F;
        Wed, 13 Jan 2021 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610559963;
        bh=P1q1obOCVIPW4fDUE6Iu/JviaKvmorHYg/9TVGkiS8c=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=K8rWQne1EXt+P8L/P3vncKBK9n/yQ8rg8j69ZBtRMBZGy8R5hdqO0lHg8n6X1BU8E
         OC2kmm7PbTlT4IGKfXZ+wtn1kxAkL9kzlLoXzUalIIsdHKCjpgTkN5bTCP5cW917PW
         QT1qgxOplr9+tDTnZJPhOe95a+bF+XvoA89NrhqH0In4LWfpCmhFxVkppypFbT3pAp
         V4rx/9dJT5659NW47KqKz2u/wVr+3UOpJWSOLkWpSD4A/qJ0WgxPiEAYfLENjBmULw
         GpxcL1ewrYh1tXHh81nu4rhKhigLHJuVk2tX1IihHnVouQKj+KxcmeHqcHoxBGjKJY
         N90OIWwlxW+UA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id D91BF3522AC3; Wed, 13 Jan 2021 09:46:02 -0800 (PST)
Date:   Wed, 13 Jan 2021 09:46:02 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20210113174602.GV2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic>
 <X/zoarV7gd/LNo4A@kernel.org>
 <20210112183550.GK13086@zn.tnic>
 <X/8rX1yFxiN79QCn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8rX1yFxiN79QCn@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 13, 2021 at 07:18:23PM +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 12, 2021 at 07:35:50PM +0100, Borislav Petkov wrote:
> > + paulmck.
> > 
> > On Tue, Jan 12, 2021 at 02:08:10AM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Jan 05, 2021 at 03:57:49PM +0100, Borislav Petkov wrote:
> > > > On Wed, Dec 16, 2020 at 03:49:20PM +0200, Jarkko Sakkinen wrote:
> > > > > Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
> > > > > period initiated by sgx_mmu_notifier_release().
> > > > > 
> > > > > A trivial example of a failing sequence with tasks A and B:
> > > > > 
> > > > > 1. A: -> sgx_release()
> > > > > 2. B: -> sgx_mmu_notifier_release()
> > > > > 3. B: -> list_del_rcu()
> > > > > 3. A: -> sgx_encl_release()
> > > > > 4. A: -> cleanup_srcu_struct()
> > > > > 
> > > > > The loop in sgx_release() observes an empty list because B has removed its
> > > > > entry in the middle, and calls cleanup_srcu_struct() before B has a chance
> > > > > to calls synchronize_srcu().
> > > > 
> > > > Leading to what? NULL ptr?
> > > > 
> > > > https://lkml.kernel.org/r/X9e2jOWz1hfXVpQ5@google.com
> > > > 
> > > > already suggested that you should explain the bug better and add the
> > > > splat but I'm still missing that explanation.
> > > 
> > > OK, I'll try to explain it how I understand the issue.
> > > 
> > > Consider this loop in the VFS release hook (sgx_release):
> > > 
> > > 	/*
> > > 	 * Drain the remaining mm_list entries. At this point the list contains
> > > 	 * entries for processes, which have closed the enclave file but have
> > > 	 * not exited yet. The processes, which have exited, are gone from the
> > > 	 * list by sgx_mmu_notifier_release().
> > > 	 */
> > > 	for ( ; ; )  {
> > > 		spin_lock(&encl->mm_lock);
> > > 
> > > 		if (list_empty(&encl->mm_list)) {
> > > 			encl_mm = NULL;
> > > 		} else {
> > > 			encl_mm = list_first_entry(&encl->mm_list,
> > > 						   struct sgx_encl_mm, list);
> > > 			list_del_rcu(&encl_mm->list);
> > > 		}
> > > 
> > > 		spin_unlock(&encl->mm_lock);
> > > 
> > > 		/* The enclave is no longer mapped by any mm. */
> > > 		if (!encl_mm)
> > > 			break;
> > > 
> > > 		synchronize_srcu(&encl->srcu);
> > > 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> > > 		kfree(encl_mm);
> > > 	}
> > > 
> > > 
> > > At this point all processes have closed the enclave file, but that doesn't
> > > mean that they all have exited yet.
> > > 
> > > Now, let's imagine that there is exactly one entry in the encl->mm_list.
> > > and sgx_release() execution gets scheduled right after returning from
> > > synchronize_srcu().
> > > 
> > > With some bad luck, some process comes and removes that last entry befoe
> > > sgx_release() acquires mm_lock. The loop in sgx_release() just leaves
> > > 
> > > 		/* The enclave is no longer mapped by any mm. */
> > > 		if (!encl_mm)
> > > 			break;
> > > 
> > > No synchronize_srcu().
> > > 
> > > After writing this, I think that the placement for synchronize_srcu()
> > > in this patch is not best possible. It should be rather that the
> > > above loop would also call synchronize_srcu() when leaving.
> > > 
> > > I.e. the code change would result:
> > > 
> > > 	for ( ; ; )  {
> > > 		spin_lock(&encl->mm_lock);
> > > 
> > > 		if (list_empty(&encl->mm_list)) {
> > > 			encl_mm = NULL;
> > > 		} else {
> > > 			encl_mm = list_first_entry(&encl->mm_list,
> > > 						   struct sgx_encl_mm, list);
> > > 			list_del_rcu(&encl_mm->list);
> > > 		}
> > > 
> > > 		spin_unlock(&encl->mm_lock);
> > > 
> > >                 /* 
> > >                  * synchronize_srcu() is mandatory *even* when the list was
> > >                  * empty, in order make sure that grace periods stays in
> > >                  * sync even when another task took away the last entry
> > >                  * (i.e. exiting process when it deletes its mm_list).
> > >                  */
> > > 		synchronize_srcu(&encl->srcu);
> > > 
> > > 		/* The enclave is no longer mapped by any mm. */
> > > 		if (!encl_mm)
> > > 			break;
> > > 
> > > 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> > > 		kfree(encl_mm);
> > > 	}
> > > 
> > > What do you think? Does this start to make more sense now?
> > > I don't have logs for this but the bug can be also reasoned.
> > 
> > It does. Now you need to write it up in a detailed form so that it is
> > clear to readers months/years from now what exactly can happen. You can
> > use a two-column format like
> > 
> > 	CPU A				CPU B
> > 
> > Bla
> > 					Blu
> > 
> > This happens now here
> > 					But this needs to happen there
> > 
> > and so on.
> > 
> > Also, from reading up a bit on this, Documentation/RCU/checklist.rst says
> > 
> > "Use of the expedited primitives should be restricted to rare
> > configuration-change operations that would not normally be undertaken
> > while a real-time workload is running."
> > 
> > so why are you using synchronize_srcu_expedited()? Grepping the tree
> > reveals only a couple of call sites only... but I've almost no clue of
> > RCU so lemme CC Paul.
> 
> It spun out of this discussion:
> 
> https://lore.kernel.org/linux-sgx/20201215213517.GA34761@kernel.org/raw
> 
> My reasoning was that this is not a common case. The main loop
> that uses synchronize_srcu().

It seems to me that loading and unloading SGX enclaves qualifies as a
configuration operation, so use of synchronize_srcu_expedited() should be
just fine in that case.  This of course implies that SGX enclaves should
not be loaded or unloaded while an aggressive real-time application
is running.  Which might well be the case for other reasons.

So I believe synchronize_srcu_expedited() should be fine in this case.

							Thanx, Paul
