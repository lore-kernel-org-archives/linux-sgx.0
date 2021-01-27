Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E29C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Jan 2021 17:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C5B64DA3
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Jan 2021 17:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343857AbhA0ReP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236068AbhA0Rck (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Jan 2021 12:32:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 967F064DA3;
        Wed, 27 Jan 2021 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611768719;
        bh=Vkt0ZsFBlrd7g34AHEPam3yDnElZNg8bGSX04AofNEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OkMX5ORQm7VRXLhFMxaVx+FiqIn5Fi6HllVzNf6uqTFc195dx5pGgDLCCcKI2hCmA
         /YLE1RlSEoPKEC24u3Wo7cwxW7NSdpxaU83eVHqgphM+Puvs0GqOc298CagJFp2WFA
         GEBKTbfM0VU29CupNB/W1p9hCGwaTPQjlOXXUdW/3+5moAceeybb9mUsfvZFiJbNac
         3gX2nm7NmzeI+EMNd5iLr0n/yhoY9Z4NbfRBdnpqFjWMd69rzikyaKYTs0YIs//bvS
         HcBuOpO/xlERTce09zQM8pgt/YUWFJOLeybiANNUcmZINZUKwZ1gX4byhvP4cg51BO
         Wqpx1loiJEnwA==
Date:   Wed, 27 Jan 2021 19:31:55 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kai.huang@intel.com, haitao.huang@intel.com,
        stable@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v4] x86/sgx: Fix the call order of synchronize_srcu() in
 sgx_release()
Message-ID: <YBGji9ZAS23r35Vo@kernel.org>
References: <20210115014638.15037-1-jarkko@kernel.org>
 <YAhp4Jrj6hIcvgRC@google.com>
 <8d232931-3675-efea-2b53-a0c76e723bff@intel.com>
 <YAvlLxCfN88Ii5qb@kernel.org>
 <5b881022-d9f1-3ac4-89e5-7da6d6ce2fc8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b881022-d9f1-3ac4-89e5-7da6d6ce2fc8@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 25, 2021 at 07:49:04AM -0800, Dave Hansen wrote:
> Haitao managed to create another splat over the weekend.  It was, indeed:
> 
> > WARNING: CPU: 3 PID: 7620 at kernel/rcu/srcutree.c:374 cleanup_srcu_struct+0xed/0x100
> 
> which is:
> 
> >         if (WARN_ON(!srcu_get_delay(ssp)))
> >                 return; /* Just leak it! */
> 
> That check means that there is an outstanding "expedited" grace period.
>  The fact that it's expedited is not important.  This:
> 
> 	https://lwn.net/Articles/202847/
> 
> describes the reasoning behind the warning:
> 
> 	If the struct srcu_struct is dynamically allocated, then
> 	cleanup_srcu_struct() must be called before it is freed ... the
> 	caller must take care to ensure that all SRCU read-side critical
> 	sections have completed (and that no more will commence) before
> 	calling cleanup_srcu_struct().
> 
> synchronize_srcu() will (obviously) wait for the grace period to
> complete.  Calling it will shut up the warning for sure, most of the time.
> 
> The required sequence of events is in here:
> 
> > https://lore.kernel.org/lkml/1492472726-3841-4-git-send-email-paulmck@linux.vnet.ibm.com/

I'll add "Link:" for this to the final fix. It's a good reference.

> I suspect that the mmu notifier's synchronize_srcu() is run in parallel
> very close to when cleanup_srcu_struct() is called.  This violates the
> "prevent any further calls to synchronize_srcu" rule.
> 
> So, while I suspect that adding a synchronize_srcu() is *part* of the
> correct solution, I'm still not convinced that the
> sgx_mmu_notifier_release() code is correct.

What Sean suggested in private discussion, i.e. using kref_get() in the MMU
notifier AFAIK should be enough to do the necessary serialization.

/Jarkko
