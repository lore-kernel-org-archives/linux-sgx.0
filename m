Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B2FC43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 09:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D92142082C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 09:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfFTJ31 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 05:29:27 -0400
Received: from wind.enjellic.com ([76.10.64.91]:35924 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfFTJ31 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 05:29:27 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5K9Sv9c004522;
        Thu, 20 Jun 2019 04:28:57 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5K9SumB004521;
        Thu, 20 Jun 2019 04:28:56 -0500
Date:   Thu, 20 Jun 2019 04:28:56 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     James Morris <jmorris@namei.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        william.c.roberts@intel.com
Subject: Re: [RFC PATCH v3 09/12] LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
Message-ID: <20190620092856.GA4489@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com> <20190617222438.2080-10-sean.j.christopherson@intel.com> <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com> <alpine.LRH.2.21.1906200702040.28119@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1906200702040.28119@namei.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 20 Jun 2019 04:28:57 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 20, 2019 at 07:13:50AM +1000, James Morris wrote:

Good morning, I hope the week is going well for everyone.

> On Wed, 19 Jun 2019, Jarkko Sakkinen wrote:
> 
> > Can LSM callbacks ever non-generic when it comes to hardware? This is
> > the very first time I ever see such callbacks being introduced.
> > 
> > I suspect that from maintainers perspective, accepting such changes for
> > Intel hardware, could open a pandoras box.

> If there's a major distro/userbase committing to ship with these
> hooks enabled via a supported in-tree LSM, the case for inclusion is
> clear.

We've been waiting for this concern over SGX specific LSM
functionality to eventuate for the last month or so of this
discussion.

It would seem that mainstream acceptance of SGX specific LSM
modifications is complicated by the fact, as we noted in a previous
e-mail, that a 1400+ machine SAAS implementation we have experience
with will only ever be run with selinux=0.

Hence our concerns and continued comments regarding the need to strike
the proper balance between implementation complexity and the actual
effective security guarantees that are being achieved.

> If the hooks could be generalized beyond just SGX, that would be
> ideal, but it's not clear if that's feasible.

We have been working to develop some thoughts on this issue.

We will forward those thoughts along after I get somewhere different
from where I am right now.

> James Morris

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC
4206 N. 19th Ave.           Implementing measured information privacy
Fargo, ND  58102            and integrity architectures.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"Can't they?

 A 64bit number incremented every millisecond can grow for half a
 billion years.  As far as I'm concerned, that is forever."
                                -- Neil Brown
                                   linux-raid
