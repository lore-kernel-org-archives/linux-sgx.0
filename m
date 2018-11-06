Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670B8C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 12:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E1420862
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 12:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37E1420862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbeKFV2o (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 16:28:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:37789 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbeKFV2o (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 16:28:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 04:03:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,471,1534834800"; 
   d="scan'208";a="278729922"
Received: from btyborox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.134])
  by fmsmga006.fm.intel.com with ESMTP; 06 Nov 2018 04:03:42 -0800
Date:   Tue, 6 Nov 2018 14:03:41 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, suresh.b.siddha@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 15/23] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20181106120341.GA11465@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com>
 <CAHp75VdhSwy8zzf64PZnHhZVikJEzasu-=a+UOz4cLAxEJW-YA@mail.gmail.com>
 <20181105173038.GD4502@linux.intel.com>
 <CAHp75Vfa2jvjOtvERB_Td1zCrfKyJp24Prd+foYz02kUCjNr-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vfa2jvjOtvERB_Td1zCrfKyJp24Prd+foYz02kUCjNr-g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106120341.AHtgBIZk1nwEQ9Sqh6jiGI2s4j74WGRtYmgz9lD6g7c@z>

On Mon, Nov 05, 2018 at 10:39:46PM +0200, Andy Shevchenko wrote:
> On Mon, Nov 5, 2018 at 7:30 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Sat, Nov 03, 2018 at 03:17:35PM +0200, Andy Shevchenko wrote:
> > > On Sat, Nov 3, 2018 at 1:18 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > >
> > > > ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
> > > > The ENCLS function that is executed is specified in EAX, with each
> > > > function potentially having more leaf-specific operands beyond EAX.
> > > > ENCLS introduces its own (positive value) error codes that (some)
> > > > leafs use to return failure information in EAX.  Leafs that return
> > > > an error code also modify RFLAGS.  And finally, ENCLS generates
> > > > ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
> > > > encounter faults on ENCLS that must be handled gracefully.
> > > >
> > > > Because of the complexity involved in encoding ENCLS and handling its
> > > > assortment of failure paths, executing any given leaf is not a simple
> > > > matter of emitting ENCLS.
> > > >
> > > > To enable adding support for ENCLS leafs with minimal fuss, add a
> > > > two-layer macro system along with an encoding scheme to allow wrappers
> > > > to return trap numbers along ENCLS-specific error codes.  The bottom
> > > > layer of the macro system splits between the leafs that return an
> > > > error code and those that do not.  The second layer generates the
> > > > correct input/output annotations based on the number of operands for
> > > > each leaf function.
> > >
> > > > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> > >
> > > > +/**
> > >
> > > I dunno if kernel-doc script still complains about this.
> >
> > Is there a way to ask for make htmldocs to do only a subset of docs?
> > Still kind of trying to figure out what would be  a good flow for
> > working with Sphinx.
> 
> What I'm telling here is about Copyright notice, which in my
> understanding is not a part of kernel-doc formatting. Though I might
> be mistaken.
> I remember some USB code has that and I saw a warning.
> 
> -- 
> With Best Regards,
> Andy Shevchenko

I'll remove it because I don't find it in other headers under arch/x86.

/Jarkko
