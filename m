Return-Path: <SRS0=H9hn=YR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B4ECA9EAF
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Oct 2019 13:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE98B20663
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Oct 2019 13:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502256AbfJXNLg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:11:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:24022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502245AbfJXNLg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:11:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210379598"
Received: from attracta-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.83.52])
  by orsmga002.jf.intel.com with ESMTP; 24 Oct 2019 06:11:26 -0700
Date:   Thu, 24 Oct 2019 16:11:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 1/3] x86/sgx: Update the free page count in a
 single operation
Message-ID: <20191024131125.GA26532@linux.intel.com>
References: <20191022224922.28144-1-sean.j.christopherson@intel.com>
 <20191022224922.28144-2-sean.j.christopherson@intel.com>
 <20191023124449.GH23733@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023124449.GH23733@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 23, 2019 at 03:44:49PM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 22, 2019 at 03:49:20PM -0700, Sean Christopherson wrote:
> > Use atomic_add() instead of running atomic_inc() in a loop to manually
> > do the equivalent addition.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 499a9b0740c8..d45bf6fca0c8 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -195,8 +195,7 @@ static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
> >  		list_add_tail(&page->list, &section->unsanitized_page_list);
> >  	}
> >  
> > -	for (i = 0; i < nr_pages; i++)
> > -		atomic_inc(&sgx_nr_free_pages);
> > +	atomic_add(nr_pages, &sgx_nr_free_pages);
> >  
> >  	return true;
> >  
> > -- 
> > 2.22.0
> > 
> 
> There reason I used atomic_inc() was that atomic_add() takes int that
> could potentially overflow.
> 
> I'll ignore this as I'll do the revert that I promised to do.

static inline unsigned long sgx_nr_free_pages(void)
{
	unsigned long cnt = 0;
	int i;

	for (i = 0; i < sgx_nr_epc_sections; i++)
		cnt += sgx_epc_sections[i].free_cnt;

	return cnt;
}

static inline bool sgx_should_reclaim(unsigned long watermark)
{
	return sgx_nr_free_pages() < watermark &&
	       !list_empty(&sgx_active_page_list);
}

I use the latter in all call sites.

/Jarkko
