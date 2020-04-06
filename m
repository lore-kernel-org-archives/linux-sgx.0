Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CEAC2BA19
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 14:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 133FA24248
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 14:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgDFOgj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:36:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:35467 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbgDFOgj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 10:36:39 -0400
IronPort-SDR: v7C5EiVss283vidhwYmtWCGp0xHg+H8xONrTiiB8vCMU0h0yN/X6iBG1wVND5eN5Tz/OZ9JceI
 JsLNk/rlWrwA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 07:36:39 -0700
IronPort-SDR: g4W7ngavcXvcV16ASb/LrFZbZi7A1Id8sd7XxaTrL1KyKcrFV+z+AQCJ6N6ySEHhSxoYGmnJ+B
 vffNnPYNm9OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,351,1580803200"; 
   d="scan'208";a="424380508"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Apr 2020 07:36:39 -0700
Date:   Mon, 6 Apr 2020 07:36:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Fix deadlock and race conditions between
 fork() and EPC reclaim
Message-ID: <20200406143638.GB21330@linux.intel.com>
References: <20200403093550.104789-1-jarkko.sakkinen@linux.intel.com>
 <20200403234239.GJ2701@linux.intel.com>
 <20200404010948.GA24717@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404010948.GA24717@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 04, 2020 at 04:12:02AM +0300, Jarkko Sakkinen wrote:
> On Fri, Apr 03, 2020 at 04:42:39PM -0700, Sean Christopherson wrote:
> > On Fri, Apr 03, 2020 at 12:35:50PM +0300, Jarkko Sakkinen wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > @@ -221,12 +224,16 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
> > >  		return ret;
> > >  	}
> > >  
> > > +	/*
> > > +	 * The page reclaimer uses list version for synchronization instead of
> > > +	 * synchronize_scru() because otherwise we could conflict with
> > > +	 * dup_mmap().
> > > +	 */
> > >  	spin_lock(&encl->mm_lock);
> > >  	list_add_rcu(&encl_mm->list, &encl->mm_list);
> > 
> > You dropped the smp_wmb().
> 
> As I said to you in my review x86 pipeline does not reorder writes.

And as I pointed out in this thread, smp_wmb() is a _compiler_ barrier if
and only if CONFIG_SMP=y.  The compiler can reorder list_add_rcu() and
mm_list_version++ because from it's perspective there is no dependency
between the two.  And that's entirely true except for the SMP case where
the consumer of mm_list_version is relying on the list to be updated before
the version changes.
