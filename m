Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF46C282DA
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 18:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8D01204EC
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 18:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfDSSea (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:34:30 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58564 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbfDSSeB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 14:34:01 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x3JGOqAw002718;
        Fri, 19 Apr 2019 11:24:52 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x3JGOonq002717;
        Fri, 19 Apr 2019 11:24:50 -0500
Date:   Fri, 19 Apr 2019 11:24:50 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190419162450.GA2615@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190418171059.GA20819@wind.enjellic.com> <d79261c0-f2ae-0ed8-96b6-fb4d1677e3dc@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d79261c0-f2ae-0ed8-96b6-fb4d1677e3dc@intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 19 Apr 2019 11:24:52 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 18, 2019 at 10:24:42AM -0700, Dave Hansen wrote:

Good morning again.

> On 4/18/19 10:10 AM, Dr. Greg wrote:
> > In addition, the driver breaks all existing SGX software by breaking
> > compatibility with what is a 3+ year ABI provided by the existing
> > driver.  This seems to contravene the well understood philosophy that
> > Linux doesn't, if at all possible, break existing applications,

> Sorry, that doesn't apply to out-of-tree modules.  While we don't go
> out of our way to intentionally break apps who are relying on
> out-of-tree modules, we also don't go our of or way to keep them
> working.

Yes, there is no question that we understand this concept.

The salient point is that when given an opportunity to preserve and
transition an existing development community, provide an
architecturally relevant driver and to impose no restrictions on how a
new, as yet untested and undesigned security architecture can emerge,
the decision is made to break all compatibility.

> Please stop asking about this.  I don't see any route where it's going
> to change.

Which goes to my first e-mail where I noted this was about idealogy
rather then technology.

Nothing wrong with that as long as we are intellectually honest.

> Companies ideally shouldn't be getting their customers hooked on
> out-of-tree ABIs and customers should consume out-of-tree ABIs
> *expecting* them to break in the future.

At the risk of being indelicate, it was your company that hooked the
SGX development community on out-of-tree driver ABI's and software.

We are just trying to find a mutually beneficial and productive path
forward.

On that note.

One of the issues we have raised in multiple missives, that remains
unaddressed, was the notion that the proposed driver may not work on
all SGX hardware moving forward.  Is there going to be an OEM mandated
requirement, enforced by Intel licensing, that all SGX capable
platforms will implement Flexible Launch Control?

For those following along at home, here is a link to the Intel
Security announcements made at RSA-2019 in February:

https://newsroom.intel.com/news/rsa-2019-intel-partner-ecosystem-offer-new-silicon-enabled-security-solutions/

Of relevant note is the section 'Operational Control':

"Intel is delivering a new capability called flexible launch control
that enables a company's data center operations to set and manage
their own unique security policies for launching enclaves as well as
providing controlled access to sensitive platform identification
information.  This capability is currently available on Intel
SGX-enabled Intel Xeon E Processors and some Intel NUC's".

FLC is primarily about supporting Data-Center Attestation Services
(DCAS) on XEON class servers.  New technologies are released on NUC's
since those are the platforms that Intel seems to target for developer
experimentation.

We have had some experience with legal and liability sensitivities
surrounding security in general and SGX in particular.  Absent an
official policy statement, it is a really open question whether this
driver will be universally useful, with the end result being a fair
amount of chaos for the Linux SGX community.

As opposed to Windows, which will have a known and stable ABI that
works on any SGX capable hardware.

As I noted in my first e-mail yesterday, we anticipated this and our
architecture provides a path forward for resolving this issue as well.

Have a good weekend.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you get to thinkin' you're a person of some influence, try
 orderin' somebody else's dog around."
                                -- Cowboy Wisdom
