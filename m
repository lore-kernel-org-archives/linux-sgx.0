Return-Path: <SRS0=1Eyi=O5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DFEC43387
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 22:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF06021741
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 22:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbeLTWJj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Dec 2018 17:09:39 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57788 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbeLTWJj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Dec 2018 17:09:39 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBKM6e06025464;
        Thu, 20 Dec 2018 16:06:40 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBKM6cwU025463;
        Thu, 20 Dec 2018 16:06:38 -0600
Date:   Thu, 20 Dec 2018 16:06:38 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181220220638.GA25110@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com> <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com> <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219144343.GA31189@wind.enjellic.com> <20181220103400.GC26410@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220103400.GC26410@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 20 Dec 2018 16:06:40 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 20, 2018 at 12:34:00PM +0200, Jarkko Sakkinen wrote:

Good afternoon to everyone.

> On Wed, Dec 19, 2018 at 08:43:43AM -0600, Dr. Greg wrote:
> > I believe it is a silent response to the issues we were
> > prosecuting 4-5 weeks ago, regarding the requirement for an SGX
> > driver on an FLC hardware platform to have some semblance of
> > policy management to be relevant from a security/privacy
> > perspective.  It would have certainly been collegial to include a
> > reference to our discussions and concerns in the changelog.
> >
> > See 364f68f5a3c in Jarkko's next/master.
> >
> > The changeset addresses enclave access to the PROVISION key but is
> > still insufficient to deliver guarantees that are consistent with
> > the SGX security model.  In order to achieve that, policy
> > management needs to embrace the use of MRSIGNER values, which is
> > what our SFLC patchset uses.
> >
> > The noted changeset actually implements most of the 'kernel bloat'
> > that our SFLC patchset needs to bolt onto.
> >
> > As of yesterday afternoon next/master still won't initialize a
> > non-trivial enclave.  Since there now appears to be a wholesale
> > change in the driver architecture and UAPI we are sitting on the
> > sidelines waiting for an indication all of that has some hope of
> > working before we introduce our approach.
> >
> > Part of SFLC won't be popular but it is driven by clients who are
> > actually paying for SGX security engineering and architectures.

> How many of these people are actually posting here?

None that I know of.

The individuals I was referring to are CISO's and security risk
managers of multi-billion dollar corporations and/or 3-letter
entities.  It has been my own personal observation that they don't
have time to post to the Linux Kernel Mailing List.

The time they do spend on this technology seems to involve sitting in
meetings and making decisions on whether or not to authorize capital
expenditure budgets for Intel processors and chipsets, based on
whether or not an SGX security stack can definably implement the
security controls that are being imposed on their organizations by the
government and/or their liability carriers.

Such issues may be out of mainstream kernel concerns but hopefully not
conceptually elusive with respect to their implications.

> /Jarkko

Merry Christmas and happy holidays to everyone.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Don't talk unless you can improve the silence."
                                -- George Will
