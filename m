Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93127C433EF
	for <linux-sgx@archiver.kernel.org>; Sat,  8 Jan 2022 15:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiAHPzG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 8 Jan 2022 10:55:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40450 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiAHPzG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 8 Jan 2022 10:55:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCF42B802C8
        for <linux-sgx@vger.kernel.org>; Sat,  8 Jan 2022 15:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19376C36AE0;
        Sat,  8 Jan 2022 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641657303;
        bh=/8v9lJ4NsSh9rzKizumIr+6XIMCXtY72ClAeVFiaQ+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xd5YiabTmprWKk9VxAl7CL0N4/G/eFAl6SuaW2jhUuYF5tVwBjADQbGIqhEmhOmvV
         5lpDRU2oC1wbZfkNz7RnlEvpEerTfmnL7ZCyzcMK7AAo4qXjwqx8DjJ+/jKbY7uLub
         VMdIu42KdFa+2li7Z7C+D2evbpW6udmFMNXtsHZGVXmzyDj/vTthA+RbP9Re99ZX2l
         VIh2ZYuZi3/wb83ERHBCHjHxjb+uyiIpQxYZdKkUA7eiGsQJtECQsRSQPOCVCP8I1t
         mzfjIitfrxitzCjpIQGRyTnxUNYbiKs5lJksItTOC0M8cScrK57g/B+yC2YZTWsOG3
         oJkDoNzgazRRA==
Date:   Sat, 8 Jan 2022 17:54:55 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
Message-ID: <Ydmzz6izGpM+dZv3@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-2-kristen@linux.intel.com>
 <YcuX/DzVsAWvhEBA@iki.fi>
 <8aa0be2752ed26317ff9b24c9803ccef542ce6ab.camel@linux.intel.com>
 <YdgxMvEu6v+fvdRz@iki.fi>
 <6c697809f70cf8d5f7ac973459672f6867f56815.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c697809f70cf8d5f7ac973459672f6867f56815.camel@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 07, 2022 at 09:17:03AM -0800, Kristen Carlson Accardi wrote:
> On Fri, 2022-01-07 at 14:25 +0200, Jarkko Sakkinen wrote:
> > On Thu, Jan 06, 2022 at 10:26:18AM -0800, Kristen Carlson Accardi
> > wrote:
> > > Hi Jarkko, thanks for your review,
> > > 
> > > On Wed, 2021-12-29 at 01:04 +0200, Jarkko Sakkinen wrote:
> > > > On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi
> > > > wrote:
> > > > > +
> > > > > +/**
> > > > > + * sgx_charge_mem() - charge for a page used for backing
> > > > > storage
> > > > > + *
> > > > 
> > > > Please remove this empty line:
> > > > 
> > > > https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > > 
> > > I read this to be that there should be an empty line after the
> > > short
> > > description/arg list but before the longer description. I think for
> > > functions without args this is the proper layout. It also is more
> > > readable.
> > > 
> > > > > + * Backing storage usage is capped by the
> > > > > sgx_nr_available_backing_pages.
> > > > > + * If the backing storage usage is over the overcommit limit,
> > > > 
> > > > Where does this verb "charge" come from?
> > > 
> > > Charge in this context means that some available backing pages are
> > > now
> > > not available because they are in use. It feels appropriate to me
> > > to
> > > use "charge/uncharge" verbs for this action, unless you think it's
> > > confusing somehow.
> > 
> > OK, it's cool.
> > 
> > I'm still wondering why you need extra variable given that
> > sgx_nr_backing_available_pages is signed. You could mark the
> > feature being disabled by setting it to -1.
> > 
> > It might cosmetically improve readability to have a boolean but
> > for practical uses (e.g. eBPF tracing scripts) it only adds extra
> > complexity.
> > 
> > /Jarkko
> 
> I can see your point. Since Boris objected to the module param, the
> next version will not have a way to disable limits at all, so I am
> deleting that boolean all together.

Ok, cool, I'm looking forward for the next version.

/Jarkko
