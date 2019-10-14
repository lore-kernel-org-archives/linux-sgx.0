Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC2EC4CECE
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 23:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C17482064B
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 23:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfJNX4f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 19:56:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:34628 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbfJNX4f (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 19:56:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 16:56:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="225242149"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 14 Oct 2019 16:56:34 -0700
Date:   Mon, 14 Oct 2019 16:56:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 1/9] x86/sgx: WARN once if an enclave is released
 with unfreed EPC pages
Message-ID: <20191014235634.GQ22962@linux.intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
 <20191010214301.25669-2-sean.j.christopherson@intel.com>
 <20191014203156.GQ15552@linux.intel.com>
 <20191014203343.GR15552@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014203343.GR15552@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 14, 2019 at 11:33:43PM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 14, 2019 at 11:31:56PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 10, 2019 at 02:42:53PM -0700, Sean Christopherson wrote:
> > > Add a WARN to detect EPC page leaks when releasing an enclave.  The
> > > release flow uses the common sgx_encl_destroy() helper, which is allowed
> > > to be called while the reclaimer holds references to the enclave's EPC
> > > pages and so can't WARN in the scenario where the SECS is leaked because
> > > it has active child pages.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/encl.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > > index c13c3ba3430a..b4d7b2f9609f 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > > @@ -511,6 +511,7 @@ void sgx_encl_release(struct kref *ref)
> > >  		fput(encl->backing);
> > >  
> > >  	WARN_ONCE(!list_empty(&encl->mm_list), "mm_list non-empty");
> > > +	WARN_ON_ONCE(encl->secs_child_cnt || encl->secs.epc_page);
> > 
> > I'd prefer to have two WARN_ON_ONCE()'s. I think disjunction's should
> > not be used with WARN*() (conjunction's obviously should when they are
> > required).
> > 
> > I changed this to:
> > 
> > 	/* Detect EPC page leak's. */
> > 	WARN_ON_ONCE(encl->secs_child_cnt);
> > 	WARN_ON_ONCE(encl->secs.epc_page);
> > 
> > The patch has been merged.
> 
> Should the mm_list check also use the same macro? The associated message
> is somewhat useless, isn't it?

Yep.
