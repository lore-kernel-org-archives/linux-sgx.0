Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AA8C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 07:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2DEF22240
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 07:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603091026;
	bh=ybPoRLwk9gRRObCHrDxH1kw1JCNmskeqI4YCYwMypEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KVvqdN5ikFeewBeUckRMWxWwum1ySeDvyB5Qzrz0VorTmegAiDGRDgD1fp/qJo5+f
	 kDD4CXup8y4jTei3m7yEeh7Tb/oXRA2tCZlQ5wH8b/VQr+MJOTra99ryCJ77uA4HwU
	 z1jecGtFnUEqNXcpYWsKgX32XGRhw8hn00xEkmAY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbgJSHDq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 03:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgJSHDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 03:03:46 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009BF22203;
        Mon, 19 Oct 2020 07:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603091025;
        bh=ybPoRLwk9gRRObCHrDxH1kw1JCNmskeqI4YCYwMypEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zga4ZuU/cKcUHl6owOPPlnthLPPS+62m6z6xAdPtPFnS1IziCk2q7yXRJyHgWwglo
         Jtj2gdMIxvJDtCYLHMxC5v2iVN7MRzWgggdKixdKgTGU+HurVLAAhWaZZml4k1vpIg
         nfXoTyRbcai2sAPKOmeFEUl4CBZRw/8ImQ2KB3OY=
Date:   Mon, 19 Oct 2020 10:03:43 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20201019070343.GA1141388@kapsi.fi>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-14-jarkko.sakkinen@linux.intel.com>
 <1739984e-0010-2031-1561-809a0b6380bb@intel.com>
 <20201018050311.GK68722@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018050311.GK68722@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 18, 2020 at 08:03:11AM +0300, Jarkko Sakkinen wrote:
> > > +	mmap_read_lock(current->mm);
> > > +	mutex_lock(&encl->lock);
> > > +
> > > +	/*
> > > +	 * Insert prior to EADD in case of OOM.
> > 
> > I wouldn't say OOM.  Maybe:
> > 
> > 	xa_insert() and EADD can both fail.  But xa_insert() is easier
> > 	to unwind so do it first.
> > 
> > >                                              EADD modifies MRENCLAVE, i.e.
> > 
> > What is MRENCLAVE?
> 
> The measurement stored in SECS. I'm wondering  with xarray, is it
> possible to preallocate entry without inserting anything?
> 
> Then we could get rid of this unwind and also would not need to
> take encl->lock in sgx_encl_may_map().

I'm still a bit confused with the unfamiliar Xarray API but I think I
got it:

1. xa_insert() with a NULL entry reserves index and more importantly
   does the memory allocation.
2. xa_cmpxchg() with the enclave page, if EADD and EEXTEND's succceed.
3. xa_release() otherwise.

This way sgx_encl_may_map() will never see a stale enclave page when it
does the permission check, even if encl->lock is not taken.

I mean right now I have to take both xas lock and enclave lock, which
is terrible but this will take care of it.

I will rewrite the comment to something more reasonable, once I've done
this code change.

The reason for doing insert first is that, if we get -ENOMEM after
successful EADD and EEXTEND's we have a legit microarchitectural state
but you cannot rollback a hash (MRENCLAVE), so game is anyway over
because your data structures are not in sync.

If -ENOMEM comes before, everything is still in sync and we don't have
invalidate the enclave.

/Jarkko
