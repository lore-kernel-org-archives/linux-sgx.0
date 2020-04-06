Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84544C2BA19
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 14:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61CD021473
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 14:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgDFOou (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:44:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:40631 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgDFOou (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 10:44:50 -0400
IronPort-SDR: 8tO4pTac2SgkQmiIxfA/3PxMdcOSVr+yALqN65YAwMe5oAiFfgVcHDUJ+oYS5fgskD2QVBbT+7
 noxSflIqww4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 07:44:50 -0700
IronPort-SDR: rP3BJO1QjE6jFLVseekvs5AOuaxQPAg44uY/cyEZ+o5AXdnULMPzvA+9WWRSt6lynfxfsalhrV
 4kpZVHUa85kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,351,1580803200"; 
   d="scan'208";a="285907519"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 06 Apr 2020 07:44:49 -0700
Date:   Mon, 6 Apr 2020 07:44:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200406144449.GD21330@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
 <20200403233237.GA11802@linux.intel.com>
 <20200403233547.GI2701@linux.intel.com>
 <20200404011248.GB24717@linux.intel.com>
 <20200406143155.GA21330@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406143155.GA21330@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 07:31:55AM -0700, Sean Christopherson wrote:
> On Sat, Apr 04, 2020 at 04:12:48AM +0300, Jarkko Sakkinen wrote:
> > On Fri, Apr 03, 2020 at 04:35:47PM -0700, Sean Christopherson wrote:
> > > On Sat, Apr 04, 2020 at 02:33:31AM +0300, Jarkko Sakkinen wrote:
> > > > On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > -	idx = srcu_read_lock(&encl->srcu);
> > > > > +	do {
> > > > > +		mm_list_version = encl->mm_list_version;
> > > > >  
> > > > > -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > > > > -		if (!mmget_not_zero(encl_mm->mm))
> > > > > -			continue;
> > > > > +		/* Fence reads as the CPU can reorder them. This guarantees
> > > > > +		 * that we don't access old list with a new version.
> > > > > +		 */
> > > > > +		smp_rmb();
> > > > >  
> > > > > -		down_read(&encl_mm->mm->mmap_sem);
> > > > > +		idx = srcu_read_lock(&encl->srcu);
> > > > >  
> > > > > -		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> > > > > -		if (!ret && encl == vma->vm_private_data)
> > > > > -			zap_vma_ptes(vma, addr, PAGE_SIZE);
> > > > > +		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > > > > +			if (!mmget_not_zero(encl_mm->mm))
> > > > > +				continue;
> > > > >  
> > > > > -		up_read(&encl_mm->mm->mmap_sem);
> > > > > +			down_read(&encl_mm->mm->mmap_sem);
> > > > >  
> > > > > -		mmput_async(encl_mm->mm);
> > > > > -	}
> > > > > +			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> > > > > +			if (!ret && encl == vma->vm_private_data)
> > > > > +				zap_vma_ptes(vma, addr, PAGE_SIZE);
> > > > >  
> > > > > -	srcu_read_unlock(&encl->srcu, idx);
> > > > > +			up_read(&encl_mm->mm->mmap_sem);
> > > > > +
> > > > > +			mmput_async(encl_mm->mm);
> > > > > +		}
> > > > > +
> > > > > +		srcu_read_unlock(&encl->srcu, idx);
> > > > > +	} while (unlikely(encl->mm_list_version != mm_list_version));
> > > > 
> > > > This is bad, or at least makes the code unnecessarily hard to understand
> > > > given the use of the fences: encl->mm_list_version is read twice per
> > > > iteration.
> > > > 
> > > > I'll change the code to use "for ( ; ; )" and have exactly one read per
> > > > iteration.
> > > 
> > > It has to be read twice per iteration, the whole point is to see if the
> > > version at the start of the iteration matches the version at the end.
> > 
> > Nope if you use zero version as invalid version.
> 
> Which would break if more than one mm is added to an enclave.

Ah, you mean within the function (just saw v3).
