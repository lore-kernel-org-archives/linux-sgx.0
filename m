Return-Path: <SRS0=O4vE=7E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A64DC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D0020723
	for <linux-sgx@archiver.kernel.org>; Fri, 22 May 2020 19:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgEVTr6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 May 2020 15:47:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:60246 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730689AbgEVTr6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 May 2020 15:47:58 -0400
IronPort-SDR: G27KpkWIjMdf0FtUmXE6Fu0XWCnef1SNGfKDVra28mfloZpIGR8CQaaLPoJ8CJc/uIIEFaZVRB
 kbfCpwaxP5Pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 12:47:57 -0700
IronPort-SDR: 9IwrwK1WT4I8iAv7BqqpTIIIdtj2r+MVFF1QRTgU1dU3FqIka+1I71GnKlKiOwUykeWj2w3NE/
 4OWGW4GRUEew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="344267267"
Received: from rpurrx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.58.10])
  by orsmga001.jf.intel.com with ESMTP; 22 May 2020 12:47:51 -0700
Date:   Fri, 22 May 2020 22:47:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>
Subject: Re: [PATCH v30 12/20] x86/sgx: Add a page reclaimer
Message-ID: <20200522194752.GG10319@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-13-jarkko.sakkinen@linux.intel.com>
 <20200522071553.GA24377@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522071553.GA24377@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 22, 2020 at 12:15:53AM -0700, Sean Christopherson wrote:
> On Fri, May 15, 2020 at 03:44:02AM +0300, Jarkko Sakkinen wrote:
> > +static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
> > +				struct sgx_backing *backing)
> > +{
> > +	struct sgx_encl_page *encl_page = epc_page->owner;
> > +	struct sgx_encl *encl = encl_page->encl;
> > +	struct sgx_backing secs_backing;
> > +	int ret;
> > +
> > +	mutex_lock(&encl->lock);
> > +
> > +	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
> > +		ret = __eremove(sgx_epc_addr(epc_page));
> > +		ENCLS_WARN(ret, "EREMOVE returned %d\n");
> 
> The " returned %d\n" is unnecessary and leads to a bad message, ENCLS_WARN
> handles the message and formatting, i.e. this should simply be:
> 
> 		ENCLS_WARN(ret, "EREMOVE");

Sure. Did not make a changelog entry of this (because it is a cosmetic
fix), but it is fixed in my tree.

/Jarkko
