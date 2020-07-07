Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9503C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5E520702
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgGGEEI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:04:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:7705 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgGGEEH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Jul 2020 00:04:07 -0400
IronPort-SDR: VM4g+NyLqFfEhRwvKKqt9SmqCY1CDIxm+ErR6Tw/VZLKYstBURtDIdZhldWL8xSZDgPlvOep6y
 sup+MKJXvmHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="127128752"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="127128752"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 21:04:07 -0700
IronPort-SDR: whC5n1N6inyYEhUxZ+E0m/f6l0mF/xLYwOkDIebBBQqrvPF/fO3YT6o6G7amHWRUpups59QMTO
 D1Ffq8Z+v/Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="268077468"
Received: from apiccion-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.45.178])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jul 2020 21:03:56 -0700
Date:   Tue, 7 Jul 2020 07:03:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200707040355.GC143804@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
 <20200707031424.GD25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707031424.GD25523@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 04:14:24AM +0100, Matthew Wilcox wrote:
> On Tue, Jul 07, 2020 at 06:01:50AM +0300, Jarkko Sakkinen wrote:
> > +++ b/mm/mprotect.c
> > @@ -603,13 +603,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> >  			goto out;
> >  		}
> >  
> > +		tmp = vma->vm_end;
> > +		if (tmp > end)
> > +			tmp = end;
> > +
> >  		error = security_file_mprotect(vma, reqprot, prot);
> >  		if (error)
> >  			goto out;
> >  
> > -		tmp = vma->vm_end;
> > -		if (tmp > end)
> > -			tmp = end;
> 
> You don't need to move this any more, right?

My bad.

/Jarkko
