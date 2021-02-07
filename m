Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58175C433E0
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Feb 2021 21:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E49164E3F
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Feb 2021 21:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhBGVdB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Feb 2021 16:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhBGVcz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Feb 2021 16:32:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 798D564E2A;
        Sun,  7 Feb 2021 21:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612733535;
        bh=RivXxiZn9Zzrs/dCzu2v4UlfD0jPwYaefogKeTQvQFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p+XqyuVy29AD6v9C+SrhkPnOPenQO+PCZeBqjV6eUa7N7Ad23AFC7i0wG8vXBFY3H
         FIxlax2BVY7Kmx6I/Y4ipHkO2FRjtIhgA5JkAMvHctAGsjoiN9bdBmbN2L7PPXipPW
         Df+2eN6fW97KcLtiYDrAaB/xQ9Cx3WeOWfjxpKbTFqyQM5zyAgXdmCOEtkQSzXfIsP
         jnK0lK0Nb5af0MYn7INxZVIfIAOZB8wKS1BELc4VLn96yR5WsxAc+EM1Se893Fgw8p
         5CdVHieFfpEg84fKEqmM9uEBXIskbUnAP4pMzHhfrH4ng4kzv7PPh4hZvrJhKzOq7j
         pXvuxW2O6K9CQ==
Date:   Sun, 7 Feb 2021 23:32:06 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/sgx: Maintain encl->refcount for each
 encl->mm_list entry
Message-ID: <YCBcVsUoIM9Nw9Iy@kernel.org>
References: <20210205182840.2260-1-jarkko@kernel.org>
 <20210205182840.2260-2-jarkko@kernel.org>
 <b874673d-9d58-0d6f-ce2d-ef4d33ac5115@intel.com>
 <YCBbynuhKKjqkzzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCBbynuhKKjqkzzk@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Feb 07, 2021 at 11:29:49PM +0200, Jarkko Sakkinen wrote:
> On Fri, Feb 05, 2021 at 11:36:57AM -0800, Dave Hansen wrote:
> > On 2/5/21 10:28 AM, Jarkko Sakkinen wrote:
> > > This has been shown in tests:
> > > 
> > > [  +0.000008] WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100
> > > 
> > > There are two functions that drain encl->mm_list:
> > > 
> > > - sgx_release() (i.e. VFS release) removes the remaining mm_list entries.
> > > - sgx_mmu_notifier_release() removes mm_list entry for the registered
> > >   process, if it still exists.
> > 
> > Jarkko, I like your approach.  This actually has the potential to be a
> > lot more understandable than the fix we settled on before.
> 
> Yeah, it's more like by-the-book use of refcount, each processs gets
> a reference. This way things should be always serialized correctly.
> 
> > But I think the explanation needs some tweaking, and I think I can take
> > it a step further to make it even more straightforward.  The issue here
> > isn't *really* mm_list, it's this:
> > 
> > 	encl_mm->encl = encl;
> 
> Agreed.
> 
> This was also in center of thinking when I did this new patch.
> 
> > That literally establishes a encl_mm to encl reference and needs a
> > reference count.  That reference remains until 'encl_mm' is freed.  I
> > don't think mm_list needs to even be taken into account.
> > 
> > The most straightforward way to fix this is to take a refcount at
> > "encl_mm->encl = encl" and release it at kfree(encl_mm).  That makes a
> > *lot* of logical sense to me, and it's also trivial to audit.
> > 
> > Totally untested patch attached (adapted directly from yours).
> 
> I tested this version, and it also seems to work. Boris, can you
> pick this refined version from Dave's attachment or do you prefer
> that I do a re-send?

Nevermind. I'll send a proper patch (just noticed that the attachment
did have short summary).

/Jarkko
