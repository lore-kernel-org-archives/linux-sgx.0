Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF45C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 18:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1502311F
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 18:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392191AbhALSgj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 13:36:39 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58318 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392178AbhALSgi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 13:36:38 -0500
Received: from zn.tnic (p200300ec2f0e8c00c6af2066566de43f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8c00:c6af:2066:566d:e43f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D26E01EC05D1;
        Tue, 12 Jan 2021 19:35:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1610476557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8ewCXROtelgxCjKkS72wMIEx2jAuhJ0XY23mMMysgdk=;
        b=D2EdN9d94gJJzsALxHhZpvIXQpjcwjD00kvBv/ok8NWwS4T1e5bCob+NLHGQKL2VKtnEkT
        XRYZRPeeduvxj28PnD68h5/ormAb1b7pjvugX8RE85PtgYCsODGIVG5VgwCTQk1fU24RZx
        EGY1JfpF2qpbdKtKsjeghqLKRl4tMUs=
Date:   Tue, 12 Jan 2021 19:35:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v3] x86/sgx: Synchronize encl->srcu in sgx_encl_release().
Message-ID: <20210112183550.GK13086@zn.tnic>
References: <20201216134920.21161-1-jarkko@kernel.org>
 <20210105145749.GF28649@zn.tnic>
 <X/zoarV7gd/LNo4A@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/zoarV7gd/LNo4A@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+ paulmck.

On Tue, Jan 12, 2021 at 02:08:10AM +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 05, 2021 at 03:57:49PM +0100, Borislav Petkov wrote:
> > On Wed, Dec 16, 2020 at 03:49:20PM +0200, Jarkko Sakkinen wrote:
> > > Add synchronize_srcu_expedited() to sgx_encl_release() to catch a grace
> > > period initiated by sgx_mmu_notifier_release().
> > > 
> > > A trivial example of a failing sequence with tasks A and B:
> > > 
> > > 1. A: -> sgx_release()
> > > 2. B: -> sgx_mmu_notifier_release()
> > > 3. B: -> list_del_rcu()
> > > 3. A: -> sgx_encl_release()
> > > 4. A: -> cleanup_srcu_struct()
> > > 
> > > The loop in sgx_release() observes an empty list because B has removed its
> > > entry in the middle, and calls cleanup_srcu_struct() before B has a chance
> > > to calls synchronize_srcu().
> > 
> > Leading to what? NULL ptr?
> > 
> > https://lkml.kernel.org/r/X9e2jOWz1hfXVpQ5@google.com
> > 
> > already suggested that you should explain the bug better and add the
> > splat but I'm still missing that explanation.
> 
> OK, I'll try to explain it how I understand the issue.
> 
> Consider this loop in the VFS release hook (sgx_release):
> 
> 	/*
> 	 * Drain the remaining mm_list entries. At this point the list contains
> 	 * entries for processes, which have closed the enclave file but have
> 	 * not exited yet. The processes, which have exited, are gone from the
> 	 * list by sgx_mmu_notifier_release().
> 	 */
> 	for ( ; ; )  {
> 		spin_lock(&encl->mm_lock);
> 
> 		if (list_empty(&encl->mm_list)) {
> 			encl_mm = NULL;
> 		} else {
> 			encl_mm = list_first_entry(&encl->mm_list,
> 						   struct sgx_encl_mm, list);
> 			list_del_rcu(&encl_mm->list);
> 		}
> 
> 		spin_unlock(&encl->mm_lock);
> 
> 		/* The enclave is no longer mapped by any mm. */
> 		if (!encl_mm)
> 			break;
> 
> 		synchronize_srcu(&encl->srcu);
> 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> 		kfree(encl_mm);
> 	}
> 
> 
> At this point all processes have closed the enclave file, but that doesn't
> mean that they all have exited yet.
> 
> Now, let's imagine that there is exactly one entry in the encl->mm_list.
> and sgx_release() execution gets scheduled right after returning from
> synchronize_srcu().
> 
> With some bad luck, some process comes and removes that last entry befoe
> sgx_release() acquires mm_lock. The loop in sgx_release() just leaves
> 
> 		/* The enclave is no longer mapped by any mm. */
> 		if (!encl_mm)
> 			break;
> 
> No synchronize_srcu().
> 
> After writing this, I think that the placement for synchronize_srcu()
> in this patch is not best possible. It should be rather that the
> above loop would also call synchronize_srcu() when leaving.
> 
> I.e. the code change would result:
> 
> 	for ( ; ; )  {
> 		spin_lock(&encl->mm_lock);
> 
> 		if (list_empty(&encl->mm_list)) {
> 			encl_mm = NULL;
> 		} else {
> 			encl_mm = list_first_entry(&encl->mm_list,
> 						   struct sgx_encl_mm, list);
> 			list_del_rcu(&encl_mm->list);
> 		}
> 
> 		spin_unlock(&encl->mm_lock);
> 
>                 /* 
>                  * synchronize_srcu() is mandatory *even* when the list was
>                  * empty, in order make sure that grace periods stays in
>                  * sync even when another task took away the last entry
>                  * (i.e. exiting process when it deletes its mm_list).
>                  */
> 		synchronize_srcu(&encl->srcu);
> 
> 		/* The enclave is no longer mapped by any mm. */
> 		if (!encl_mm)
> 			break;
> 
> 		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
> 		kfree(encl_mm);
> 	}
> 
> What do you think? Does this start to make more sense now?
> I don't have logs for this but the bug can be also reasoned.

It does. Now you need to write it up in a detailed form so that it is
clear to readers months/years from now what exactly can happen. You can
use a two-column format like

	CPU A				CPU B

Bla
					Blu

This happens now here
					But this needs to happen there

and so on.

Also, from reading up a bit on this, Documentation/RCU/checklist.rst says

"Use of the expedited primitives should be restricted to rare
configuration-change operations that would not normally be undertaken
while a real-time workload is running."

so why are you using synchronize_srcu_expedited()? Grepping the tree
reveals only a couple of call sites only... but I've almost no clue of
RCU so lemme CC Paul.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
