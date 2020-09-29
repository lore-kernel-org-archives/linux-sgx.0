Return-Path: <SRS0=LTc5=DG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AFFC4346E
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 08:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5962075A
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 08:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgI2Ifc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 29 Sep 2020 04:35:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:44863 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgI2Ifc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 29 Sep 2020 04:35:32 -0400
IronPort-SDR: NsYEVSA57OkvwXSDYcdQjyll6lGyXsK+UYo0nu+GCytTBVTbATLjmUIMoWgEFxATw6powPH+YN
 zi8Z0VwqLZqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="161371984"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="161371984"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 01:35:31 -0700
IronPort-SDR: UgLzSefUspPCRspHRQgyPO1tTCeV29f13AFZwPfkybz0UPN9MKI0TxsE4oe0T0uEB8aYLkGBoe
 1sfjMFQPjf0Q==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="345191068"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 01:35:30 -0700
Date:   Tue, 29 Sep 2020 01:35:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200929083528.GN353@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
 <20200922104538.GE22660@zn.tnic>
 <20200922140314.GA164527@linux.intel.com>
 <20200929011438.GA31167@linux.intel.com>
 <20200929035010.GB301037@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929035010.GB301037@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 29, 2020 at 06:50:10AM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 28, 2020 at 06:14:39PM -0700, Sean Christopherson wrote:
> > On Tue, Sep 22, 2020 at 05:03:23PM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Sep 22, 2020 at 12:45:38PM +0200, Borislav Petkov wrote:
> > > > > +	spin_lock(&sgx_active_page_list_lock);
> > > > > +	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
> > > > > +		if (list_empty(&sgx_active_page_list))
> > > > 
> > > > Isn't it enough to do this once, i.e., not in the loop? You're holding
> > > > sgx_active_page_list_lock...
> > 
> > Argh, I missed this until I looked at Jarkko's updated tree.
> > 
> > The reason for checking list_empty() on every iteration is that the loop is
> > greedy, i.e. it tries to grab and reclaim up to 16 (SGX_NR_TO_SCAN) EPC pages
> > at a time.
> > 
> > > I think that would make sense. Distantly analogous to the EINIT
> > > discussion. Too complex code for yet to be known problem workloads I'd
> > > say.
> > 
> > Nooooo.  Please no.
> 
> I added this comment in the beginning of the sgx_reclaim_pages() based
> on your response:
> 
> /*
>  * Take a fixed number of pages from the head of the active page pool and
>  * reclaim them to the enclave's private shmem files. Skip the pages, which have
>  * been accessed since the last scan. Move those pages to the tail of active
>  * page pool so that the pages get scanned in LRU like fashion.
>  *
>  * Batch process a chunk of pages (at the moment 16) in order to degrade amount
>  * of IPI's and ETRACK's potentially required. sgx_encl_ewb() does degrade a bit
>  * among the HW threads with three stage EWB pipeline (EWB, ETRACK + EWB and IPI
>  * + EWB) but not sufficiently. Reclaiming one page at a time would also be
>  * problematic as it would increase the lock contention too much, which would
>  * halt forward progress.
>  */
> 
> And reverted reclaimer patch as it was. Do you have anything in mind
> that I should add or modify in it?

Nope, can't think of anything.
