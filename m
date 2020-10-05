Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BC6C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5018C20795
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601898591;
	bh=x2E7D/Bq7z8jOY7BiQWC//3JD7gQJsyO7QhtZ0g1+8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xFsGpwjez5GVntXJEvT7T/S2vHxAz1ZVqRiFeb1n+3Qqb4AmAwtsx87qwr+eFwGcK
	 N4l08igGGgmdljWqwCNysbXs4j3xQD3iHItbsdoBYLGMA8li42y8v4+q8w4ZUNIzLZ
	 6byB7BE//5OBW7KXIW1uQIUYkOzYRE0mqM7nxE6A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJELtr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgJELtr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 07:49:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27CB20757;
        Mon,  5 Oct 2020 11:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601898585;
        bh=x2E7D/Bq7z8jOY7BiQWC//3JD7gQJsyO7QhtZ0g1+8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ggN5USXx2aHa9HR1XYsNlXca9WXHJ+MB1Abz/y/1ghvlIO6xVY++tmNYTlYmUfLWT
         EpZfRRfZAttuK677+5RTDcN2eLBm1nYuwAgWldxF7adXHKC8tGSxnO5DJ4Fop9mYKx
         fnPnr0MyJhjW+yRrT1lATeU/n/M7sQdOkOOBUxkE=
Date:   Mon, 5 Oct 2020 13:50:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>, x86@kernel.org,
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
Message-ID: <20201005115030.GA682263@kroah.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201005084554.GA3403@infradead.org>
 <20201005114250.GB181338@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005114250.GB181338@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 02:42:50PM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 05, 2020 at 09:45:54AM +0100, Christoph Hellwig wrote:
> > On Sat, Oct 03, 2020 at 04:39:25PM +0200, Greg KH wrote:
> > > > @@ -0,0 +1,173 @@
> > > > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > > 
> > > You use gpl-only header files in this file, so how in the world can it
> > > be bsd-3 licensed?
> > > 
> > > Please get your legal department to agree with this, after you explain
> > > to them how you are mixing gpl2-only code in with this file.
> > > 
> > > > +// Copyright(c) 2016-18 Intel Corporation.
> > > 
> > > Dates are hard to get right :(
> > 
> > As is comment formatting apparently.  Don't use // comments for anything
> > but the SPDX header, please.
> 
> I'll bring some context to this.
> 
> When I moved into using SPDX, I took the example from places where I saw
> also the copyright using "//". That's the reason for the choice.
> 
> I.e.
> 
> $ git grep "// Copyright" | wc -l
> 2123
> 
> I don't care, which one to use, just wondering is it done in the wrong
> way in all these sites?

Probably, but I know at least one subsystem requires their headers to be
in this manner.  There's no accounting for taste :)

thanks,

greg k-h
