Return-Path: <SRS0=o5ed=5U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCC4C43331
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 01:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D490C20731
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 01:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgDDBMa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 21:12:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:29948 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgDDBMH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Apr 2020 21:12:07 -0400
IronPort-SDR: +UJded3TFHVYVt7NYiAGD8Tg38UEhGRxwmYBJAqqdLmZ7rUCMK3wXFPNyJoOHOc7XLtx7wCnSq
 KPsjoPQ2wumw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 18:12:05 -0700
IronPort-SDR: 4NCfFkgw6d5HdNw7t3trZFuaXGLrAEABbaoa8+r6wL15VhjP5Ax6jO7buQmBmk6SKr/WQXI7nl
 /eqKcusmmC6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,341,1580803200"; 
   d="scan'208";a="253543466"
Received: from shyleshu-mobl.amr.corp.intel.com (HELO localhost) ([10.252.37.189])
  by orsmga006.jf.intel.com with ESMTP; 03 Apr 2020 18:12:03 -0700
Date:   Sat, 4 Apr 2020 04:12:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200404010948.GA24717@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
 <20200403234239.GJ2701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403234239.GJ2701@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 03, 2020 at 04:42:39PM -0700, Sean Christopherson wrote:
> On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > @@ -221,12 +224,16 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
> >  		return ret;
> >  	}
> >  
> > +	/*
> > +	 * The page reclaimer uses list version for synchronization instead of
> > +	 * synchronize_scru() because otherwise we could conflict with
> > +	 * dup_mmap().
> > +	 */
> >  	spin_lock(&encl->mm_lock);
> >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> 
> You dropped the smp_wmb().

As I said to you in my review x86 pipeline does not reorder writes.

/Jarkko
