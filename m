Return-Path: <SRS0=niAy=DQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19DDC433DF
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Oct 2020 07:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A02922264
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Oct 2020 07:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602228056;
	bh=zIymCSHg9Zg+z9GLKQbc3ItuquT9CYWzArm0DOFUUoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dKvMMmraNu+y1gKHGyDxTSYMLWePucd49j5FZRPPwnQU1vYNYvAmb89c2aixhze1h
	 poqQuJB8AwcpD5a5s912t/bt9pWY/+ylIoCak2MlN/nkxkH40Bz7KSoJjMhcXuOAQD
	 G+SwSX5mP+cS/K9WLMYoUq17VhgciGSDyyAL4gUc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgJIHU4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Oct 2020 03:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgJIHU4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Oct 2020 03:20:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7D322244;
        Fri,  9 Oct 2020 07:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602228055;
        bh=zIymCSHg9Zg+z9GLKQbc3ItuquT9CYWzArm0DOFUUoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tq0xt+Nj7bKX0IcFmLIcPoPZcfdELavFD7QDp0QLmuFCy5I77+nFLPbz94RDcOasl
         abJmGXK82DmAQLJSj7lATakLmj1QgQL+idU2cELdRtn3zw+9C8kvf3zqff2ZqkhcEy
         owFFKDs7GEWMZtFxuyJFiTRKgXG8TcAcu4GyPcvE=
Date:   Fri, 9 Oct 2020 09:21:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201009072141.GA12545@kroah.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201009071045.GA10335@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009071045.GA10335@amd>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 09, 2020 at 09:10:45AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > new file mode 100644
> > > index 000000000000..f54da5f19c2b
> > > --- /dev/null
> > > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > > @@ -0,0 +1,173 @@
> > > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > 
> > You use gpl-only header files in this file, so how in the world can it
> > be bsd-3 licensed?
> > 
> > Please get your legal department to agree with this, after you explain
> > to them how you are mixing gpl2-only code in with this file.
> 
> This specifies license of driver.c, not of the headers included. Are
> you saying that it is impossible to have a kernel driver with anything
> else than GPL-2? That would be news to many, and that's not what
> current consensus is.

If you want to write any non-GPL-2-only kernel code, you had better be
consulting your lawyers and get very explicit instructions on how to do
this in a way that does not violate any licenses.

I am not a lawyer, and will not be giving you any such advice, as I
think it's not something that people should be doing.

greg k-h
