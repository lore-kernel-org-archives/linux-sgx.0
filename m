Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD57BC2BA19
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 14:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9697F23D6B
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 14:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgDFOb4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:31:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:17400 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbgDFOb4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 10:31:56 -0400
IronPort-SDR: gZem2lD8NHLJ2NHBo3GqscVpJIl4mIGQKO7PbI7A+DzU5XLlgYioOS6Nt7WHvr/Sp1CsltERqB
 enlQVYHQoWiw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 07:31:55 -0700
IronPort-SDR: 5CyuNZBPjHsfy2vKoLYEMioKVfw+nRHyyhLGBgxXiUTGh2RWyU9armbwjHTedzZpbeqrTytGiP
 gaRCNG4JN55g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,351,1580803200"; 
   d="scan'208";a="397518044"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 06 Apr 2020 07:31:55 -0700
Date:   Mon, 6 Apr 2020 07:31:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200406143155.GA21330@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
 <20200403233237.GA11802@linux.intel.com>
 <20200403233547.GI2701@linux.intel.com>
 <20200404011248.GB24717@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404011248.GB24717@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 04, 2020 at 04:12:48AM +0300, Jarkko Sakkinen wrote:
> On Fri, Apr 03, 2020 at 04:35:47PM -0700, Sean Christopherson wrote:
> > On Sat, Apr 04, 2020 at 02:33:31AM +0300, Jarkko Sakkinen wrote:
> > > On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > -	idx = srcu_read_lock(&encl->srcu);
> > > > +	do {
> > > > +		mm_list_version = encl->mm_list_version;
> > > >  
> > > > -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > > > -		if (!mmget_not_zero(encl_mm->mm))
> > > > -			continue;
> > > > +		/* Fence reads as the CPU can reorder them. This guarantees
> > > > +		 * that we don't access old list with a new version.
> > > > +		 */
> > > > +		smp_rmb();
> > > >  
> > > > -		down_read(&encl_mm->mm->mmap_sem);
> > > > +		idx = srcu_read_lock(&encl->srcu);
> > > >  
> > > > -		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> > > > -		if (!ret && encl == vma->vm_private_data)
> > > > -			zap_vma_ptes(vma, addr, PAGE_SIZE);
> > > > +		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > > > +			if (!mmget_not_zero(encl_mm->mm))
> > > > +				continue;
> > > >  
> > > > -		up_read(&encl_mm->mm->mmap_sem);
> > > > +			down_read(&encl_mm->mm->mmap_sem);
> > > >  
> > > > -		mmput_async(encl_mm->mm);
> > > > -	}
> > > > +			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
> > > > +			if (!ret && encl == vma->vm_private_data)
> > > > +				zap_vma_ptes(vma, addr, PAGE_SIZE);
> > > >  
> > > > -	srcu_read_unlock(&encl->srcu, idx);
> > > > +			up_read(&encl_mm->mm->mmap_sem);
> > > > +
> > > > +			mmput_async(encl_mm->mm);
> > > > +		}
> > > > +
> > > > +		srcu_read_unlock(&encl->srcu, idx);
> > > > +	} while (unlikely(encl->mm_list_version != mm_list_version));
> > > 
> > > This is bad, or at least makes the code unnecessarily hard to understand
> > > given the use of the fences: encl->mm_list_version is read twice per
> > > iteration.
> > > 
> > > I'll change the code to use "for ( ; ; )" and have exactly one read per
> > > iteration.
> > 
> > It has to be read twice per iteration, the whole point is to see if the
> > version at the start of the iteration matches the version at the end.
> 
> Nope if you use zero version as invalid version.

Which would break if more than one mm is added to an enclave.
