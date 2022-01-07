Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B102BC433F5
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jan 2022 17:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348545AbiAGRRZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Jan 2022 12:17:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:58161 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348555AbiAGRRX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Jan 2022 12:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641575843; x=1673111843;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+kq2ubBsGASxh7GueH/LvnwizPElB+qolsPDyrRBdn4=;
  b=ZT4vpDdj3r8JTAnsdAboGN4+mj87UdcZKGbcVMLhWiu14p7oDHdX/9+I
   M8DNslNge9GmgmDyKghjRbEm94tT4urJeFn7b2XVYbrli0gynM/1YMzSJ
   bboImfjtBcgPA+ib+gRlz/wuGDccLm+FBx+UBikVEDlCgoMrZrUIGs7Xk
   FEIgZJn4eszmDWikIS9KYIPuWm/OthIZXwFp2XfzhVi8SuYH75dcvvM80
   WlNSx7MlY0n54Fnw6f6aKVwsrN4uA6i7hiTLXcmYrtohl0oB0WSNlnWbg
   234EGTwOYiM2Ba0WbLnMS6gnNY7I65M9i4gmzVZ6VlaqGmL5pgsWrlO5f
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="306267179"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="306267179"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:17:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="527434028"
Received: from hmogilis-mobl2.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.25.179])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:17:04 -0800
Message-ID: <6c697809f70cf8d5f7ac973459672f6867f56815.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date:   Fri, 07 Jan 2022 09:17:03 -0800
In-Reply-To: <YdgxMvEu6v+fvdRz@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
         <20211220174640.7542-2-kristen@linux.intel.com> <YcuX/DzVsAWvhEBA@iki.fi>
         <8aa0be2752ed26317ff9b24c9803ccef542ce6ab.camel@linux.intel.com>
         <YdgxMvEu6v+fvdRz@iki.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2022-01-07 at 14:25 +0200, Jarkko Sakkinen wrote:
> On Thu, Jan 06, 2022 at 10:26:18AM -0800, Kristen Carlson Accardi
> wrote:
> > Hi Jarkko, thanks for your review,
> > 
> > On Wed, 2021-12-29 at 01:04 +0200, Jarkko Sakkinen wrote:
> > > On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi
> > > wrote:
> > > > +
> > > > +/**
> > > > + * sgx_charge_mem() - charge for a page used for backing
> > > > storage
> > > > + *
> > > 
> > > Please remove this empty line:
> > > 
> > > https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > 
> > I read this to be that there should be an empty line after the
> > short
> > description/arg list but before the longer description. I think for
> > functions without args this is the proper layout. It also is more
> > readable.
> > 
> > > > + * Backing storage usage is capped by the
> > > > sgx_nr_available_backing_pages.
> > > > + * If the backing storage usage is over the overcommit limit,
> > > 
> > > Where does this verb "charge" come from?
> > 
> > Charge in this context means that some available backing pages are
> > now
> > not available because they are in use. It feels appropriate to me
> > to
> > use "charge/uncharge" verbs for this action, unless you think it's
> > confusing somehow.
> 
> OK, it's cool.
> 
> I'm still wondering why you need extra variable given that
> sgx_nr_backing_available_pages is signed. You could mark the
> feature being disabled by setting it to -1.
> 
> It might cosmetically improve readability to have a boolean but
> for practical uses (e.g. eBPF tracing scripts) it only adds extra
> complexity.
> 
> /Jarkko

I can see your point. Since Boris objected to the module param, the
next version will not have a way to disable limits at all, so I am
deleting that boolean all together.

