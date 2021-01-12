Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28610C432C3
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 00:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D0F322D58
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 00:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403842AbhALA0E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404233AbhALAI5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 11 Jan 2021 19:08:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8301922D2C;
        Tue, 12 Jan 2021 00:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610410096;
        bh=ZewBbOKkpJFchFbmCZ2t2HXICe9jRma7+PRcg0QLhoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZrOF6SWwnRq/819rEVH+s39VkacuDYLuubjg/DrDZ/6zuEkUUobNKLtiDVOu1D26w
         ORYfCTgoXSyNyFkN1uWDQWDg3lCKzNTjRut3BJvESRSMD9G2GBTgaZE+Gv7rW+xdjl
         RIwZorjRk9Yrvs2oaLkMNzOhTpOmhqjP+y8Cicq8ic/Dug9CGfwEzFHxnVZZbo59Ko
         42rQ5S8XEksXQooA26IilkYH4Y5yeBIZZtyJppEbRjl0F7utl2H8rWOVYE6TxGNlBB
         Ix5M14NXnAvMt2IiBo1z/Of1txMoWLtqFOxTLkCNGPMtaNtnE1EN/c/8mLJ+YO1dbu
         F5QfDGTcOWmyw==
Date:   Tue, 12 Jan 2021 02:08:10 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <X/zoarV7gd/LNo4A@kernel.org>
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105145749.GF28649@zn.tnic>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 05, 2021 at 03:57:49PM +0100, Borislav Petkov wrote:
> On Wed, Dec 16, 2020 at 03:49:20PM +0200, Jarkko Sakkinen wrote:
> > Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
> > period initiated by sgx_mmu_notifier_release().
> > 
> > A trivial example of a failing sequence with tasks A and B:
> > 
> > 1. A: -> sgx_release()
> > 2. B: -> sgx_mmu_notifier_release()
> > 3. B: -> list_del_rcu()
> > 3. A: -> sgx_encl_release()
> > 4. A: -> cleanup_srcu_struct()
> > 
> > The loop in sgx_release() observes an empty list because B has removed its
> > entry in the middle, and calls cleanup_srcu_struct() before B has a chance
> > to calls synchronize_srcu().
> 
> Leading to what? NULL ptr?
> 
> https://lkml.kernel.org/r/X9e2jOWz1hfXVpQ5@google.com
> 
> already suggested that you should explain the bug better and add the
> splat but I'm still missing that explanation.

OK, I'll try to explain it how I understand the issue.

Consider this loop in the VFS release hook (sgx_release):

	/*
	 * Drain the remaining mm_list entries. At this point the list contains
	 * entries for processes, which have closed the enclave file but have
	 * not exited yet. The processes, which have exited, are gone from the
	 * list by sgx_mmu_notifier_release().
	 */
	for ( ; ; )  {
		spin_lock(&encl->mm_lock);

		if (list_empty(&encl->mm_list)) {
			encl_mm = NULL;
		} else {
			encl_mm = list_first_entry(&encl->mm_list,
						   struct sgx_encl_mm, list);
			list_del_rcu(&encl_mm->list);
		}

		spin_unlock(&encl->mm_lock);

		/* The enclave is no longer mapped by any mm. */
		if (!encl_mm)
			break;

		synchronize_srcu(&encl->srcu);
		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
		kfree(encl_mm);
	}


At this point all processes have closed the enclave file, but that doesn't
mean that they all have exited yet.

Now, let's imagine that there is exactly one entry in the encl->mm_list.
and sgx_release() execution gets scheduled right after returning from
synchronize_srcu().

With some bad luck, some process comes and removes that last entry befoe
sgx_release() acquires mm_lock. The loop in sgx_release() just leaves

		/* The enclave is no longer mapped by any mm. */
		if (!encl_mm)
			break;

No synchronize_srcu().

After writing this, I think that the placement for synchronize_srcu()
in this patch is not best possible. It should be rather that the
above loop would also call synchronize_srcu() when leaving.

I.e. the code change would result:

	for ( ; ; )  {
		spin_lock(&encl->mm_lock);

		if (list_empty(&encl->mm_list)) {
			encl_mm = NULL;
		} else {
			encl_mm = list_first_entry(&encl->mm_list,
						   struct sgx_encl_mm, list);
			list_del_rcu(&encl_mm->list);
		}

		spin_unlock(&encl->mm_lock);

                /* 
                 * synchronize_srcu() is mandatory *even* when the list was
                 * empty, in order make sure that grace periods stays in
                 * sync even when another task took away the last entry
                 * (i.e. exiting process when it deletes its mm_list).
                 */
		synchronize_srcu(&encl->srcu);

		/* The enclave is no longer mapped by any mm. */
		if (!encl_mm)
			break;

		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
		kfree(encl_mm);
	}

What do you think? Does this start to make more sense now?
I don't have logs for this but the bug can be also reasoned.

/Jarkko
