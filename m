Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86920C43331
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 23:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EC2B206F8
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 23:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgDCXfs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 19:35:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:65092 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgDCXfr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Apr 2020 19:35:47 -0400
IronPort-SDR: PuEYsFlCZaL+v9p9I5vZo1VucZ/bwv1K8JEkXC8UHaylKtyvD1HfjY+vk2wygz0QvY18EIy7ad
 b491xggRyeVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 16:35:47 -0700
IronPort-SDR: X+xQFYZshz4pPQ7m64Y20GBdB9gs9btrVnqsUoC958yXmBGsCt05NoztOECeosvPldAZPNNWS+
 vi8/FUJ9B15g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,341,1580803200"; 
   d="scan'208";a="253526601"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 03 Apr 2020 16:35:47 -0700
Date:   Fri, 3 Apr 2020 16:35:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200403233547.GI2701@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
 <20200403233237.GA11802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403233237.GA11802@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 04, 2020 at 02:33:31AM +0300, Jarkko Sakkinen wrote:
> On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > -	idx = srcu_read_lock(&encl->srcu);
> > +	do {
> > +		mm_list_version = encl->mm_list_version;
> >  
> > -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > -		if (!mmget_not_zero(encl_mm->mm))
> > -			continue;
> > +		/* Fence reads as the CPU can reorder them. This guarantees
> > +		 * that we don't access old list with a new version.
> > +		 */
> > +		smp_rmb();
> >  
> > -		down_read(&encl_mm->mm->mmap_sem);
> > +		idx = srcu_read_lock(&encl->srcu);
> >  
> > -		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> > -		if (!ret && encl == vma->vm_private_data)
> > -			zap_vma_ptes(vma, addr, PAGE_SIZE);
> > +		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > +			if (!mmget_not_zero(encl_mm->mm))
> > +				continue;
> >  
> > -		up_read(&encl_mm->mm->mmap_sem);
> > +			down_read(&encl_mm->mm->mmap_sem);
> >  
> > -		mmput_async(encl_mm->mm);
> > -	}
> > +			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> > +			if (!ret && encl == vma->vm_private_data)
> > +				zap_vma_ptes(vma, addr, PAGE_SIZE);
> >  
> > -	srcu_read_unlock(&encl->srcu, idx);
> > +			up_read(&encl_mm->mm->mmap_sem);
> > +
> > +			mmput_async(encl_mm->mm);
> > +		}
> > +
> > +		srcu_read_unlock(&encl->srcu, idx);
> > +	} while (unlikely(encl->mm_list_version != mm_list_version));
> 
> This is bad, or at least makes the code unnecessarily hard to understand
> given the use of the fences: encl->mm_list_version is read twice per
> iteration.
> 
> I'll change the code to use "for ( ; ; )" and have exactly one read per
> iteration.

It has to be read twice per iteration, the whole point is to see if the
version at the start of the iteration matches the version at the end.
